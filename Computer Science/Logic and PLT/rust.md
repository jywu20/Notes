可变不共享，共享不可变。

似乎`&T`类型是copy语义的。下面的代码不会报错：
```rust
let x = ModelParameter {
    j: 0.1, beta: 0.1
};
let y = &x;
// let z = &y;
let z = y;
println!("{:?}", y.j);
```
但是把`&`改成`&mut`就会报错。

函数的参数就是在进入函数时引入、函数返回时drop的变量；`x : mut Type`是没有意义的。

在一个struct上调用它的方法同样可以让所有权丢掉，因为方法无非是第一个参数就是struct本身的函数；Rust也不保证一个struct的成员总是拥有它们原本的值的所有权——如见[此处](https://stackoverflow.com/questions/64391055/struct-ownership)，可以看到，如下代码
```rust
struct Haha {
    pub a: u32,
    pub b: Vec<u32>,
}
let example = Haha {
    a: 32,
    b: vec![1],
}; 
let new_a = example.a;
let new_b = example.b;
```
中，变量`example.b`的数据类型没有Copy trait，因此在最后一行语句后，`example.b`就不再能使用了
（但是`example.b`对应的这一块栈上的数据并没有被释放，因为仍然有一个变量——`new_b`拥有这块数据）。

以下代码：

```rust
let mut a = 1;
deprive_ownership(a);
a = 2;
```
是可以运行的，因为可以无限制地对`a`重新赋值。

编译器的borrow checker之类可以理解成对用到`ORef`的代码的静态检查。一点民科见解：对用到`ORef`的代码的静态检查实际上就是某种affine type，但是在这里motivation主要并不是“一般的类型系统的表现能力”而是具体的内存管理；引入dependent type之类的feature后在表现力上带来的好处是一眼可见的，而引入affine type的动机如果不考虑“如何实现安全的并行”、“如何避免野指针”之类的议题则并不那么清晰。
Rust的所有权机制和生命周期标注、drop机制等都是非常不pure的东西，对应内存状态的改变。的确，可以在一个substructual type system中把它们表示出来（类型系统并不需要在意函数是不是纯的：不纯的程序同样构成一个Kleisli范畴，它自然对应一个类型系统），但是这在实际工作中并不能因此给程序员提供多少用处（除了在做正确性证明时可以用到）。
Rust的不可变let在各种方面都和Haskell中的`<-`很像，除了它也服从所有权机制（从而强迫程序员使用引用，以避免频繁地复制对象）；可以认为有一个`ConstantORef`，它提供了借用等操作。（它不是Haskell中的`let`，因为给Rust中的`let x = ...`赋值时等号右边可以是有副作用的）
在使用Rust做函数式编程时因此需要频繁用到借用，由于无法对immutable变量的借用做任何修改，它事实上起到了传递值的效果（虽然被传来传去的是一个引用，但是这个引用不能用于修改任何东西），而与此同时又不需要频繁地复制。
已经有人在Haskell中用`ORef`和`ConstantORef`把所有权机制实现出来了（见[此处](https://hackage.haskell.org/package/oref)）。
Rust`let x = ...`相当于给内存（程序状态）的一块区域贴上了标签，给它取了一个名字，这和一个用于记录状态的Monad的do notation中`<-`的意义完全一样。

总之是不是把lifetime一类的东西称为类型完全取决于“类型系统”这个概念的划界。
这些机制不仅依赖于变量的类型，也依赖于程序的结构。原则上它们可以在一个足够强大的类型系统中用dependent type定义出来（因为一段程序也是一个term），因此可以看成类型系统的一部分。
但是刨去它们，Rust的类型系统是一个和Haskell的类型系统非常像的非常自洽的系统，并且是不是能够通过类型检查和程序的结构无关，那么borrow checker, lifetime这些概念被当成类型系统的一部分又会让类型系统看起来无端的别扭。

关于region type system: Verifying pointer and string analyses with region type systems
Author links open overlay panelLennart Beringer a, Robert Grabowski b, Martin Hofmann b
