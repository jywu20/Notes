program StaticLinking
    implicit none
    
    integer, parameter :: dp = 8
    real(8), dimension(:), allocatable :: arr
    integer :: length
    integer :: i

    print *, "Length of the array:"
    read *, length

    allocate(arr(length))
    do i = 1, length
        print *, "Element ", i
        read *, arr(i)
    end do

    print *, "Length calculated by passing the array to function:"
    print *, my_length(arr)
    deallocate(arr)
    
contains 

    function my_length(arr) 
        real(8), intent(in), dimension(:) :: arr
        integer :: my_length 

        my_length = size(arr) 
    end function my_length

end program StaticLinking