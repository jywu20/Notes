using Plots 
using LaTeXStrings
using ProgressMeter
using LinearAlgebra 
using Statistics

struct TwoLevelFloquetAtom
    Δ::Float64   # Detuning 
    Ω::Float64   # Rabi frequency; possibly the type should be changed to ComplexF64
    ω::Float64   # Deriving frequency
end

function ham_floquet(
    atom::TwoLevelFloquetAtom, 
    floquet_cutoff::AbstractRange{T}
) where T <: Integer
    if step(floquet_cutoff) != 1
        throw("The step of Floquet frequency range has to be 1.")
    end

    Δ = atom.Δ
    Ω = atom.Ω
    ω = atom.ω

    E = Δ + ω    # Energy gap between the two levels 
    H_two_level = [
        0.0   0.0 
        0.0   E
    ]
    H_light_matter = [
        0.0   Ω 
        Ω     0.0 
    ]
    
    N = length(floquet_cutoff) # Number of Floquet frequencies
    H_floquet = zeros(2N, 2N)
    
    # Diagonal blocks in Floquet effective Hamiltonian
    for (i, m) in enumerate(floquet_cutoff)  
        H_floquet[2i-1 : 2i, 2i-1 : 2i] = H_two_level - m * ω * I
    end

    # Non-diagonal, Floquet transition blocks 
    for i in 1 : length(floquet_cutoff) - 1
        H_floquet[2i-1 : 2i, 2(i + 1) - 1 : 2(i + 1)] = H_light_matter
        H_floquet[2(i + 1) - 1 : 2(i + 1), 2i-1 : 2i] = H_light_matter
    end
    
    H_floquet
end

function ham_RWA(atom::TwoLevelFloquetAtom)
    Δ = atom.Δ
    Ω = atom.Ω

    [
        0.0   Ω 
        Ω     Δ 
    ] 
end

back_to_1BZ(x) = x - floor(x)
back_to_1BZ(x, period) = if period == 0
    0
else
    period * back_to_1BZ(x / period)
end 

"""
Used for convergence test for Floquet subspace cutoff 
"""
function floquet_subspace_convergence_hams(atom::TwoLevelFloquetAtom, N_max::Integer)
    for N in 1 : N_max
        # TODO
    end
end

# The Floquet spectrum v.s. the RWA spectrum
let E = 1.0,
    Ω = 0.4, 
    ω = 0.7, 
    N = 80
    
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N:N - 1)
    H_RWA     = ham_RWA(atom)
    
    E_floquet = sort(back_to_1BZ.(eigen(H_floquet).values, ω))
    E_RWA     = sort(back_to_1BZ.(eigen(H_RWA).values    , ω))
    
    display(H_floquet)

    p = scatter(E_floquet)
    hline!(p, E_RWA)
    p
end

# The Floquet spectrum v.s. the RWA spectrum, quantitatively:
function floquet_rwa_diff(E, Ω, ω, N) 
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N : N - 1)
    H_RWA     = ham_RWA(atom)
    
    E_floquet = sort(back_to_1BZ.(eigen(H_floquet).values, ω))
    E_RWA     = sort(back_to_1BZ.(eigen(H_RWA).values    , ω))
    
    E_RWA = vcat(ones(2N) * E_RWA[1], ones(2N) * E_RWA[2]) 
    
    sqrt(mean((E_floquet - E_RWA).^2) / E) 
end

@profview let Ω_list = LinRange(0, 2, 50), 
    ω_list = LinRange(0, 2, 50)
    
    sqrt_mse_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(sqrt_mse_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            sqrt_mse_list[Ω_idx, ω_idx] = floquet_rwa_diff(1.0, Ω, ω, 40)
            next!(progress)
        end
    end
    
    Ω_min = minimum(Ω_list)
    Ω_max = maximum(Ω_list)
    ΔΩ    = step(Ω_list)
    ω_min = minimum(ω_list)
    ω_max = maximum(ω_list)
    Δω    = step(ω_list)
    p = heatmap(Ω_list, ω_list, sqrt_mse_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega",
        ylabel = L"\omega",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
        clims = (0, 1))
    display(p)
    p
end
