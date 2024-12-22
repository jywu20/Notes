#include<iostream>
#include<vector>
#include<memory>

int main(int argc, char const *argv[])
{
    std::cout << "Part 1: reference to array element" << std::endl;

    int arr[] = {1, 2, 3};
    std::cout << arr[1] << std::endl;

    int& ref = arr[1];
    ref = 4;
    std::cout << arr[1] << std::endl;
    std::cout << ref << std::endl;
    
    std::cout << "Part 2: reference to vector element" << std::endl;
    // Note that here we can't directly pass arr to the vector constructor,
    // because an array doesn't know how long it is.
    std::vector<int> vec = {1, 2, 3};
    std::cout << vec[2] << std::endl;    
    // Here we can't reuse ref, because ref has been bound to arr[1]
    // and can't be reseated.
    // Also, the return value of operator[] of a std::vector is a reference,
    // and therefore if we write int result = vec[2],
    // then the value of vec[2] is copied into result,
    // while if we write int& ref2 = vec[2],
    // then we get a reference directly pointing to vec[2].
    // We can't do this in C: in C we have to explicitly return a pointer,
    // so the * operator has to appear somewhere.
    int& ref2 = vec[2];
    ref2 = 5;
    std::cout << vec[2] << std::endl;
    
    // References are just pointers with restricted operations on them.
    // We can do the same with a pointer.
    int *ptr2 = &(vec[2]);
    *ptr2 = 6;
    std::cout << vec[2] << std::endl;
    
    std::cout << "Part 3: reference to resources managed by smart pointer" << std::endl;
    std::unique_ptr<std::vector<int>> ptr_to_vec{new std::vector<int>(4, 0)};
    std::cout << (*ptr_to_vec)[2] << std::endl;
    // Here *ptr_to_vec is the std::vector, and (*ptr_to_vec)[2] 
    // is a reference to the address where the third element of the vector is stored.
    // Note that to allow modification of the whole object managed by the smart pointer,
    // the return value of operator* of unique_ptr is also a reference.
    int& ref3 = (*ptr_to_vec)[2];
    ref3 = 1;
    std::cout << (*ptr_to_vec)[2] << std::endl;
    
    return 0;
}
