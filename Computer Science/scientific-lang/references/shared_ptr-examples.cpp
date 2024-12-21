#include<memory>
#include<iostream>

// It's possible to return a 
std::unique_ptr<float> generate_float()
{
    return std::unique_ptr<float>(new float);
}

int main(int argc, char const *argv[])
{
    // Allocate some space to store a float
    std::unique_ptr<float> dp(new float);
    // Modify the value of the said place
    *dp = 7.0;
    
    // The following line doesn't work.
    // Note that it doesn't work at the compilation stage:
    // the copy constructor of unique_ptr is declared as "delete",
    // so no copy constructor can be called.
    // auto dp2 = dp;

    // On the other hand, the move constructor is good:
    std::unique_ptr<float> dp2(std::move(dp));
    std::cout << "dp2: " << *dp2 << std::endl;

    // Note that unlike the case in Rust,
    // std::move does nothing to dp:
    // what destroys dp is the move constructor of unique_ptr.
    // So at the compilation stage,
    // nothing wrong will be reported.
    // When the program is run, however, a segmentation fault will happen.
    // std::cout << "old dp: " << *dp << std::endl;

    // Some resources are allocated in a function,
    // and we use a unique_ptr to hold it.
    auto res = generate_float();
    std::cout << "res: " << *res << std::endl;

    return 0;
}
