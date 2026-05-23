The type system of Julia
========

# Preliminaries

## Dynamic, strongly typed

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
That's to say, whether we're able to motivate concepts in Julia as design patterns in a typical type theory.

Embedding into a strong type system is not really a mainstream approach to study type systems,
as it says nothing about desirable properties like decidability or soundness.
That said, in informal discussions on type systems,
comparison with proof assistant-level type theories is often made ("C++'s concept is `Prop`-like and it's not always easy to find why a type satisfies a concept"):
a good way to conceptually reconstruct and motivate the type system of an industrial language is
to trim down a type theory and extract emergent patterns found in it.
It's also possible to find academic discussions like The End of History? Using a Proof Assistant to Replace Language Design with Library Design.

## Type classes

Type classes can be seen as computationally relevant existential properties on types:
to say `Group G` means there's a group structure on type `G`,
and unlike `Prop` existential statements,
instances of type classes do not have proof irrelevance,
and hence from an instance of a type class,
we're able to get a set of functions on `G` that exist.
Of course, we can also put proof irrelevant terms into the definition of a type class
(by asserting existence of a proof of a statement,
we're asserting that it holds),
and in this case a type class isn't different from a predicate.

Type classes were originally intended as a way to implement ad hoc polymorphism in pure functional languages:
by "outsourcing" the behavior of a function corresponding to different input types to different type class instances,
there is no need to deal with the need to have multiple type signatures for the same function.
However, if we allow a type class to extend another - 
which we should allow, as if the automatic instance synthesis of type classes is ignored,
a type class has nothing different from a record or `structure` type,
which naturally admits extending or field inheritance - 
then we have actually introduced subtypeclassing,
which, when the rest of the programming language is powerful enough,
[can be used to simulate subtyping](plt概况.md#在未知对象具体类型时的动态方法派发).

The fine details of polymorphism in a language hence 
corresponds to the fine details of the type class synthesis strategy
in the elaboration strategy built on top of a stable, unchanged type theory.
For instance, duck typing or structural typing means type classes are synthesized whenever possible in rather radical way,
often because the only constraints that can be expressed in the language are statements like "the object has a property named such and such", corresponding to something like 

```Lean
class Named (α : Type) where 
  has_name (x : α) : has_method(x, "name")
```

On the other hand, a rather conservative type class synthesis makes subtyping without explicit conversions impossible.

We sometimes say more conservative type class synthesis strategies *nominal*.
The reason to adopt this terminology is obvious, as with a conservative type class synthesis strategy,
a type implementing a type class leaves a "mark" on that type, 
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
Also see [here](#manually-throw-a-method-error).

In Julia terminology, an instance of a function signature - conceived as a type class here - is called a *method*.

---

One thing to note is Julia overloading imposes no constraint on the number of arguments of a function.
```julia
id(x::Int) = x
id(x::Int, y::Int) = x == y
```
But this kind of overloading can still be easily defined as a type class acting on a tuple.
```Lean
-- The type class corresponding to Julia function `id`
class IdClass (α : Type) (β : Type) where 
  id : α → β

-- Corresponds to a single-argument Julia method of `id`
instance : IdClass Nat Nat where
  id x := x

-- Corresponds to a two-argument Julia method of `id`
instance : IdClass (Nat×Nat) Bool where 
  id p := p.1 = p.2

#reduce (IdClass.id (1,1) : Bool) -- true; 
-- the return type has to be specified in Lean as it doesn't assume that 
-- for each input type, there can be only one implementation.
```

---

Another issue is that in Julia, functions are singletons, 
and hence perhaps we should define a Julia-like function in Lean in the following way:

```Lean
-- corresponding to Function type, collecting all function singletons
-- See [here](#abstract-types)
class Func (α : Type) 

-- Corresponding to the concrete type of a Julia function `func1`
inductive Func1 

-- Declare that `func1` is indeed a Julia Function
instance : Func Func1 where 

-- The type class corresponding to the Julia function `func1`
class FuncClass {f : Type} [Func f] (_ : f) (α : Type) (β : Type) where
  func1 : α → β

instance : Func1 (Input1 × Input2 × ...) Output where 
  -- implementation of method 1

instance : Func1 (Input1 × Input2 × ...) Output where 
  -- implementation of method 2

--...
```

The reason why functions are singletons is discussed [here](#datatype-any-type-and-type-in-type).

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

We should note that *how* to do type class synthesis is a non-trivial topic,
and indeed the whole field of theoretic study of subtyping can be understood 
as exploring a specific family of type class synthesis strategy.
Academic research on Julia's type system mostly focuses on subtyping,
which has been proven to be undecidable.

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
although note that we can say if we're to replicate Julia in a version of Lean with a modified elaborator,
it has to have different type class synthesis strategies for 
"coercion" related to subtyping and coercion related to `convert`.

## Return type checking

One place where assignment-like behavior occurs is when a value is returned.
Consider the following code:
```julia
f(n::Int)::SVector{n, Float64} = SVector{n}(zeros(n))
```

To type check this program,
we need the dependent arrow type, which is not available in the built-in type system notations of standard Julia.

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

## Manually throw a method error

One can throw a method error manually.
Whether or not a function call results in such an error typically need not and cannot be formalized within a static type system in an industrial language,
as it's equivalent to the halting problem and can't be automatically examined.

That said, it is possible to use manually thrown method errors to define conditions a type has to satisfy when declared to be a subtype of an abstract type.
As is discussed [here](#abstract-types),
an abstract type is essentially a type class when translated to Lean.

```julia
abstract type A end
blink(::A, ::Int) = throw(MethodError("blink method not defined."))
```

The code above is equivalent to
```lean
class A (α : Type)
  blink (x : α) (y : x) 
``` 

Or, considering that in Julia functions are [singletons](#function-calls-and-overloading), perhaps we should write something like 

```lean
class A (α : Type) 
  blink (_ : Blink) (x : α) (y : x) 
```

where `Blink` refers to the singleton type corresponding to the function `blink`.

# Defining types 

## Product and sum types

Julia has structs and tuples; the main difference is the latter is not tagged.
Because of existence of [internal constructors](#inner-constructor), a type system that is able to catch all type errors of Julia should also include refinement types.

We note that in Julia it's not possible to dynamically define a struct:
that's to say, a struct definition cannot rely on a type that can be determined at runtime.
The same is the case for function definitions.

## Abstract types 

Recall that the term *abstract type* refers to types declared to be supertypes of concrete types,
which exclude union types.

Below is an instance of how to use type classes and (tagged) union to simulate the type tree defined by subtype relations.


```Lean
-- Requirements of being a subtype of Abstract; 
-- it's empty here, but if there's a catch-all method like f(::Abstract) = throw MethodError(...)
-- then the function can be added here.
-- See also [here](#manually-throw-a-method-error)
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
struct ParsedInput # The name ParsedInput is the tag
  data::Int
end

struct NodeId
  data::Int
end

struct UnparsedInput
  data::String
end

const Data = Union{ParsedInput, NodeId, UnparsedInput} # Equivalent to 
# | ParsedInput Int
# | NodeId Int
# | UnparsedInput String
```

But the inverse problem, i.e. how to simulate untagged union in, say, Lean, is a question.

---

One thing we can have is a trivial type class:

```Lean
class IntOrStr

instance : IntOrStr Int
instance : IntOrStr String
```

Currently it is not possible to define conditions for a type to be a subtype of an abstract type,
and this is why the type class has no member.

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
as the type function has to (a) build both the `IntOrStr` type class and `IntOrStrType` at *runtime*, which is not possible in standard Lean as type class declaration is fundamentally a static thing, and 
(b) make sure `Union{A, Union{B, C}} == Union{A, B, C}`.
The second condition may be loosened by declaring automatic conversions between different type-and-type-class pairs corresponding to the same union type `Union{A, B, C}` but again this can't be a dynamic process in Lean.

In Julia programs where all union types in function dispatch and/or variable type declaration are known at compilation time,
the `Union` type function in Julia doesn't add to the expressivity of Julia.
However, Julia does allow dynamically computing union types in function definitions.
Below is an example: 

```julia
f(::Type{T}, x::Union{T, Int}) where T = x
```

---

Union expressions can also be understood as operating on type *expressions*.
But in Lean it is not possible to dynamically define nominal types:
that is, it's not possible to go over names in a list 
and declare types of the corresponding names.

## Type constructors and existential types

The type of a type constructor, in a "canonical" functional programming language, should be $\mathsf{Type} \to \mathsf{Type}$ or maybe something like $\mathsf{Int} \to \mathsf{Type}$,
and mathematically defines a fiber bundle.
The total space is $\sum_{x:A} B(x)$, with $B$ being the type constructor.
The projection map - which tells us which point in the base space $A$ a point in the total space is from - exists (just take the first element of a term in $\sum_{x:A} B(x)$).
This means we are able to construct $\sum_{x:A} B(x)$, and also recover the type constructor $B$ from $\sum_{x:A} B(x)$ by the following way:
each $x$ in $A$ is mapped to a subtype of $B$ $\{p : \sum_{x':A} B(x') | p.\textsf{left} = x \}$,
which is isomorphic to $B(x)$.

(Note that the type of $B$ itself is a forall type,
but this means $B$ *belongs* to a forall type,
and not that $B$'s internal structure is isomorphic or comparable to a forall type.)

Although Julia has no subtype (as it has no $\mathsf{Prop}$),
the construct above still holds.
In Julia, suppose `B{x}` is a parameterized struct.
From `t::B`, from `f(t::B{x}) where x = ...` we can trivially read `x` out,
and hence we can decide the `B{x}` that `t` comes from.
Therefore naturally we can naturally identify `B` with $\sum_{x':A} B(x')$,
and hence in Julia, a type constructor is considered an existential type.
(Not saying that it belongs to an existential type, but that itself is an existential type).

Note that the term *existential type* may be misleading.
In some systems it is a primitive, and in some systems (System F, etc.) it can be defined as 
$\exist \alpha.T = \forall Y (\forall \alpha.T \to Y) \to Y$.
In Lean, the term used is *sigma type*,
which can be easily defined using dependent arrow and inductive type:
```
structure Sigma
  type : Type
  x : type
```
The term *existential* in Lean relates closer to the computation-irrelevant existential statements in `Prop`.
But in industrial programming languages, the term *existential type* seems to always refer to sigma types, and this is the definition used in this document.

An explicit existential notation is the `where` expression (which means something different in function definitions), and we have `(Vector{T} where T) == Vector`.
Note that the fact that we can recover the type constructor from an existential type also means we are able to *instantiate* an existential type:

```julia
(Array{T, N} where T where N){3}{Int} == Array{Int64, 3}
```

Because an embedding from a concrete `A{T}` to the existential type `A{T} where T` is always possible and is intuitively natural,
in Julia the former is considered a subtype of the latter.

## Constraints in `where`

In `B{x} where x`, `x` can really be anything:
there's actually no way to write $\sum x:A. B(x)$.
This is consistent with the discussion [here](#datatype-any-type-and-type-in-type),
in which we argue that type expressions in Julia sometimes should be seen as what they are literally,
that is, expressions constructed using a certain formal grammar,
and not types in the type theoretic sense. 
(We can also say the only possible $A$ is `TypeVar`.)

However Julia does have one way to impose constraints on the type parameter:
```julia
Vector{T} where Int <: T <: Signed
```

This behavior is easily replicated in Lean using type classes (again).
$\sum_{A <: T <: B} \mathsf{List}(T)$ can be implemented as

```lean
structure Packed where 
  T : Type 
  x : List T
  [inst1 : Coe A T]
  [inst2 : Coe T B] 
```

One problem with this approach is, $\mathsf{Packed}$ now is in $\mathsf{Type \ 1}$.
Perhaps we should change the definition into 
```lean
structure Packed where 
  T : JuliaType
  x : List (promote T)
  [inst1 : Coe A (promote T)]
  [inst2 : Coe T (promote T)] 
```
Here we use $\mathsf{promote}$ to refer to the mapping from type expressions ($\mathsf{JuliaType}$) to actual types.
The distinction between type expressions and actual types can be found [here](#datatype-any-type-and-type-in-type).

## Traits

One thing interesting in Julia is 

# Types of types

## `DataType`, `Any`, `Type`, and type-in-type

All types declared in the subtype hierarchy - including all concrete types and all abstract types - belong to `DataType`.
Hence `DataType::DataType`.

```julia
Int::DataType
Integer::DataType
DataType::DataType
```

This immediately smells like Russell's paradox,
although because Julia's type system isn't powerful enough,
no paradoxical behavior can be triggered in type checking.

A similar problem is, `Any`, being the ultimate abstract type, is an element of itself.

Both facts indicate a failure of naive set theoretic - or type theoretic - understanding of `::`.

One way forward (without considering exotic algebraic structures that interpret Julia's type hierarchy more literally) is to posit dual roles of type expressions.
If `T` is a type, then the expression `x::T` is to be understood as $x:T$ in type theory,
but `T` in `T::DataType` is to be understood as the *type expression* - a term, merely a AST.
We then stipulate that there is an implicit mapping from `DataType` to $\mathsf{Type\ 1}$ (the latter in the notation of Lean) that 
translates a type expression back to a type (that asserts the type of a variable and can appear in function signatures, etc.).

A mapping in the opposite direction - from $\mathsf{Type}$ in Lean to the type of Julia type expressions - 
is not possible, because of cardinality,
as in a set theoretic semantics (note: we're trying to interpret the type system of Julia to Lean, and Lean - with type theoretic Axiom of Choice - and ZFC+countable inaccessible cardinals are equi-interpretable) of a type system,
$\mathsf{Type}$ is basically the ZFC universe,
while the Julia `Type`, when treated as a type,
is typically interpreted as a set - a countable set, actually.

---

To make our life easier, we assume that there's a one-to-one correspondence between 
*types* in Julia (the thing appearing after `::`) 
and *type expressions* (members of `Type`) in Julia.
This avoids questions like in `Vector{T} where T`, where `T` goes over all *types* (including those that can't be named) or all *type expressions*.

This truncation of the type universe of Julia has consequences.
Cardinality of type system spreads via parametricity.
If Julia had arrow type, the cardinality of $\mathsf{Nat} \to \mathsf{Nat}$ would be $\reals$
(as real numbers have decimal representations),
and therefore the number of types in the form of `Val{T}` where `T` is a function is at least as large as $\reals$,
and this goes against the assumption that there's a one-to-one correspondence between types and type expressions.
Therefore, by saying that there's a one-to-one correspondence between 
*types* in Julia and *type expressions* (members of `Type`, including expressions in the form of `Val{...}`, where `...` can be a value) in Julia,
we're essentially demanding that anything resembling arrow types in Julia does not admit standard function space semantics,
and more over, the set theoretic interpretation of any Julia type is countable.

The truncation of the type universe is also natural motivated by the fact that in Julia,
there is no way to impose any limit to what can be placed between `{}`,
and we can pass everything to `Val`.
So if the type universe of Julia was, say, $\mathsf{Type}$ in Lean,
the cardinality of `Val` eventually would become that of the ZFC universe,
and the interpretation of `Val` would cease to be within $\mathsf{Type}$.

That an interpretation of a type system is countable isn't per se surprising, 
as type theories have *term models*,
in which no uncountable sets appear.
However, we note that type theories also have set theoretic models or other kind of extensional, "large" models,
while Julia's type system doesn't, and 
therefore we should not attempt to interpret Julia parametricity as type functions in type theory (which is something we desire) 
*and* interpret something in Julia as arrow type.
Interestingly, Julia does indeed have no arrow type and only a `Function` type as the supertype of all function singleton types.

Further, when we try to replicate Julia's type system's behavior in type theory,
`B{...}` cannot be naively interpreted as $\mathsf{B(\dots)}$,
as such a naive interpretation allows $\dots$ to be both types and values.
It is instead desirable to consider what can be put between `{}` in `B{...}` `Any`:
types appearing be `{}` are *type expressions*, i.e. values.
(see also [here](#constraints-in-where)).

---

With the discussion above in mind,
Here dots being in a circle means $\in$, and a circle being in another means subtype relation in the abstract type hierarchy.
Hence `1::Number`, `Float64::DataType`, `Any::DataType`, and so on.
Note that the `1` value in the set denoted by `Int64` has the tag `Int64` on it, and so on.
The arrows describe how a type expression is "promoted" to an actual type.

![](julia-basic-types.png)

Note that this type-as-type-expression approach does not automatically grant us a paradox-free semantics,
as now the mapping promoting a type expression (before `::`) to a type (after `::`) may be ill defined.

A Julia function like 
```julia
my_id(::Type{T}, input::T)::T = x
```
therefore should be translated into something like this:

```Lean
inductive JuliaType
| nat
| string
-- ...

def promote (typeexpr : JuliaType) : Type :=
  match typeexpr with
  | JuliaType.nat => Nat
  | JuliaType.string => String

def my_id (typeexpr : JuliaType) (input : promote typeexpr) : promote typeexpr := input

#eval my_id JuliaType.string "str"
```

## `Union`

Type expressions defined using `Union` have `Union` type.
```julia
Union{Int, Float64} :: Union
```

## `UnionAll`

Type expressions defined using `where` have `UnionAll` type.
```julia
Array::UnionAll
(Array{T, 3} where Int <: T <: Number)::UnionAll
```

# Functions

## Callable objects

Functions in Julia are singletons with runnable code attached to them, except a few built-in functions. 
That's to say, we can define an "empty" function without any method.
```julia
function empty end # empty (generic function with 0 methods)
```
How to replicate this behavior in a type theory has been discussed at the end of [this section](#function-calls-and-overloading).

Besides, we can also define non-function singleton callable objects in the following way:
```julia
struct A
  data::Int
end

(a::A)(x::Int) = a.data + x
```
This behavior can be defined in Lean using the same strategy in [this section](#function-calls-and-overloading):
```Lean
class AClass (α : Type) (β : Type) where
  func1 : A → α → β

instance : AClass A (Input1 × Input2 × ...) Output where 
  -- implementation of method 1

instance : AClass A (Input1 × Input2 × ...) Output where 
  -- implementation of method 2

--...
```

## Arrow types

It's actually possible to simulate arrow type in Julia.

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

This construct however deviates from typical arrow type in functional programming,
in that it cannot be interpreted as $A \to B$ in set theory at all,
because it involves `Function`, which has a cardinality issue if interpreted as the set of all functions
(For a similar phenomenon, see [here](#datatype-any-type-and-type-in-type).)

If we want to embed `FunctionArrow` into Lean and make sure no method error is ever thrown,
an additional field witnessing existence of a method from `A` to `B` is necessary.
Because `Function` is countable, so is `FunctionArrow`.

# Summary

It is possible to automatically translate a substantial part of Julia into a type theory like Lean.

Regarding self-containment in `Any`, `DataType`, etc.:
- We resolve this by distinguishing between *types* (appearing after `::`) and *type expressions* (AST, appearing before `::`).
- We want a one-to-one mapping relating the two.
- To avoid paradoxes, it's a good idea to keep the total number of types in Julia countable (see [here](#datatype-any-type-and-type-in-type)).
  Otherwise we're merely moving the paradox to the type expression-type mapping.

Regarding function calls:

- The multiple dispatch paradigm, which covers both [ad hoc polymorphism](#function-calls-and-overloading) and [subtype polymorphism](#subtype-and-multiple-dispatch), can be formalized based on type classes.
- The function-as-singleton approach in Julia can be motivated by our desire to not have true arrow type, or otherwise by passing elements of $\mathsf{Nat} \to \mathsf{Nat}$ to a parametric type, the number of types exceeds the number of type expressions (see above).
- The method table of a generic function in Julia can be understood as [the set of instances of a type class](#function-calls-and-overloading).
- The method table of callable objects  can similarly be understood as [type class instances](#callable-objects).

Regarding non-function data types:

- Type checking assignments and internal constructors in Julia requires dependent arrow type and refinement type, which are not available in Julia but are available in e.g. Lean. 
- Abstract types can be conceived dually: as type classes and as sigma types that contain terms whose types satisfy the type class (see [here](#abstract-types)). The type hierarchy can be understood as a specific type class synthesis.
- That a parametrized struct is an existential type [can be understood in Lean](#type-constructors-and-existential-types), and the natural coercion from a concrete type `B{Int}` to `B` can be understood as a subtype relation.
- `where` expression with constraints can be understood as [sigma types with automatic type class synthesis too](#constraints-in-where).
- "Static" union types, i.e. union types whose coverage can be determined at compilation, can be [simulated](#union-types) by the type class-plus-sigma type approach. 
- However, *dynamic* union types, e.g. the union type in `f(::Type{T}, x::Union{T, Int}) where T = x`, seems beyond the ability of idiomatic Lean, for the very reason that it's not possible to define type classes and sigma types on the fly at runtime.

Stratification:
- The type expression/type duality of Julia types interprets `Any::Any` etc. 
- There is no way to directly operate on the "true" type universe $\mathsf{Type}$ in Julia;
  we work on types by indirectly work on `Type` - an ordinary type containing all type *expressions*.
- It is also not possible to work on "real" arrow types in Julia,
  although something similar - essentially a subtype of `Function` - can be [defined](#arrow-types).
