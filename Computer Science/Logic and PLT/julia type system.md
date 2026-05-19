The type system of Julia
========

# Preliminaries

## Dynamic, strong typing

Julia is strongly typed in that all values in Julia have a **concrete type**.
(The term *strongly typed* is ambiguous though.)

Type checking in Julia happens at runtime and therefore the language is dynamically typed.
We especially note that type errors in Julia can be caught and handled with `try`-`catch`,
which clearly deviates from the expected behavior of typed lambda calculi.

Dynamical type checking happens in two places:
1. Function dispatch. That's to say, if a function invocation does not match an existing function definition, then a type error (actually a `MethodError`, but below we consider it a subtype of type errors) is thrown.
2. Variable type declaration. `x::Int` means any assignment to `x` involves a type conversion, and if this is not possible, a type error is thrown.

## "Static" typing mechanisms in Julia

There are still a lot of "static typing" mechanisms in Julia,
in the sense that certain constructs feel more declarative and their behaviors can be described by a type system calculus ($\Gamma \vdash \phi$ style).
This includes declaration of composite types and subtype relations.

In Lean's type theory (or the type theory of many other dependent type provers), the primitives are only [the type universes, dependent arrow types, and inductive types](https://lean-lang.org/theorem_proving_in_lean4/Inductive-Types/#inductive-types).
Examining these three pillars in Julia or more generally industrial languages,

- We don't have explicit type universes in Julia or in most programming languages. 
  In some systems this has theoretic consequences 
  (like the absence of set theoretic interpretation of System F).
  In industrial languages, though, this is mostly about keeping things simple,
  and often something equivalent to stratification is actually available.
- Arrow types, i.e. function definitions and invocation, correspond to what Julia community calls method dispatch. The two are different, though a connection can be found [here](#encoding-a---b).
- The "static" mechanisms in industrial languages are [a rather imperfect shadow of general inductive types](plt概况.md#结构体和枚举).

The *definition* part of all the three pillars is almost always static.
In Julia, for instance, a struct is a constant.
Mechanisms to declare what type tags are legitimate in the language therefore should be static too.
Whether or not a language has dynamic typing is about when 
(statically defined) functions or type constructors are called in an inappropriate way, what happens.

## Statically capturing well-typedness of a dynamically typed language

One may wonder whether we can have a *static* type system that gives all and only terms in Julia that do not produce type errors.
Note that here we want to *not generate* type errors,
not to catch and handle them.

Such a system of course trivially exists - but the nontrivial problem is whether it is decidable or consistent or can be formulated with concepts already defined in standard Julia
(the existing "static" typing mechanisms, namely definition of composite data types, have to be incorporated directly into that static type system,
which is what we mean by "concepts already defined").

There has been studies on decidability of Julia's subtyping
(unfortunately the answer is not).

In this note we do not attempt to do a research-level analysis of Julia's type system or to formalize it as yet another type calculus.
What intrigues us is whether a static type system required to rule out type errors can be easily *embedded* into a typical type *theory*,
like that of Lean - or does it possess some more unusual properties and has the potential to open a non-mainstream family of type system calculi.
That's to say, whether we're able to motivate concepts in Julia as design patterns in a type theory.

Embedding into a strong type system is not really a mainstream approach to study type systems,
as it says nothing about decidability or soundness.
That said, in informal discussions on type systems,
comparison with proof assistant-level type theories is often made ("C++'s concept is `Prop`-like and it's not always easy to find why a type satisfies a concept").
It's also possible to find academic discussions like The End of History? Using a Proof Assistant to Replace Language Design with Library Design.

## Type classes

The multiple dispatch system of Julia mixes overloading (i.e. ad hoc polymorphism),
subtype polymorphism and also parametric polymorphism.
All three can be [expressed by type classes with appropriate type class synthesis strategies](plt概况.md#在未知对象具体类型时的动态方法派发).
The fine details of polymorphism can alternatively be framed as the fine details of type class synthesis strategies.
For instance, duck typing or structural typing means type classes are synthesized whenever possible in rather radical way,
often because the only constraints that can be expressed in the language are statements like "the object has a property named such and such", corresponding to something like 

```Lean
class Named (α : Type) where 
  has_name (x : α) : has_method(x, "name")
```

On the other hand, a rather conservative type class synthesis makes subtyping without explicit conversions impossible.

We sometimes say more conservative type class synthesis strategies *nominal*.
The reason to adopt this terminology is obvious, as a type implementing a type class leaves a "mark" on that type, 
though it should be noticed that types classes per se are *not* types containing types.

# Where do type errors appear in Julia?

Below we discuss where type errors appear in Julia - and what static mechanism rules them out.

## Function calls and overloading

We focus on overloading first.

(Note that ad hoc polymorphism, that is, overloading, can be formalized using intersection type.
Intersection type however does not capture the whole of subtype polymorphism.)

In Julia all function definitions allow overloading.
(Unlike, say, Rust, in which ordinary function definitions do not allow overloading,
although we have the trait system to solve the problem).
Therefore *all* function definitions in Julia,
under the type class-oriented perspective sketched above,
can be considered as implementation of type classes:
type errors are ruled out by not making a function call that doesn't fit one of the implementations.

Interestingly, this notion of functions as type classes is consistent with the notion in the official documentation,
which talks about [informal interfaces](https://docs.julialang.org/en/v1/manual/interfaces/).


In Julia terminology, an instance of a function signature - conceived as a type class here - is called a *method*.

---

One thing to note is Julia overloading imposes no constraint on the number of arguments of a function.
```julia
id(x::Int) = x
id(x::Int, y::Int) = x == y
```
But this kind of overloading can still be easily defined as a type class acting on a tuple.
```Lean
class IdClass (α : Type) (β : Type) where
  id : α → β

-- Corresponds to a single-argument Julia function
instance : IdClass Nat Nat where
  id x := x

-- Corresponds to a two-argument Julia function
instance : IdClass (Nat×Nat) Bool where 
  id p := p.1 = p.2

#reduce (IdClass.id (1,1) : Bool) -- true; 
-- the return type has to be specified in Lean as it doesn't assume that 
-- for each input type, there can be only one implementation.
```

## Subtype and multiple dispatch

Subtype polymorphism in Julia takes place when there isn't a concrete method corresponding to a function call.
A function call fails when there is no subtype relation from 
the tuple containing all input arguments to the tuple of parameters of any method supplied,
or when there are multiple equally "distant" methods on the hierarchy of subtype relations,
an example of which is shown below. 

```julia
f(x::Int, y::Any) = 1
f(x::Any, y::Int) = 2
f(1, 1) # ERROR: MethodError: f(::Int64, ::Int64) is ambiguous.

# Treating the input of the function as a tuple, the subtype relations below are why there's an ambiguity
Tuple{Int, Int} <: Tuple{Any, Int} # true
Tuple{Int, Int} <: Tuple{Int, Any} # true
```

Subtype polymorphism can be simulated using type classes as well (see below).
Both types of method errors can be understood as type class instance synthesis failures (including ambiguities).

---

Subtype relations can be naively conceived as subset relations.
In actual development, though, this is not always wieldy,
as it is subtype polymorphism that matters the most,
which lacks an explanation if subtyping is just subset relation.
The fact that we can define one function on a type and one on its supertype
is also not well captured by a naive subset interpretation.

Alternatively, we can use type classes to implement subtyping.
The "fallback" behavior of function calls, also known as method inheritance, in subtyping can be simulated by coercion:
if `A <: B`, this means there exists a coercion mapping from the former to the latter.
If function `f` is defined on both type `A` and type `B`,
then its invocation on `x::A` naturally invokes the `f(x::A)` implementation,
but if not, then the compiler tries to coerce `x` to another type - `B` in this case -
and the `f(x::B)` implementation is called.

Simulating subtype polymorphism requires more efforts.
We have to regard a type `A` in the programming language as three things:
- a type in the type theoretic sense when `A` appears in expressions like `new A(args)`,
- a trait describing what behaviors the subtypes of `A` should have, and
- a (tagged) union of all subtypes of `A`, in expressions like `A a = ...`.

It shouldn't be hard to automatically generate the coercion mappings.
Twisting of type class synthesis mechanisms may be needed 
in order for coercion mappings - instances of `Coe` - to be correctly identified
when function calls appear.

In Julia, supertypes are obligatorily not concrete.
This simplifies the picture above considerably.
We have several kinds of non-concrete types, i.e. supertypes.
They are [abstract types](#abstract-types), 
[`Union` types](#union-types) and `UnionAll` types.

A concrete type has the status of a type in type theory,
and a non-concrete is to be understood as a type class that imposes constraints to what can be it subtypes,
or a union of its subtypes, depending on the context.

The subtyping rules and the multiple dispatch algorithm of Julia can be understood as a particular strategy of type class synthesis.
Note that the understanding that the rules are conceptually type class synthesis rules is not sufficient for determining the details of the rules.

## Parametric polymorphism

Julia supports quite generic parametric polymorphism.
```julia
function id(::Type{T}, a::T, b::T) where T 
  a == b
end
```
At the first glance, unlike C++, in Julia type parameters of a function are not placed in a separate list, 
although in order for the compiler to know that `T` is a type parameter and not the name of a concrete type,
we have to utilize the `Type{T}` and `where T` syntax.

But we should notice that the dispatch mechanism here cannot be explained by tuple subtyping,
as is shown in the subtype check below.

```julia
Int :: Type{T} where T # No problem here 
1 :: T where T # No problem here
(Int, 1) :: Tuple{Type{T}, T} where T # ERROR: TypeError: in typeassert, expected Tuple{Type{T}, T} where T, got a value of type Tuple{DataType, Int64}
```

Therefore parametric polymorphism in Julia involves more than subtype relations.
This may be or may not be a design mistake; not too sure about it...

## Diagonal type variable

We have 
```Julia
(1, 2.0) :: Tuple{T, T} where T # ERROR: TypeError: in typeassert, expected Tuple{T, T} where T, got a value of type Tuple{Int64, Float64}
```

This reveals a quite interesting - but not surprising - behavior of Julia,
called the diagonal rule:
if a type variable appears twice in a type expression then it can only be a concrete type.
Obviously this is for not being overly permissive,
as intuitively `Tuple{T, T} where T` means the concrete types of the two elements of the tuple should be identical;
if we allow subtyping here then `T` can just be `Any`, and all two-element tuples belong to this type.

## Assignment

When a value of type `U` is assigned to a variable declared to have type `V` in Julia,
and `V` is a supertype of `U`, nothing unusual happens.
Otherwise the `convert` function is called.

This of course looks syntactic sugar-ish and can be simulated by type class-guided coercion too,
although note that we can say if we're to replicate Julia in a version of Lean,
it has to have different type class synthesis strategies for 
"coercion" related to subtyping and coercion related to `convert`.

## Inner constructor

An inner constructor in Julia validates the input and throws an error if it's not valid.
In this way we can simulate refinement types:

```julia
struct PositiveInt
    x::Int
    # Inner constructor for validation
    PositiveInt(x) = x > 0 ? new(x) : error("Must be positive")
end
```
With this constructor it is never possible to create a `PositiveInt` that's not positive.

If we decide to not catch the error thrown by inner constructors,
then type checking in Julia has to involve refinement types - which goes beyond notation provided by standard Julia.

# Defining types 

## Product and sum types

Julia has structs and tuples; the main difference is the latter is not tagged.
Because of existence of [internal constructors](#inner-constructor), a type system that is able to catch all type errors of Julia should also include refinement types.

## Abstract types 

Recall that the term *abstract type* refers to types declared to be supertypes of concrete types,
which exclude union types.

Below is an instance of how to use type classes and (tagged) union to simulate the type tree defined by subtype relations.


```Lean
-- Requirements of being a subtype of Abstract; none in Julia
-- 
class Abstract (α : Type)

-- An abstract type, to which concrete types can be associated to.
-- This is to make sure expressions like v::AbstractType = 6 do not erase the concrete type information of the value on the RHS.
-- Can also be understood as dyn trait i.e. trait objects in Rust.
structure AbstractType where 
  α : Type
  inst : Abstract α
  val : α

-- Nat and String are concrete types.
-- Because in Julia concrete types can't be extended,
-- there's no need for declaration of "Nat type class" or "abstract Nat class" 
-- to contain contents of subclasses of Nat.

-- Subtype declaration, so a Nat term can be safely placed in AbstractType
instance : Abstract Nat where 
-- Should be handled by macro
@[coe] def nat_to_abstract_type (x : Nat) : AbstractType := ⟨Nat, inferInstance, x⟩ 

-- Subtype declaration, so a String term can be safely placed in AbstractType
instance : Abstract String where
-- Should be handled by macro
@[coe] def str_to_abstract_type (x : String) : AbstractType := ⟨String, inferInstance, x⟩

universe u
class MyAdd (α : Type u) (β : Type u) where
  add : α → β → AbstractType

instance : MyAdd Nat Nat where
  add (x : Nat) (y : Nat) := ⟨Nat, inferInstance, x + y⟩

instance : MyAdd String String where 
  add (x : String) (y : String) := ⟨String, inferInstance, x ++ y⟩

instance : MyAdd AbstractType AbstractType where 
  add (_ : AbstractType) (_ : AbstractType) := ⟨String, inferInstance, "In progress"⟩

#eval (MyAdd.add 1 2).val
#eval (MyAdd.add "Hello, " "world").val
#eval (MyAdd.add 1 "Hello") -- Will fail because coercions in Lean are not part of typeclass inference search
```

Subtype relation between two abstract types `A <: B` can be understood as one type class extending another
(or other mechanisms to automatically synthesize an instance of the type class corresponding to `B` from the type class corresponding to `A`).

## `Union` types

What complicates subtyping in Julia is,
besides the subtype hierarchy of abstract types (`Int <: Signed <: Integer <: Number`),
which is neatly captured with type classes,
we also have `Union` and `UnionAll` types.

Untagged union type can be used to define tagged union types.
Below is an instance:

```julia
struct ParsedInput
  data::Int
end

struct NodeId
  data::Int
end

struct UnparsedInput
  data::String
end

const Data = Union{ParsedInput, NodeId, UnparsedInput}
```

But the inverse problem, i.e. how to simulate untagged union in, say, Lean, is a question.
The closest thing we can have is actually a trivial type class:

```Lean
class IntOrStr

instance : IntOrStr Int
instance : IntOrStr String
```

And similar to [how abstract types are simulated](#abstract-types), 

```Lean
structure IntOrStrType where 
  α : Type
  inst : IntOrStr α
  val : α
```

Then no more instance is allowed to be added to `IntOrStr`.
(Though in native Lean there seems to be no easy way to enforce it.)

The main problem of this approach is it's hard to define a `Union{A, B, C}` type function in Lean with this translation,
as the type function has to (a) build both the `IntOrStr` type class and `IntOrStrType` at runtime, which is not possible in standard Lean as type class declaration is fundamentally a static thing, and 
(b) make sure `Union{A, Union{B, C}} == Union{A, B, C}`.
The second condition may be loosened by declaring automatic conversions between different type-and-type-class pairs corresponding to the same union type `Union{A, B, C}` but again this can't be a dynamic process in Lean.

Fortunately, in Julia, it's not possible to dynamically define functions either,
and therefore all union types in function dispatch and/or variable type declaration are known at compilation time.
Therefore, the `Union` type function in Julia doesn't add to the expressivity of Julia.

## Type constructors and existential types

The type of a type constructor, in a "canonical" functional programming language, should be $\mathsf{Type} \to \mathsf{Type}$ or maybe something like $\mathsf{Int} \to \mathsf{Type}$,
and mathematically defines a fiber bundle.
The total space is $\sum_{x:A} B(x)$, with $B$ being the type constructor.
The projection map - which tells us which point in the base space $A$ a point in the total space is from - exists (just take the first element of a term in $\sum_{x:A} B(x)$).
This means we are able to construct $\sum_{x:A} B(x)$, and also recover $B$ from $\sum_{x:A} B(x)$:
each $x$ in $A$ is mapped to the subset of $B$ (defined via refinement type) in which the first element in the term is $x$. 

(Note that the type of $B$ itself is a forall type,
but this means $B$ *belongs* to a forall type,
and not that $B$'s internal structure is isomorphic or comparable to a forall type.)

In Julia, because from `x::A{N}` we can trivially read `N` out, and hence a projection function exists,
in Julia, a type constructor is considered an existential type.
(Not saying that it belongs to an existential type, but that itself is an existential type).
An explicit existential notation is the `where` expression (which means something different in function definitions), and we have `(Vector{T} where T) == Vector`.
Note that the fact that we can recover the type constructor from an existential type also means we are able to *instantiate* an existential type:

```julia
(Array{T, N} where T where N){3}{Int} == Array{Int64, 3}
```

# Types of types

## `DataType`

All types declared in the subtype hierarchy - including all concrete types and all abstract types - belong to `DataType`.

```julia
Int::DataType
Integer::DataType
DataType::DataType
```

This immediately smells like Russell's paradox.

Another problem is, `Any`, being the ultimate abstract type, is an element of itself.

Both facts indicate a failure of naive set theoretic understanding of `::`.

One way forward (without considering exotic algebraic structures) is to posit dual roles of type expressions.
If `T` is a type, then the expression `x::T` is to be understood as $x:T$ in type theory,
but `T` in `T::DataType` is to be understood as the *type expression* - a term, merely a AST.
There is an implicit mapping from `DataType` to `Type 1` (the latter being a notation in Lean) that allows 

## `Union`

## `UnionAll`