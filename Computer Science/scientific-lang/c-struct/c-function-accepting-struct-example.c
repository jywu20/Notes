typedef struct pair_int
{
    int a; 
    int b;
} pair_int;

// Note that the struct is supposed to be passed by value.
int first(pair_int pair)
{
    return pair.a;
}
