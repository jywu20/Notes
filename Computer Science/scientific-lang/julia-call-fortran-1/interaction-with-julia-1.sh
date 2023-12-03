gfortran -shared -o interaction-with-julia-1.so interaction-with-julia-1.f90
nm -D interaction-with-julia-1.so
# The name mangling convention can then be observed from the output.