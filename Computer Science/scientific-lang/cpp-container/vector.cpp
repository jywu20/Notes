#include<vector>
#include<iostream>
#include<cassert>

// v1 and v2 are references, to avoid copying.
template <typename T>
std::vector<T> add(std::vector<T>& v1, std::vector<T>& v2)
{
    assert(v1.size() == v2.size());
    std::vector<T> sum(v1.size());
    for (size_t i = 0; i < v1.size(); i++)
    {
        sum[i] = v1[i]+ v2[i];
    }
    
    // No need to use move semantics here since return value optimization will happen.
    // When we write return expression(v1, v2),
    // there may be a copy operation,
    // but the second copy - from the return value to the variable that catches the return value
    // can usually be avoided.
    return sum;
}

int main(int argc, char const *argv[])
{
    std::vector<float> v = {1, 2, 3};

    std::cout << "Part 1: reading and writing elements." << std::endl;

    // Unfortunately we don't have enumerate before C++ 23,
    // so the good old index-based for loop is used instead.
    for (size_t i = 0; i < v.size(); i++)
    {
        std::cout << "v[" << i << "] = " << v[i] << std::endl;  
    }
    
    std::cout << "Part 2: adding two vectors up." << std::endl;
    
    auto s = add(v, v);
    // Unfortunately we don't have enumerate before C++ 23,
    // so the good old index-based for loop is used instead.
    for (size_t i = 0; i < v.size(); i++)
    {
        std::cout << "2v[" << i << "] = " << s[i] << std::endl;  
    }

    std::cout << "Part 3: \"constant\" vectors." << std::endl;
    // Initialize a vector with 3 elements, which are all zero.
    std::vector<float> all_zero(3, 0);

    std::cout << "Part 4: vector and array." << std::endl;
    // Here we copy the content of all_zero to an array.
    float all_zero_arr[3];
    std::copy(all_zero.begin(), all_zero.end(), all_zero_arr);
    // Note that in C++, when we access an array, it's treated as a pointer,
    // so it makes no sense to do
    // std::cout << all_zero_arr << std::endl;
    // instead, we do
    for (size_t i = 0; i < all_zero.size(); i++)
    {
        std::cout << all_zero_arr[i] << " ";
    }
    std::cout << std::endl;
    

    return 0;
}
