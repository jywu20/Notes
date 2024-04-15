#include<iostream>

int main(int argc, char const *argv[])
{
    double v[3], w[] = {2., 4., 6.}, x[] = {6., 5., 4.};
    for (int i = 0; i < 3; i++)
    {
        v[i] = w[i] + x[i];
    }

    for (int i = 0; i < 3; i++)
    {
        std::cout << "v[" << i << "] = " << v[i] << '\n';
    }

    for (double vi : v)
    {
        std::cout << vi << '\n';
    }

    return 0;
}
