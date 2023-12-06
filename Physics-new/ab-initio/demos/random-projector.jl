using Statistics
using Plots
using ProgressMeter

N_S = 100

wfcs = map(1 : N_S) do S
    vec = zeros(ComplexF64, N_S)
    vec[S] = 1.0
    vec
end

rand_eiθ(N) = exp.(im * 2π * rand(N))

function random_projector()
    eiθ_list = rand_eiθ(N_S)
    res = zeros(ComplexF64, N_S, N_S)
    for n1 in 1 : N_S
        for n2 in 1 : N_S
            res += eiθ_list[n1]' * wfcs[n1] * eiθ_list[n2] * wfcs[n2]'
        end
    end
    res
end

let N_ξ = 3
    progress = Progress(N_ξ)
    amplitudes = abs.(mean(map(1:N_ξ) do _
        res = random_projector()
        next!(progress)
        res
    end))
    heatmap(
        amplitudes, 
        aspect_ratio = :equal,
        xlims = (0.5, N_S - 0.5),
        ylims = (0.5, N_S - 0.5),
    )
end

# It can be seen that we need Nξ∼10 to get a relatively good 
# approximation of the projector, and hence the Green function 
# when the high-energy poles are moved out of the summation 
# over all bands.
# The problem, however, is that Nξ can be 1-3 for GW calculations, 
# without harming the accuracy.
# This means the pseudobands technique needs further investigation, 
# as it can't be justified by stochastic convergence as Nξ → ∞.