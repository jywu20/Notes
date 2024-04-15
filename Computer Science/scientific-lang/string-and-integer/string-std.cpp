#include<string>
#include<iostream>

int main(int argc, char const *argv[])
{
    std::string s3 = "This is a long, long, and long string. "
                     "This string is definitely too long for one line"
                     "so we break it into several lines. "
                     "Note that no enter is inserted."
    ;
    std::cout << s3 << std::endl;

    
    
    return 0;
}
