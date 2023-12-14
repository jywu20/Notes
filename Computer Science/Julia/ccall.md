Foreign function calling, and Julia ABI
========

https://stackoverflow.com/questions/27498755/integrating-fortran-code-in-julia

# Passing a value, or a pointer?

In Julia it seems all composite data types are passed by sharing:
```julia
function first(s::NTuple{3, Int})
    s[1]
end

@code_llvm first((1, 2, 3))
``` 
```llvm
;  @ REPL[22]:1 within `first`
define i64 @julia_first_949([3 x i64]* nocapture noundef nonnull readonly align 8 dereferenceable(24) %0) #0 {
top:
;  @ REPL[22]:2 within `first`
; ┌ @ tuple.jl:29 within `getindex`
   %1 = getelementptr inbounds [3 x i64], [3 x i64]* %0, i64 0, i64 0
; └
  %2 = load i64, i64* %1, align 8
  ret i64 %2
}
```
Note that we have a star after `[3 x i64]` and `dereferenceable(24)`.

Similarly we have 
```julia
using StaticArrays

function first(s::SVector{3, Int})
    s[1]
end

arr = SVector{3, Int}([1, 2, 3])
@code_llvm first(arr)
```
```llvm
;  @ REPL[9]:1 within `first`
define i64 @julia_first_909([1 x [3 x i64]]* nocapture noundef nonnull readonly align 8 dereferenceable(24) %0) #0 {
top:
;  @ REPL[9]:2 within `first`
; ┌ @ /home/jinyuan/.julia/packages/StaticArrays/yXGNL/src/SArray.jl:62 within `getindex` @ tuple.jl:29
   %1 = getelementptr inbounds [1 x [3 x i64]], [1 x [3 x i64]]* %0, i64 0, i64 0, i64 0
; └
  %2 = load i64, i64* %1, align 8
  ret i64 %2
}
```
Again we see a star after the type declaration.

This is also the case in `StaticCompiler` - see `Computer Science/scientific-lang/julia-static-compiler`.

This behavior is documented in https://docs.julialang.org/en/v1/manual/functions/#Argument-Passing-Behavior. 
This originates from the "label binding" semantics of Julia variables;
in principle, even primitive data types can be understood in this way, 
but since they are never mutated internally in any way, 
in the actual compiling process they are passed by value.

However, it seems that when a Julia `struct` or `Tuple` is passed to a C function using `ccall`, 
it's passed by value -- see `Computer Science/scientific-lang/c-struct`.

On the other hand, user-defined or built-in primitive types are passed by value.
This can be seen by the following demonstration:
```julia
primitive type MyInt8 8 end

function +(a::MyInt8, b::MyInt8)::MyInt8
    a′ = reinterpret(Int8, a)
    b′ = reinterpret(Int8, b)
    reinterpret(MyInt8, a′ + b′)
end

@code_llvm +(reinterpret(MyInt8, Int8(1)), reinterpret(MyInt8, Int8(2)))
```
```llvm
define void @"julia_+_2501"(i8 zeroext %0, i8 zeroext %1) #0 {
top:
  %2 = alloca [2 x {}*], align 8
  %.sub = getelementptr inbounds [2 x {}*], [2 x {}*]* %2, i64 0, i64 0
;  @ REPL[5]:4 within `+`
  %3 = zext i8 %0 to i64
  %4 = getelementptr inbounds [256 x {}*], [256 x {}*]* @jl_boxed_int8_cache, i64 0, i64 %3
  %5 = load {}*, {}** %4, align 8
  %6 = zext i8 %1 to i64
  %7 = getelementptr inbounds [256 x {}*], [256 x {}*]* @jl_boxed_int8_cache, i64 0, i64 %6
  %8 = load {}*, {}** %7, align 8
  store {}* %5, {}** %.sub, align 8
  %9 = getelementptr inbounds [2 x {}*], [2 x {}*]* %2, i64 0, i64 1
  store {}* %8, {}** %9, align 8
  %10 = call nonnull {}* @ijl_apply_generic({}* inttoptr (i64 140081897692808 to {}*), {}** nonnull %.sub, i32 2)
  call void @llvm.trap()
  unreachable
}
```
The code is a mess, but the first line is very clear: the two variables - `%0` and `%1` - are indeed passed as values; 
and therefore primitive types are always immutable.

*The only way we are able to modify a variable in a primitive type 
is to reinterpret the variable as some sort of containers, 
and then modify its "elements".
But this can't be done: no method of `reinterpret` can do so, 
and when you try to implement this yourself, 
you find you don't have enough primitives to do so.*

*It may be possible to modify a memory region used to store someone with a primitive type; suppose we point a variable to that memory region,
this may create a semantic ambiguity about whether the value of the latter variable should change.*

~~We can also verify this behavior using `StaticCompiler.jl`.~~
For some reason `StaticCompiler` refuses to accept the function in `Computer Science/scientific-lang/julia-primitive-type-calling-convention/user-defined-primitive-type-lib.jl`.
I also fail to modify a primitive type because I can't convert it to a container type.
