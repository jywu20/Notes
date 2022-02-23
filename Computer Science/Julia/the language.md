# Loops

```julia
list_funcs = []

for n in 1 : 4
    function this_func(x)
        return n * x
    end
    push!(list_funcs, this_func)
end

list_funcs[1](1)   # 1
list_funcs[2](1)   # 2
```