using Flux 
using Zygote

function loss(xs, ys, a, b)
    diff = a * xs .+ b - ys
    diff' * diff
end

a = [1.0]
b = [1.0]
params = Params([a, b])

xs = [0.0, 1.0]
ys = [0.0, 1.0]

for epoch in 1 : 10000
    Flux.Optimise.update!(Descent(0.01), params, gradient(params) do 
        loss(xs, ys, a[1], b[1])
    end)
end

println(a[1])
println(b[1])
println(loss(xs, ys, a[1], b[1]))