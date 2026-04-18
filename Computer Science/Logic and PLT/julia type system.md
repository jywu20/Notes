The type system of Julia
========

# Dynamic, strong typing

Julia is strongly typed in that all values in Julia have a **concrete type**.
Type checking in Julia happens at runtime and therefore the language is dynamically typed.
Dynamical type checking happens in two places:
1. Function dispatch. That's to say, if a function invocation does not match an existing function definition, then a type error is thrown.
2. Variable type declaration. `x::Int` means any assignment to `x` involves a type conversion, and if this is not possible, a type error is thrown.

There are still a lot of "static typing" mechanisms in Julia,
like declaration of composite types and subtype relations.
This isn't coincidental.
In Lean's type theory, the primitives are only [the type universes, dependent arrow types, and inductive types](https://lean-lang.org/theorem_proving_in_lean4/Inductive-Types/#inductive-types).
Now if we compare the three pillars with industrial languages,
- We don't have type universes in Julia or in most programming languages.
- Arrow types, i.e. function definitions and invocation, correspond to what Julia community calls method dispatch (also see [here](#arrow-type)).
- The "static" mechanisms are [a rather imperfect shadow of inductive types](plt概况.md#结构体和枚举);
mechanisms to attach a tag i.e. a descriptor to a value seem to never be dynamic even in dynamic programming languages
(in Julia, for instance, a struct is a constant).

Below, when we talk about "Julia's type system without qualification,
we're talking about the part of Julia related to definition of composite types, subtypes, etc.
The non-trivial question on the other hand is how to establish a comprehensive *static* type system for Julia that involves *arrow types* (which is, in a trivial sense, always doable - but it's not impossible that whether a term causes a type error has to be decided using mechanisms beyond primitives in standard Julia),
and whether that type system has a set theoretic semantics.
Of course, the existing "static" typing mechanisms, namely definition of composite data types, have to be incorporated directly into that static type system.

# Basic data and types in Julia

## The tree of data types

Concrete types are defined either via `struct` or via `primitive type`.
They can be declared to belong to different abstract types,
thus forming a tree of types connected by subtype relation `<:`.
At the top of the tree sits `Any`.

```julia
function show_supertypes(T)
    while T != Any
        println(T)
        T = supertype(T)
    end
    println(Any)
end

show_supertypes(Int)
# Output:
# Int64
# Signed
# Integer
# Real
# Number
# Any
```

And `12::Number`, `12::Any`, etc.
From this perspective one may want to naively interpret `::` as $\in$, and `<:` as $\subseteq$.
The main problem of this interpretation is `Any::Any`, and this screams Russell's paradox.

The way we adopt to resolve this problem is to assume that a type name means two things:
in `Any::Any`, the first `Any` is understood as a *type tag*, which is nothing but a name (a string, in the metalanguage),
while the second `Any` is interpreted as the set that the name `Any` refers to.
We'll go back to this topic when talking about [the type of a type](#types-of-types).

On the other hand, `A <: B` should be understood as "the set denoted by `A` is a subset of the set denoted by `B`".
That's to say, `A` and `B` should both be understood as the set they refer to and not just the names of the types.


## Types of types

All types defined in the tree of data types have the type `DataType`, whose type is itself.

```julia
typeof.([Integer, Any, FunctionArrow{Int, String}, DataType,])
# Output:
# 4-element Vector{DataType}:
#  DataType
#  DataType
#  DataType
#  DataType
```

However,

```
julia> Union{Int, Float64} :: DataType
ERROR: TypeError: in typeassert, expected DataType, got Type{Union{Float64, Int64}}
```

This means in the set denoted by `DataType`, we can only find concrete type tags, like `Int` or `Float64`, but not unions.
Because `DataType` is a concrete type tag, `DataType :: DataType` (that's to say, the tag `DataType` belongs to the set denoted by itself).

A user defined struct in Julia behaves in a way comparable to types shipped with Julia - primitive or composite.

```julia
struct A end
A::DataType
A()::A
A <: Any
```

That's to say, the tag `A` is in the set denoted by `DataType`,
and the set denoted by `A` is a subset of the set denoted by `Any`.

Thus the situation is illustrated below.
Here dots being in a circle means $\in$, and a circle being in another means $\subseteq$.
Hence `1::Number`, `Float64::DataType`, `Any::DataType`, and so on.
Note that the `1` value in the set denoted by `Int64` has the tag `Int64` on it, and so on.

![](julia-basic-types.png)


## Tuples

A tuple in Julia is almost a tuple in untyped set theory.

```julia
Tuple{Int} <: Tuple{Integer} # true
```

Unlike the case of tuples, we have 
```julia
!(Vector{Int} <: Vector{Integer})
```
This means parameterized structs are nominal. 

It is also how we capture variable number of arguments.

```julia
f(x...) = x
typeof(f(1, 2, 3)) # Tuple{Int64, Int64, Int64}
```

Julia offers some primitives to define flexible tuple types.
For instance,
```julia
NTuple{2, Int} == Tuple{Int, Int}
```
Note that `Tuple{Int, Tuple{Float64, Float64}}` is not the same as `Tuple{Int, Float64, Float64}`.
We seems to be unable to define a flat tuple with $n$ `Int` elements and $m$ `Float64` elements.
But this isn't necessarily a bad thing, as it would be hard to operate on such a tuple.

`NTuple` can be seen as a counterpart of `Fin n -> a` in Lean.

## `Type`

Besides `DataType`, we also have `Type`.
We have `DataType <: Type`, and this also means `DataType :: Type`,
as the tag `DataType` is in the set denoted by `DataType`
and hence has to be in the set denoted by `Type`.
What non-`DataType` elements `Type` has will be discussed later.

# Parameterized types

## Parameters in type definition

Parametric types in Julia have no substantial difference from parametric types in other languages.
For instance we have 
```julia
struct MyStaticVector{N, T}
    data::NTuple{N, T}
end

MyStaticVector{2, Int}((1, 2))
```
The parameters have two roles.
First, they are a part of the type tag of the composite data type, which carries metadata in method dispatch;
this isn't fundamentally from how an integer is different from a string of the same size in memory, but offers us a way to do limited pattern matching with the help of method dispatching, as now we can write something like 

```julia
f(::Val{1}, ...) = ...
f(::Val{2}, ...) = ...
```

Second, because of `NTuple`, Julia allows type operations that dynamically decide the structure of the composite type.

Currently, Julia's parametric types are very limited.
It is for instance not possible to write
```julia
struct B{N}
    data::Tuple{2*N, Int}
end
```

## Type-to-type functions?

Naturally we ask why `MyStaticVector` is not defined as a function.
It *is* possible to define functions taking type arguments and returning either a type or a value.
For instance, 

```julia
create_tuple(t::Type) = NTuple{3, t}
create_tuple(Int) # Tuple{Int64, Int64, Int64}

string(Int) # "Int64 
```

But these functions can't be used in parametric type definitions.

```julia
struct B{N}
    data::create_tuple(N)
end
# RROR: MethodError: no method matching create_tuple(::TypeVar)
```

Obviously the type of anything passed to a parametric type definition is assigned as `TypeVar`,
and there is no way to get an `Int` from a `TypeVar` and feed it to `create_tuple`.
It is clear that type-level operations in Julia,
if defined as regular functions, can't be used in type definitions,
while type-level operations in type definitions are highly limited.

This constraint certainly has a lot of reasons,
one being machine code optimization relies on concrete types.

Another motivation for this limit is the aforementioned set theoretic semantics of the type system.
A generic function from one type to another itself belongs to a higher universe:
in Lean for instance 
```lean
#check Type -> Type 
-- Type 1
```
And therefore if such a type constructor is a member of the set denoted by `Any`
then the latter isn't a well defined set at all. 

So in order to weaken the generic type constructor,
two things can be done.

First, an ordinary function that takes a type and does something to it and return it 
actually takes a *type expression* from the set denoted by the type `Type`:

```julia
string(Union{Int, Float64}) # "Union{Float64, Int64}"
```

And it can trigger some type operations (as in `create_tuple`).
However, it doesn't define a new type `A` that appears in something like `x::A`.

Second, the only thing 

# Arrow type

## Encoding `A -> B`

It's not straightforward to refer to a function like $f: A \to B$ (called a **method** in Julia terminology) directly in Julia,
as in Julia, a **function** contains several methods, and which method is called when a function invocation happens is decided by multiple dispatch.

Therefore, a function (in Julia terminology) is just a *name*, and hence should be regarded as a singleton.

```julia
typeof(typeof) # typeof(typeof) (singleton type of function typeof, subtype of Function)
```

Conversely a method can be attached to anything - including an existing singleton.

```julia
(::Nothing)(x) = x
nothing(1) # 1
```

However, it is still possible to simulate arrow types in Julia.
This can be done by the following construct:

```julia
struct FunctionArrow{A, B} 
    run::Function
end

function (f::FunctionArrow{A, B})(x::A) where {A, B}
    return f.run(x)::B
end

# A function with multiple methods
function foo(x::Int)
    x + 1
end

function foo(x::String)
    x
end

foo(5) # 6 
foo("str") # "str"

foo_packaged = FunctionArrow{Int, Int}(foo)
foo_packaged(5) # 6
foo_packaged("std") # MethodError
```

`foo_packaged` obligatorily calls the `Int -> Int` method of `foo`,
and if this is not possible, raises a method error.
That's to say, if `f::FunctionArrow{A, B}` and `x::A`, then `f(x)` causes no method error, if and only if 
- There exists a `A -> B` method of the function `f.run`, and 
- That method causes no method error in its internal code.

Recursively, this means if in a Julia program,
functions are always defined using `FunctionArrow` (perhaps with some macros to automatically extract the type information of a `function` block
and pass it to a corresponding `FunctionArrow` constructor),
then type safety can be guaranteed by static check. 

Some sort of dependent type-like feature exists in Julia: 

```julia
using StaticArrays

function foo(n::Int)::SVector{n, Int64}
    SVector{n, Int64}(zeros(n))
end

foo(2)
# Output:
# 2-element SVector{2, Int64} with indices SOneTo(2):
#  0
#  0
```

The type of this method is `(n:Int):SVector{n, Int64}`, but this type can't be captured by `FunctionArrow` defined above.
Therefore Julia lacks the ability to express dependent arrow types with its native type notation.

In simply typed lambda calculus, all we need is the arrow type,
and composite data types can be encoded into arrow types.
In Julia we start with composite data types and method dispatch
and end up getting an arrow type.

## Size issues

If we treat `Int` or `BigInt` as the true natural number set,
then the size of a set denoted by a tuple or a struct on top of the true natural number set 
is identical to $\aleph_0$.
If we allow functions to be *generic* functions in set theory (a standard practice in studying set theoretic semantics of type systems), however, 
the cardinality of `FunctionArrow{Int, Int}` is identical to $\reals$.
This means the set denoted by `Any` is large.

(Studying only partial recursive functions is even more problematic.
Suppose we have a computable partial function $X \times A \to B$.
Can we always find a computable partial function $X \to (A \times B)$?
Note that the latter has to mimic the halting behavior of the former.
There is no computable operator that takes arbitrary computable behavior depending on $X$ and produces a single program computing it uniformly for all $X$.
The same problem means studying total recursive functions is problematic as well.
From another perspective, if we have a oracle machine, 
it should be imaginable that we write a Julia interface of it,
and hence `A -> B` should still contain all functions, and not just computable ones.) 

# Unions

# `where` expression: as template



It is not possible to get an abstract type of a value via `where`.
The following definition, intended to extract `MyAbstractTypeB` from an instance of `MyStruct`, fails:

```julia
abstract type MyAbstractTypeA end
abstract type MyAbstractTypeB end
struct MyStruct <: MyAbstractTypeB end

function get_abs_type(v::A) where MyStruct <: A 
    A
end # ERROR: UndefVarError: `A` not defined
```

