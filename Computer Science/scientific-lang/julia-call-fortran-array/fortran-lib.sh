gfortran -shared fortran-lib.f90 -o fortran-lib.so
nm -D fortran-lib.so
julia julia-call-fortran.jl