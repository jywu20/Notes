从Haskell出发，记录一些编程语言理论中常见的主题。

# Haskell概况

Haskell是*纯函数式*的，基于typed lambda calculus。

Haskell的类型并不是一等的：例如，在GHCi中可以交互式地求值各种变量和表达式，但是不能交互式地求值类型。你不能输入`:type Int`，那样只会提示找不到变量`Int`，但是`:type 1`就是`Int`。

需要注意的是Haskell本身的类型系统的表现力并不强，因此不能将对程序的行为的预期完全编码在类型系统中。
例如在[Functor](#Functor)中我们会看到光靠Haskell本身不能够分辨一个真正的函子和一个类型签名像函子但是并不能保留范畴结构的映射。
这意味着对Haskell程序的正确性验证通常需要在某个“真正的逻辑”中完成，比如说Coq。

Haskell代表的强类型纯函数式编程某种意义上在理论计算机科学中享有“首席”地位，因为无类型表处理函数式编程、过程式编程等更加常见的编程范式都可以毫无困难地嵌入它们中。
Linear type可以用所谓linear monad嵌入Haskell中（虽然这并不是对类型系统的扩展），动态类型有一个Dynamic包可以做到这一点，等等。
对类型系统的修改，如类型系统层面的linear type、dependent type等，不那么容易做到，但它们总是可以嵌入一个足够强的dependent type theory中，如嵌入Coq或是Lean中。

这样可以比较容易地判断不同feature的正交性，如我们看到过程式编程实际上就是一个Monad，可以确定mutable与否和类型系统基本无关。
TODO：关于内存安全；编译期

一点个人见解：把“足够强的dependent type theory”中能够自然地模拟的feature都做出来，会得到这样的一种语言：过程式（stateful， 可以用Monad等那一套模拟），动态类型，有静态检查（老本行），允许gradual type checking，有一定面向对象能力，dot syntax（record type），subtyping等等，这不就是Julia吗？当然Julia没有dependent type。

# 类型系统和计算模型

一个从类型`A`到类型`B`的函数的类型就是`A -> B`。Haskell允许有限的类型变量，但是类型变量必须出现在函数的类型签名的最前面，因此可以有类似于`a => [a] -> a`这样的函数类型签名。
TODO：forall quantifier的位置

因为类型系统的限制Haskell中不能直接写出Y组合子的类型，不过有一些方式可以绕开它。

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

`data`定义的ADT在一种特殊的情况下可能是不必要的：被定义的新类型只是对一些原有类型的简单封装，从而只有一个数据构造器。
此时为了减少性能开销Haskell有另一个关键字`newtype`。`newtype`默认是严格求值（而不是惰性求值）的，这可以从`undefined`测试看出来：以下代码
```Haskell
data MyBool = MyBool {myBool :: Bool}
helloBool :: MyBool -> String
helloBool myBool = "hello"

main = putStrLn $ (helloBool undefined)
```
会报错，但是以下代码
```Haskell
newtype MyBool = MyBool {myBool :: Bool}
helloBool :: MyBool -> String
helloBool myBool = "hello"

main = putStrLn $ (helloBool undefined)
```
则不会。

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

## bottom、不停机、错误处理及其它

Haskell中有这样一个函数`error`，它的类型是`[Char] -> a`，即接受一个描述错误的字符串，然后可以返回任意类型的表达式。
它返回的表达式一旦在计算中出现，就会导致一个错误，此时程序运行中止，错误被展示给用户。

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

顺便，这样是容易踩坑的，比如说`**`是`Floating a => a -> a -> a`的，而`n`是`Int`型变量，那么`n**0.5`就报错了，因为编译器会把`a`匹配到`Int`上面，然后`Int`当然不是`Floating`的，那么就报错了。

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

实际上`List`就实现了`Monad`类。`return`就是从一个元素建立一个列表，`>>=`就是`map`。这也就是列表推导式中`<-`等记号的来源：`[a | a <- ...]`就是`a <- ... return a`。

# stateful相关话题

强类型函数式编程经常被如此辩护：范畴论、typed lambda calculus、逻辑构成所谓computational trinitarianism。
更加重视实际问题的人会反驳说，存在很多其它不同的编程范式，它们也许也有类似的underlying structure。
的确如此——但是实际上，重要的编程范式实际上可以被归并入强类型函数式编程。
本节讨论stateful在函数式编程中如何体现。

## Monad可以描述过程式编程

考虑一个过程式算法$s_1 ; s_2 ; \ldots ; s_n$。我们需要一种系统的方法把它转化为函数式编程。
由于过程式算法是有状态的，每一个语句就是一个动作。
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

do语句是写出Monad的一种语法糖，它可以让Monad看起来很像过程式编程。它是monad的语法糖，具体来说，根据Haskell Report 2010：
```
do {e}	=	e
do {e;stmts}	=	e >> do {stmts}
do {p <- e; stmts}	=	let ok p = do {stmts}
    ok _ = fail "..."
  in e >>= ok
do {let decls; stmts}	=	let decls in do {stmts}
```
过程式编程需要的各个组成部分都在这里了：顺序执行语句就是monad的`>>`，其类型签名为`Monad m => m a -> m b -> m b`，也就是先执行可能返回类型`a`的一个monad（对应一个或者一组语句），然后执行可能返回类型`b`的一个monad。
`let`用于简单地创建一个别名，而`<-`则运行一个语句并获得它的结果；后者是可能有副作用、可能产生错误等的，而前者不会。
（这又意味着，如果某个值需要从一个monad获得，而我们需要将它传入一个函数中，那么必须使用
```Haskell
x <- expr
func(x)
```
而不能写`func(expr)`）

可以看到`return`关键字并不立刻终止一个do语句，在它后面跟上一些别的语句后`return`没有效果。
实际上Haskel中的`a; b; ... ; return sth`和Scala之类语言的`a; b ; ... ; sth`的意思是一样的；后者之所以看起来非常简洁只是因为后者直接接纳stateful，因此并不需要将表达式`sth`包进monad中，而Haskell需要这么做。

## ST Monad

和很多其它Monad不同，数据*可以*离开ST Monad：函数`runST :: forall α. (forall s. ST s α) -> α`可以用来做这件事。

常见以下代码：
```Haskell
runST $ do           -- runST takes out stateful code and makes it pure again.
    n <- newSTRef 0             -- Create an STRef (place in memory to store values)
    forM_ xs $ \x -> do         -- For each element of xs ..
        modifySTRef n (+x)      -- add it to what we have in n.
```
等价于过程式语言中的
```C++
{  // enter a block, that is, define and run a runST to take out stateful code and make it pure again
    auto n = 0; // create an STRef (place in memory to store values)
    for (x in xs) { // For each element of xs ..
        n += x; // add it to what we have in n.
    }
}
```
我们在这里做的事情实际上是给过程式编程提供了一种函数式语义：一个block就是一个ST monad，block中的变量（真的可变的、可以多次赋值的量）就是`STRef`，各种`if`，`for`之类的关键字就是用于建立新monad的函数，`;`就是`>>`（使用ST monad配合do notation得到的过程式语言带着函数式风味，或者说是函数式语言带着过程式风味，不区分表达式和语句，从而一个语句可以有一个运行结果也可以有抛出错误，那么`;`就是`>>`，`;`只是忽略上一个语句的执行结果，然后执行下一个语句；Scala就是这样）。
实际上在Haskell中可以实现各种各样的过程式语言中的特征，比如说可以实现`break`，然后还可以实现Rust中的ownership（见The Ownership Monad；PLT上通常称这是affine type，但考虑到Rust允许mutable，在Haskell中需要用Monad模拟ownership以体现这一点；这样一来原本编译期实现的ownership检查就被拖延到了运行期，那就不尽准确了），move语义、copy语义等，由于程序运行的状态全部可以得到细粒度的控制，这些的实现几乎就是把spec翻译成代码。
不太好实现的主要还是变量的复杂行为，如动态作用域等；要完整实现动态作用域肯定不能用`a <- ...`这样的语句冒充变量赋值了，而可能要写`createRef("a", ...)`——这就真的变成写解释器了。

考虑一个过程式编程语言怎么嵌入Haskell中有一定的好处。我们知道无副作用有很大好处，但是不便于开发，因此好的过程式编程语言应该“有点像”函数式编程语言但是又保留了必要的过程式特征。
因此用Monad模拟过程式编程时，产生的语法噪声越多，暗示着对应的过程式范式越过程式、可能也越糟糕。
在类型系统支持时，`try ... catch`在很多时候比Maybe型结果要糟糕，因为需要在Monad保存的状态中显式引入一个标记“有无出现错误”；ownership并不更加糟糕，它和`IORef`之类的东西相比用起来并没有产生更多语法噪声（实际上函数式版本的ownership实际上就是线性逻辑）。

TODO:具体实现

## IO

诸如IO之类的东西肯定是过程式的，因此也需要使用Monad实现。

## 迁移指南：循环

实际上，很多过程式的代码都可以使用列表重现出来，尤其是那些涉及循环的代码。
反正Haskell默认惰性求值，列表被声明的时候并不会被计算。（这个套路在Python编程中也经常用到）

对for循环，只需要使用一个列表收集循环中的中间结果，然后事后使用作用在列表上的一些`fold`之类的函数来“加总”所有的中间结果。

while循环有时候是因为IO，此时关于IO的monad可以很好地处理这些问题，有时候是指“不断地解构一个输入”，此时只需要简单地使用递归就可以。

如果用于取代循环的递归函数的参数中有一些不希望暴露给用户的中间状态，使用
```Haskell
publicFunction arg1 arg2 = functionWithInnerState arg1 arg2 state where
    functionWithInnerState arg1 arg2 state = ...
```

将中间过程包括在函数参数中是有好处的，因为这样可以很容易地写尾递归的代码。所谓尾递归是指函数中最后一步计算是递归调用的递归，下面的写法不是尾递归：
```Haskell
mySum :: (Num a) => [a] -> a
mySum [] = 0
mySum [a] = a
mySum (x : xs) = x + (mySum xs)
```
因为`mySum (x : xs)`的最后一步是加法而不是`mySum xs`。下面的写法是尾递归：
```Haskell
mySum :: (Num a) => [a] -> a
mySum list = mySumWithState list 0 where
    mySumWithState [] acc = acc
    mySumWithState [a] acc = a + acc
    mySumWithState (x : xs) acc = mySumWithState xs (acc + x) 
```
因为`mySumWithState`的最后一步就是递归调用，加法发生在函数调用之前。尾递归可以很容易地被优化，因为既然最后一步是递归调用，无需在函数调用栈中保留本次调用的信息，从而递归可以被优化为循环。

`break`语句可以简单地使用递归的结束来重现。

## 迁移指南：mutable和赋值

如果不考虑它们本质上是`let ... in`，可以有下面的诠释：
`let`：从无副作用的函数获得结果
`<-`：从可能有副作用的过程获得结果

外层`let ... in`中的变量被内层变量屏蔽这件事和Rust中重复let导致覆盖类似。

过程式语言中变量同时表示一个名称（其上绑定了一个表达式）和内存的一个区域的状态；我们这里的`let`和`<-`都只有前者的功能，所以实际上未必能够覆盖一切过程式编程的行为。
或者说，只使用`let`和`<-`只能写这种风格的过程式编程：`let b = f(a); let c = g(b);`，没有mutable的数据结构。
这里还有一个细节，就是Haskell中`let x = x + 1`实际上是用于寻找不动点的，因此`let x = 1; let x = x + 1`不能给出正确的结果。
不过这个解决起来并不困难，因为可以认为过程式语言实际上创建了临时变量来保存`x+1`然后把它赋值给`x`。
另一个问题在于没法做循环之类需要持续、自动改变变量值的操作。当然这也不是真的不可以，因为有
```Haskell
for_ xs $ \x ->
    modifySTRef n (+x)
```
这样的写法。

因此如果要在Haskell中模拟完整的过程式编程，处理mutable的数据结构，**引用**是必须的。我们用`a <- newIORef`之类的语句来创建引用并且把它绑定在一个名称上，用`b <- readIORef a`之类的语句来读取引用的内容，等等。

我们会发现直接通过`<-`绑定的名称似乎像是栈上的变量，而引用像是堆上的内存区域。
（这和实际上Haskell编译器的实现方式无关，我们这里是把命令式编程嵌入Haskell，不是在把Haskell嵌入机器语言）
这个说法有些误导性，因为即使在命令式编程语言中，创建对栈的引用也是可能的。
栈和名称、堆和引用的对应关系更多的是一种良好的实践而没有太多理论基础。

TODO：内存安全

# 运算符总结


