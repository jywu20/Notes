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

The SSA Julia IR corresponding to a loop 
inevitably involves multiple assignments 
when the code is actually run.
However, if we just look at the listing,
we still only find one assignment for each variable,
although this assignment is executed 
for several times due to the control flow.

```julia
function test2(n)
    x = 0
    while x <= n
        x += 1
    end
    x
end
```

```
julia> code_typed(test2)
1-element Vector{Any}:
 CodeInfo(
1 ─      nothing::Nothing
2 ┄ %2 = φ (#1 => 0, #3 => %5)::Int64
│   %3 = (%2 <= n)::Any
└──      goto #4 if not %3
3 ─ %5 = Base.add_int(%2, 1)::Int64
└──      goto #2
4 ─      return %2
) => Int64
```

```
julia> code_typed(test2, (Int,))
1-element Vector{Any}:
 CodeInfo(
1 ─      nothing::Nothing
2 ┄ %2 = φ (#1 => 0, #3 => %5)::Int64
│   %3 = Base.sle_int(%2, n)::Bool
└──      goto #4 if not %3
3 ─ %5 = Base.add_int(%2, 1)::Int64
└──      goto #2
4 ─      return %2
) => Int64
```
In this simple case, if the input type is specified, 
the corresponding relation between the LLVM code and the typed IR code is clear:
```
julia> code_llvm(test2, (Int,))
;  @ REPL[50]:1 within `test2`
define i64 @julia_test2_886(i64 signext %0) #0 {
top:
  br label %L2

L2:                                               ; preds = %L2, %top
  %value_phi = phi i64 [ 0, %top ], [ %1, %L2 ]
;  @ REPL[50]:3 within `test2`
; ┌ @ int.jl:488 within `<=`
   %.not = icmp sgt i64 %value_phi, %0
; └
;  @ REPL[50]:4 within `test2`
; ┌ @ int.jl:87 within `+`
   %1 = add i64 %value_phi, 1
; └
;  @ REPL[50]:3 within `test2`
  br i1 %.not, label %L7, label %L2

L7:                                               ; preds = %L2
;  @ REPL[50]:6 within `test2`
  ret i64 %value_phi
}
```