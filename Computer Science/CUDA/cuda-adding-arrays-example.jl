using CUDA
using BenchmarkTools
using Test

N = 2^20
x = fill(1.0f0, N)  # a vector filled with 1.0 (Float32)
y = fill(2.0f0, N)  # a vector filled with 2.0

function sequential_add!(y, x)
    for i in eachindex(y, x)
        @inbounds y[i] += x[i]
    end
    return nothing
end

fill!(y, 2)
sequential_add!(y, x)
@test all(y .== 3.0f0)

function parallel_add!(y, x)
    Threads.@threads for i in eachindex(y, x)
        @inbounds y[i] += x[i]
    end
    return nothing
end

fill!(y, 2)
parallel_add!(y, x)
@test all(y .== 3.0f0)

x_d = CUDA.fill(1.0f0, N) # Here the d means "device"
y_d = CUDA.fill(1.0f0, N)

# The version of add! below is very slow, 
# because the task runs on CPU and involves data transmission between 
# CPU and GPU
function slow_gpu_add!(y, x)
    for i in eachindex(y, x)
        @inbounds y[i] += x[i]
    end
end

function gpu_broadcast_add!(y, x)
    CUDA.@sync y .+= x
    return
end

gpu_broadcast_add!(y_d, x_d)
@test all(Array(y_d) .== 3.0) 

@btime sequential_add!($y, $x)
@btime parallel_add!($y, $x)
#@btime slow_gpu_add!($y_d, $x_d) # Very, very slow.  
@btime gpu_broadcast_add!($y_d, $x_d) 
# It's much slower than the CPU version on not-so-good GPUs; 
# on the other hand, on Perlmutter, running this script and you will see 
# $ julia -t 4 cuda-example-1.jl 
# 108.563 μs (0 allocations: 0 bytes)
# 33.653 μs (24 allocations: 2.28 KiB)
# 14.717 μs (31 allocations: 1.86 KiB)