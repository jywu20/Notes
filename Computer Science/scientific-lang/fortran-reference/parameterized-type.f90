program parameterized_type
    implicit none
    type :: vector(length)
        integer, len :: length        
        real, dimension(length) :: content
    end type vector
    
    integer :: length 
    type(vector(10)) :: vec

    print *, "length: "
    read *, length

    vec = ones(length)
    print *, vec%content
    
    block
        type(vector(length)) :: vec2
        vec2 = ones(length)
        print *, vec2%content
    end block
contains
    function ones(length) result(res)
        integer, intent(in) :: length
        type(vector(length)) :: res
    
        res%content(:) = 1.0
    end function ones
end program parameterized_type
