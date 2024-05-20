program parallel_sum
    use omp_lib
    implicit none
    real :: total_sum, partial_sum 
    integer :: i
    
    !$omp parallel shared(total_sum) private(partial_sum)
        total_sum = 0
        partial_sum = 0
        !$omp do 
        do i = 1, 1000
            partial_sum = partial_sum + i
            print *, i, omp_get_thread_num() 
        end do
        !$omp end do
        
        !$omp critical 
        total_sum = total_sum + partial_sum
        !$omp end critical
    !$omp end parallel

    print *, total_sum
end program parallel_sum