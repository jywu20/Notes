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

# 类型系统和类型论

类型系统、类型论、类型的语义这几个概念经常被混在一起说，这里做一些区分。

## 作为数学基础的类型论

先说类型论。类型论这个概念本身其实就有歧义，它既可以特指一个具体的、足够复杂的类型论，如Lean，又有类似于作为学科的集合论这样的意思，即一门研究可以称为类型论的形式系统的数理逻辑学科。
后者是前者的元理论。
作为后者的类型论可能会研究作为前者的类型论的一致性强度、模型论性质、证明论性质等等。
例如，“Lean和ZFC+可数个不可达基数可以互相在对方中构造模型”就是一个作为后者的类型论的成果。

如前所述，（作为一个具体的形式系统的）类型论有模型，或者可以说有语义。
如前所述，一种常见的语义是把类型理解成语义。
这个理解不是总是行得通的，例如同伦类型论中的类型恐怕就不能简单地看成集合。
一个更加“低阶”的例子是impredicative type不能简单地翻译成集合。
Lean中的Prop不predicative，但是非Prop的类型则不然；考虑到本来我们也没有打算把Prop当成集合，Lean的类型论和集合论之间的互相翻译是比较容易做得到的。

## 编程语言：动态类型检查

现在看更常规的编程语言中的类型系统。
假设我们有一个无类型编程语言。显而易见，很容易出现错把整数当成字符串这种错误，为了避免这一点，在这个语言的运行时中，
我们就把每个**值**看成它的二进制表示带上一个类型tag，来保证当我们对它调用某个操作时，这个操作是我们想要的那个操作。
例如一个带有Int标签的值上面如果调用了字符串连接的操作（可能也写成加号），那就应该报错（如果没有运行时类型检查的话可能不报错但是输出错误结果）。
这些类型标签还可以触发类似于Julia这样的运行时根据数据类型做的派发，来实现ad hoc polymorphism。
实际上如果我们想做一个基于集合论的proof assistant，高层设计也可以这么做，为了好让人知道各种函数和运算符是什么语境下的。

在研究用此编程语言开发的程序的行为时，我们用（比如说）small step semantics来定义这个编程语言的operational semantics。
这种情况下，一个程序$f$的类型安全性等价于如下的命题：设$x_1 : T_1, x_2 : T_2, \ldots$，则$f(x_1, x_2, \ldots)$的运行过程中不会出现类型错误。
这样，一个函数的类型签名可以理解成如下的Hoare三元组：
$\{ x_1 : T_1, x_2 : T_2, \ldots \} r := f(x_1, x_2, \ldots) \{ r : T_{\text{return}} \}$.

我们强调此处的值、类型等概念是讨论该编程语言时的**元语言**中的概念。
例如如果我们选择在Lean中形式化这门编程语言，那么Lean是这个元语言，而所谓$x_1 : T_1$的意思真的就是Lean中的`x_1 : T_1`；如果我们选择在一个集合论的元语言中形式化这门编程语言，那么$x_1 : T_1$可能应该理解为类似于$(x_1, T_1) \in \mathrm{tagged}(T_1)$这样的命题。
又比如如果我们真的在运行这门编程语言写的程序，则值真的就是内存中的编码-类型标签对。
另一方面，$f$**不是**元语言中的函数，甚至也不是元语言中的有副作用的计算模型，而是这门编程语言的语法树，而$r := f(x_1, x_2, \ldots)$需要使用operational semantics定义。
（这样又会引入一些subtlety，如如果$f$不停机，则如何理解$r$。）

## 用类型系统（部分地）消除动态类型检查的必要性

类型正确性以及其他的正确性如内存安全等都可以做动态检查。
不过，动态检查在程序真的运行的时候浪费资源，而安全地移除动态检查需要保证一段程序对预期的输入不报任何错误，为了保障这一点，需要对每个程序的正确性做一遍数学证明，而这是困难的。
我们从而希望在编程语言中引入一些因素，使得写出来的每一段代码都是proof carrying code。
一个自然的想法是向编程语言内引入一个**类型系统**，即不仅给值贴类型标签，也给表达式（和值合称term）贴上类型标签，然后据此开发一个subsequent calculus来在运行前就自动地检查一段程序是不是会有类型问题。

这个类型系统可以理解成元语言中关于值的类型和表达式的结果的类型的理论的一个切片。这个类型系统是**对象语言，即待分析的编程语言**中的类型系统。
如果元语言是Lean，那么一个non-value term$\tau$在元语言中的类型就该是某个`Trm`类型，指代全体term构成的类型：它能够evaluate出来类型`T`的值这件事是通过引入额外的谓词来保证的。
例如一个简单的对[STLC](https://elifuskuplu.github.io/Stlc_deBruijn/docs/Stlc/call_by_value.html)的形式化中，soundness的提法是下面这样的：

```Lean
theorem preservation(E : context) (e : Trm) (T : Typ) :
typing E e T → ∀ (e' : Trm), eval e e' → typing E e' T

theorem progress(e : Trm) (T : Typ) :
typing [] e T → value e ∨ ∃ (e' : Trm), eval e e'
```
$E \vdash e : T$在这里被形式化成了一个谓词和它的变量`typing E e T`，而`T`的类型也是`Typ`——STLC的类型在Lean中的编码——而不是Lean中的类型宇宙`Type 0`。

（这种先有untyped的程序再定义类型系统的观念在Wright and Felleisen, A syntactic approach to type soundness一文中有非常简练的讨论："a partial function... defines the semantics of *untyped* programs... let... mean that the type system assigns program $e$ the type $\tau$..."需要注意一些编程语言的operational semantics中也会出现类型标签以实现polymorphism，这些类型标签可能是可组合的，如Julia的类型；但组合这些类型标签的操作和操作一个普通的树结构没有什么本质区别，因此前述先有untyped的程序再定义类型系统的观念仍然可以认为是正确的，只不过是我们要将类型标签的组合的操作纳入静态类型系统而已。
与这个话题相关的还有intrinsic typing和extrinsic typing的区别：人们经常说前者是先有类型系统再有操作语义而后者反过来，但这个说法可能有些问题：这两种类型系统的主要区别在于类型标签是怎么贴到term上面的，intrinsic typing中标签始终是跟着term走的，而后者中可以证明一个term有某个type。
两种类型的系统都可以是纯语法的而暂时不考虑语义，也都可以被赋予给一个已知的操作语义以保证正确性。
又有说法说intrinsic typing允许让语义依赖于类型；但这只是trivially true。
考虑intrinsic type中用类型标签区分结构相同的Tuple的做法。
在一个extrinsic type system中，可以往tuple中加一个常量的标签，然后将含有标签`T`的tuple的类型都指定为$T$。这并没有造成任何区别。）

另外也注意此处作者其实已经定义了一个operational semantics，因为有谓词`eval e e'`，但这个operational semantics被形式化时是“语法”的而不是“语义”的，因为`e`可能是一个值（as in `value e`）但是$e : T$还是被形式化成了`typing E e T`。
这就是说，此处的形式化完全不在乎`e`等“实际上代表什么”，即它们实际上没有和Lean中的自然数、结构体等形成任何关系。

如前所述，一个（具体的编程语言中的）类型系统的作用就是自动地证明$\{ x_1 : T_1, x_2 : T_2, \ldots \} r := f(x_1, x_2, \ldots) \{ r : T_{\text{return}} \}$，从而保证没有动态类型检查的必要。
如果这个类型系统做到了这一点，就可以说这个类型系统是**sound**的。
有若干种不同的soundness的定义。
最强的定义是这样的：“一个程序的输出*真的*在它的输出类型中”——这就是说，它从来不报类型错误（从而输出的值的类型标签和这个程序的函数签名中的输出类型一致），而且输出的值的二进制编码（如前所述，一个值是编码-类型标签对）也确实在这个类型对应的集合里面（也即没有data corruption，比如说一个字符串的二进制表示被强行贴上了`ArrayList`的标签）。
弱一些的定义是把“输出的值真的在其类型标签对应的集合里面”这句话删掉。

弱一些的定义——weak soundness——可以通过通常称为syntactic soundness的方式证明，即证明progress（程序不会因为类型不匹配的原因运行不下去，即不会报“找不到具有特定签名的函数”的错误）和preservation（类型标签不能偷梁换柱）两个性质，详见上面的代码块——它被称为syntactic的原因也不言而喻。
syntactic soundness一般来说不能保证被标称为一个类型的数据不出问题，除非在一份syntactic soundness证明中用到的所有primitive操作都是内存安全的。
有关的讨论可见[此处](https://blog.sigplan.org/2019/10/17/what-type-soundness-theorem-do-you-really-want-to-prove/)。

## 编程语言的类型系统和作为数学基础的类型论

由于一个类型系统可以非常强（Lean的类型论本身就可以看成一个类型系统），对类型系统的研究和（作为对各种不同的类型论进行研究的元数学的）类型论显然有重叠的关系，而前者的研究者有时也称为type theorists。
不过，两者的关注点还是有不少不同。

不少程序语言设计者会试图让类型系统管理通常不是类型系统管理的问题，如Rust的生命周期标注经常被看成其类型系统的一部分。作为数学基础的类型论很少关心这些。（生命周期甚至不是一个函数式编程中经常出现的东西）
这类更enriched的类型系统如果和作为数学基础的类型论扯上了关系，几乎总是是在后者中被形式化，别无其它。

作为数学基础的类型论中的函数一般会要求要是总是停机的（否则可以拿着一个其实算不出来的死循环的term招摇撞骗说构造出了inhabit某个类型的term，就不自洽了）。
通用编程语言中的函数不该总是停机。
停机问题和类型系统的复杂关系（normalization）是一个主要集中在程序语言理论而非元数学中讨论的问题。

（前面提到类型系统可以看成Hoare logic的一个特例，实际上在类型系统足够强大的时候，Hoare logic也可以看成类型系统的一个特例：例如如果类型系统中有Prop，则前置条件和输入可以打包在一起，而后置条件和输出可以打包在一起（实际上这就是refinement type）。但是考虑到自洽性没有了，在通用编程语言中引入Prop、允许做定理证明的意义可能也有限吧……另一方面，refinement type和Hoare logic的等价性倒是很可以用在作为数学基础的类型论中来定义Hoare logic。）

soundness对作为数学基础的类型论来说是一定要满足的。
理想情况下对通用编程语言也该是这样，但实操上数量可观的语言的类型系统其实都不sound。
“如何让一个不sound的类型系统变sound”是程序语言理论中的而不是数学基础中的话题。

“检查一段程序是否报类型错误”不是一个图灵可判定的问题，因此一个通用编程语言的类型系统如果能排除所有的运行时类型错误的话，是图灵不可判定的，也就是说对每个能被实际写出来的类型检查器，都存在一些程序实际上是well typed的但是没法通过检查。
实际上，即使一个类型系统不保证排除所有运行时类型错误，也有可能不可判定。
decidability（请注意这和给定一个Prop是否总能找到证明的decidability没有直接关系，前者是验证$t : T$是不是对，不是寻找一个$t$）在作为数学基础的和作为编程语言一部分的类型系统中都很重要。
Lean的definitional equality不是decidable的，但这点也许问题不大，因为人类用户总可以手动书写两个东西相等的证明。
但不能确认$t:T$则听起来极为糟糕。

类型推导是一个主要见于程序语言设计——但开发proof assistant时显而易见很有好处——的议题。
类型推导有自己的decidability问题。

最后，类型论的元理论几乎总是关注typed lambda calculi，而实用的类型系统的开发还是要考虑命令式编程。（这点前面提到Rust的时候已经暗示过了）
但这倒没有说明前者对后者没有帮助，因为命令式程序总是可以编码成函数式语言中的Monad。
设想一个函数式编程语言$L_F$有类型系统$T$。将$T$移植到一个命令式编程语言$L_I$中。
显然，$L_F$可以看成$L_I$的子集，因为后者额外引入了副作用。
现在的问题是，能否严格地将后者再嵌入前者？
设想有一个返回值类型为`T`但可能中间报错（Java中的`throws`关键字）的命令式程序，我们要问此命令式程序的“行为”（包括类型检查）能否完整地编码到此函数式语言中。
这里有很多subtlety，例如如果一个程序抛出多种异常，而$L_I$又支持`try... catch...`，那这个程序编码到函数式程序语言中后的返回值实际上是一个很大的sum type（`result T | error1 | error2`），而`try catch`对应模式匹配。
如果$T$不支持sum type那$L_I$的程序就无法嵌入$L_F$。
另一方面，如果$T$已经被充分地扩展以容纳$L_I$了（异常以外，仍需要Types and Programming Languages一书12.3节这一类的编码如何读取变量和赋值的类型系统扩展，但这些可以自然地在将命令式程序翻译成monad时做完；请注意这一节，包括第19章对Java的形式化，都没有要求类型系统“看到”命令式编程的求值语义），是否可以说$L_I$中的程序是well-typed，当且仅当它在$L_F$中的对应物是well-typed，以及两个语言中的soundness是否可以互相翻译？

对较为简单的类型系统而言回答应该是肯定的。

不过仔细想一下，在最一般的情况下，两者的对应关系其实没有那么简单，因为如果类型系统中有dependent type而某个类型依赖于某个term而后者又有副作用，情况会变得很复杂：类型检查应该被允许做IO吗？
一个讨论见[此处](https://cs.stackexchange.com/questions/84578/can-we-add-dependent-type-into-an-existing-imperative-programming-language)。

## 命令式编程与内存安全

在命令式编程中除了类型安全以外尚有内存安全。数据损坏的问题——即一个变量确实获得了一个值，但是这个值和这个变量的类型不符合——前面已经讨论了，在primitives是类型安全的情况下可以看成类型安全的一部分。
另一个内存安全问题是解引用空指针这一类的行为。我们可以模仿解决类型安全时采用的步骤，先是定义带有边界检查的指针、数组等，在越界的时候会报错，然后试图寻找一种构造proof carrying code的calculus来保证一段代码内部一定不会出内存安全错误。
当然，和类型安全性类似，一个保证decidability的类型系统会误伤实际上内存安全但是在前者中无法证明的程序，而一个保证decidability的内存安全性calculus也
下面的问题是，这样获得的calculus是否能自然地类型系统的一部分，如果是的话，它有没有自然的函数式编程对应？

这个问题不是那么好回答的。平庸地，只要类型系统够强，内存安全性的Hoare triple可以用refinement type来表示。
可是正如类型安全性的判定不是图灵可计算的一样，如此general的内存安全性也不是图灵可计算的，其结果就是程序员需要对每个函数都手动写一遍内存安全性的数学证明。
类型系统发明出来就是避免这一点的，一个好的关于内存安全性的calculus也应该要避免这一点。

这个问题至今缺乏太多探索。Rust是主流编程语言中唯一试图通过静态分析保证内存安全性的，而它的borrow checker和lifetime都是让初学者感到头疼的概念。

我们也许会想要通过把Rust嵌入到某个常规的函数式编程语言中来make sense of它的借用检查和lifetime机制：如果这样做得到，那么我们就得出结论：一个已经有工业应用的内存安全calculus可以看成常规的（函数式编程中的）类型系统的一部分。
不幸，市面上的关于Rust的形式化研究并没有这么做。RustBelt: Securing the Foundations of the Rust Programming Language一文给出了一个所谓的“lambda calculus with natural numbers and state”，但它的operational semantics完全就是命令式的（充斥着$h | e \to h' | e'$，其中$h$是内存模型）。
我们来看类型系统。lifetime被编码进了引用的类型中：引用的类型是$\delta^\kappa_\mu \tau$，其中$\kappa$是lifetime index，而$\mu$是可变性。
$\kappa$的值由程序结构中的`newlft;`和`endlft;`语句决定。

lifetime似乎是可以在常规的函数式编程语言中不开语法扩展实现的。
常规的monad其实可以实现一个比较简单的lifetime，如[大路货的`ST`](haskell.md#st-monad)。
或许我们可以考虑一下将`ST`中的生命周期机制扩展一下，如允许将`STRef s a`转换成`STRef t a`，只要`t`在`a`的外面，这样就可以模仿Rust的生命周期机制。
问题显然在于我们如何能知道`t`在`a`的外面。
Lightweight Monadic Regions一文提到了怎样处理nested region。
一个比较简单的做法如下：
```Haskell
newLSRgn :: (forall s. SIO (r,s) v)-> SIO r v

importSHandle :: SHandle (SIO r)->
SHandle (SIO (r,s))
```
使用时将写在child region（生命周期参数为`s`）里面的程序传给`newLSRgn`，其返回值是一段外面的region中的程序（生命周期参数为`r`），并用`importSHandle`处理生命周期subtype的问题。
这个写法的问题是过于限制性，把外面的引用传到里面的时候不能跨层级，需要一步一步地转换。
下面的写法
```Haskell
newtype SubRegion r s =
SubRegion (forall v. SIO r v-> SIO s v)

newRgn :: (forall s. SubRegion r s-> SIO s v)->
SIO r v
```
中，类型`SubRegion`中的元素记录了region subtyping。

有人试图将ownership checking在monad中实现，例如见The Ownership Monad by Michael McGirr。
但这篇文章明确说了它做的是动态的检查，实际上是给带运行时ownership checking的智能指针赋予了函数式语义。
The Linearity Monad by Paykin and Zdancewic倒是成功地将一个linear type system嵌入了Haskell，但这个嵌入和前述的将命令式编程中的赋值符号替换成`<-`这样的操作还是很不一样的。
这篇论文实际上把linear type的type inference rules嵌入到了Haskell的类型系统中，如Haskell中的`x :: exp γ σ`说的其实是（线性类型系统中）$\gamma \vdash x : \sigma$。
σ ⊸ τ定义为`Lolli σ τ`。
linearity的保证靠的是`HasLolli`中用到的若干个type class：
`CSingleton x σ γ''`和`CAdd x σ γ γ'`说的实际上就是$\gamma'' = [x : \sigma]$以及$\gamma'$是$\gamma$和$[x : \sigma]$的不交并。
这几乎就是在写线性类型系统的定义：线性性就是依靠定义线性函数时写`λ $ \s → s ⊗ e`得到维持的。
这种定义下，一个linear的程序只是一个term而已，尚无monad结构。
文章的确定义了一个monad，但这个monad的用处实际上是将前述的linear程序组合起来或者让它们和常规的、非linear的命令式code交互。
我们完全可以在这个monad里面写`h <- ...; (h, h)`，没有任何机制避免这一点！

以下是一段linear程序的Haskell编码
```Haskell
readWriteTwice ∶∶ HasFH exp ⇒ exp Empty (Handle ⊸ Handle)
readWriteTwice = λ $ \h → read h `letPair` \(h,x) →
x >! \c →
writeString [c,c] h
```
这里`read h letPair \(h, x) -> ...`是
```
let (h, x) = read h 
  ...
```
的编码。如果Haskell提供足够的语法糖，其实是可以让这个EDSL看起来和do notation一样接近命令式编程的（说到底`ST`的实例也就是term而已），但目前版本的Haskell并不支持。
我们在这里做的事情看起来和在Lean中定义一个任意的编程语言的类型系统和操作语义没有本质区别。
如果要将Rust的borrow checking嵌入进来——reddit上有人觉得[这是做得到的](https://www.reddit.com/r/haskell/comments/6ievgv/comment/dj61335/)得到的大概也就是长成这样的东西。
当然，这个嵌入的成功至少是说明将内存安全放到类型系统中并没有真的增强类型系统，那也可以说是一个不错的理论结果了。