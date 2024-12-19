#include<vector>

int main(int argc, char const *argv[])
{
    std::vector<int> v = {1, 2, 3};
    const auto& v_ref = v;
    
    // The line below is not right:
    // you can't get a modifiable reference from a const &.
    // The const in, say, JavaScript roughly correspond to ordinary reference,
    // except in C++, assignment to a reference is legal.
    //
    // With all the references, C++ programming becomes kind of like Fortran programming:
    // If an input to a function is never modified,
    // and we don't want to copy it,
    // we use const &, which is equivalent to intent(in) in Fortran.
    // The main difference is that we don't have intent(out):
    // there is only intent(inout), which is just &.
    v_ref[0] = 2;
    

    return 0;
}
