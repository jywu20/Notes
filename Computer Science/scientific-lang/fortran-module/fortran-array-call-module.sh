gfortran -o fortran-array-call-module.x fortran-array-call-module.f90 fortran-mod.f90
gfortran -o fortran-array.so -shared fortran-mod.f90
nm -D fortran-array.so
./fortran-array-call-module.x