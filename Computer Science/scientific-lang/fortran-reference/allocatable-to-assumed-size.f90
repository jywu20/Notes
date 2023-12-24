program allocatable_to_assumed_size
    implicit none
    
    real, allocatable, dimension(:) :: arr 
    real :: res

    allocate(arr(3))
    
    arr(1) = 1.0
    arr(2) = 2.0
    arr(3) = 4.0
    
    call average(arr, res)

    print *, res
    
    deallocate(arr)
contains
    subroutine average(arr, res)
        real, intent(in), dimension(:) :: arr
        real, intent(out) :: res
        
        res = sum(arr) / size(arr)
    end subroutine average
end program allocatable_to_assumed_size