可变不共享，共享不可变。

函数的参数就是在进入函数时引入、函数返回时drop的变量；`x : mut Type`是没有意义的。

在一个struct上调用它的方法同样可以让所有权丢掉，因为方法无非是第一个参数就是struct本身的函数。

以下代码：

```rust
let mut a = 1;
deprive_ownership(a);
a = 2;
```
是可以运行的，因为可以无限制地对`a`重新赋值。

关于Rust的变量，其实可以把immutable的变量当成`let ... in`中的变量，把mutable的变量当成引用，并且能对这种引用做的操作局限为（以满足所有权机制）：
- 定义，`let a;`应当被翻译为`a <- newORef(default)`
- 赋值，`a = expr`应当被翻译为
- 借用，
- 读取，

编译器的borrow checker之类可以理解成对用到`ORef`的代码的静态检查。一点民科见解：对用到`ORef`的代码的静态检查实际上就是某种affine type，但是在这里motivation主要并不是“类型系统表现能力”而更多的是内存管理；引入dependent type之类的feature后在表现力上带来的好处是一眼可见的，而引入affine type的动机如果不考虑“如何实现并行”、“如何避免野指针”之类的议题则并不那么清晰。
考虑到Rust的所有权机制和生命周期标注、drop机制等很难被非常简洁地结合进类型系统（肯定是可以结合进去的，已经有了现成的工作）的机制息息相关，强调它substructual type system的一面在实际工作中没有特别大的意义（在做正确性证明时可以用到）。
Rust的不可变let在各种方面都和Haskell中的`<-`很像，除了它也服从所有权机制；可以认为有一个`ConstantORef`。
Haskell的类型系统不足以在编译阶段做检查，但是如果有refinement type我们已经用`ORef`和`ConstantORef`把所有权机制实现出来了。