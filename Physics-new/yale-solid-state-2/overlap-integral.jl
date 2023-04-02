using Base.Iterators
using LinearAlgebra
using ProgressMeter

L = 10
nx = 30
Δx = L / nx
axis_mesh = LinRange(- L / 2, L / 2, nx + 1)
r_mesh = product(axis_mesh, axis_mesh, axis_mesh)
r_mesh = map(collect, r_mesh)
dxdydz = Δx^3
ex = [1, 0, 0]

a = 4.69
R1 = - a * ex / 2
R2 = a * ex / 2

A = 1 / (24 * sqrt(5π))
function ϕ(r::Vector{Float64})
    r = norm(r)
    A * r^2 * exp(- r / 2)    
end

q = [0, 0, 0.01]

res = 0.0
progress = Progress(length(r_mesh)^2)
@profview for r1 in r_mesh
    for r2 in r_mesh
        r2 += q
        res += ϕ(r1 - R2) * ϕ(r1 - R1) * 1 / norm(r1 - r2) * ϕ(r2 - R1) * ϕ(r2 - R2)
        next!(progress)
    end
end

res *= dxdydz^2
res