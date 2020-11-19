# Haskell概况

Haskell是*纯函数式*的，基于typed lambda calculus。

Haskell的类型并不是一等的：例如，在GHCi中可以交互式地求值各种变量和表达式，但是不能交互式地求值类型。你不能输入`:type Int`，那样只会提示找不到变量`Int`，但是`:type 1`就是`Int`。

需要注意的是Haskell本身的类型系统的表现力并不强，因此不能将对程序的行为的预期完全编码在类型系统中。
例如在[Functor](#Functor)中我们会看到光靠Haskell本身不能够分辨一个真正的函子和一个类型签名像函子但是并不能保留范畴结构的映射。
这意味着对Haskell程序的正确性验证通常需要在某个“真正的逻辑”中完成，比如说Coq。

# 类型系统和计算模型

一个从类型`A`到类型`B`的函数的类型就是`A -> B`。Haskell允许有限的类型变量，但是类型变量必须出现在函数的类型签名的最前面，因此可以有类似于`a => [a] -> a`这样的函数类型签名。
TODO：forall quantifier的位置

## 代数数据类型

Haskell支持Algebraic Data Type，ADT。具体的语法如下：我们考虑一个最简单的情况，逻辑变量：

```Haskell
data Bool = True | False
```

其中`True`和`False`是**数据构造器**。数据构造器不是类型，它们是函数；它们的名称和类型的名称可以重复，因为Haskell中没有dependent type，类型和数据基本上是分开的。
数据构造器要以大写字母开头，这暗示它们和普通的函数（以小写字母开头）有一些不同。主要的不同是，数据构造器可以出现在模式匹配表达式的左手边中，但是一般的函数不行。
这当然是正确的，因为任何一个ADT表达式都可以重复使用数据构造器构造出来，并且是唯一地构造出来，但是一般的函数调用未必能够正确析构。
下面的模式匹配是良定义的：
```Haskell
func Maybe a = ...
```
而下面的模式匹配则不是：
```Haskell
func truncate a = ...
```
显然不同数值可以被四舍五入到同一个整数上，于是`a`就不能确定下来。

`data`语句可以含有类型变量：

```Haskell
data Tree a = Tip | Node a (Tree a) (Tree a)
```

此时的`Tree`是一个**类型构造器**。类型构造器不是普通的表达式，因为它们的类型实际上是`Type -> Type`，但是这个类型在Haskell的类型系统中不能表达出来。
通过类型构造器机制可以实现所谓的parametric polymorphism，即泛型。

总是可以定义类型为`a -> m a`的函数，但是并不总是能定义`m a -> a`的函数，例如不能定义类型为`Maybe a -> a`的函数，因为一个`Maybe a`表达式可以是`Nothing`，从中无法体取类型为`a`的任何东西。

## type class

一个type class给出了一个范畴图的模式（或者说一个**结构**）：我们有一些对象和一些态射，它们放在一起未必能够形成一个范畴，因为没有定义恒等态射。
当一个type class被实现之后就得到一个范畴，因为此时类型变量什么的被具体的类型取代，而每个具体的类型上都可以定义恒等态射`\x -> x`。

很容易看出，随意给一个type class中的`a`，`b`等类型变量赋值后不能保证能够找到相应的type class的实例。
这意味着，如果一个类型是某个type class的实例，这个类型的可能取值范围就受到了一定的约束。

type class可以看成面向对象语言中的接口。通过type class可以实现ad hoc polymorphism，与它同类的机制包括函数重载和操作符重载。（我们可以认为重载的函数定义于其上的类型实现了一个只涉及一个函数的type class，操作符同理）
实际上，type class是标准Haskell中唯一能够重载函数的方法；而且也不能重载别的任何东西。

被type class约束的可以是类型也可以是类型构造器，例如Monad就约束类型构造器：

```Haskell
class Monad m where
  return :: a -> m a
  (>>=)  :: m a -> (a -> m b) -> m b
```

这里面，`m`是类型构造器，`m a`才是一个类型。

也可以要求类型参数或者类型构造器参数已经实现了特定的type class，例如：
```Haskell
class  (Eq a, Show a) => Num a where
  ...
```
就要求，如果`a`要实现`Num` type class，它必须首先实现`Eq`和`Show`。

一个可能引起混淆的记号：`Monad m`指的其实是一个属于`Monad`类的类型或类型构造器`m`，并不表示将`Monad`作用到`m`上面，但是`m a`确实可以理解为将类型构造器`m`作用到`a`上面。

## existential type

上面提到的类型变量的scope都贯穿了整个类型签名，如设`a`和`b`是两个类型变量，`a -> b -> a`实际上是$\forall a, \forall b, a \to b \to a$。
Haskell也提供了`forall`关键字，如对`a -> b -> a`完整的类型签名是`forall a b. a -> b -> a`。
类似的，类型构造器`data Something x y = ...`的类型就是$\forall x, \forall y, \mathtt{Something} \; x \; y \to \ldots$。（这个类型在Haskell内部是写不出来的）

在实际开发时，这样的表现力可能是不够的。考虑以下类型构造器：

```Haskell
data Worker x y = Worker {buffer :: b, input :: x, output :: y}
```

直觉上看，它希望表示类型变量`b`是extentially quantified的：对任何类型`x`和`y`，都能够定义类型`Worker x y`，另一方面，也许不是所有的类型`b`都对应某个`Worker`，但是一定可以找到一个类型`b`使得`Worker x y`有定义。
不加以修改的话这段代码会报错，因为`b`出现在了等号右边但没有出现在等号左边。
把它修改成
```Haskell
data Worker x y b = Worker {buffer :: b, input :: x, output :: y}
```
当然就解决了这个问题。但是这样会引入一些新的问题。其一是语义——一个从`Worker`类型到别的类型——比如说，`String`——的函数具有签名`b => Worker b x y -> String`，但是如果我们认为`b`代表“某一个”类型，它显然不应该受全称量词量化，但是`b => Worker b x y -> String`中的`b`无疑受到全称量词量化。
第二个问题是，这样不能实现特定的需求。例如，考虑一个`[Worker x y]`类型的表达式，直觉上它应该允许具有不同`b`的`Worker`作为其元素，但是按照定义`data Worker x y b = Worker {buffer :: b, input :: x, output :: y}`，这样的表达式中的元素的`b`必须是一样的。

总之existential type是有必要的。通过一些类型论上的论证，含有一个existential type variable $a$ 的类型可以通过
```Haskell
data XX = forall x. something about x
```
来给出。上面的含有existential type variable的`Worker`可以写成
```Haskell
data Worker x y = forall b. Worker {buffer :: b, input :: x, output :: y}
```
或者如果我们需要给`b`加上一些限制，那就是
```Haskell
data Worker x y = forall Buffer b. Worker {buffer :: b, input :: x, output :: y}
```
这导致了一个非常奇怪的现象，就是Haskell中虽然有existential type但是没有存在量词。

## 惰性求值

惰性求值的好处包括：

- 语义上说，能够声明实际上是无穷的对象，例如可以写`[1..]`，一个没有终点的列表

坏处在于：

- 语义上说，不能区分coinductive和inductive。使用`data`声明的ADT可以看成inductive的也可以看成coinductive的。当然似乎实际写程序的人也不会太在乎这件事。
- 在定义时看起来像是inductive的数据类型可以包含用inductive的方法构造不出来的term。一个典型的例子：Haskell中表面上自然数就是inductive的自然数，但是可以有这样的语句：
  ```Haskell
  n :: Int
  n = n + 1
  ```
  这段代码毫无疑问可以通过编译——Haskell是惰性求值的，从而编译期不需要将`n`算出来，但是如果我们执行这样的程序：
  ```Haskell
  n :: Int
  n = n + 1
  main = putStrLn $ show $ (n + 5)
  ```
  好了，死循环了。此处定义的`n`是well typed的（它的类型就是`Int`），但是它会导致不停机，

# 原始元素

## 列表和元组

列表定义如下：
```Haskell
data  [a]  =  [] | a : [a]  deriving (Eq, Ord)
```
列表是使用类型构造器`:`从后往前构造出来的。

元组是另一种ADT，通常直接以
```
func (a, b, c) = ...
```
的方式析构。

一个字符串就是`[Char]`。

## 数

在纯函数式语言中处理数似乎是比较麻烦的一件事，因为数自然地要求数据类型自动转换，如整数可以自动转换为浮点数。
Haskell对此的解决方法是定义以下的抽象type class：
```Haskell
class  (Eq a, Show a) => Num a  where  
    (+), (-), (⋆)  :: a -> a -> a  
    negate         :: a -> a  
    abs, signum    :: a -> a  
    fromInteger    :: Integer -> a  
 
class  (Num a, Ord a) => Real a  where  
    toRational ::  a -> Rational  
 
class  (Real a, Enum a) => Integral a  where  
    quot, rem, div, mod :: a -> a -> a  
    quotRem, divMod     :: a -> a -> (a,a)  
    toInteger           :: a -> Integer  
 
class  (Num a) => Fractional a  where  
    (/)          :: a -> a -> a  
    recip        :: a -> a  
    fromRational :: Rational -> a  
 
class  (Fractional a) => Floating a  where  
    pi                  :: a  
    exp, log, sqrt      :: a -> a  
    (⋆⋆), logBase       :: a -> a -> a  
    sin, cos, tan       :: a -> a  
    asin, acos, atan    :: a -> a  
    sinh, cosh, tanh    :: a -> a  
    asinh, acosh, atanh :: a -> a
```

数值字面量被定义为`fromInteger`作用在数学上的整数（即大整数类型`Integer`）或是`fromRational`作用在小数上的结果，从而它们类型被设定为`Num p => p`或者`Fractional p => p`。
例如，`12`的类型是`Num p => p`而`1.2`的类型是`Fractional p => p`。
现在如果`12`被赋予给一个具有某个实现了`Num`的类型的变量，那不会出现任何问题：类型推断会自动导出`p`，然后`p`实现的`fromInteger`函数会自动地被作用到`Integer`类型的12上。
这就避免了隐式数据类型转换。

# 常见设计模式和范畴论

一个type class就是一个范畴图，有一些（抽象的）对象和箭头。instance语句可以看成给一些具体的对象赋予了一些结构。

## Functor

```Haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

`f`经常是一种容器类型。例如，如果`f`是列表，那么`fmap :: (a -> b) -> [a] -> [b]`，因此它就是map函数。

`fmap`对应操作符`<$>`。

一般会要求`Functor`的实例满足以下条件，即所谓**Functor law**：

```Haskell
fmap id = id
fmap (f . g)  ==  fmap f . fmap g
```

这两个条件不能在Haskell的类型系统中表示。满足这些条件之后，**Functor**的实例实际上就是一个函子。
Haskell内部没有足够的机制可以约束`a`和`b`的取值范围，因此使用Haskell能够定义的任何函子实际上都是$\mathsf{Hask}$上的自函子。

## Monad

```Haskell
class Monad m where
  (>>=)  :: m a -> (  a -> m b) -> m b
  (>>)   :: m a ->  m b         -> m b
  return ::   a                 -> m a
  fail   :: String -> m a
```

自函子范畴上的幺半群

# 过程式编程

## Monad可以描述过程式编程

考虑一个过程式算法$s_1 ; s_2 ; \ldots ; s_n$。我们需要一种系统的方法把它转化为函数式编程。
由于过程式算法是有状态和副作用的，每一个语句就是一个动作。
每一个动作可以产生一些值，当然也可以不产生任何值。以下记`m a`为一个可能产生类型为`a`的`m`型动作。

我们知道，总是可以将$s_1 ; s_2 ; \ldots ; s_n$重新加括号为$(s_1 ; (s_2 ; \ldots ; (s_{n-1} ; s_n)))$，这一长串动作可能会有一个返回值，即它们组合在一起可以产生一个会产生一个值的大动作，所以只需要定义$(s ; s')$，以及`return`语句就可以。

如果$s$中没有赋值，那么$(s;s')$是非常简单的——只需要将它们串联起来即可。
具体如何串联留给具体的“动作”类型去实现，我们只是指出，这样一个“串联”是类型为`m a -> m b -> m b`的纯函数。我们记它为操作符`(>>)`。

如果$s$中有赋值，设其形如`var <- something`，那么$s'$代表的实际动作和变量`var`的具体取值密切相关，由于$s'$中显含`var`，此时应当将它看成一个类型为`a -> m b`的函数，其中`a`是`var`的类型而`b`是$s'$产生的值的类型。
这样一来$(s;s')$对应类型为`m a -> (a -> m b) -> m b`。我们记它为操作符`>>=`。

很容易看出`(>>)`是`>>=`的特例：`e1 >> e2`其实就是`e1 >>= (\_ -> e2)`。

`return`语句通常会显式地依赖先前的一些赋值，即它读入一个值而产生一个和这个值有关的动作，因此一个`return`语句就是形如`a -> m a`的纯函数。

我们注意到为了模拟过程式编程需要两个函数：一个是`>>= :: m a -> (a -> m b) -> m b`，一个是`return :: a -> m a`，它们正好组成[Monad](#Monad)。
由于不能一般地构造类型形如`m a -> a`的纯函数，过程式编程具有*传染性*：如果某个纯函数依赖过程式编程产生的值，那么它们组装起来之后得到的代码一定是过程式的。
因此，将stateful的代码收集到一个monad中，而让程序的其它部分保持pure是比较好的做法。

## do语句

do语句

## IO

诸如IO之类的东西肯定是过程式的，因此也需要使用Monad实现。

# 运算符总结


