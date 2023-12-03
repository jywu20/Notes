subroutine add(a, b, c)
    integer(kind=4), intent(in)  ::  a
    integer(kind=4), intent(in)  ::  b
    integer(kind=4), intent(out) ::  c
    
    c = a + b
end subroutine add