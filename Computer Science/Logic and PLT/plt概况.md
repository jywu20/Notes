# Typed lambda calculus

强类型纯函数式编程某种意义上在理论计算机科学中享有“首席”地位，因为无类型表处理函数式编程、过程式编程等更加常见的编程范式都可以毫无困难地嵌入它们中。
Linear type可以用所谓linear monad嵌入Haskell中，动态类型有一个Dynamic包可以做到这一点，等等。
对类型系统的修改，如类型系统层面的linear type、dependent type等，不那么容易做到，但它们总是可以嵌入一个足够强的dependent type theory中，如嵌入Coq或是Lean中。

这样可以比较容易地判断不同feature的正交性，如我们看到过程式编程实际上就是一个Monad，可以确定mutable与否和类型系统基本无关。
TODO：关于内存安全；编译期

泛型等是从范畴到范畴的映射

所以我们又绕回来了：范畴的范畴和高阶范畴有什么关系？

# mutable 

TODO， Kleisli category，