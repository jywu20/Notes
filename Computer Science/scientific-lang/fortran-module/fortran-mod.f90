module arrays
    implicit none
    
contains
    function my_length(arr) 
        real(8), intent(in), dimension(:) :: arr
        integer :: my_length 

        my_length = size(arr) 
    end function my_length
end module arrays