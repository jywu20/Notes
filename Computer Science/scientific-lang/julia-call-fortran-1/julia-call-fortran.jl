a = 12
b = 13
c = Ref{Int32}() # c has to be a Ref, or otherwise it can't be changed

@ccall "./interaction-with-julia-1.so".add_(
    a::Ref{Int32}, b::Ref{Int32}, c::Ref{Int32})::Cvoid

println(c[])