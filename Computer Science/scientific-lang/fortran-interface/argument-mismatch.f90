program argument_mismatch
    implicit none
    
    real :: num
    
    num = 1.1
    call printint(num)
    
end program argument_mismatch

! Don't give this subroutine an interface, 
! or otherwise even the -fallow-argument-mismatch flag won't prevent the compilation error.
! That's to say, don't place printint after the contains keyword.
! Also the conversion is NOT rounding etc.:
! it's reinterpreting a float as an integer,
! so you can expect the output to be strange. 
subroutine printint(num)
    integer, intent(in) :: num

    print *, 'Printed as integer: ', num     
end subroutine printint