program openmp_helloworld
    use omp_lib
    implicit none
    integer :: thread_id

    !$omp parallel private(thread_id)
    thread_id = omp_get_thread_num()
    print *, "Hello from process", thread_id
    !$omp end parallel
end program openmp_helloworld