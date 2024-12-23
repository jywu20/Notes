# C as a compilation target

C's abstract machine is a good representation of older computers like PDP-11,
in which control flows are managed by sequential execution, `if`, `for` and `while`,
and data flows are managed by elementary arithmetics and also pointer mechanisms,
the latter being the key for dynamic memory allocation in C,
which is necessary for Turing completeness.

The programming model of C, which assumes sequential execution,
a single, continuous address space,
and also global states,
is not in complete agreement with modern computers.
Because of the limited speed of data transferring between the memory and the CPU,
modern computers have several layers of caches,
making the memory structure no longer flat.
Serial execution is technically not true because we have instruction-level parallelism.
Existence of global states adds additional complexities to multithreading,
obliging programmers to lock and unlock shared resources.
Still, designers of modern CPUs design their chips to make sure C programs can still be relatively straightforwardly compiled if we don't need very, very high speed:
the process loading data into the cache is invisible even at the assembly level,
and instruction-level parallelism involves automatic dependency analysis of the binary code.
So here we see co-evolution of CPUs and softwares:
people have been familiar with programming with C-like languages,
and hardwares are designed in a way to make C-like programming easy.

[Making programs even faster](../HPC/overview.md) is challenging and needs the collaboration of chip designers and compiler engineers. 
Since as is mentioned above, no one wants to completely break the C-like hardware-software ecosystem,
more and more techniques are invented in a kind of ad-hoc way
to accelerate recurring patterns seen in C-like programming.
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
for example, can be accelerated by SIMD.
It is *here* where C in the modern world shows its greatest weakness:
its *low-level-ness* means programmers often can't promise that they will *not* do something,
and it's generally hard to make sure that a code indeed fits in an optimization trick.
In the second listing, for example,
are you sure that `p1` and `p2` are not pointing to the same address?

We can summarize the situation into two statements:
- Mainstream languages are still C-like in some sense.
- C is not enough for optimization: not enough information is provided.

The second point can be solved by adding pragmas or attributes (like `__restrict`) to C programs,
or by using languages that do allow the programmer to promise that they won't do anything blocking possible optimizations
(in Rust, for example, the ownership mechanism blocks possibilities that two pointers to be modified are pointing to the same address).

Our discussions above highlight one fact.
C used to be a target language when people designed new programming languages.
But if you compile Rust or, more hilariously, C with high performance pragmas to standard C...
you lose all information you need for optimization.

A modern compiler designer should have the two points in mind.
They need a C-like intermediate representation,
and they also need to make this IR hold as much information as possible.
LLVM IR is a good example of such a IR:
it's [C-like](#llvm-ir-and-c), but it allows the code generator to know [a lot more than what it knows when staring at C source codes](#attributes-in-llvm-ir).

# LLVM IR and C

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
each of which supports a certain piece of information for possible optimizations.