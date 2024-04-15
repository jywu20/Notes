//#define NDEBUG 
// The above line disables assertions;
// but it's much better to pass the value by -DNDEBUG 
#include<cassert>

double sqrt(double x)
{
    assert(x >= 0);
    return 0.0;
}

int main(int argc, char const *argv[])
{
    sqrt(-1);
    return 0;
}
