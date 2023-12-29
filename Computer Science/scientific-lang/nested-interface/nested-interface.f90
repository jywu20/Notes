program nested_interface
    implicit none
    
contains
    subroutine print_generate(fun)
        interface 
            function fun(func2, i) result(res)
                integer, intent(in) :: i
                integer :: res
                interface 
                    function func2(j) result(res)
                        integer, intent(in) :: j
                        integer :: res
                    end function func2
                end interface 
            end function fun
        end interface
        
        
    end subroutine print_generate
end program nested_interface