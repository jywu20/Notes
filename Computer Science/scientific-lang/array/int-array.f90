program IntegerArrays
    implicit none
    
    integer, dimension(3) :: a, b
    integer, dimension(:, :), allocatable :: c
    
    a = [1, 2, 3]
    b = [4, 5, 6]
    
    allocate(c(1, 3))
    c(1, :) = a + b 
    print *, c
    deallocate(c)     
end program IntegerArrays