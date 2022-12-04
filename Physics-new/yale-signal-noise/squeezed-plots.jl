using QuantumOptics
using LaTeXStrings
using Plots

b = FockBasis(20)

a = destroy(b)
at = create(b)

##

n = 2 
ψ = fockstate(b, n)

Δx = 0.01
Reα_min = -5
Reα_max = 5
Reαs = collect(Reα_min : Δx : Reα_max)
Imα_min = -5
Imα_max = 5
Imαs = collect(Imα_min : Δx : Imα_max)

wigner_sampled = zeros(length(Reαs), length(Imαs))

for (i, Reα) in enumerate(Reαs)
    for (j, Imα) in enumerate(Imαs)
        wigner_sampled[j, i] = wigner(ψ, Reα + im * Imα)
    end
end

cmap = cgrad([:cyan, :black, :orange], [0.0, 0.5, 1.0])
p = heatmap(Reαs, Imαs, wigner_sampled, 
    c = cmap, 
    clim = (-0.3, 0.3), 
    aspect_ratio=:equal, 
    xlim = (Reα_min, Reα_max))
xlabel!(p, L"\mathrm{Re} \alpha")
ylabel!(p, L"\mathrm{Im} \alpha")

savefig(p, "fock-state.pdf")

##

##
 
ψ = coherentstate(b, 0)

Δx = 0.01
Reα_min = -5
Reα_max = 5
Reαs = collect(Reα_min : Δx : Reα_max)
Imα_min = -5
Imα_max = 5
Imαs = collect(Imα_min : Δx : Imα_max)

wigner_sampled = zeros(length(Reαs), length(Imαs))

for (i, Reα) in enumerate(Reαs)
    for (j, Imα) in enumerate(Imαs)
        wigner_sampled[j, i] = wigner(ψ, Reα + im * Imα)
    end
end

cmap = cgrad([:cyan, :black, :orange], [0.0, 0.5, 1.0])
p = heatmap(Reαs, Imαs, wigner_sampled, 
    c = cmap, 
    clim = (-0.3, 0.3), 
    aspect_ratio=:equal,
    xlim = (Reα_min, Reα_max),)
xlabel!(p, L"\mathrm{Re} \alpha")
ylabel!(p, L"\mathrm{Im} \alpha")

savefig(p, "coherent-state.pdf")

##

##

# This setting gives an empty heatmap,
# because the expected photon number exceeds 
# out cutoff 20
ψ = coherentstate(b, 2 + 2im)

Δx = 0.01
Reα_min = -5
Reα_max = 5
Reαs = collect(Reα_min : Δx : Reα_max)
Imα_min = -5
Imα_max = 5
Imαs = collect(Imα_min : Δx : Imα_max)

wigner_sampled = zeros(length(Reαs), length(Imαs))

for (i, Reα) in enumerate(Reαs)
    for (j, Imα) in enumerate(Imαs)
        wigner_sampled[j, i] = wigner(ψ, Reα + im * Imα)
    end
end

cmap = cgrad([:cyan, :black, :orange], [0.0, 0.5, 1.0])
p = heatmap(Reαs, Imαs, wigner_sampled, 
    c = cmap, 
    clim = (-0.3, 0.3), 
    aspect_ratio=:equal,
    xlim = (Reα_min, Reα_max),)
xlabel!(p, L"\mathrm{Re} \alpha")
ylabel!(p, L"\mathrm{Im} \alpha")

savefig(p, "coherent-state2.pdf")

##

##
 
S(ξ) = exp(dense(ξ' * a^2 - ξ * at^2) / 2)
ψ = S(1/2 + sqrt(3) / 2 * im) * coherentstate(b, 0)

Δx = 0.01
Reα_min = -5
Reα_max = 5 
Reαs = collect(Reα_min : Δx : Reα_max)
Imα_min = -5
Imα_max = 5
Imαs = collect(Imα_min : Δx : Imα_max)

wigner_sampled = zeros(length(Reαs), length(Imαs))

for (i, Reα) in enumerate(Reαs)
    for (j, Imα) in enumerate(Imαs)
        wigner_sampled[j, i] = wigner(ψ, Reα + im * Imα)
    end
end

cmap = cgrad([:cyan, :black, :orange], [0.0, 0.5, 1.0])
p = heatmap(Reαs, Imαs, wigner_sampled, 
    c = cmap, 
    clim = (-0.3, 0.3), 
    aspect_ratio=:equal,
    xlim = (Reα_min, Reα_max),)
xlabel!(p, L"\mathrm{Re} \alpha")
ylabel!(p, L"\mathrm{Im} \alpha")

savefig(p, "squeezed-state.pdf")

##

##
 
ψ = normalize(coherentstate(b, 2 + 2im) + coherentstate(b, -2 - 2im))

Δx = 0.01
Reα_min = -5
Reα_max = 5
Reαs = collect(Reα_min : Δx : Reα_max)
Imα_min = -5
Imα_max = 5
Imαs = collect(Imα_min : Δx : Imα_max)

wigner_sampled = zeros(length(Reαs), length(Imαs))

for (i, Reα) in enumerate(Reαs)
    for (j, Imα) in enumerate(Imαs)
        wigner_sampled[j, i] = wigner(ψ, Reα + im * Imα)
    end
end

cmap = cgrad([:cyan, :black, :orange], [0.0, 0.5, 1.0])
p = heatmap(Reαs, Imαs, wigner_sampled, 
    c = cmap, 
    clim = (-0.3, 0.3), 
    aspect_ratio=:equal,
    xlim = (Reα_min, Reα_max),)
xlabel!(p, L"\mathrm{Re} \alpha")
ylabel!(p, L"\mathrm{Im} \alpha")

savefig(p, "coherent-state-composition.pdf")

##