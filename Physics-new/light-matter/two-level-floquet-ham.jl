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

######################################################
#region Display eigensystem of Floquet and RWA Hamiltonians

let E = 1.0,
    # The configuration below gives us a small gap 
    #Ω = 0.2, 
    #ω = 0.58, 
    Ω = 0.2, 
    ω = 0.3,
    N = 80
    
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N:N - 1)
    H_RWA     = ham_RWA(atom)
    
    println("Floquet:")
    display(H_floquet)
    println("RWA:")
    display(H_RWA)
    println()
    
    E_floquet = sort(back_to_1BZ.(eigen(H_floquet).values, ω))
    E_RWA     = sort(back_to_1BZ.(eigen(H_RWA).values    , ω))
    display(E_floquet)
    display(E_RWA)
end

#endregion
######################################################

######################################################
#region The Floquet spectrum v.s. the RWA spectrum, quantitatively:
# plots of eigensystem

let E = 1.0,
    Ω = 1.0, 
    ω = 0.95, 
    N = 200
    
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N:N - 1)
    H_RWA     = ham_RWA(atom)
    
    E_floquet = sort(back_to_1BZ.(eigen(H_floquet).values, ω))
    E_RWA     = sort(back_to_1BZ.(eigen(H_RWA).values    , ω))
    
    p = scatter(E_floquet)
    hline!(p, E_RWA)
    ylims!(p, (0, 1))
    p
end

let E = 1.0,
    Ω = 1.0, 
    ω = 0.9999999, 
    N = 200
    
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N:N - 1)
    H_RWA     = ham_RWA(atom)
    
    E_floquet = sort(eigen(H_floquet).values)
    E_RWA     = sort(eigen(H_RWA).values)
    
    p = scatter(E_floquet)
    ylims!(p, (E_RWA[1]-5, E_RWA[2]+5))
    hline!(p, E_RWA)
    p
end

#endregion
######################################################

######################################################
#region  The Floquet spectrum v.s. the RWA spectrum, quantitatively: heatmap

function floquet_energy_level_align(ω, E1, E2; N=5)
    displacements = collect(- N : N - 1) * ω
    E1_displaced = map(Iterators.product(map(E -> E .+ displacements, E1)...)) do E1′
        sort([E1′...])
    end

    energy_differences = (x -> norm(x)).(E1_displaced .- [E2]) 
    E1_displaced[argmin(energy_differences)]
end

function floquet_rwa_diff(E, Ω, ω, N; ϵ = 0.01) 
    Δ = E - ω 
    atom = TwoLevelFloquetAtom(Δ, Ω, ω)

    H_floquet = ham_floquet(atom, -N : N - 1)
    H_RWA     = ham_RWA(atom)
    
    E_floquet = sort(eigen(H_floquet).values)
    E_RWA     = sort(eigen(H_RWA).values)  
    
    ΔE² = map(E_RWA) do E
        minimum((E_floquet .- E).^2)
    end
    
    #E_average = map(x -> max(x, ϵ), E_average)
    #mean(sqrt.(ΔE.^2) ./ E_average) 
    E_floquet = map(E_RWA) do E
        E_floquet[argmin((E_floquet .- E).^2)]
    end
    sqrt(mean(ΔE² ./ E_floquet.^2)) 
end

let Ω_list = LinRange(0, 2, 500), 
    ω_list = LinRange(0, 2, 500)
    
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

    pyplot()
    p = heatmap(Ω_list, ω_list, sqrt_mse_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega / \omega_{\mathrm{eg}}",
        ylabel = L"\omega / \omega_{\mathrm{eg}}",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
        clims = (0, 1),
        background_color = :transparent,
        xtickfontsize=18,ytickfontsize=18,
        xlabelfontsize=18,ylabelfontsize=18,
        colorbar_tickfontsize=18,
        xticks = [0.0, 1.0, 2.0],
        yticks = [0.0, 1.0, 2.0],
        colorbar_ticks=[0.0, 0.5, 1.0],
        size=(500, 400)
    )
    display(p)
    savefig(p, "relative-error-rwa.pdf")
    p
end

#endregion
######################################################

######################################################
#region Fixed Ω

let Ω_list = [1.0], 
    ω_list = LinRange(0, 2, 5000)
    
    sqrt_mse_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(sqrt_mse_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            sqrt_mse_list[Ω_idx, ω_idx] = floquet_rwa_diff(1.0, Ω, ω, 40)
            next!(progress)
        end
    end
    
    p = plot(ω_list, sqrt_mse_list[1, :], 
        xlabel = L"\omega / \omega_{\mathrm{eg}}")
    display(p)
    p
end

#endregion
######################################################

######################################################
#region Fixed ω

let Ω_list = LinRange(0, 2, 10000),
    ω_list = [0.5]
    
    sqrt_mse_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(sqrt_mse_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            sqrt_mse_list[Ω_idx, ω_idx] = floquet_rwa_diff(1.0, Ω, ω, 40)
            next!(progress)
        end
    end
    
    p = plot(Ω_list, sqrt_mse_list[:, 1], 
        xlabel = L"\Omega / \omega_{\mathrm{eg}}")
    p
end

#endregion
######################################################

######################################################
#region Fixed ω, plot band gap 

let Ω_list = LinRange(0, 2, 100),
    ω_list = LinRange(0, 2, 200),    
    E = 1.0, 
    N = 10
    
    gap_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(gap_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            Δ = E - ω
            sys = TwoLevelFloquetAtom(Δ, Ω, ω)
            H_RWA = ham_RWA(sys)
            E_RWA = back_to_1BZ.(eigen(H_RWA).values, ω)
            gap_list[Ω_idx, ω_idx] = abs(E_RWA[1] - E_RWA[2]) 
            next!(progress)
        end
    end
    
    Ω_min = minimum(Ω_list)
    Ω_max = maximum(Ω_list)
    ΔΩ    = step(Ω_list)
    ω_min = minimum(ω_list)
    ω_max = maximum(ω_list)
    Δω    = step(ω_list)
    p = heatmap(Ω_list, ω_list, gap_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega / \omega_{\mathrm{eg}}",
        ylabel = L"\omega / \omega_{\mathrm{eg}}",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
    )
    display(p)
    p
end

let Ω_list = LinRange(0, 2, 100),
    ω_list = LinRange(0, 2, 200),    
    E = 1.0, 
    N = 10
    
    gap_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(gap_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            Δ = E - ω
            sys = TwoLevelFloquetAtom(Δ, Ω, ω)
            H_RWA = ham_RWA(sys)
            #E_RWA = back_to_1BZ.(eigen(H_RWA).values, ω)
            # It seems the sole reason there are discontinuity in the heatmap 
            # is because back_to_1BZ itself introduces discontinuity.
            E_RWA = eigen(H_RWA).values
            gap_list[Ω_idx, ω_idx] = abs(E_RWA[1] - E_RWA[2]) 
            next!(progress)
        end
    end
    
    Ω_min = minimum(Ω_list)
    Ω_max = maximum(Ω_list)
    ΔΩ    = step(Ω_list)
    ω_min = minimum(ω_list)
    ω_max = maximum(ω_list)
    Δω    = step(ω_list)
    p = heatmap(Ω_list, ω_list, gap_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega / \omega_{\mathrm{eg}}",
        ylabel = L"\omega / \omega_{\mathrm{eg}}",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
    )
    display(p)
    p
end

let Ω_list = LinRange(0, 2, 200),
    ω_list = LinRange(0, 2, 200),    
    E = 1.0, 
    N = 10
    
    gap_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(gap_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            Δ = E - ω
            sys = TwoLevelFloquetAtom(Δ, Ω, ω)
            H_RWA = ham_RWA(sys)
            #E_RWA = back_to_1BZ.(eigen(H_RWA).values, ω)
            E_RWA = eigen(H_RWA).values
            gap_list[Ω_idx, ω_idx] = minimum(E_RWA) 
            next!(progress)
        end
    end
    
    Ω_min = minimum(Ω_list)
    Ω_max = maximum(Ω_list)
    ΔΩ    = step(Ω_list)
    ω_min = minimum(ω_list)
    ω_max = maximum(ω_list)
    Δω    = step(ω_list)
    p = heatmap(Ω_list, ω_list, gap_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega / \omega_{\mathrm{eg}}",
        ylabel = L"\omega / \omega_{\mathrm{eg}}",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
    )
    display(p)
    p
end

#endregion
######################################################

######################################################
#region Plot difference between RWA and Floquet 

let Ω_list = LinRange(0, 2, 200),
    ω_list = LinRange(0, 2, 200),    
    E = 1.0, 
    N = 10
    
    diff_list = zeros(length(Ω_list), length(ω_list))
    progress = Progress(length(diff_list))
    for (Ω_idx, Ω) in enumerate(Ω_list)
        for (ω_idx, ω) in enumerate(ω_list)
            Δ = E - ω
            sys = TwoLevelFloquetAtom(Δ, Ω, ω)
            H_RWA = ham_RWA(sys)
            E_RWA = sort(eigen(H_RWA).values) 
            H_floquet = ham_floquet(sys, -N:N-1)
            E_floquet = sort(eigen(H_floquet).values)
            diff_list[Ω_idx, ω_idx] = minimum(abs.(E_floquet .- E_RWA[2])) 
            next!(progress)
        end
    end
    
    Ω_min = minimum(Ω_list)
    Ω_max = maximum(Ω_list)
    ΔΩ    = step(Ω_list)
    ω_min = minimum(ω_list)
    ω_max = maximum(ω_list)
    Δω    = step(ω_list)
    p = heatmap(Ω_list, ω_list, diff_list', 
        aspect_ratio = :equal,
        xlabel = L"\Omega / \omega_{\mathrm{eg}}",
        ylabel = L"\omega / \omega_{\mathrm{eg}}",
        xlims = (Ω_min - ΔΩ / 2, Ω_max + ΔΩ / 2),
        ylims = (ω_min - Δω / 2, ω_max + Δω / 2), 
    )
    display(p)
    p
end

#endregion
######################################################