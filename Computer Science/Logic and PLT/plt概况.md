# Typed lambda calculus

强类型纯函数式编程某种意义上在理论计算机科学中享有“首席”地位，因为无类型表处理函数式编程、过程式编程等其他的（也许更加常见）的编程范式都可以毫无困难地嵌入它们中。
Linear type可以用所谓linearity monad（另一个更加冷门的实现叫做ownership monad，如此冷门以至于谷歌上面只有几个搜索结果……）嵌入Haskell中，动态类型有一个Dynamic包可以做到这一点，等等。
对类型系统的修改，如类型系统层面的linear type、dependent type等，不那么容易做到，但它们总是可以嵌入一个足够强的dependent type theory中，如嵌入Coq或是Lean中。

这样可以比较容易地判断不同feature的正交性，如我们看到过程式编程实际上就是一个Monad，可以确定mutable与否和类型系统基本无关。
但一些特征，如rust的lifetime标记（特别是lifetime typing），确实似乎只有在足够强大的dependent type theory中才能比较容易地作为类型表示出来。

泛型等是从范畴到范畴的映射

所以我们又绕回来了：范畴的范畴和高阶范畴有什么关系？

TODO， Kleisli category，

纯面向对象语言中的interface实际上是一个coproduct：如果我们把面向对象语言中的subtyping理解为一种从子类到父类的态射，具体来说是隐藏掉子类有而父类没有的方法，那么这就是显然的。

# 常见的范式

类型系统：

- C是最简单的
- C++：
  - 封装：class（将数据和操作放在一起）
  - 多态：template或者subtyping
  - 类型构造器：template
  - dependent type：不完全支持，而是通过template提供编译期支持
- Java型纯面向对象语言
  - 封装：class（将数据和操作放在一起）
  - 多态：subtyping，包括interface，`Interface x = new Class(...)`
  - 类型构造器：generic
  - 基本上没有dependent type支持
- Rust型：
  - struct + trait
- Python型
- Julia
  - 这里的妙处在于，变量的“类型”（静态强类型语言意义上的类型）就是Dynamic而值的类型（实际上是tag）则是确定的，而如果能够确定一个变量总是取某个tag的值时，这个变量就可以认为是typed的，而Julia的设计意味着这样的推导是很容易的。

类型系统和类型论是重叠的关系：一般的语言的类型系统并没有类型论的全部表现力，可是一些我们公认为（类型系统中的）类型的东西，如动态类型、gradual typing、以及如果你愿意的话，Rust的生命周期标注，并不能很好地在类型论中用`x:T`这样的式子表示出来。
很多时候，与其把类型系统归约到某个类型论中，不如把它看成hoare logic里面的前置和后置条件：
我们可以把每个值看成它的二进制表示带上一个类型tag（并非类型论中的类型type，因为这不是关于变量的声明），来保证当我们对它调用某个操作时，这个操作是我们想要的那个操作，例如不会对整数调用字符串连接的操作，尽管后者可能被写成加号（实际上如果我们想做一个基于集合论的proof assistant，高层设计也要这么做，为了好让人知道各种函数和运算符是什么语境下的）；进一步，这些类型标签可以触发类似于Julia这样的运行时根据数据类型做的派发，来实现polymorphism。
函数f(x::Int, y::Float64)::String可以看成如下的Hoare三元组：{x is Int, y is Float64} res = f(x, y) {res is String}；如果考虑多态还需要适当处理派发机制。
诸如rust的生命周期标记这样的东西也可以很轻易地加进来，而不用担心”lifetime subtyping要怎么在类型论中处理“之类的问题：subtyping在此处简单地成为一个逻辑蕴涵的问题。
唯一需要类似于类型论的记号的地方是给有类型声明的变量赋值，但是这里为了正确捕捉诸如数据类型自动转换，单纯的类型论还是不足的。

应当注意以上的系统会over generate：一些程序实际上是正确的，但是因为类型系统的设计特征，无法被证明是正确的，从而通不过编译；可是如果后者是实际情况，那应该做的是改进这种语言，而不是坚持要求完美复刻它的类型系统的行为。
