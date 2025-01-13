#include<stdio.h>
#include<omp.h>

int f(int x)
{
    return x^2;
}

int main(int argc, char const *argv[])
{
    #pragma omp parallel
    {
        //int num = omp_get
    }

    return 0;
}
