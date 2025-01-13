program parallel_sum
    use omp_lib
    implicit none
    integer :: sum_result
    
    call parallel_sum_critical(1000, sum_result)
    print *, sum_result
    call parallel_sum_critical(1000, sum_result)
    print *, sum_result
    
contains 

    subroutine parallel_sum_critical(max, result)
        integer, intent(in) :: max
        integer, intent(out) :: result
    
        integer :: total_sum, partial_sum 
        integer :: i
        
        ! Note that the do directive instructs the compiler to divide the work,
        ! but doesn't launch any threads.
        ! It has t obe used in a parallel block.
        !$omp parallel shared(total_sum) private(partial_sum)
        total_sum = 0
        partial_sum = 0
        !$omp do 
        do i = 1, max
            partial_sum = partial_sum + i
            !print *, i, omp_get_thread_num() 
        end do
        !$omp end do
        
        ! The critical construct is slower than the reduction clause
        !$omp critical 
        total_sum = total_sum + partial_sum
        !$omp end critical
        !$omp end parallel
        
        result = total_sum
    end subroutine parallel_sum_critical
    
    subroutine parallel_sum_reduction(max, result)
        integer, intent(in) :: max
        integer, intent(out) :: result
    
        integer :: total_sum
        integer :: i

        ! Note that this line of initialization has no effect:
        ! the initial value of total_sum is determined by the type and the operator.
        total_sum = 0 
        !$omp parallel do reduction(+:total_sum)
        do i = 1, max
            total_sum = total_sum + i
        end do
        !$omp end parallel do
        result = total_sum
    end subroutine parallel_sum_reduction

end program parallel_sum