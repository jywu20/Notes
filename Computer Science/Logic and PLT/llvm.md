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

# Metadata in LLVM IR

What makes LLVM IR drastically different from C is that
it allows a wide range of metadata annotations.
