##
using LinearAlgebra
using SparseArrays
using Arpack
using Plots
using ProgressMeter

##
L = 25
N = L^2

function back_into_range(idx, upper)
    if idx > upper
        return idx % upper
    end
    (idx - upper) % upper + upper
end

function site_index(i, j)
    i = back_into_range(i, L)
    j = back_into_range(j, L)
    (i - 1) * L + j
end

function index_to_site(index::Int64)
    (Int64(floor(index / L)), back_into_range(index % L, L))
end

function make_hamiltonian(S)
    kinetic_hamiltonian = spzeros(N, N)

    for i in 1:L, j in 1:L
        σ_down = S[back_into_range(i - 1, L), j]
        σ_up = S[i, j]
        kinetic_hamiltonian[site_index(i, j), site_index(i, j + 1)] = -1.0
        kinetic_hamiltonian[site_index(i, j), site_index(i, j - 1)] = -1.0
        kinetic_hamiltonian[site_index(i - 1, j), site_index(i, j)] = - σ_down
        kinetic_hamiltonian[site_index(i + 1, j), site_index(i, j)] = - σ_up
    end

    kinetic_hamiltonian
end

function total_energy(S, μ)
    T = make_hamiltonian(S)

    spectrum = eigs(T, nev=N, ncv=N)[1]
    sum(spectrum[spectrum .< μ])
end

function set_side(side)
    global L = side
    global N = L^2
end

##

energy_to_length = []
l_range = [20, 25, 30]

p = plot()

for l in l_range
    set_side(l)
    μ = -0.0
    S = fill(1.0, N, N)
    dis_range = 1:20
    energy_to_dis = []
    energy_0 = total_energy(S, μ)
    for dis in dis_range
        S[5, dis] = -1
        push!(energy_to_dis, (total_energy(S, μ) - energy_0) / N)
    end
    plot!(p, dis_range, energy_to_dis, label="L = $l")
end

p