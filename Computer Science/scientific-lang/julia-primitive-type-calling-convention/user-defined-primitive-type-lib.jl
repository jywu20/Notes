using StaticCompiler

primitive type MyInt 64 end

function my_add(a::MyInt, b::MyInt)::MyInt
    a′ = reinterpret(Int64, a)
    b′ = reinterpret(Int64, b)

    reinterpret(MyInt, a′ + b′)
end

compile_shlib(my_add, (MyInt, MyInt))