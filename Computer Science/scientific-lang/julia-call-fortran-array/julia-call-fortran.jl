arr = [1.0, 2.0, 3.0]
arr_len = length(arr)

println("The Fortran average function.")
res = @ccall "./fortran-lib.so".average_(
    arr::Ptr{Float64}, arr_len::Ref{Int32})::Float64
println(res)

println("Trying to let Fortran decide how large the array is.")
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
# The reason might be the bind(C) option.