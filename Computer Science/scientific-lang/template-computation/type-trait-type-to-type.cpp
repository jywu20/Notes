#include<type_traits>
#include<complex>

// The default case
template <typename T>
// No <T> allowed here: this is a primary template without any specialization:
// it's some sort of a default case.
struct Magnitude 
{
    using type = T; // To be visited by Magnitude::type
};

template <typename T>
// If we are assuming that the type passed to the Magnitude template takes a special form,
// the pattern is to be defined here;
// we still need a type parameter after the template keyword
struct Magnitude<std::complex<T>> 
{
    using type = T;
};

int main(int argc, char const *argv[])
{
    auto v = std::complex<float>(1.0, 2.0);
    Magnitude<std::complex<float>>::type abs_v = abs(v);
    // Do something to abs_v
    return 0;
}
