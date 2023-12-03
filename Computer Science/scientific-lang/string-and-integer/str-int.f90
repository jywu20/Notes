program StringAndIntegerIO
    implicit none
    
    integer :: i
    integer :: student_number
    integer, dimension(:), allocatable :: student_id_list
    
    read *, student_number
    allocate(student_id_list(student_number))
    
    do i = 1, student_number
        ! The format string means: first a string, 
        ! then an integer with a width of 4, 
        ! and finally a string 
        print "(A, I4, A)", "student ", i, ":"
        read *, student_id_list(i)
    end do
    
    print *, "student ids are: "
    print *, student_id_list
    
    deallocate(student_id_list) 
end program StringAndIntegerIO