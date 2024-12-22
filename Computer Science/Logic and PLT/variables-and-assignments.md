Evaluation strategies and reference types
==========

In this note we discuss evaluation strategies in procedural programming languages.
In other words, we talk about what `a = ...` or `a.p = ...` means.

# The low-level reference type: raw pointers, passed by value

Turing completeness requires unbounded dynamic memory allocations.
Unbounded memory is not physically possible,
but we can always use a memory that's large enough to cover most algorithms we need in reality:
as long as increasing the memory doesn't necessitate a complete overhaul of existing programs,
a programming language can be said to be Turing complete.
What matters, then, is how *dynamic* memory allocation is handled.

The most straightforward way is to utilize the stack-heap distinction
(note that what we're talking about here is more precisely the distinction between memory allocation on the stack frame and dynamic memory allocation; whether after compilation they are indeed implemented by a stack or a heap is not always clear; see [here](llvm.md).)
and write a `malloc` function that allocates memory spaces on the heap.
When the program is hosted, this of course involves coordination with the operation system over
the mapping of physical memories to virtual memories;
when the program is running on bare metal,
like when we're writing an operation system or doing embedded development,
we're on our own.
The dynamically allocated memory area is manipulated by *pointers* pointing to it.

So here we get the standard paradigm of dynamic memory allocation in procedural systematic programming.
A *variable* is always something on the stack,
whose creation and deconstruction is completely controlled by the scope
(so when a function call ends, all variables within its scope get destroyed),
and dynamic memory allocation is *not* feasible just by operations like `a = xxx`.
Dynamic memory allocation involves *pointers*,
which themselves are just variables but point to some sort of "external" memory spaces (i.e. the heap),
and we play with the heap *indirectly*, by doing `*p = xxx`.
Note that what's in the heap remains there after the function call that puts it in the heap ends.
This paradigm is neatly implemented in the C programming language.

In this way, the variables are essentially representing the *finite* internal state of a machine, which manipulates the *infinite* heap memory outside it, leaving possible side effects.
This is comparable with how we pair a digital circuit with very small internal memories with a big memory block;
although, in designing a digital circuit, unbounded loops need to be implemented by finite state machines and we can't just write `while(1) {...}`.
See [here](../Circuit/HDL.md) for more discussions.
Pointers, just like integers, are passed around by value.
Therefore 
```C
pointer1 = pointer2;
```
or 
```C
some_func(pointer1);
```
doesn't copy `*pointer1`: it just copies the address of the object that `pointer1` points to,
and assigns it to another variable.
So now `pointer1` and `pointer2` points to the same object.

This separation between the finite variables on the stack and the infinite heap memories they possibly point to has another benefit.
The memory is *not* infinite in practice,
it needs to be considered as a type of resources,
and this separation between variables and heap is a good (although rudimentary) model for resource management.
The standard library of C, for example, treats files in the same way:
we write 
```C
FILE *fp;
fp = fopen("fileName", "r");
```
The file is opened and closed by the OS.
It's represented by a struct in the heap memory,
which is visible to all functions as long as they know where it is,
and they can manipulate the file by sending system calls to the OS based on the content of `*fp`.
To abstract away implementation details,
the file is better represented not by the struct stored in `*fp`, but by `fp`,
which can be passed from one function to another,
and they all point to the one and the same `FILE` struct in the heat memory,
so we don't need to worry about losing the information about the file 
if the function that opens the file returns without passing anything about the file outsides.
The system calls related to file IO are then encapsulated into functions like `fread` or `fscan`.
If everything is implemented well,
then we rarely need to write `*fp`:
`fread`, `fscan`, etc. appear whenever we may want to write `*fp = xxx`, etc.

# Always use pointers for non-primitive objects: the call-by-sharing strategy

As is said in the last section, C provides a very neat programming model where everything is passed by value,
and some values are to be interpreted as pointing to resources,
including heat memory blocks, files, etc.
One phenomenon we observe is that for big objects, statements like `*p = ...` or `*p.a = xxx` appear much more frequently than `p = ...`,
the latter involving creation and copying of large objects.
And for tasks that do not explicitly involve dynamic memory allocation (though they always implicitly involve it),
even `*p` rarely appears: we just write `fread(fp)` and so on.
On the other hand it seems not so wise to have `int*` most of the time.

This observation gives us a change to change what assignment to a variable means
and get rid of `*p` by *always* using pointers to point to non-primitive objects and never using pointers to point to primitive objects.
We stipulate we only work with pointer types for non-primitive types, and therefore when we write 
```Java
SomeClass p = ...;
```
we are actually write
```C
SomeClass *p = ...;
```
and when we write `p.a = ...`, we are essentially writing `*p.a = ...`.
`p` appearing in an expression like `p.a + 1` also automatically involves a dereference, resulting in an expression like `*p.a + 1`.
On the other hand, `p = ...` retains its original meaning, where `p` is understood as a pointer, not the content it points to (which is understandable because we're working with pointers only).
Then we replace all appearance of `*p` by `p`.
On the other hand, if the type of `p` is primitive ( `int` or `float`, etc.),
no such replacement is performed.
A consequence is that we don't need to talk about pointers anymore: there is no chance for us to use pointers for primitive data types,
and there is no chance for us to not use pointers for non-primitive ones.

Now we see a brand new semantics of variables and assignments emerges from the C-style call-by-value semantics:
if `a` and `b` are not primitive, now `a = b` doesn't copy the content `b` refers to, but simply copies the address of the content, and 
```
a = new SomeClass(f1, f2);
func1(a);
```
may change the content of `a` after the function call.
We therefore say that we have *call-by-sharing* semantics here:
if a variable in a function is passed to another function,
then the two functions share what is referred to by the variable.

Note that actually we *don't* need the distinction between the primitive and non-primitive types when defining the semantics of the call-by-sharing strategy.
This is because primitive types don't have members and are atomic.
Therefore, numbers like `1`, `2`, etc. can be alternatively viewed as atomic objects that "are already there",
and writing `p = 1` is just "pointing the pointer `p` to the pre-existing object `1`".
So we find that by staring with a C-style call-by-value semantics and working with only pointers for non-primitive data types,
and by defining primitive objects as atoms,
we can both arrive at the the call-by-sharing semantics.
The distinction between the primitive and non-primitive types is purely from the fact that `a = b` and `a.f = b` are defined differently.

# Everything is a pointer: call by reference as in Fortran

We can push beyond call-by-sharing and redefine `a = b` into `*a = *b`.
After doing so, we basically get a language where everything is a pointer.
Of course, when `a` is primitive, in expressions involving `a`, `a` is not to be understood as a pointer, but as the content it points to,
and when `a` is not primitive, in expressions involving `a.p`, `a.p` is not to be understood as a pointer, but as the content it points to.
The resulting semantics is known as *call-by-reference*.

Fortran is a call-by-reference language, where indeed everything is a pointer,
and a function can modify its integer arguments and let the changes be reflected in the function that calls it.
True call-by-reference languages are rare these days,
and the term "call-by-reference" often refers to the behavior of *some* variables:
thus a call-by-sharing language is call-by-reference for non-primitive variables, but call-by-value for primitive variables,
although, as is said above, to define the semantics of call-by-sharing, the primitive-non-primitive distinction is not needed in theory.

# Mixing these behaviors

Call-by-value, call-by-sharing, and call-by-reference are all language-wise properties; changing them means changing the programming language in question into something else.
However, as the call-by-reference and call-by-sharing semantics can be naturally derived from a C-like semantics by redefining the meaning of `p.a`,
we can actually implement these semantics within a pass-by-value language,
if enough syntax sugar is available in that language,
essentially creating a EDSL in the language with a different evaluation strategy,
which can also be achieved by adopting a very strict programming paradigm 
(for example, "always use pointers!" - this is how `f2c`, a utility that turns Fortran programs into C program, works, by the way).

In C++ overloading `.` is not possible, so we can't implement our own reference type which allows us to use `.` to access the fields of the object referred to.
There is however a reference type built in, which, when used, provides us call-by-reference semantics in the strict sense: thus after
```C++
int i = 42;
int& j = i;
j = 43;
```
`i` is 43. This is *not* call-by-sharing: here the statement `j=43` doesn't view `j` as a pointer variable whose value is changed to refer to the address at which we have the value `43`:
`j = 43` instead can be understood as `*j = 43` in C.
This is known as the *inreseatable* feature of C++ references, which means the semantics of `pointer = xxx` in C can never be done with C++ references.
Reseatability is what tells call-by-sharing from call-by-reference here.
On the other hand, call-by-sharing allows reseating, but with call-by-sharing, `i` above can never be explicitly changed into a different value.

References in C++ are not just for call-by-reference.
They are also important to make vectors, etc. look like their C-style counterparts.
For instance, suppose `v` is a `std::vector`; `v[1]` is something that can be dereferenced.
Why? Because `operator[]` of `std::vector` actually returns a reference.
We can enable the same behavior by pointers (references are pointers when implemented, anyway), of course, but it won't be very smooth
because we need additional mechanisms to make sure that `&v[1]` is correctly interpreted as a pointer pointing to the memory address `v[1]`.
So when we write 
```C++
std::vector<int> v = {1, 2, 3};
int& ref = v[1];
```
we are truly assigning a reference to another reference!

We can emulate call-by-sharing in C++ if we can accept accessing fields by `->` and not `.`:
just use `shared_ptr` to refer to all composite objects.
One thing worth noting is the reference mechanism in C++ involves nothing about dynamic memory allocation:
the reference mechanism is just there to remind programmers the safest ways to use pointers
(that is, forget about you're dealing with pointers and program like a Fortran programmer).
On the other hand, smart pointers are strongly intermingled with dynamic memory allocation:
they deallocate the memory resources they manage when the number of references goes to zero or when they go out of scope. 
Therefore it's *not* a good idea to use smart pointers to refer to variables on the stack:
memory resources on the stack are already well managed by the scope,
so this may lead to double freeing, causing possible segment faults.
(There is no problem pointing a reference to a variable on the stack.)
We may ask when should we use smart pointers and when should we use references.
It turns out that it's related not directly to evaluation strategies, but to memory management:
see [here](#raii-and-garbage-collection).

In Fortran there are also pointers, but `pointer = xxx` i.e. reseating is done by a different notation: `pointer => ...`.
You can see that the viewpoint of a Fortran programmer is drastically from the viewpoint of a C++ programmer.
For the latter, call-by-value is the default,
and the C++ `typename &` syntax is just a more controlled way to use pointers;
a Fortran programmer's variables are just a C++ programmer's references,
and for the Fortran programmer, ordinary pointer assignments is an *additional* feature that needs a specific `pointer => ...` syntax.

In Rust, a reference can be reseated or in other words reassigned,
and automatic dereference occurs in method calls and member accesses,
so the Rust reference has very typical call-by-sharing properties.
Note however in Rust, `*p = ...` is still available, and we have references to references.
The Rust reference is therefore a good example of a (smart) pointer with call-by-sharing syntax sugars.


# RAII and garbage collection 

Evaluation strategies are about how resources are used.
How big objects are allocated and deallocated, or more generally, how resources are allocated and deallocated,
of course has something to do with the evaluation strategy.
Resource allocation usually means calling the `new` operator, which in turns calls `malloc`, and possible system calls.
Resource deallocation can be tricky because resources are finite after all, and problems like unclosed files, memory leakage, etc are to be avoided,
but we also don't want a function to visit already freed resources, not knowing they're no longer there.

- Garbage collection works well with pass-by-sharing languages
- RAII works well with pass-by-value languages 


Sometimes it's a good idea to use both references and smart pointers:
this corresponds to allocatable variables in Fortran:
the smart pointer manages the allocation and deallocation of memory,
and the references read and write the memory blocks.
Or, we can manage the allocation and deallocation of memory in the constructor and destructors of our own classes,
essentially writing another kind of domain-specific smart pointer,
and write some methods of the class to manipulate the data.
`std::vector` is a good example.
This time references should point to a `std::vector` object,
not the heap memory addresses maintained by it.
So in conclusion: usually we use smart pointers for memory allocation on the heap,
and we use references to manipulate already allocated memory (on the heap or on the stack).

Smart pointers own the memory resources they point to,
meaning that when they leave their scopes, the memory resources are released.
But we're not so sure about what happens to references referring to a memory resource managed by a smart pointer or maybe something else:
references can't be freed,
but they may be read and written to when the memory resource has already been freed.
Unlike RAII, there is no systematic way in C++ to make sure this doesn't happen.