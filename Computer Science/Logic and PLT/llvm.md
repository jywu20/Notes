# C as a compilation target

C's abstract machine is a good representation of older computers like PDP-11,
in which control flows are managed by sequential execution, `if`, `for` and `while`,
and data flows are managed by elementary arithmetics and also pointer mechanisms,
the latter being the key for dynamic memory allocation in C,
which is necessary for Turing completeness.

## Unoptimized C is still a "portable assembly language"

The programming model of C, which assumes sequential execution,
data and instructions being stored together,
a single, continuous address space,
and also global states,
is not in complete agreement with modern computers.
Because of the limited speed of data transferring between the memory and the CPU,
modern computers have several layers of caches,
making the memory structure no longer flat.
Plus, modern CPUs often have split caches (one for data, another for instructions) and therefore are modified Harvard architectures.
Serial execution is technically not true because we have instruction-level parallelism.
Existence of global states in C adds additional complexities to multithreading.

Still, designers of modern CPUs design their chips to make sure C programs can still be relatively straightforwardly compiled
if we don't need very, very high speed:
the process loading data into the cache is invisible even at the binary code level,
and instruction-level parallelism involves automatic dependency analysis of the binary code.
This is because of co-evolution of CPUs and softwares:
people have been familiar with programming with C-like languages,
and existing softwares are all written in C-like languages,
which are most easily compiled to C-oriented binary codes.
Hardwares have to be designed in a way to make C-like programming easy,
and in this sense, C, without optimizations, is still a language that's close to bare metal,
because the input of the bare metal has been specially designed to make it easy to compile C code to it.
This can be clearly seen on [Godbolt](https://godbolt.org/), where you can see that without optimization, a line of C code indeed *locally* (without runtime or boilerplate code or non-local structural changes) corresponds to several lines of assembly.

We can imagine or even make machines with no memory and only caches surrounding cores,
or machines that run Jave bytecode or whatever,
but the programming model of them will be too different from that of C,
causing serious ecosystem problems.
As for modern CPUs,
the true heavy lifting computations are done on a modified Harvard architecture with some internal parallelisms,
all of which are however hidden at the instruction set level.
You can insist that unoptimized C is not a low-level language,
but neither is assembly.
The mismatch between C (and also the instruction set architecture) and the *true, true* low-level stuff in modern CPUs
may make some tasks slow, but that's what we have now.

## What standard C can't do

There still things that are or were idiomatic in assembly but hard or impossible to do in C.

The first thing is in C we have a pre-defined concept of the stack.
C doesn't provide primitives for playing with the stack:
functions like `setjump` have to be written in assembly.
In hosted C code, it's possible to try to read an address and check if memory access exceptions appear,
and thus determine the range of the stack https://stackoverflow.com/a/18921287.
LLVM IR provides `llvm.stacksave` and `llvm.stackrestore` intrinsics but they are used to implement variable sized arrays, etc. and probably not for day-to-day uses.
Still in modern software engineering people don't do black magic like this frequently,
which probably explains why in both C and LLVM IR,
these tricks are introduced by (kind of) abusing functions as a workaround.

Probably more important is optimization.
When it comes to optimization, the problem pure C encounters is two-fold:
- manually using things like SIMD (which, unlike caching or instruction-level parallelism, *can* be controlled in assembly) 
  is not supported by standard primitives of C, and
- if we want to let the compiler to perform certain optimizations, then the idiomatic form is not *high-level* enough,
  because it's impossible to promise to the compiler that certain scenarios that hinder optimization
  will never happen.

Since as is mentioned above, no one wants to completely break the C-like hardware-software ecosystem,
we'd like to see how to solve the problems by utilizing concepts already in C.
The first problem is easy to solve.
We just add intrinsics to C.
A SIMD parallel add intrinsic looks like 
```C
extern __m128 _mm_add_ps( __m128 _A, __m128 _B );
```
which looks like a function but is implemented directly by the compiler by a single instruction.

A consequent problem is that writing intrinsics is burdensome and possibly not portable,
and it would be desirable to just give the compiler a hint.
We can for example manually write four add statements and then add a pragma in the source code:
```C
#pragma GCC optimize("no-tree-vectorize")
```
or a compiler flag. Here, we want the compiler to recognize 
certain recurring patterns seen in C-like programming that can be accelerated,
and then perform the optimization in a automatic way.
(We can imagine pushing this to the extreme and designing a language of which each primitive can be relatively easily optimized;
in most cases, though, compiler engineers work in an ad-hoc, case-by-case way,
and do not attempt to identify a set of *orthogonal* code snippets.)

What we want is *automatic* optimization on *existing*, *human readable* codes,
leaving intrinsics call and pragmas to libraries like OpenBLAS,
which is mainly written in C (the Fortran files are for testing and reference).
But this turns out to be hard - see the next section.

Note: sometimes manual optimization is always needed.
Consider an extreme case:
we probably won't expect the compiler to automatically do OpenMP parallelization for us.
In this note we focus on feasible automatic optimization.

## Automatically optimizing C is hard

Let's consider a typical example of automatic optimization.
Operations like 
```C
for (int i = 0; i < len; i ++) {
    a[i] = b[i] + c[i];
}
```
or 
```C
*p1 = *p1 + a1;
*p2 = *p2 + a2;
```
for example, can be accelerated by SIMD - or can it?
Are you sure that `p1` and `p2` are not pointing to the same address?
The *low-level-ness* of C means programmers often can't promise that this will not happen.

The problem can be solved by adding pragmas or attributes (like `__restrict__`) to C programs.
This breaks portability, again.
By adding all kinds of pragmas, attributes, and intrinsics,
we are essentially creating a dialect of C, i.e. *optimized* C,
which is no longer supposed to be a transportable assembly language.
Not saying this is necessarily a bad thing,
but it does destroys one usage of C.
C used to be a target language when people designed new programming languages.
But if you compile Rust (where the ownership mechanism blocks possibilities that two pointers to be modified are pointing to the same address) or, more hilariously, C with pragmas and attributes to standard, portable C...
you lose all information you need for optimization.
On the other hand, if we keep all the pragmas and attributes,
the resulting C code is often vender-dependent and is not cross-platform:
again not a good thing for an intermediate representation.

## What does it mean for a compiler ecosystem

We can summarize the situation into two statements:
- Mainstream languages are still C-like because due to the glorious past of C, modern CPUs are suppose to be friendly to C-like languages
  (which is not probably identical to how things are done internally in the CPU 
  but no programming language can influence how things are done internally in the CPU anyway).
- Standard C is not a good choice as an intermediate representation in compilation,
  because of optimization issues:
  basically C is too low-level and only neatly translates to the old, generic ways to do things
  but not the new, optimized though less generic ways.
  To do the latter we need platform-dependent pragmas, intrinsics and attributes in C source code,
  which breaks portability.

Some of the pragmas, intrinsics and attributes are irrelevant to compiler IR designing.
OpenMP pragmas certain belong to the compiler frontend.
So are manual calls of SIMD intrinsics.
Things like `__restrict__` however deserve a place in the IR,
probably as an annotation of the function argument.
A modern compiler designer, therefore, needs a C-like intermediate representation,
but they also need to make this IR hold as much information as possible.
LLVM IR is a good example of such a IR:
it's [C-like](#llvm-irs-c-like-semantics), but it allows the code generator to know [a lot more than what it knows when staring at C source codes](#attributes-in-llvm-ir).

TODO: C ABI forbids reordering structs, but then SIMD can't be used sometimes

Suppose you want tail call optimization to *always* happen.
Is there a way to tell a C compiler this?
No, if we restrict ourselves to standard C.
An attribute can do the trick: in Clang we write  
```C
 __attribute__((musttail)) return f(x-1);
```
In GCC there is a ` -foptimize-sibling-calls` compiler option.
Not the same as what we do in Clang.

# LLVM IR's C-like semantics

The big aspects of semantics of LLVM IR are quite similar to those of C.

- The function call conventions are similar.
- Members of arrays are structs are visited by pointer offset,
  although in LLVM IR, we use the more structured `getelementptr` instruction.
- We have the distinction between memory allocation on the stack frame (e.g. `int i = ...`) and dynamic memory allocation (e.g. `int *p = malloc(...)`).
  Colloquially we often equate this distinction with the stack/heap distinction
  (for example [here](variables-and-assignments.md)),
  but the latter, technically, is about the implementation of the semantics of the stack frame/dynamic memory management.
- No overloading for user-defined functions: across programming languages, the mechanism of overloading varies greatly, 
  so probably it's not a good idea to dictate one single way to do overloading in a low-level representation.
  (But we do have overloading for things like `getelementptr`: see below).
- Function pointers have what are known as arrow types in type theory:
  so in C we have `int (*operation)(int, int)` and in LLVM IR we have `%operation = alloca i32 (i32, i32)*, align 8`.
- Types' role is clear: to guide how instructions like `getelementpr` behave,
  just like what Julia's type system does (which however is much more dynamic).
  We can say that LLVM IR supports instruction overloading.
  Like the case in C, we probably shouldn't conceive the type system in LLVM
  as an implementation of a *type theory*.

There are some minor differences, where LLVM IR is either more flexible or more flexible.

- In LLVM IR it's possible to have a function argument like `[2 x i64] %0`:
  in C it's impossible. We can do the same by a struct containing two `i64`,
  which however is translated into `{i32, i32}` in LLVM IR.
  This seems to be a minor problem:
- Implicit conversion is not allowed in LLVM:
  a `bitcast` instruction has to be explicitly made.
- LLVM IR is a static single-assignment form (SSA).
  Therefore control flows are represented solely by labels and goto in LLVM IR,
  and assignment to a variable appears once and only once.
  Therefore local identifiers declared in a function are not explicitly typed:
  ```llvm
  %i = alloca i32, align 4
  ```
  From this statement we already know that `%i` has type `i32`.
  
  The SSA form creates some subtleties.
  In converting a `if-else` block to SSA,
  we note that a variable (let's call it `var`) may be assigned in both branches
  and used in statements following the `if-else` block.
  An additional step, creating a `var_3` variable that reconciles `var_1` and `var_2` in the two branches based on which branch was called,
  is necessary after a `if-else` block.
  This is done by a so-called phi-node:
  we add a statement like `var_3 = phi(var_1, var_2)` after the `if-else` block ends.

  In converting a loop to a SSA form,
  variables are read and written to arbitrarily
  and it's not possible to reduce these assignments to a variable into a finite chain of assignments.
  The semantics of a loop is represented by `load` and `store` instructions in LLVM.
  The latter is semantically an assignment but not syntactically so.

Compiling something into LLVM IR therefore is basically the same as compiling something to C.
A function that can be suspended and resumed, for example,
is usually to be transformed into a state machine, probably in the following form:
```llvm
define void @goroutine(%struct.Context* %ctx) {
entry:
  %state = load i32, i32* getelementptr(%struct.Context, %ctx, 0, 0)
  switch i32 %state, label %start [
    i32 0, label %start
    i32 1, label %after_first_print
  ]

start:
  call void @println(i8* "hello")
  store i32 1, i32* getelementptr(%struct.Context, %ctx, 0, 0)
  ret void  ; Potentially yield to scheduler

after_first_print:
  call void @println(i8* "world")
  ret void
}

; ... other statements

```

Here we see an asymmetry.
From the perspective of the user of a high-level language,
a function that can be suspended and resumed is just like a function running in the debug mode.
From the perspective of a [hardware engineer](../Circuit/HDL.md),
ordinary sequential execution can also be trivially mapped to a state machine.
So a function that just runs from the beginning to the end and a function that can be suspended and resumed
are semantically not that different,
and yet they are represented by very different LLVM IR.
This, of course, is due to the fact that LLVM IR is eventually to be compiled to 
binary codes running on a CPU, which has no debug mode and runs a program from the beginning to the end,
and a function that can be suspended and resumed needs to be implemented in a more painstaking way.

# Attributes in LLVM IR

What makes LLVM IR drastically different from C is that
it allows a wide range of attribute annotations.
Below is an instance of a LLVM IR code snippet from a Julia function that adds the two members of a struct together:
```llvm
;  @ REPL[2]:1 within `add`
define i64 @julia_add_146([2 x i64]* nocapture noundef nonnull readonly align 8 dereferenceable(16) %0) #0 {
top:
;  @ REPL[2]:2 within `add`
; ┌ @ Base.jl:37 within `getproperty`
   %1 = getelementptr inbounds [2 x i64], [2 x i64]* %0, i64 0, i64 0
   %2 = getelementptr inbounds [2 x i64], [2 x i64]* %0, i64 0, i64 1
; └
; ┌ @ int.jl:87 within `+`
   %3 = load i64, i64* %1, align 8
   %4 = load i64, i64* %2, align 8
   %5 = add i64 %4, %3
; └
  ret i64 %5
}
```
Note the long, long `nocapture noundef nonnull readonly align 8 dereferenceable(16)` sequence.

Unlike its  elegant, orthogonal design C-like semantics, LLVM IR's attributes are more or less ad hoc,
each of which supports a certain piece of information that may be used for possible optimizations.