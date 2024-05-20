gfortran -fopenmp parallel-sum.f90 -o parallel-sum.x
export OMP_NUM_THREADS=4
# We don't need mpirun here: it's only for MPI tasks.
./parallel-sum.x