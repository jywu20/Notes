function average(arr, length)
    ! Get double precision kind on the machine we are using
    integer, parameter :: dp = 8

    ! Parameters
    real(dp), dimension(length)  :: arr
    integer                      :: length    
    ! Return type 
    real(dp)   :: average

    integer  :: i
    real(dp) :: sum 
    
    sum = 0.0_dp
    do i = 1, length
        sum = sum + arr(i) 
    end do
    
    average = sum / real(length, dp) 
end function average

function my_length(arr) 
    real(8), intent(in), dimension(:) :: arr
    integer :: my_length 

    my_length = size(arr) 
end function my_length

function my_length_c(arr) bind(c)
    real(8), intent(in), dimension(:) :: arr
    integer :: my_length_c

    my_length_c = size(arr) 
end function my_length_c