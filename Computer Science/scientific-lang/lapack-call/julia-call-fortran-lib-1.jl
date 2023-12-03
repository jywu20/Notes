function compute_dot(DX::Vector{Float64}, DY::Vector{Float64})
    @assert length(DX) == length(DY)
    n = length(DX)
    incx = incy = 1
    # The name of the library may differ from installation to installation;
    # so is the symbol ddot_.
    # In the example of https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#Fortran-Wrapper-Example,
    # There is no underscore at the end of ddot_.
    # By default, functions are found in the lib folder in Linux. 
    # For example on Ubuntu, 
    # by sudo apt-get install libblas-dev liblapack-dev
    # we are able to have /lib/x86_64-linux-gnu/liblapack.so,
    # which is the libary called here. 
    product = @ccall "liblapack".ddot_(
        # For Fortran libraries, 
        # scalar arguments should be passed as Ref, 
        # because in Fortran subroutines are able to modify input variables.
        # This doesn't make it possible for us to change the value of variables in Julia:
        # if that's the behavior we want, 
        # we need to declare a Ref ourselves and pass it to @ccall
        # MethodError: no method matching unsafe_convert(::Type{Ptr{Int32}}, ::Int32)
        n::Ref{Int32}, DX::Ptr{Float64}, incx::Ref{Int32}, 
                       DY::Ptr{Float64}, incy::Ref{Int32})::Float64
    return product
end
