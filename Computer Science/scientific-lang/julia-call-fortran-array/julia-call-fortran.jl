arr = [1.0, 2.0, 3.0]
arr_len = length(arr)

println("The Fortran average function.")
res = @ccall "./fortran-lib.so".average_(
    arr::Ptr{Float64}, arr_len::Ref{Int32})::Float64
println(res)

println("Trying to let Fortran decide how large the array is: the no bind(c) version.")
res = @ccall "./fortran-lib.so".my_length_(arr::Ptr{Float64})::Int32
println(res)
# The return value is zero; 
# probably this is an undefined behavior; 
# In C, sizeof doesn't work for arrays passed to a function, 
# and an additional length of array parameter is needed,
# as is said in https://stackoverflow.com/questions/37538/how-do-i-determine-the-size-of-my-array-in-c
# In Fortran, if an array with unknown is passed to a function, 
# its length is also passed to that function,  
# but in an implicit way by the so-called array descriptor;
# size(arr) then reads the array descriptor. 
# In principle we are able to construct an array descriptor 
# and pass it to a Fortran function or subroutine, 
# so that the Fortran code feels that the array is created in Fortran:
# see https://fortran-lang.discourse.group/t/allocate-interoperability-and-c-descriptors/5088.
# Also see this: https://thinkingeek.com/2017/01/14/gfortran-array-descriptor/
#
# Then it makes me wonder why passing a pointer to the Fortran subroutine, 
# which should be an array descriptor, doesn't cause any problem:
# it seems in https://fortran-lang.discourse.group/t/allocate-interoperability-and-c-descriptors/5088., 
# what is passed to the Fortran subroutine is a pointer of the array descriptor;
# but both the assembly code output of compilation and 
# the fact that we are able to pass a pointer to the first element of an array 
# to a Fortran subroutine without any problem 
# suggest that the array descriptor should be passed as value, not as pointer.
# The reason might be the bind(C) option: 
# indeed for gfortran, the assembly codes generated with and without bind(c) 
# are completely different, and the version with bind(c)
# doesn't seem to pass the whole array descriptor by value to my_length:
# if I turned on the bind(c) option but still pass the array as a pointer to the function, 
# an error will appear.


# The following lines have to be commented because it leads to immediate program crash.
#println("Trying to let Fortran decide how large the array is: the bind(c) version.")
#res = @ccall "./fortran-lib.so".my_length_c(arr::Ptr{Float64})::Int32
#println(res)
#
# Result: Internal Error: Invalid type in descriptor

println("Trying to let Fortran decide how large the array is: the bind(c) version.")

using StaticArrays

struct DescriptorDimension  
    stride      :: Cptrdiff_t 
    lower_bound :: Cptrdiff_t
    upper_bound :: Cptrdiff_t
end

struct Descriptor{R, T}
    base_addr :: Ptr{T}
    offset :: Cptrdiff_t
    dtype :: Cptrdiff_t
    dim :: StaticArray{R, DescriptorDimension} 
    # Alright, so I'm trying to implement the array descriptor mentioned in https://thinkingeek.com/2017/01/14/gfortran-array-descriptor/
    # The problem here is we can't define something like descriptor_dimension dim[Rank] in Julia, 
    # which is an array without any descriptor attached to it: 
    # can I just use StaticArray?
end

function fortran_dtype_specifier(rank::Integer, element_type, element_size::Integer)
    element_type_coding = Dict(
        Cint => 1, 
        Bool => 2,
        Cfloat => 3, 
        Complex => 4, 
        :drived => 5, 
        Cchar => 6
    )
    
    rank = Int(rank)
    element_type = element_type_coding[element_type]
    element_size = Int(element_size)

    spec = rank                 # The rightmost three bits are for the rank 
    spec |= (element_type << 3) # The middle 3 bits are for the element type 
    spec |= (element_size << 6)

    spec
end

let base_address = Base.unsafe_convert(Ptr{Int}, arr),
    offset = -1, # 1-based indexing
    dtype = fortran_dtype_specifier(1, Cint, 8), # rank 2, integer, and the size of each element is 8 bytes
    stride = length(arr), 
    lower_bound = firstindex(arr), 
    upper_bound = lastindex(arr)

    descriptor = Descriptor(base_address, offset, dtype, 
        SVector{1, DescriptorDimension}([
            DescriptorDimension(stride, lower_bound, upper_bound)
        ]))
   
    res = @ccall "./fortran-lib.so".my_length_c(Ref{Descriptor}(descriptor)::Ref{Descriptor})::Int32
    println(res)
end