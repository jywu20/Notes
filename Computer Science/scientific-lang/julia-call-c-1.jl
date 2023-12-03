function mycompare(a, b)::Cint
    if a < b
        -1
    elseif a > b 
        +1
    else
        0
    end 
end

mycompare_c = @cfunction(mycompare, Cint, (Ref{Cdouble}, Ref{Cdouble}))

A = [1.3, -2.7, 4.4, 3.1]
@ccall qsort(A::Ptr{Cdouble}, length(A)::Csize_t, sizeof(eltype(A))::Csize_t, mycompare_c::Ptr{Cvoid})::Cvoid
println(A)
