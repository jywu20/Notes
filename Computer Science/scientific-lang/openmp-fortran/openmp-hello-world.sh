gfortran -fopenmp openmp-hello-world.f90 -o openmp-hello-world.x
export OMP_NUM_THREADS=4
# We don't need mpirun here: it's only for MPI tasks.
./openmp-hello-world.x