#include<type_traits>
#include<vector>
#include<iostream>

// In newer versions of C++, is_class_v is defined in STL.
template <typename T>
constexpr bool my_is_class_v = std::is_class<T>::value;

int main(int argc, char const *argv[])
{
    bool vec_is_class = std::is_class<std::vector<int>>::value;
    bool vec_is_class_2 = my_is_class_v<std::vector<int>>;
    std::cout << vec_is_class << std::endl;
    std::cout << vec_is_class_2 << std::endl;
    return 0;
}
