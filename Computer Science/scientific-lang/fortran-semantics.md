Corner cases of Fortran semantics that can't be embedded into C/C++ or the like in an easy way
============

  
# Arrays

## Zero-size arrays???

First, in Fortran we have arrays with zero size.
This of course is not normal in C.

## Interaction between different arrays types: function call

The next question is, whether attributes like 
`real, dimension(3)` and `real, dimension(4)` 
can be neatly considered as *types* - dependent types, actually - 
as in general purpose languages.
That's to say, whether the behavior of variables and arguments with these attributes 
in function calls and assignments 
can be captured by subtyping, implicit case, etc.
The behaviors described below are
exemplified in fortran-reference/array-passing.f90.

It seems in a function call, 
the dummy variable will try its best to convert the 
it can be clearly seen in attempts to convert Fortran codes to C/C++
(like https://cci.lbl.gov/fable/)
where we have  
```C++
void sf(arr_cref<float> abcss, /*...*/)
{
    abcss(dimension(3));
    // ...
}
```
in place of 
```fortran
subroutine sf(abcss, ...)
implicit none
REAL :: abcss(3)
!...
```
and `abcss(dimension(3))` truncates 
(or, more appropriately, hides, because the array variables like `abcss` 
may be seen as array descriptors which point to an allocated memory space, 
and modification of the array descriptor) 
`abcss` to a three-element array if the length of `abcss` is longer than 3;
when `abcss` is smaller than 3, a compilation error is thrown; 
but this behavior can be worked around by the follows:
```fortran
print *, "Applying sum_assumed_size (size=5) on alloc", sum_assumed_size(alloc, 3)
!...
contains
!...
function sum_assumed_size(arr, n) result(res)
    real, intent(in), dimension(n) :: arr
    integer, intent(in) :: n
    real :: res
    
    res = sum(arr)
end function sum_assumed_size
```
Note however the `arr`  dummy argument is an *automatic* array, 
not a fixed size array; the behavior therefore is expectedly different.

## Interaction between different arrays types: Assignment 

Assignment between arrays with different ranks has a different semantics - 
see 7.2.1.3 Interpretation of intrinsic assignments of [the J3/10-007 specification](https://j3-fortran.org/doc/year/10/10-007.pdf).

## Discussion on Fortran array semantics

There are several immediate conclusions that can be drawn from the above discussion,
First, assignment and function calling are very different in Fortran,
and both of them have complicated semantics.
If we are to embed the Fortran semantics to a more domain general language, like C++,
it might be helpful to conceive array variables as *values* of the array descriptor type 
(i.e. not pointers to array descriptors), 
and the assignment operator is overloaded to enable this complicated behavior;
the behaviors of argument association may be captured by 
defining a macro like `FORTRAN_FUNCTION`, 
which automatically generates the aforementioned `abcss(dimension(3));` lines,
or alternatively it may be better captured by user-defined conversion rules 
for converting one type of array (allocatable, for example) to another (fixed sized, for example).

If we don't consider the possibility of putting an array into a struct, 
we can understand the complicated behaviors of the Fortran array 
by analogy with a dynamic array, like `np.array`, 
and what the compiler does is just to spot cases 
that are bound to cause problem when the program runs.
However, we *are* able to put an array with *parameterized size* 
into a *parameterized* struct;
this construct reminds us of C++ templates, 
and it seems that `real, dimension(3)` and `real, dimension(4)` are indeed different types, 
and a parameterized structure is a dependent type;
note that unlike "dependent types" created with C++ templates
whose paramters have to be decided at compiling time,
in Fortran the template instantiation can be delayed to execution!
This is shown in `fortran-reference/parameterized-type.f90`
(compile it with `ifort` instead of `gfortran`).
This means the whole type system modern Fortran, if well implemented, 
actually is *stronger*  than that of C++ in some occasions;
in C we have variant length arrays but they can't be placed into structs, 
so Fortran is also stronger than C in that aspect.

The behavior difference between fixed size parameterized types 
and automatic parameterized types persists; 
we may say that's because of some sort of type erasure mechanism, 
or, alternatively, we note that for most practical programming languages, 
the type system is more about *guiding method dispatch* 
(or its failure, liking asking what is the first `i64` element 
of a 32bit slot in the memory):
for example, arithmetic operations should not be done 
on the binary representation of a struct containing two `i32`; 
if we really want to do so, we can `reinterpret` the binary representation as `i64` - as in Julia - 
and then call arithmetic operations on it;
in this way a type is like a module containing 
procedures that play with things in memory in a special way.

One question may be if types are used to trigger method dispatch, 
then why the return values are also typed; 
but getting the return values types is not harmful at all:
if we want to play some black magic on the returned binary representation,
we can use reinterpretation functions, 
whose return types then make the black magic played on the binary representation more organized.
Another question may be since the type label is about one argument,
why it should also be consulted when several arguments are present.
This can be tackled by observing that $(a, b) \to c$ is equivalent to $a \to (b \to c)$.
Yet another question is why can't we change and "edit" the type tag of a value dynamically 
to control dispatch in different modules;
this need however can be easily covered by the so-called Holy trait (i.e. Tim Holy's trait) in Julia:
for example see the below example from https://ahsmart.com/pub/holy-traits-design-patterns-and-best-practice-book/
```julia
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

struct Residence <: House
   location
end

struct Stock <: Equity
    symbol
    name
end

struct TreasuryBill <: FixedIncome
    cusip
end

struct Money <: Cash
    currency
    amount
end

abstract type LiquidityStyle end
struct IsLiquid <: LiquidityStyle end
struct IsIlliquid <: LiquidityStyle end

# Default behavior is illiquid
LiquidityStyle(::Type) = IsIlliquid()

# Cash is always liquid
LiquidityStyle(::Type{<:Cash}) = IsLiquid()

# Any subtype of Investment is liquid
LiquidityStyle(::Type{<:Investment}) = IsLiquid()

# The thing is tradable if it is liquid
tradable(x::T) where {T} = tradable(LiquidityStyle(T), x)
tradable(::IsLiquid, x) = true
tradable(::IsIlliquid, x) = false
```
In the above example the trait system is used to group types into ad hoc groups, 
and an additional tag representing which group `x`'s type is in 
is passed together with `x`;
this, in essence, serves as the ad hoc modification of `x`'s type tag.
In principle `LiquidityStyle` can have an additional argument that takes `x` 
and checks whether it satisfies certain conditions or not.
Unlike a large `if` block deciding what to do with `x`, 
the above example makes full use of the existing type system infrastructure
and is highly extensible.
So in the end, for function calls on concrete types, 
the whole system still looks like a (rather simple) type lambda calculus 
(maybe even a typed lambda calculus with dependent type - 
but see below: not all features in modern type systems are to be used);
and if the complicated procedure of dispatching 
(i.e. finding the right implementation for a given set of input arguments) is ignored, 
more complicated typed lambda calculi are also applicable to the (runtime) type system. 

Now a static type system, which inevitably rejects 
certain programs that don't really have the possibility of type errors, 
is used to make it easier for the compiler to *prove* that there *can't* be any type error,
by asking the programmer to write what is essentially proof-carrying code:
if the type system is sound, then it's a *theorem* that 
if $P$ is statically type checked, then it doesn't have any runtime type error; 
of course, it doesn't mean that a program has to pass the static type checking to have expected behaviors.
If the type system is not sound, then the theorem becomes 
"if $P$ is statically type checked *and* satisfies some additional conditions, 
then it doesn't have any runtime type error".
How restrictive the static type system is depends on the intentions of the designer of the language, 
and there is no absolute need to make the static type system 
look like a typed lambda calculus; 
indeed, in Julia, although the type system is quite complicated, 
the complexity mostly comes from subtyping: 
there is no arrow type at all, so the type of a function is literally just `typeof(that_function)`!
And whether something like $(A \to B) \to C$ works well or we end up with `MethodError` 
is completely decided at the runtime.
Another example is in Fortran, the types of functions, so to speak, are defined differently: 
an `interface` block instead of a `type :: arg` statement is used to specify the expected signature.
Of course, we can also make the type system more complicated and more expressive: 
for example we can have refinement types, 
which can be seen as rewriting Hoare logic in the language of type systems.
These features, unlike simple type annotations, 
are usually not a part of the operational semantics of the language, 
although they of course can be. 

The above conception of the type system is like the extrinsic view of the type system;
the only deviation from the prototypical extrinsic type system 
is that type tags are a part of the operational semantics of the programming language.

## Another way to understand Fortran array semantics

If parameterized derived types are not used,
there is actually no need to think that the attribute combinations define various array types:
it's more helpful to conceive Fortran arrays as something similar to `np.array`,
maybe `fortran.array` in a general purpose language,
although the Fortran array contains much more flags (i.e. the attributes like `allocatable`); 
the fact that `gfortran` will prevent some function calls, like 
```fortran
real, dimension(3) :: r
! ...
print *, "Applying sum4d to a 3d array ", sum4d(r)
```
is simply because this looks like an obvious error; 
it can be well emulated by dictating that once a `fortran.array` is initialized in a fixed-size way, 
its size is never changed by the `=` operator, 
and can only be reduced by the `arr(dimension(...))` call 
automatically generated by `FORTRAN_FUNCTION`
and since the function call `sum4d(r)` involves the `r(dimension(4))` line, 
which tries to enlarge it, the function call fails,
and the Fortran compiler - now as a compiler of a DSL - reports the problem which is bound to appear at runtime.
The reason why this behavior is chosen is not out of any prudent theoretical reckoning, 
but is merely an arbitrary choice, presumably related to the implementation of the array 
(enlarging an allocated slot in memory is hard and not efficient, etc.);
`arr(dimension(size_smaller_then_arr))` would be fine, 
because this can be easily implemented by just changing the array descriptor. 
But then that's it - no further discussion on an elegant theoretical model for this behavior is needed.
Similarly `array_declared_as_4_element = array_declared_as_3_element` doesn't work, 
maybe because of memory management issues - but then that's it, 
that's just an ad hoc convention and needs no further investigation.

The existence of Fortran as an important strongly typed language 
also demonstrates that sometimes, *not* conceiving type systems as those in typed lambda calculi 
and instead conceiving type systems as compiling stage reasoning about what will happen in a dynamically-typed language  
helps to under real-world languages better.