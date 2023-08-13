# Compiled forms 

There are four functions that display various compiling results of Julia.
They are `code_lowered`, `code_typed`, `code_llvm` and `code_native`.
It seems to me that `code_lowered` is nothing more 
than the desugared AST.
For example, for the following Julia code
```julia
function test1(x)
    x = x - 3
    if x < 3
        y = x * 2
    else
        y = x - 3
    end
    
    w = x - y
    z = x + y

    (w, z)
end
```
we have 
```
julia> code_lowered(test1, (Int64,))
1-element Vector{Core.CodeInfo}:
 CodeInfo(
1 ─       x@_6 = x@_2
│         Core.NewvarNode(:(z))
│         Core.NewvarNode(:(w))
│         Core.NewvarNode(:(y))
│         x@_6 = x@_6 - 3
│   %6  = x@_6 < 3
└──       goto #3 if not %6
2 ─       y = x@_6 * 2
└──       goto #4
3 ─       y = x@_6 - 3
4 ┄       w = x@_6 - y
│         z = x@_6 + y
│   %13 = Core.tuple(w, z)
└──       return %13
)
```
It can be seen that variable declarations are made 
in the beginning of the code block,
and control flows are all represented by GOTO statements; 
this style is very similar to what early Fortran does;
the only major difference is 
Fortran doesn't allow dynamic typing.
As for `code_typed`, we have 
```
julia> code_typed(test1, (Int64,))
1-element Vector{Any}:
 CodeInfo(
1 ─ %1  = Base.sub_int(x@_2, 3)::Int64
│   %2  = Base.slt_int(%1, 3)::Bool
└──       goto #3 if not %2
2 ─ %4  = Base.mul_int(%1, 2)::Int64
└──       goto #4
3 ─ %6  = Base.sub_int(%1, 3)::Int64
4 ┄ %7  = φ (#2 => %4, #3 => %6)::Int64
│   %8  = Base.sub_int(%1, %7)::Int64
│   %9  = Base.add_int(%1, %7)::Int64
│   %10 = Core.tuple(%8, %9)::Tuple{Int64, Int64}
└──       return %10
) => Tuple{Int64, Int64}
```
There are two notable changes compared with the IR
given by `code_lowered`. 
The first is, as the name indicates, 
`code_types` runs on a somehow *statically* typed IR.
In the above example, 
type information is given, 
but even when it's not, 
type annotations are still made, 
as is shown by the following block:
```
julia> code_typed(test1)
1-element Vector{Any}:
 CodeInfo(
1 ─ %1  = (x@_2 - 3)::Any
│   %2  = (%1 < 3)::Any
└──       goto #3 if not %2
2 ─ %4  = (%1 * 2)::Any
└──       goto #4
3 ─ %6  = (%1 - 3)::Any
4 ┄ %7  = φ (#2 => %4, #3 => %6)::Any
│   %8  = (%1 - %7)::Any
│   %9  = (%1 + %7)::Any
│   %10 = Core.tuple(%8, %9)::Tuple{Any, Any}
└──       return %10
) => Tuple{Any, Any}
```
It can also be seen that in the more generic version, 
expressions like `x@_2 - 3` are still "templatic": 
they are still waiting for multiple dispatch to happen.
In the more specific version given by 
`code_typed(test1, (Int64,))`, 
these expressions are replaced by concrete methods,
like `Base.sub_int`.
The second notable change is 
the IR used in `` is a SSA form: 
thus, although in `code_lowered` 
we are able to assign to a variable 
for multiple times, 
in `code_typed`, 
a variable is assigned to for one and only one time.
If in a `if` expression, 
a variable is assigned to in both branches, 
a $\phi$ node is inserted 
at the end of the compilation target 
of the `if` block,
retrieving the correct value of the variable 
depending on how we get to the $\phi$ node.
In the example above, `%7  = φ (#2 => %4, #3 => %6)::Any`
retrieves the value of `y` after the `if` block.

