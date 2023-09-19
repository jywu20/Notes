using QuantumOptics
using Plots
using ProgressMeter

# Number of photon modes in the bath 
N = 10000 

# The first state is |e, no photon>; 
# the (i + 1)th state is |g, one photon in mode i>
basis = NLevelBasis(N + 1)

g = 0.1 * ones(Float64, N)
ω = rand(Float64, N)
ω_eg = 0.2

H_0 = map(enumerate(ω)) do (i, ωi)
    ωi * transition(basis, i + 1, i + 1)
end |> sum

H_0 += transition(basis, 1, 1)

H_int = map(enumerate(g)) do (i, gi)
    gi * transition(basis, 1, i + 1) + gi' * transition(basis, i + 1, 1)
end |> sum

H = H_0 + H_int

ψ_g = nlevelstate(basis, 1)
ψ = nlevelstate(basis, 1) 

t_span = LinRange(0, 5, 1000)

progress = Progress(length(t_span); barglyphs=BarGlyphs("[=> ]"), barlen=50, color=:blue)
_, ψ_g_t = timeevolution.schroedinger(t_span, ψ, H, fout = (t, ψ) -> begin
    next!(progress)
    ψ_g' * ψ
end)

plot(t_span, abs.(ψ_g_t))


# The result seems rather weird, why ψ_g_t is so periodic?