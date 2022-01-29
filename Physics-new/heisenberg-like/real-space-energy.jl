# This program is an implementation of DMRG of Heisenberg model in its real-space renormalization 
# formulation. That is, we use the lowest eigenvectors of the reduced density matrix as the low energy
# degrees of freedom after a new spin is added.
#
# The model we are going to analyze is an one-dimensional spin 1/2 Heisenberg chain:
# H = J ∑_i S_i ⋅ S_{i+1} = J ∑_i Sᶻ_i Sᶻ_{i+1} + J/2 ∑_i (S⁺_i S⁻_{i+1} + S⁻_i S⁺_{i+1}).
# The model is exactly solved, and its ground state energy is 1/4 - ln 2 per site.
# The exact solution provides a good benchmark for DMRG.

using LinearAlgebra
using SparseArrays
using Arpack
using Plots
using ProgressMeter
using LaTeXStrings

##
# A few definitions.

# Simulation parameters.
# The lattice length
n_sites = 100
# The local dimension
local_dim = 2
# The maximal number of stored states.
n_max_states = 32
############################################

# Operators in the model.
# The "J" appearing in the Hamiltonian
J = 1.0
Sx = 1/2 * [0 + 0im 1 ; 1 0] |> sparse
Sy = 1/2 * [0 -im ; im 0] |> sparse
Sz = 1/2 * [1 + 0im 0 ; 0 -1] |> sparse
S⁺ = (Sx + im * Sy) |> sparse 
S⁻ = (Sx - im * Sy) |> sparse
σ0 = [1.0 0 ; 0 1] |> sparse

eye(dim::Int64) = SparseMatrixCSC(1.0*I, dim, dim)
############################################

##
# Block configuration and operations on it.

mutable struct HeisenbergBlock
    # The Hamiltonian of the block
    ham::SparseMatrixCSC{Float64, Int64}
    # The length of the block, or in other words, how many sites have been added into the block.
    len::Int64
    # The Sz operator of the last site inserted. 
    Sz::SparseMatrixCSC{Float64, Int64}
    # The S⁺ operator of the last site inserted
    S⁺::SparseMatrixCSC{Float64, Int64}
    # The reduced density matrix
    dm::SparseMatrixCSC{Float64, Int64}
end

##

"""
Create an one site block.
With the open boundary condition, the Hamiltonian is zero.
"""
function HeisenbergBlock()
    HeisenbergBlock(zeros(local_dim, local_dim) |> sparse, 1, Sz, S⁺, zeros(local_dim, local_dim) |> sparse)
end

⊗(a, b) = kron(a, b)
sidelen(H) = size(H)[1]

function add_site(block::HeisenbergBlock)::HeisenbergBlock
    len = block.len
    ham_old = block.ham
    Sz_old = block.Sz
    S⁺_old = block.S⁺

    ham_dim_old = sidelen(ham_old)

    ham_new = ham_old ⊗ σ0 + J * Sz_old ⊗ Sz + J / 2 * (S⁺_old ⊗ S⁺' + S⁺_old' ⊗ S⁺)
    Sz_new = eye(ham_dim_old) ⊗ Sz
    S⁺_new = eye(ham_dim_old) ⊗ S⁺

    HeisenbergBlock(ham_new, len + 1, Sz_new, S⁺_new, block.dm)
end

"""
Add one site into a block, but do not update the density matrix.
"""
function add_site!(block::HeisenbergBlock)
    len = block.len
    ham_old = block.ham
    Sz_old = block.Sz
    S⁺_old = block.S⁺

    ham_dim_old = sidelen(ham_old)

    ham_new = ham_old ⊗ σ0 + J * Sz_old ⊗ Sz + J / 2 * (S⁺_old ⊗ S⁺' + S⁺_old' ⊗ S⁺)
    Sz_new = eye(ham_dim_old) ⊗ Sz
    S⁺_new = eye(ham_dim_old) ⊗ S⁺

    block.len += 1
    block.ham = ham_new
    block.Sz = Sz_new
    block.S⁺ = S⁺_new

    nothing
end

symmetrize(A) = (A + A') / 2
function ground(ham)
    E, ψ = eigs(ham, which = :SR, nev = 1)[1:2]
    E = E[1]
    ψ = ψ[:, 1]
    (E, ψ)
end

function partial_trace(ψ, dim1, dim2)
    ρ = reshape(ψ, dim2, dim1)
    ρ1 = transpose(ρ' * ρ)
    ρ2 = transpose(ρ * ρ')
    (ρ1, ρ2)
end

"""
Building a superblock, calculate its groundstate and hence the reduced density matrix of two blocks.
Update the density matrix of the two blocks.
"""
function update_dm!(sys_block::HeisenbergBlock, env_block::HeisenbergBlock)
    # Build the superblock Hamiltonian
    # Hamiltonians of the two blocks.
    H_super = sys_block.ham ⊗ eye(sidelen(env_block.ham)) + eye(sidelen(sys_block.ham)) ⊗ env_block.ham
    # Interaction between the two blocks.
    H_super += J * sys_block.Sz ⊗ env_block.Sz 
    H_super += J / 2 * (sys_block.S⁺' ⊗ env_block.S⁺ + sys_block.S⁺ ⊗ env_block.S⁺')

    # Find the ground state of the superblock.
    E_GS, ψ_GS = ground(H_super)
    E_GS_per_site = E_GS / (sys_block.len + env_block.len)
    # Find the reduced density matrix for both sys and env.
    sys_dm, env_dm = partial_trace(ψ_GS, sidelen(sys_block.ham), sidelen(env_block.ham))
    sys_block.dm = symmetrize(sys_dm)
    env_block.dm = symmetrize(env_dm)

    (E_GS_per_site, ψ_GS)
end

"""
Throw away unimportant eigenstates of reduced density matrices.
"""
function truncate!(block::HeisenbergBlock)
    P = eigs(block.dm, which = :LM, nev = n_max_states)[2]
    block.Sz = P' * block.Sz * P
    block.S⁺ = P' * block.S⁺ * P
    block.ham = P' * block.ham * P
end

##
# The whole DMRG algorithm.

sys_block = HeisenbergBlock()
env_block = HeisenbergBlock()

E_per_site_history = []
ψ = zeros(n_sites)

progress = Progress(n_sites - 1)

for iter_count in 2 : n_sites
    add_site!(sys_block)
    add_site!(env_block)

    E_per_site, ψ_GS = update_dm!(sys_block, env_block)
    push!(E_per_site_history, E_per_site)
    copy!(ψ, ψ_GS)

    truncate!(sys_block)
    truncate!(env_block)

    next!(progress)
end

##
# We check the energy history.

# The exact energy per site is 
E_per_site_exact = 1/4 - log(2)

p = scatter(E_per_site_history, label = "DMRG")
hline!(p, [E_per_site_exact], label = "Exact")
ylims!(p, (-0.45, -0.4))

xlabel!(p, L"N")
ylabel!(p, L"E/N")