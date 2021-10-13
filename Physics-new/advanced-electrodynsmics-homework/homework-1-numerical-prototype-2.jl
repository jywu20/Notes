using LinearAlgebra
using Statistics
using Plots
using Test
using SpecialFunctions
using SphericalHarmonics

##
# Defining the mesh
# The order of coordinates: r, θ, ϕ

r_points = 40
θ_points = 80
ϕ_points = 20

r_max = 20

r_range = LinRange(0.01, r_max, r_points) 
θ_range = LinRange(0.01, π, θ_points)
ϕ_range = LinRange(0.01, 2π, ϕ_points)

dr = (r_range[end] - r_range[1]) / (r_points - 1)
dθ = (θ_range[end] - θ_range[1]) / (θ_points - 1)
dϕ = (ϕ_range[end] - ϕ_range[1]) / (ϕ_points - 1)

r_idxs = 1 : length(r_range)
θ_idxs = 1 : length(θ_range)
ϕ_idxs = 1 : length(ϕ_range)

r = [r_this for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]
θ = [θ_this for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]
ϕ = [ϕ_this for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]

#dV = [r_this^2 * dr * sin(θ_this) * dθ * dϕ for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]
dV = dr * dθ * dϕ * r.^2 .* sin.(θ)
x = @. r * sin(θ) * cos(ϕ)
y = @. r * sin(θ) * sin(ϕ)
z = @. r * cos(θ)

e_r = [[sin(θ_this) * cos(ϕ_this), sin(θ_this) * sin(ϕ_this), cos(θ_this)] for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]
e_θ = [[cos(θ_this) * cos(ϕ_this), cos(θ_this) * sin(ϕ_this), - sin(θ_this)] for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]
e_ϕ = [[- sin(ϕ_this), cos(ϕ_this), 0.0] for r_this in r_range, θ_this in θ_range, ϕ_this in ϕ_range]

e_r_conj = map(x -> x', e_r)
e_θ_conj = map(x -> x', e_θ)
e_ϕ_conj = map(x -> x', e_ϕ)

nothing

##
# Opeartors related to the coordinates

function back_into_range(idx, upper)
    if idx > upper
        return idx % upper
    end
    (idx - upper) % upper + upper
end

function ∂r(f::AbstractArray{F, 3}) where F <: AbstractFloat
    result = zeros(size(f))
    result[1 : end - 1, :, :] = (f[2 : end, :, :] - f[1 : end - 1, :, :]) / dr
    result[end, :, :] = result[end - 1, :, :]
    result
end

function ∂θ(f::AbstractArray{F, 3}) where F <: AbstractFloat
    result = zeros(size(f))
    result[:, 1 : end - 1 , :] = (f[:, 2 : end, :] - f[:, 1 : end - 1, :]) / dθ
    for ϕ_idx in ϕ_idxs
        # Warning: note that the increasing directions of θ with ϕ and ϕ+π are *opposite*, and therefore
        # we should use the following formula instead of 
        # result[:, end, ϕ_idx] = 
        #   (f[:, end - 1, back_into_range(ϕ_idx + Int(ϕ_points / 2), ϕ_points)] - f[:, end, ϕ_idx]) / dθ
        result[:, end, ϕ_idx] = 
            (f[:, end, ϕ_idx] - f[:, end - 1, back_into_range(ϕ_idx + Int(ϕ_points / 2), ϕ_points)]) / dθ
    end
    result 
end 

function ∂ϕ(f::AbstractArray{F, 3}) where F <: AbstractFloat
    result = zeros(size(f))
    result[:, :, 1 : end - 1] = (f[:, :, 2 : end] - f[:, :, 1 : end - 1]) / dϕ
    result[:, :, end] = (f[:, :, 1] - f[:, :, end]) / dϕ
    result
end

##
# Verify whether the definitions work well.
# The orghogonal relations

@test any(x -> x ≈ 1.0, e_r_conj .* e_r)
@test any(x -> x ≈ 1.0, e_θ_conj .* e_θ)
@test any(x -> x ≈ 1.0, e_ϕ_conj .* e_ϕ)

@test any(x -> x ≈ 0.0, e_r_conj .* e_ϕ)
@test any(x -> x ≈ 0.0, e_r_conj .* e_θ)
@test any(x -> x ≈ 0.0, e_θ_conj .* e_ϕ)
@test any(x -> x ≈ 0.0, e_θ_conj .* e_r)
@test any(x -> x ≈ 0.0, e_ϕ_conj .* e_r)
@test any(x -> x ≈ 0.0, e_ϕ_conj .* e_θ)

## 
# Now it is time to deal with vector spherical wave functions.

n_max = 10

jr(n) = map(x -> sqrt(π / 2x) * besselj(n + 1/2, x), r)
Plmcosθ_storage = map(x -> computePlmcostheta(x, lmax = n_max), θ)
Pcosθ(m, n) = map(v -> v[(n, m)], Plmcosθ_storage)
∂θPcosθ(m, n) = (- (n + 1) * cos.(θ) .* Pcosθ(m, n) + (1 - m + n) * Pcosθ(m, n+1)) ./ sin.(θ)

##
plot(r_range, jr(2)[:, 1, 1])

##
plot(θ_range, Pcosθ(0, 3)[1, :, 1])

##

p = plot()
plot!(p, ∂θPcosθ(1, 4)[1, :, 1][2:end-2], label = "formula")
plot!(p, ∂θ(Pcosθ(1, 4))[1, :, 1][2:end-2], label = "numerical")

# The figure is weird. The two curves don't match ?!
# TODO

##

electric_spherical_wave(m, n) = - m .* sin.(m * ϕ) .* Pcosθ(m, n) .* jr(n) .* e_θ ./ sin.(θ) - cos.(m * ϕ) .* jr(n) .* ∂θPcosθ(m, n) .* e_ϕ
electric_spherical_wave_conj(m, n) = - m .* sin.(m * ϕ) .* Pcosθ(m, n) .* jr(n) .* e_θ_conj ./ sin.(θ) - cos.(m * ϕ) .* jr(n) .* ∂θPcosθ(m, n) .* e_ϕ_conj

for np in 1 : n_max - 2
    for mp in 0 : np
        println(sum(electric_spherical_wave_conj(1, 4) .* electric_spherical_wave(mp, np) .* dV))
    end
end
