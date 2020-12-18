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
编译器的borrow checker之类可以理解成对用到`ORef`的代码的静态检查。