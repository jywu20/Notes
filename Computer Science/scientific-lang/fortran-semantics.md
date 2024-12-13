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
`abcss` to a three-element array if the length of `abcss` is longer than 3.

There is one thing that makes `dimension(n)` look like *dependent types*.
When `abcss` is smaller than 3, a compilation error is thrown; 
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
The `arr`  dummy argument is an *automatic* array, not a fixed size array. 
We can view this behavior as the compiler being over-cautious:
an assignment of an array of size 5 to an array of size 4 looks strange 
and is more likely to be a mistake than an intended behavior,
so even though what we want is to create a 4-element view of the 5-element array,
the compiler reminds us to think twice.

## Interaction between different arrays types: Assignment 

Assignment between arrays with different ranks has a different semantics - 
see 7.2.1.3 Interpretation of intrinsic assignments of [the J3/10-007 specification](https://j3-fortran.org/doc/year/10/10-007.pdf).

## Understanding Fortran arrays: Fortran array as `np.array` with syntax sugars

There are several immediate conclusions that can be drawn from the above discussion,
First, assignment and function calling are very different in Fortran,
and both of them have complicated semantics.
If we are to embed the Fortran semantics to a more domain general language, like C++,
it might be helpful to conceive array variables as *values* of the array descriptor type 
(i.e. not pointers to array descriptors), 
and the assignment operator is overloaded to enable the complicated conversion rules between different array types when function calls happen.
This may be captured by defining a macro like `FORTRAN_FUNCTION`, 
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
This means the whole "type system" in modern Fortran, so to speak, if fully implemented, 
actually is *stronger*  than that of C++ in some occasions;
in C we have variant length arrays but they can't be placed into structs, 
so Fortran is also stronger than C in that aspect.

This being said, the *operational semantics* of Fortran parameterized types can be embedded into C++:
suppose we have a Fortran parameterized type with one parameter `n` and an array `arr` with dimension `(n,n)`.
Its behaviors can be fully simulated by a C++ struct with fields `n` and `arr`, and in the constructor there is a statement `arr(dimension(n,n))`,
and hence the dimension of `arr` is specified to be `(n,n)` in the constructor.
This seems to be the right way to think about parameterized types:
a type inheriting from a parameterized type inherits all the parameters in the same way 
it inherits the regular fields. 

In conclusion, from the perspective of operational semantics, Fortran's arrays *can* be imitated by C++ primitives:
declarations like 
```Fortran
integer              :: n 
real, dimension(n,n) :: arr
```
in a function can be imitated by 
```C++
void somefunction(arr_cref<float> arr, int n) {
    arr(dimension(n, n));
    // ...
}
```
while parameterized types can be imitated by doing the same in the *constructor* (and *not* as a part of the template: it's `parametric_type(size_of_array)`, not `parametric_type<size_of_array>()`).
The fact that assignment between fixed-size arrays with different sizes can be understood as the compiler being over cautious,
or we can even dictate that once a `fortran.array` is initialized in a fixed-size way, 
its size is never changed by the `=` operator, 
and can only be reduced by the `arr(dimension(...))` call 
automatically generated by `FORTRAN_FUNCTION`
and since the function call `sum4d(r)` involves the `r(dimension(4))` line, 
which tries to enlarge it, the function call fails,
and the Fortran compiler - now as a compiler of a DSL - reports the problem which is bound to appear at runtime.

## Is it a good idea to view Fortran array dimensions as `N` in Julia `SVector{N, Float64}`?

On the other hand, the behavior difference between fixed size arrays 
and automatic arrays can indeed by understood as some sort of dependent typing.
The fact that assignment from a fixed size array to an automatic array
can then be understood as some sort of type coercion.
In my opinion however this is not a good way to understand it:
see the following discussions.

## The distinction between the two views: what is the type system, really? 

The point I want to make here is that for most practical programming languages, 
the type system is more about *guiding method dispatch* 
(or about the failure to do method dispatch, liking asking what is the first `i64` element 
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

Now going back to the case of Fortran.
From the perspective of type system as dispatch controller,
if we are able to show that the distinction between automatic and fixed size arrays 
isn't relevant in function dispatching,
then automatic and fixed size arrays are to be considered as in one type.
This is indeed true: the following code snippet
```fortran
module array_test
    implicit none
    interface array_type
        module procedure array_type_automatic, array_type_fixed_3
    end interface
contains
    subroutine array_type_automatic(arr)
        integer, intent(in), dimension(:) :: arr
        print *, "Automatic array!"
    end subroutine array_type_automatic
    
    subroutine array_type_fixed_3(arr)
        integer, intent(in), dimension(3) :: arr
        print *, "3-element array!"     
    end subroutine array_type_fixed_3

end module array_test
```
results in `Error: Ambiguous interfaces in generic interface 'array_type' for ‘array_type_automatic’ at (1) and ‘array_type_fixed_3’ at (2)`.
Therefore from the perspective of function dispatching, `integer, intent(in), dimension(:)` is the same as `integer, intent(in), dimension(3)`.
If the two were different types, no such problem would occur.

So our conclusion is that at least from the perspective of method dispatching, in Fortran there is one and only one array type.
Parameterized types are to be regarded as types with automatically generated array coercion logic, not dependent types.
Indeed we can visit the parameters of a parameterized type by simply writing `obj%parameter`, which is not something we expect in a language with dependent types.
This is always how Fortran works: it provides you with features that are quite good for day-to-day scientific computing,
which however are puzzling to make sense of from the general theory of programming language theory,
but eventually are possible to make sense of if we choose to think in a simpler way.

## Fortran as a DSL for `np.array` with constraints

It's likely that the behaviors of Fortran arrays and hence parameterized types 
are chosen not out of any prudent theoretical reckoning, 
but out of a somehow arbitrary choice, presumably related to the implementation of the array 
(enlarging an allocated slot in memory is hard and not efficient, etc.).
Therefore `arr(dimension(size_smaller_then_arr))` would be fine, 
because this can be easily implemented by just changing the array descriptor. 
But then that's it - no further discussion on an elegant theoretical model for this behavior is needed.
Similarly `array_declared_as_4_element = array_declared_as_3_element` doesn't work, 
maybe because of memory management issues - but then that's it, 
that's just an ad hoc convention and needs no further investigation.

The existence of Fortran as an important strongly typed language 
also demonstrates that sometimes, *not* conceiving type systems as those in typed lambda calculi 
and instead conceiving type systems as compiling stage reasoning about what will happen in a dynamically-typed language  
helps to under real-world languages better.

# Procedures and interfaces

There are Fortran functions and procedures with *interfaces*,
and there are Fortran functions and procedures without them.
The latter are more or less external functions.
An interface is just a configuration of the types of arguments, 
or in other words, the condition of function dispatch.
Note that Fortran doesn't do type coercion in procedure calls 
- which is also what Julia does when handling method dispatch.

Dispatch is more limited in Fortran compared with it is in Julia.
Multiple dispatch in Fortran has to be static:
that's equivalent to using Julia multiple dispatch but doing so without subtyping,
which in turn is equivalent to static operator overloading.
In Fortran this is done by one usage of the `interface` block:
```Fortran
! From https://stackoverflow.com/questions/50581324/function-overloading-in-fortran-2008
module mod

  private

  interface volume
     module procedure volume_cube, volume_cylinder
  end interface volume
  public volume

contains
  integer function volume_cube(s)
    integer, intent(in) :: s
    volume_cube = s**3
  end function volume_cube

  double precision function volume_cylinder(r, h)
    double precision, intent(in) :: r
    integer, intent(in) :: h
    volume_cylinder = 3.1415926d0*r**2*h
  end function volume_cylinder

end module mod
```
Here we have a notational difference with Julia.
In Julia a function is a collection of difference implementations (different "methods") with different interfaces.
A Julia method is a Fortran procedure (i.e. function/subroutine), while a Julia function is something like 
```Fortran
interface volume
    module procedure volume_cube, volume_cylinder
end interface volume
```
in Fortran: in Fortran we can't just declare procedures with the same name,
we have to use an `interface` block to explicitly group procedures with different interfaces in one name (which is `volume` here).
Also, static dispatch based on the `interface` block can't do subtype polymorphism
(Modern Fortran Explained, Sec. 15.3.6):
this is only possible for the approach in the next paragraph.

Dynamic dispatch is possible in Fortran but only in the way of traditional inheritance-based OO:
this is done by the usual way to first declare an abstract method (`deferred`) and specify the intended function signature (by an `interface` block), and then implement the method in sub-classes.

```Fortran
module animal_m
   type, abstract :: animal_t
   contains
      procedure(IGreet), nopass, deferred :: Greet
   end type
   abstract interface
      subroutine IGreet()
      end subroutine 
   end interface
end module

module activities_with_pet_m
   use animal_m
contains
   subroutine play_with_pet( pet )
      class(animal_t) :: pet
      call pet%Greet() !<-- "dynamic" dispatch but with late binding
   end subroutine 
end module 

module cat_m
   use animal_m
   type, extends(animal_t) :: cat_t
   contains
      procedure, nopass :: Greet => Greet_cat
   end type
contains
   subroutine Greet_cat()
      print *, "Meow"
   end subroutine
end module 
module dog_m
   use animal_m
   type, extends(animal_t) :: dog_t
   contains
      procedure, nopass :: Greet => Greet_dog
   end type
contains
   subroutine Greet_dog()
      print *, "Woof! Woof!"
   end subroutine
end module
   use animal_m
   use activities_with_pet_m 
   use cat_m
   use dog_m 
   class(animal_t), pointer :: mypet
   type(cat_t) :: Julia
   type(dog_t), target :: Lassie
   call Julia%Greet() !<-- "dynamic" dispatch though with possible early binding
   mypet => Lassie
   call play_with_pet( mypet )
end 
```

Static multiple dispatch and dynamic single dispatch can be used together: to do this, the polymorphic method (or "type-bound procedure") has to be declared as `generic`: 
```Fortran
type 
!...
contains
    generic :: gen_proc => impl_1, impl_2
end type
```

Note that we need to distinguish method dispatch - or in more theoretical terms, polymorphism - with the so-called "polymorphic variables" in Fortran.
Polymorphic variables in Fortran are actually a device to convert an object belonging to a type to a (possibly indirect) parent type,
and a procedure can have multiple polymorphic arguments.
The relations between the so-called polymorphic variables and polymorphism i.e. dispatch are 
- the so-called passed variable (`self` in Python) to a type-bound procedure should always be a polymorphic variable (see https://stackoverflow.com/questions/50158320/overload-deferred-procedure-with-non-polymorphic-procedure-in-fortran-2008):
this is reasonable because we may want to invoke a method from a parent class to an object;
- if `var` is a polymorphic variable, then the procedure invokation `var%something()` involves inheritance-based polymorphism.

A `interface` block within a function/subroutine definition does what `method_exists` does in Julia.

We can also give an interface to an external procedure by an interface block.
A Fortran procedure defined outside a module or a `contains` region is 
somewhere between an authentic external procedure and a procedure with an interface:
by default it also has an interface and therefore calling it with the wrong argument types will result in a compilation error.
However, with the `-fallow-argument-mismatch` option, the compilation error is downgraded into a warning.
Calling a procedure with an explicit interface with the wrong argument types always results in an error, 
regardless of the `-fallow-argument-mismatch` option.