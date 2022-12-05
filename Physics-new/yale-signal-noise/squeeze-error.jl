using QuantumOptics
using LaTeXStrings
using Plots
using ProgressMeter
using LaTeXStrings

a1_space = FockBasis(30)
a2_space = FockBasis(30)
whole_space = a1_space ⊗ a2_space

a1 = destroy(a1_space) ⊗ identityoperator(a2_space)
at1 = create(a1_space) ⊗ identityoperator(a2_space)
a2 = identityoperator(a1_space) ⊗ destroy(a2_space)
at2 = identityoperator(a1_space) ⊗ create(a2_space)

ϕ = π / 10
bt1 = cos(ϕ) * at1 - im * sin(ϕ) * at2
bt2 = im * sin(ϕ) * at1 - cos(ϕ) * at2
b2 = -im * sin(ϕ) * a1 - cos(ϕ) * a2
nb2 = bt2 * b2

S(ξ, a, at) = exp(dense(ξ' * a^2 - ξ * at^2) / 2)

θ = 2ϕ - π 
polar(r, θ) = r * cos(θ) + im * r * sin(θ)

res = Float64[]

rs = LinRange(0, 0.6, 100)

α = 2 

@showprogress for r in rs
    ψ = S(polar(r, θ), a2, at2) * (coherentstate(a1_space, α) ⊗ coherentstate(a2_space, 0))
    # We can't write
    # push!(res, variance(nb2, ψ))
    # because of small imaginary part arising from numerical error 
    var = sqrt(abs(expect(nb2^2, ψ) - expect(nb2, ψ)^2)) / abs(expect(nb2, ψ))
    push!(res, var)
end

xs = rs |> collect
p = plot(xs, res, label = "real")
xlims!(p, (min(rs...), max(rs...)))
xlabel!(p, L"r")
ylabel!(p, L"\Delta n_{b_2} / \langle n_{b_2} \rangle")
plot!(xs, 1 / (α * ϕ) * exp.(-xs), label = "approx.")
#savefig(p, "squeezing-error-measure-cutoff-30-phi-pi-10-alpha-2.pdf")