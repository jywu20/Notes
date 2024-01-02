using CUDA
using BenchmarkTools
using Test

N = 2^20
# Here the d means "device"; the data is stored on graphics card, not in RAM
x_d = CUDA.fill(1.0f0, N) 
y_d = CUDA.fill(1.0f0, N)

function gpu_broadcast_add!(y, x)
    CUDA.@sync y .+= x
    return
end

CUDA.fill!(y_d, 2)
gpu_broadcast_add!(y_d, x_d)
@test all(Array(y_d) .== 3.0) 

# This, despite looking like an ordinary function, 
# has the potential to be a CUDA kernel
function single_thread_add_kernel!(y, x)
    for i in 1 : length(y) #eachindex(y, x) doesn't work here: why?
        @inbounds y[i] += x[i]
    end
end

# Sealing the CUDA kernel into a CPU subroutine  
# which looks like a serial subroutine because of @sync
function single_thread_add!(y, x)
    CUDA.@sync begin
        @cuda single_thread_add_kernel!(y, x)
    end
end

CUDA.fill!(y_d, 2)
single_thread_add!(y_d, x_d)
@test all(Array(y_d) .== 3.0) 

function single_block_add_kernel!(y, x)
    starting_point = threadIdx().x
    stride = blockDim().x
    
    # This kernel is meant to be run on one block  
    # containing a one-dimensional array of threads.
    # Therefore the number of threads is just blockDim().x
    # y[1] is dealt by thread 1, 
    # y[2] by thread 2, etc., 
    # and y[1 + blockDim().x] is dealt by thread 1,
    # and it goes on and on in this way.
    for i in starting_point : stride : length(y)
        @inbounds y[i] += x[i]
    end
end

function single_block_add!(y, x)
    CUDA.@sync begin
        # The number of threads is hard-coded here.
        @cuda threads=256 single_block_add_kernel!(y, x)
    end
end

CUDA.fill!(y_d, 2)
single_block_add!(y_d, x_d)
@test all(Array(y_d) .== 3.0)

function multi_block_add_kernel!(y, x)
    # The logic is the same as  that in single_block_add_kernel!,
    # but since now we want to use more streaming processors in the GPU,
    # we'd better ask for multiple blocks,
    # and the starting point and stride parameters have to change.

    starting_point = threadIdx().x + blockDim().x * (blockIdx().x - 1) 
    stride = blockDim().x * gridDim().x

    for i in starting_point : stride : length(y)
        @inbounds y[i] += x[i]
    end 
end

function multi_block_add!(y, x)
    num_blocks = ceil(Int, length(y) / 256)

    CUDA.@sync begin
        @cuda threads=256 blocks=num_blocks multi_block_add_kernel!(y, x)
    end
end

CUDA.fill!(y_d, 2)
multi_block_add!(y_d, x_d)
@test all(Array(y_d) .== 3.0)


println("broadcast function in CUDA.jl:")
@btime gpu_broadcast_add!($y_d, $x_d)
println("Single thread adding:")
@btime single_thread_add!($y_d, $x_d)
println("Single block adding:")
@btime single_block_add!($y_d, $x_d)
println("Multiple block adding:")
@btime multi_block_add!($y_d, $x_d)
# The default broadcasting is the fastest way;
# the single thread kernel is the slowest, 
# actually much slower than the CPU version;
# the single block kernel improves the performance, 
# and the multiple block kernel's performance is very close to the builtin version.
#
# Output on Perlmutter:
# broadcast function in CUDA.jl:
#   18.605 μs (31 allocations: 1.86 KiB)
# Single thread adding:
#   51.492 ms (25 allocations: 1.20 KiB)
# Single block adding:
#   747.395 μs (25 allocations: 1.20 KiB)
# Multiple block adding:
#   19.086 μs (23 allocations: 1.14 KiB)