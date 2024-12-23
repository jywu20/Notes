#include<iostream>

// The primary template.
template <typename ...P> struct sum_type;

template <typename T>
struct sum_type<T> // Note that here we *need* <T>, because this is not the primary template anymore.
{
    using type = T;
};

template <typename T, typename ...P>
struct sum_type<T, P...> // P... here unpacks the sequence of types
{
    // What we are doing here is to decide the type of 
    // the expression t + p1 + p2 + ... where t is of type T
    // and p1 is of the first type in P and ...
    // The keyword typename is here because sum_type<P...>::type is a type and not a function,
    // so the keyword typename has to appear here.
    using type = decltype(T() + typename sum_type<P...>::type());
};

template <typename ...P>
using sum_type_t = typename sum_type<P...>::type;

// Now we can define the actual sum function.
template <typename T>
inline T sum(T t) {return t;}

// We may want to write decltype(t + sum(p...)) as the type of the return value,
// but this fails because a function like sum(P ...p) has to be defined once as a whole:
// writing decltype(t + sum(p...))  as the return value assumes that we can define 
// sum(p), sum(p1, p2), sum(p1, p2, p3), ... separately and resursively,
// which is not allowed in C++.
// We may also understand this return type as the return type of a single function,
// but now we have to allow that the body of a function is defined before its return type is defined,
// which is not possible in C++.
template <typename T, typename ...P>
inline sum_type_t<T, P...> sum(T t, P ...p)
{
    return t + sum(p...);
}

int main(int argc, char const *argv[])
{
    // The numbers: an integer, a float, a unsigned integer, and a long float.
    auto s = sum(-1, 1.2f, 9u, -2.6);
    std::cout << s << std::endl;
    return 0;
}
