# This program is an implementation of exact diagonalization of Heisenberg model.
#
# The model we are going to analyze is an one-dimensional spin 1/2 Heisenberg chain:
# H = J ∑_i S_i ⋅ S_{i+1} = J ∑_i Sᶻ_i Sᶻ_{i+1} + J/2 ∑_i (S⁺_i S⁻_{i+1} + S⁻_i S⁺_{i+1}).
# The model is exactly solved, and its ground state energy is 1/4 - ln 2 per site.
# The exact solution provides a good benchmark, and our ED calculation can also provide a benchmark for DMRG.

using LinearAlgebra
using SparseArrays
using Arpack
using Plots
using LaTeXStrings
using ProgressMeter

##

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
end

"""
Create an one site block.
With the open boundary condition, the Hamiltonian is zero.
"""
function HeisenbergBlock()
    HeisenbergBlock(zeros(local_dim, local_dim) |> sparse, 1, Sz, S⁺)
end

⊗(a, b) = kron(a, b)
sidelen(H) = size(H)[1]

function ground(ham)
    E, ψ = eigs(ham, which = :SR, nev = 1)[1:2]
    (E[1], ψ[:, 1])
end

"""
Add one site into a block, but do not update the density matrix.
"""
function add_site(block::HeisenbergBlock)::HeisenbergBlock
    len = block.len
    ham_old = block.ham
    Sz_old = block.Sz
    S⁺_old = block.S⁺

    ham_dim_old = sidelen(ham_old)

    ham_new = ham_old ⊗ σ0 + J * Sz_old ⊗ Sz + J / 2 * (S⁺_old ⊗ S⁺' + S⁺_old' ⊗ S⁺)
    Sz_new = eye(ham_dim_old) ⊗ Sz
    S⁺_new = eye(ham_dim_old) ⊗ S⁺

    HeisenbergBlock(ham_new, len + 1, Sz_new, S⁺_new)
end

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
end

"""
Build a Heisenberg spin chain with a given length.
"""
function HeisenbergBlock(n::Int64)::HeisenbergBlock
    block = HeisenbergBlock()
    for _ in 1 : n - 1
        add_site!(block)
    end
    block
end

##
#

n_sites = 10
block = HeisenbergBlock(n_sites)
E, ψ = ground(block.ham)
E_per_site = E / n_sites

# The result is -0.42580352072828853.
# The exact groundstate per site is 1/4 - ln 2, or approximately -0.44315, which roughtly 
# agrees with our result using 10 sites.

##
# Now we run the same code for a slightly larger system:

n_sites = 12
block = HeisenbergBlock(n_sites)
E, ψ = ground(block.ham)
E_per_site = E / n_sites

# E_per_site = -0.4285075527367106, a little closer to the energy per site in an infinite lattice.
# It is not very pratical to simply add more sites, as the memory will soom explode.
# On my computer when writing this code, when n_sites is set to 13, as the computation starts 
# the screen seems frozen for about 30 miniutes, without any response to mouse mouvement or
# keyboard input. Checking the task manager, you will find the memory is almost fully occupied.

##
# Now we turn to examine the wavefunction.
plot(ψ, legend = false)

# We will soon find some features of the wavefunction:
# - It is symmetric around 2048 - which is expected because a symmetry operation around 2048 is just flipping 
#   all 1 to 0 and 0 to 1, and Heisenberg model has spin flipping symmetry.
# - No imaginary parts - which is also expected because actually Heisenberg Hamiltonian only consists of Sᶻ, 
#   S⁺ and S⁻, all of which are real.
# - All 0 and all 1 states' weights are almost zero. That means the 1D Heisenberg chain does not have FM order, 
#   because if it has a magnetic order, it must be AFM.

##
# Now we investigate what states are with large weights.

# Note that since Julia uses 1-based indexing by default,
# the binary form of (i - 1) gives the configuration of the i-th state.
index_to_state(idx) = map(x -> parse(Int64, x), collect(string(idx - 1, base = 2, pad = n_sites)))

@show index_to_state(argmax(ψ))

# The state with the maximal weights is an AFM state.

##
# Now we investigate the reduced density matrix.

function partial_trace(ψ, dim1, dim2)
    ρ = reshape(ψ, dim2, dim1)
    ρ1 = transpose(ρ' * ρ)
    ρ2 = transpose(ρ * ρ')
    (ρ1, ρ2)
end

n_half_sites = Int64(n_sites / 2)
dim1 = 2^n_half_sites
dim2 = 2^n_half_sites

ρ1, ρ2 = partial_trace(ψ, dim1, dim2)

##
# Show ρ1

heatmap(ρ1)

##
# Show ρ2

heatmap(ρ2)

# ρ1 and ρ2 are almost identical, which is correct because of the symmetry. 
# It can be observed that there are negative elements in the reduced density matrices.
# That is a typical feature for strongly correlated systems.

##
# We try to calculate some observables.

# The correlation function.

function Sz_at_site(n::Int64, i::Int64)
    op_list = fill(σ0, n)
    op_list[i] = Sz
    foldl(⊗, op_list)
end

correlation(ψ, i, j) = (ψ' * Sz_at_site(n_sites, i) * Sz_at_site(n_sites, j) * ψ)

correlation_list = []

i = 1
for j in 1 : n_sites
    push!(correlation_list, correlation(ψ, i, j))
end

scatter(correlation_list, xlabel = L"d", ylabel = L"S^z_i S^z_j", legend = false)

# The correlation function decreases with longer distance. A real AFM phase's correlation function
# does not decrease in such a way, so the 1D Heisenberg chain is not really in an AFM phase.
# Nonetheless, staggering can be seen in the correlation function, so it still has AFM features.
