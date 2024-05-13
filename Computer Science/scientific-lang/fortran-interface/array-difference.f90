module array_test
    implicit none
    interface array_type
        module procedure array_type_automatic, array_type_fixed_3
    end interface
contains
    subroutine array_type_automatic(arr)
        integer, intent(in), dimension(:) :: arr
        print *, "Automatic array!"
    end subroutine array_type_automatic
    
    subroutine array_type_fixed_3(arr)
        integer, intent(in), dimension(3) :: arr
        print *, "3-element array!"     
    end subroutine array_type_fixed_3

end module array_test

program array_in_dispatching
    use array_test
    implicit none

    integer, dimension(3) :: arr
    call array_type(arr)
end program array_in_dispatching
