program passing_different_arrays_around
    implicit none
    
    real, dimension(3) :: r
    real, dimension(4) :: x
    real, dimension(:), allocatable :: alloc
    ! We can't declare deferred type array in the main program!
    !real, dimension(:) :: arbitrary
    
    r = [0.0,  1.0, 2.0]
    x = [-1.0, 0.0, 2.0, 4.0]
    
! Interacting between fixed size array types
!==================================================================
    
    ! The following line is not legal, 
    ! because dimension is checked when a fixed size array 
    ! is passed to another variable typed as a fixed size array

    !print *, "Applying sum4d to a 3d array ", sum4d(r)


    ! However, passing a fixed size array to 
    ! a dummy array argument with a smaller size is good.
    print *, "Applying sum2d to a 3d array                 ", sum2d(r)

    ! And - surprise! - when the expected dimension of the array 
    ! is explicitly passed to a function (the array is known as an automatic array)
    ! and that dimension is NOT the dimension of the array passed to the same function, 
    ! it works! 
    ! We see exactly the same behavior of 
    ! what is seen when an allocatable array is passed to a fixed size array dummy variable
    print *, "Applying sum_automatic_array (size=5) to 3d array ", sum_automatic_array(r, 5)

    ! It should be noted that the following direct assignments are not possible
    !x = r
    !r = x
    
!==================================================================

! Passing allocatable arrays to fixed size array dummy arguments and 
! assigning them to fixed size variables
!================================================================== 
    
    ! When an allocatable 4-element array is passed 
    ! to a fixed array dummy argument, 
    ! it is similarly "truncated" into a 3-element array 
    ! when passed to sum3d (but see below).
    allocate(alloc(4))
    alloc(1) = 1.0
    alloc(2) = 2.0
    alloc(3) = 3.0
    alloc(4) = 10.0

    ! We can pass allocatable arrays to functions with fixed size dummy arguments; 
    ! interestingly, even when the size of alloc is smaller than the size required, 
    ! it still works!
    ! The usual truncation also happens when the size of the dummy argument is smaller than 
    ! the size of the array passed to the function.
    print *, "result of sum3d                  on alloc", sum3d(alloc)
    print *, "result of sum4d                  on alloc", sum4d(alloc)
    print *, "result of sum5d                  on alloc", sum5d(alloc)
    print *, "result of sum_assumed_size       on alloc", sum_assumed_size(alloc)
    print *, "Applying sum_automatic_array (size=5) on alloc", sum_automatic_array(alloc, 5)

    ! It's possible to pass the allocatable array to a fixed size variable:
    ! the usual truncation appears
    r = alloc
    print *, "Passing a 4-element array to a 3-element one: ", r

!==================================================================

! Pass allocatable arrays to fixed size variables
!==================================================================
 
    ! The reverse of r = alloc, interestingly, is also feasible; 
    alloc = r
    print *, "Assign fixed length array to alloc", alloc
    print *, "Size of alloc now is changed", size(alloc)
    print *, "But it's still allocatable", allocated(alloc)
    
    ! Passing fixed size arrays to functions with allocatable dummy arguments
    ! is not possible

    !print *, sum_allocated(r)
    
    deallocate(alloc)

!==================================================================


contains

    ! In the following I set up several functions
    ! accepting arrays with sizes 2, 3, 4, and 5,
    ! all rank-1 arrays, and allocatable arrays.
    ! These functions are going to be used to test 
    ! how different types of array interact.

    function my_size(arr)
        real, intent(in), dimension(:) :: arr
        integer :: my_size 
       
        my_size = size(arr)
    end function my_size
    
    function sum2d(arr) result(res)
        real, intent(in), dimension(2) :: arr
        real :: res
    
        res = sum(arr)     
    end function sum2d
   

    function sum3d(arr) result(res)
        real, intent(in), dimension(3) :: arr
        real :: res
    
        res = sum(arr)     
    end function sum3d

    function sum4d(arr) result(res)
        real, intent(in), dimension(4) :: arr
        real :: res
    
        res = sum(arr)     
    end function sum4d

    function sum5d(arr) result(res)
        real, intent(in), dimension(5) :: arr
        real :: res
    
        res = sum(arr)     
    end function sum5d

    function sum_assumed_size(arr) result(res)
        real, intent(in), dimension(:) :: arr
        real :: res
    
        res = sum(arr) 
    end function sum_assumed_size
    
    function sum_automatic_array(arr, n) result(res)
        real, intent(in), dimension(n) :: arr
        integer, intent(in) :: n
        real :: res
        
        res = sum(arr)
    end function sum_automatic_array
    
    function sum_allocated(arr) result(res)
        real, intent(in), dimension(:), allocatable :: arr
        real :: res
    
        res = sum(arr) 
    end function sum_allocated
end program passing_different_arrays_around