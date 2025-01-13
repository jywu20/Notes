See [here](https://julialang.github.io/PackageCompiler.jl/dev/devdocs/sysimages_part_1.html).

```shell
$(which julia) -e "unsafe_string(Base.JLOptions().image_file) |> println"
```

```
/home/jinyuan/software/julia-1.9.2/lib/julia/sys.so
```

$(which julia) --startup-file=no --output-o mat_mut_naive.o mat_mut_naive.jl

Currently this doesn't work; probably we need to wait until Julia 1.12 is released.