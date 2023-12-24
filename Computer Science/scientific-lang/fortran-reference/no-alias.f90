module linear_algebra
    implicit none
    
contains
    function dot(arr1, arr2)
        real, dimension(3) :: arr1
        real, dimension(3) :: arr2

        real :: dot
        
        integer :: i
        
        dot = 0.0
        do i = 1, 3
            dot = dot + arr1(i) * arr2(i) 
        end do
    end function dot
    
    function norm2(arr) 
        real, dimension(3) :: arr
        real :: norm2 
    
        norm2 = sqrt(dot(arr, arr)) 
    end function norm2

    subroutine sub(i,i2)
        real, intent(in)  :: i
        real, intent(out) :: i2
        i2 = 2*i
    end subroutine sub
end module linear_algebra

program no_alias
    use linear_algebra
    
    implicit none

    real, dimension(3) :: a 
    real    :: b

    a = [1.0, 2.0, 3.0]
    b = 1.0
    
    print *, dot(a, a)  ! No warning here 
    call sub(b, b)      ! Warning here

end program no_alias

