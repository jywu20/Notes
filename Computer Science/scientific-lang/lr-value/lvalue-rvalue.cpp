#include<utility>

template <typename T>
void f1(T p) {}

template <typename T>
void f2(const T& p) {}

template <typename T>
void f3(T& p) {}

template <typename T>
void f4(T&& p) {}

template <typename T>
void f5(T&& p) {
    f3(p);
}

template <typename T>
void f6(T&& p) {
    f3(std::forward<T>(p));
}

int main(int argc, char const *argv[])
{
    int i = 0;
    float j0 = 0.0;
    float& j = j0;
    char k0 = 'a';
    const char& k = k0;  
    
    // i, j, k are all lvalues; 
    // they therefore all work with f1:
    // the initialization p = i, p = j, p = k all results in calling the copy constructor.
    // f1 can also accept a literal.
    f1(1); f1(i); f1(j); f1(k);
    
    // The three also work with f2:
    // the initialization p = i, p = j, p = k all results 
    // in creating a constant reference to the three.
    // const T& p can also accept a literal.
    f2(1); f2(i); f2(j); f2(k);

    // i, j, k still work well with f3;
    // the literal however doesn't work with f3,
    // because it's a rvalue.
    /*f3(1);*/ f3(i); f3(j); f3(k);
    
    // A literal is a rvalue, so it can be accepted by a rvalue reference.
    // It's also possible to assign lvalue references to rvalue references.
    f4(1); f4(i); f4(j); f4(k);
    // std::move maps a lvalue reference to a rvalue reference;
    // the results can also be assigned to T&& p.
    f4(std::move(j)); f4(std::move(k));

    // On the other hand, it's not possible to pass a rvalue reference to a lvalue reference 
    /* f3(std::move(i)); */
    // On the other hand, it's possible to pass a rvalue reference to f5:
    // although f5 calls f3, which only accept lvalue references,
    // once the rvalue reference is passed to p,
    // p, having a name and therefore a lvalue, is passed to f3,
    // and no error is raised.
    f5(std::move(i));
    
    // On the other hand, std::forward<int>(p) is still a rvalue (because this is perfect forwarding),
    // and the following statement results in an error.
    /* f6(std::move(i)); */

    return 0;
}
