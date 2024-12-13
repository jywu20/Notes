Move in C++
===========

# L- and r-values

Intuitively, an **lvalue** is an expression that can be assigned to,
which means it has an address.
An **rvalue** is an expression that's not a lvalue,
which means it doesn't necessarily have an address.

The definition looks weird so we look for some examples.
A variable name, an array subscript reference, a defererenced pointer, a function call that returns a reference
are all lvalues.
A literal is a rvalue:
you can't write `"xxx" = yyy`.
A function call that returns non-references is also a rvalue.
(Note, however, that string literals and array literals are lvalues,
because it makes no sense to generate them on the fly:
after compilation an integer literal becomes a part of a single `mov` instruction,
but an array literal or a string literal is simply too long,
and usually they are stored in [the data section of a program](c语言.md#内存分区)
of which members *have* addresses.
So a string literal or a array literal is to be understood as `const my_str = ...`,
which is a l-value.
Indeed, some early languages allow you to manipulate the data section manually,
which however seems rather unnecessary because this can be immediately done
with the functionalities in modern languages.)

In practice, there may be a temporary variable that holds a rvalue.
For example, there has to be a block in the memory that holds the return value of a function,
The point is we don't have any direct access to that temporary variable,
and it often gets deleted quite soon anyway.

In a sentence: an rvalue can never have a name.

# RAII

Now we consider a concept that's seemingly orthogonal to the concept of l- or r-values:
resources allocation and deallocation.
As is said [here](variables-and-assignments.md),
the low-level way to do this is to use pointers,
on which deallocation functions like `free` or `fclose` can be defined.
In C++ programming we want to avoid using these functions everywhere because it's so easy to forget to do it.
What can we do?

One method that doesn't require garbage collection is called *resource acquisition is initialization* (RAII), which is kind of a misnomer:
we'd better call it Scope-Bound Resource Management because what's truly trickly is not resource allocation (which is still complicated if you want to write your own `malloc`, but relatively easy if you just call `malloc` or `fopen`), but resource deallocation.
In RAII, resources are wrapped into classes, whose constructors do the allocation, which are then allocated *on the stack*,
and when the current scope finishes, their destructor functions are called,
which then free the resources contained in them.
The destructor for example may be written in this way:
see whether the internal pointer is `nullptr`,
and if not, `free` it.
(Why the internal pointer is possibly `nullptr`? See below.)

# (Transfer of) ownership

In many cases, it's a good idea to make sure that a resource is held by only one instance of this kind of smart pointers in the broad sense.
This means the above destructor is safe to use,
because we'll never free a resource twice.
For memory, a good example is `unique_ptr`.
Therefore when we write 
```C++
std::unique_ptr<MyClass> result = something_else;
```
we want to make sure that the memory block is now managed by `result`,
and not by `something_else`.
Saying a resource is managed or owned by an object means the responsibility of freeing the resource lies on the destructor of that object.
An easy way to enable this transfer of ownership is to make sure that the assignment statement above sets the internal pointer of `result` to point to the resource, and sets the internal pointer of `something_else` to `nullptr`.
This makes `something_else` no longer usable as a pointer...
but it probably doesn't matter, because in most idiomatic usages,
`something_else` is a *r-value*:
we write 
```C++
std::unique_ptr<MyClass> result = getObject();
```
much more frequently. 

# The necessity of a *move* constructor

Alright, so now the question is, how we can insert the behavior of "set the internal pointer of `result` to point to the resource, and set the internal pointer of `something_else` to `nullptr`" into the assignment statement.
In C++, we have a copy constructor when `obj2 = obj1` is called.
But it doesn't work here.
The copy constructor takes the form of 
```C++
ClassName(const ClassName& other) {
    field = other.field;
    // ... 
    // Possibly in the copy process we do not attempt to make obj1 and obj2 identical:
    count = other.count + 1;
}
```
which means we can't modify `obj1`.
But in `std::unique_ptr<MyClass> result = something_else;`,
we are to modify `something_else`:
we're to set its internal pointer to `null_ptr` to avoid double freeing.

So basically, we need a new kind of constructors that allow us to modify `obj1`.
Furthermore, we want to be able to clearly see which constructor to call when we see an assignment statement.
A natural way to distinguish ordinary `obj2 = obj1` and `std::unique_ptr<MyClass> result = ...` is to note that the latter often involves a r-value on the right hand side 
(a l-value can also appear on the right hand side, but a r-value can only appear on the right hand side).
Therefore, C++ defines a new type of constructors, known as the *move constructor*,
which has higher priority when assignment to a r-value happens.

# Rvalue references

Now we consider what's the signature of a move constructor.
It should be a mutable reference type,
but it can't be `ClassName(ClassName& other)`, which creates ambiguity about which constructor to call at an assignment statement.
Therefore, C++ defines a new type of reference, the *r-value reference*,
which is used to catch a r-value like `getObject()`.
The copy constructor is defined roughly as
```C++
unique_ptr<T>(unique_ptr<T>&& other) {
    ptr = other.ptr;
    other.ptr = nullptr;
    // ...
}
```
At an assignment to a r-value, the move constructor is called by default,
if it is there.

# When is `std::move` needed

Now suppose we actually want to trigger the move constructor when doing an assignment to a l-value (which may also destroy the internal structure of the l-value).
This can be done by the follows:
```
new_ptr(std::move(old_ptr));
```
here `std::move` converts a l-value to a r-value.
Note that `std::move` doesn't do any movement of ownership:
it's the move constructor that does the magic.
But the name `std::move` stronger suggests that conversion of a l-value to a r-value is usually only necessary when we want to trigger the move constructor.

Sometimes we want to make things even more complicated.
Suppose we want a function to accept a `unique_ptr`-like object that is expected to be mutated and will be discarded after this function call.
That function's signature will then be 
```C++
ReturnType func(unique_ptr&& ptr) {
    // ...
}
```
Now suppose we want to call the move constructor within `func`.
But note that `ptr` in the function is a l-value, because it has a name!
So we have to write the follows:
```C++
ReturnType func(unique_ptr&& ptr) {
    // ...
    unique_ptr ptr2(std::move(ptr));
    // ...
}
```
A named r-value reference is still a l-value:
but we can turn it into a r-value by `std::move`,
whose return value is by definition *unnamed* and therefore is a r-value.

One thing to note is that is a r-value reference is to be passed around,

# Conversion rules between r-value references and l-value references

`std::move` can actually be implemented using standard C++ primitives without special compiler supports.
The secret is to utilize the reference collapsing rules.
Indeed that's probably the only reason these rules exist.

# Summary

It's the r-value reference that makes RAII easy to use.
And by virtue of `std::move` and so on,
C++ allows us to call move constructors however we want.

# Rust move semantics

