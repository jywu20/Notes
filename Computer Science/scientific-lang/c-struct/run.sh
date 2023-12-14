gcc -shared c-function-accepting-struct-example.c -o c-function-accepting-struct-example.so
nm -D c-function-accepting-struct-example.so
julia  julia-call-c-passing-struct.jl
