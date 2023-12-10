using BenchmarkTools
using Test

println("Package loading finished.")

function sum_def(a)
    s = 0
    for i in a
        s += i
    end
    s
end

# The following function is bond to fail.
function sum_multi_bad(a)
    s = 0
    Threads.@threads for i in a
        s += i
    end
    s
end

# Reliability: data race
#@test sum_multi_bad(1:10000) == sum_def(1:10000)

# The line is commented because it will definitely cause error.
# The result:
# Test Failed at /mnt/d/Notes/Computer Science/Julia/threads.jl:23
# Expression: sum_multi_bad(1:10000) == sum_def(1:10000)
# Evaluated: 28126615 == 50005000
# 
# ERROR: LoadError: There was an error during testing
# in expression starting at /mnt/d/Notes/Computer Science/Julia/threads.jl:23
# 
# The reason is that s += i is not atomic:
# suppose now s is zero, and thread 1 does the follows: 
# temp = s (now temp = 0)
# s = temp + i (suppose i==1, and s is now 1).
# However, when these steps happen, thread 2 also tries to add 2 to s; 
# and suppose when doing `temp = s`, the `s` read is still zero; 
# now after the step s = temp + i, 
# s becomes 2 - not the correct 1 + 2 = 3!

# One way to handle this is to use atomic add:
# Threads has a atomic_add! function, 
# used specifically for manipulating an atomic container.
function sum_multi_atomic(a)
    s = Threads.Atomic{Int}(0)
    Threads.@threads for i in a
        Threads.atomic_add!(s, i) 
    end    
    s[]
end

# The test passes
@test sum_def(1 : 10000) == sum_def(1 : 10000)

# Another way to handle this is to dispatch the computational task to different threads 
function sum_multi_spawn(a)
    chunks = Iterators.partition(a, length(a) ÷ Threads.nthreads())
    tasks = map(chunks) do chunk
        Threads.@spawn sum_def(chunk)
    end
    chunk_sums = fetch.(tasks)
    return sum_def(chunk_sums)
end

# The test passes
@test sum_def(1 : 10000) == sum_multi_spawn(1 : 10000)

# Now we do performance test 
println("Benchmark of the three implementations of sum")
@btime sum_def(1 : 10000000)
@btime sum_multi_atomic(1 : 10000000)
@btime sum_multi_spawn(1 : 10000000)   
# It can be seen that the atomic implementation is extremely awkward:
# it's a serial code essentially, but also with overhead from thread communication 
# The sum_multi_spawn has similar performance compared with sum_def; 
# the task of summation is too simple, after all.

function exp_map(arr)
    res = zeros(length(arr))
    Threads.@threads for i in eachindex(arr)
        x = arr[i]
        res[i] = exp(-x)
    end
    res
end

println("Benchmark of exp")
@test exp_map(1 : 500000) == exp.(-(1 : 500000))
@btime exp_map(1 : 500000)
@btime exp.(-(1 : 500000))
# The complexity of exp is already high enough 
# for multithreading to show significant boost of performance; 
# still, due to overheads, the multithreading version is only 
# 2x faster than the serial version
# when 4 threads are used.
# Note that in exp_map, different threads work on 
# different elements of an array, so although they are working on the same variable,
# no data race happens.

