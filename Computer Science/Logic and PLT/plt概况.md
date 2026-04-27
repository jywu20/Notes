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

如前所述，（作为一个具体的形式系统的）类型论有模型，或者可以说有语义。一种常见的语义是把类型理解成集合。
这个理解不是总是行得通的，例如同伦类型论中的类型恐怕就不能简单地看成集合。
一个更加“低阶”的例子是impredicative type不能简单地翻译成集合。
Lean中的Prop不predicative，但是非Prop的类型则不然；考虑到本来我们也没有打算把Prop当成集合，Lean的类型论和集合论之间的互相翻译是比较容易做得到的。

## 编程语言：动态类型检查

现在看更常规的编程语言中的类型系统。
假设我们有一个无类型编程语言。显而易见，很容易出现错把整数当成字符串这种错误，为了避免这一点，在这个语言的运行时中，
我们就把每个**值**看成它的二进制表示带上一个类型tag，来保证当我们对它调用某个操作时，这个操作是我们想要的那个操作。
例如一个带有Int标签的值上面如果调用了字符串连接的操作（可能也写成加号），那就应该报错（如果没有运行时类型检查的话可能不报错但是输出错误结果）。
（理论计算机科学中更多的是让演算停滞，即因为没有能继续执行的操作而进行不下去；证明计算不会报类型错误，就是证明后面所说的progress属性。）
这些类型标签还可以触发类似于Julia这样的运行时根据数据类型做的派发，来实现ad hoc polymorphism。
实际上如果我们想做一个基于集合论的proof assistant，高层设计也可以这么做，为了好让人知道各种函数和运算符是什么语境下的。

在研究用此编程语言开发的程序的行为时，我们用（比如说）small step semantics来定义这个编程语言的operational semantics。
这种情况下，一个程序$f$的类型安全性等价于如下的命题：设$x_1 : T_1, x_2 : T_2, \ldots$，则$f(x_1, x_2, \ldots)$的运行过程中不会出现类型错误。
这样，一个函数的类型签名可以理解成如下的Hoare三元组：
$\{ x_1 : T_1, x_2 : T_2, \ldots \} r := f(x_1, x_2, \ldots) \{ r : T_{\text{return}} \}$.

此处的值、类型等概念是讨论该编程语言时的**元语言**中的概念，或者说是这个编程语言的语义中的概念。
如果我们选择在Lean中形式化这门编程语言，那么Lean是这个元语言，而所谓$x_1 : T_1$的意思真的就是Lean中的`x_1 : T_1`；如果我们选择在一个集合论的元语言中形式化这门编程语言，那么$x_1 : T_1$可能应该理解为类似于$(x_1, T_1) \in \mathrm{tagged}(T_1)$这样的命题。
又比如如果我们真的在运行这门编程语言写的程序，则值真的就是内存中的编码-类型标签对。
另一方面，$f$**不是**元语言中的函数，而是**这门编程语言中**合法的一个语法树，而$r := f(x_1, x_2, \ldots)$需要使用operational semantics定义。
（这样又会引入一些subtlety，如如果$f$不停机，则如何理解$r$。）

## 用类型系统（部分地）消除动态类型检查的必要性

类型正确性以及其他的正确性如内存安全等都可以做动态检查。
不过，动态检查在程序真的运行的时候浪费资源，而安全地移除动态检查需要保证一段程序对预期的输入不报任何错误，为了保障这一点，需要对每个程序的正确性做一遍数学证明，而这是困难的。
我们从而希望在编程语言中引入一些因素，使得写出来的每一段代码都是proof carrying code。
一个自然的想法是向编程语言内引入一个**类型系统**，即不仅给值贴类型标签，也给表达式（和值合称term）贴上类型标签，然后据此开发一个natural deduction或者sequent calculus来在运行前就自动地检查一段程序是不是会有类型问题。

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

（soundness和作为数学基础的类型论的自洽性——不该被inhabit的类型是否被inhabit——不是一回事。
一个sound的类型系统完全可以不自洽，例如“寻找最大的自然数”的代码应该能通过任何不做停机检查的类型系统的检查，这就产生了一个矛盾，因为显然我们“构造”出了最大的自然数：这段代码的类型难道不是`Int`吗？
另一方面，某些类型的不sound意味系统内定义出的函数运行时会崩溃，但是也只是崩溃而已，自始至终没有让我们能往一个类型里面塞入一个不该存在的term。）

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
这里有很多subtlety，例如如果一个程序抛出多种异常，而$L_I$又支持`try... catch...`tagged union type（`result T | error1 | error2`）的monad，而`try catch`对应模式匹配。
（`try ... catch`和Option type的区别，在函数式编程中可以理解为前者是针对整个函数——整个monad的，异常的传播是通过`>>=`，而后者可以出现在普通的immutable的变量里面或者`STRef`里面而异常的传播是通过这些东西上的运算发生的。）
如果$T$不支持tagged union type那$L_I$的程序就无法嵌入$L_F$。
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

# 工业语言中的具体类型

实用的编程语言，如C，C++，Python等的类型系统和类型论（无论是作为数学基础的类型论，还是研究通常弱于前者的那些类型系统的元理论）中的类型又不一样。
例如，Rust以外，基本上没有什么主流编程语言有tagged union type的。
实用编程语言中的类型在类型论中应该看成什么，需要一些（其实并不nontrivial的）讨论。

## 空值

首先要处理的是空值问题，即写`int x;`而不赋予初值的做法要看成什么。
学术上研究的类型系统一般都不支持这种写法，除非被声明的变量的类型指定了默认值。
但是工业实际上有这种写法——要怎么研究它呢？

考虑到在没有默认值的情况下，`x`的值大概是垃圾，而所有依赖于它做的计算也都是垃圾，语义上其实可以认为此时的`x`的值是某个空值。
也就是说如果我们试图将C或者不赋默认值的语言嵌入到一个做得比较好的函数式编程语言中，则`int x`这样的写法实际上对应于`x : Option Int`，
其中`Option`是一个tagged union type，可能是`Some val`或者`None`。
然后后续的所有加减乘除运算都定义成操作数中只要出现`None`就一概输出`None`。

与做得较好的typed lambda calculus不同，在主流编程语言中无从判断一个值是`None`还是不是，因为处于性能考虑，不可能真的给每个`int64`变量或浮点数变量或别的变量都附带一个是否空的flag。
如果要求所有变量都要有初始值，那么`x`嵌入到Lean或其他演算后的类型就不需要被Option包一层了。
不过有一个特殊情况需要考虑：共用体（见后文）。

## 结构体和枚举

结构体可以理解成product，不必多说。

```Lean
inductive Point where
| mk : Nat → Nat → Point
```

枚举类型是sum type的一个特例，即可以看成只有构造器名的inductive type

```Lean
inductive Weekday
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday
```

可以认为一般编程语言中的结构体是一个列出了所有字段名的枚举类型和一个product放在一起做product，

```Lean
inductive PointFields
  | x
  | y

inductive PointData
  | mk : Nat → Nat → Point
```
然后`.`运算符就是一个`PointData -> PointFields -> Nat`的函数（在不同字段的类型不同时需要使用依赖类型来给`.`定类型）。
当然，Lean中有`structure`关键字自动地做这件事。

现在考虑空值的问题。如果在书写结构体字面量的时候，不要求每个字段被赋予的值都是有意义的（如`Point p = {x : x, y : y}`，其中`x`和`y`都没有初始化），那么实际上`Point`应该写成
```Lean
inductive Point where
| mk : Option Nat → Option Nat → Point
```

当我们写下`Point p;`时，栈上分配了两个没有初始化的整数变量，而`Point p = {x : x, y : y}`（其中`x`和`y`都没有初始化）也做了同样的事情。
因此`Point p;`可以编码为`p : Point`，而不是`p : Option Point`，也即`Option`包装可以认为是仅仅出现在原始类型外面的。

## 共用体

C中的共用体嵌入到函数式编程语言中大概是$\Pi x:I, \mathsf{Option}(A(x))$，其中$I$是一个枚举类型而$A(x)$是字段$x$的类型。
或许可以再附加一个约束条件，要求不能有超过一个$x$对应的字段非空——记这个命题为$H: \mathsf{Prop}$。
（从而一个共用体的类型实际上是$\Pi x:I, \mathsf{Option}(A(x))$和$H$的product）。

一个未经正确初始化的共用体中所有字段都是空的，就是说都是`Empty`。这也说明，共用体嵌入函数式编程语言时同样不需要整体的`Empty`包装。
请注意我们前面说过，主流编程语言无从判断这里的$\mathsf{Option}$是空的还是$\mathsf{Some} \ v$，所以也不知道哪个字段真的被占据了。
一个共用体必须和一个表明它内部哪个字段非空的标签放在一起，才能使用。大体上，我们是在处理$I \times (\Pi x:I, \mathsf{Option}(A(x))) \times H$。

这多如牛毛的Option让人烦躁，也充分说明强制要求赋初值有很大的好处。
无论如何，在加强$H$为$H':$“有且只有一个字段非空”后，容易证明$\Sigma x:I, A(x)$和$I \times \Pi x : I, A(x) \times H'$之间有双射，且这一双射可以用不判断一个值是否为`Empty`的手段构造出来。
同理$\Sigma x:I, \mathsf{Option}(A(x))$和$I \times (\Pi x:I, \mathsf{Option}(A(x))) \times H$之间有双射且这一双射可以用不判断一个值是否为`Empty`的手段构造出来。

我们注意到$\Pi x:I, \mathsf{Option}(A(x)) \times H$在内存中可以实现为一段长度为各$A(x)$中最长的那个的空间。
当然，也可以实现为所有$A(x)$的长度之和，后者基本上就是用结构体强行模仿共用体了。


总之，共用体可以在dependent type system中理解，并且也可以用于模拟sum type，可是后者需要付出很大的代价，而且需要额外手动检验诸如“是否有超过一个字段非空”的条件（理论上，对应于和sum type的等价性，在硬件上，对应于一个字段的数据覆盖另一个字段），因此不是很好的设计。

## 子类型作为数据类型转换

所有具有子类型的语言都要允许类型转换。可以通过[基于type class的coercion](https://lean-lang.org/doc/reference/latest/Coercions/)来模拟：$A <: B$等价于存在一个从$A$到$B$的`Coe` type class instance。
（从`A`到`B`，而不是反过来，例如从`int32`到`int64`有一个数据类型转换映射，因此应该认为`int32 <: int64`;可以将其看成从`A`到`B`的嵌入映射）
如下的规则
$$
\frac{\Gamma \vdash A <: B \quad \Gamma \vdash B <: C}{\Gamma \vdash A <: C}
$$
则可以通过所谓的type class synthesis得到("[At invocation sites, Lean either synthesizes a suitable instance from the available candidates or signals an error.](https://lean-lang.org/doc/reference/latest/Type-Classes/#--tech-term-synthesizes)")。
这样，当调用`f(x : B)`而`x : A`时，就可以自动将`x`的类型转换为`B`。

从这个翻译立刻可以看出，将subtyping直接加入类型系统（并仍然希望类型系统decidable）其实是指望能自动判断特定的type class instance是否存在，这看着就不像一个很容易的事情。

这个翻译的一个问题是从$A$到$C$的嵌入映射的唯一性。在具体的实现中可以通过只给出唯一的`Coe`实现来解决这个问题。
这个做法是利用了typeclass的运作方式来实现nominal subtyping，即只允许使用用户要求编译器使用的那种方式来做数据类型转换。

一些人反对子类型，因为有子类型的系统的type judgement不仅要包括$x : A$还要包括$A <: B$，后者无论如何没法在Curry-Howard correspondence中得到解释。

此外数据类型转换和`Coe`不是唯一的模拟子类型方法，尤其假如子类型的用处是做方法派发。见后文。

# Set theoretic types

本节处理所谓的set theoretic type，即已经有若干具体类型以后，在其上做并、交、分离等集合论操作得到的类型。
向类型系统引入这些概念的后果是丢失完整的Curry-Howard correspondence，因为如果$A \lor B$被理解为一个命题，那么对它的证明必须说明被证明的是两个命题中的哪一个。
然而如果我们采取归纳构造演算或类似系统中的做法，而区分`Prop`和`Type`（见[此处](Lean.md#propositions)），则可以只向`Type n`中引入这些概念。
由于`Type n`具有集合论语义，而子类型、untagged union type又可以直接看成子集、并集，因此引入这些概念至少不会导致理论不一致。

在这里可以看到两种不同的做类型系统的思路的张力，一种是从Curry-Howard correspondence出发的，一种是从集合论语义出发的。

## 并集

与subtyping紧密相关的是untagged union type，虽然可以只有前者而没有后者；只有后者没有前者则更为少见。

## Type as contracts or interfaces; intersection types

有了untagged union type以后自然的会有intersection type。
显然，假设$A, B, C$均不交，则有$(A \cup B) \cap (B \cup C) = B$.
然而intersectional type这个名字其实和一些更有趣的东西有关：如果我们将类型看成“至少有这些行为，而不是不多不少正好有这些行为”，那intersection type忽然变得极其有表达能力。

作为第一个例子，`A -> B`如果重新定义为“至少在`A`上有定义，且映射到`B`的函数的集合”，则`f : (int -> int) & (float -> float)`就是一个被重载的函数`f`的类型。

（但intersection type不是必须的。另一种理解函数重载的方法是，将`int -> int`和`float -> float`的两段代码外包到两个不同的属于某个`Strategy`类型的term中，然后让`f`的类型签名变成`∀(A : Type) (B : Type) (Strategy A B -> A -> B)`，然后想个办法让`Strategy A B`参数能被自动搜索。这就是typeclass的来源。通过适当定义typeclass可以实现任意的ad hoc polymorphism，即重载。）

我们前面说的那种有Curry-Howard correspondence的类型论里面对record type——就是结构体——的处理是把它当作一个元组加上一个标签，类似于说
```Lean
inductive Point where
| mk : Nat → Nat → Point
```
所谓`p.x`，`p.y`这些写法可以看成语法糖。当然我们也可以认真对待`p.x`这种写法而把他当成`p["x"]`，这里`p`被建模为一个哈希表。
后者听起来比较笨拙但是逻辑上不是说不通。

现在考虑一个类型定义
```typescript
interface User {id: number; name: string;}
```
这个定义应该理解为什么呢？包含`id`和`name`两个字段的结构体的集合吗？这听起来很合理，但实际上可以把它看成“**至少**包含`id`和`name`两个字段的结构体的集合”。

这立刻意味着，如果有`A`，`B`两个如此定义的结构体类型，则`A & B`不应该理解为空集，而应该理解为包含`A`和`B`中所有字段的结构体的集合。

上面定义的两个`&`类型称为intersection type。
在具有非平凡的intersection type的类型系统中，至少一些类型应该看成接口，即“至少有某某行为的值的集合”。

请注意这样的类型系统的语义和常见的typed lambda calculus中的类型系统的语义是很不一样的。
后者中的类型也可以诠释成集合，但这些集合是通过inductive type或类似手法，加上可能的选择公理这种非构造性公理，一次定义出来的，而不是通过“至少具有某某行为”的谓词，从全体可能的值组成的集合中筛选出来的。
因此Typescript中的类型实际上对应于Lean中的集合：Typescript中的`x:T`，对应到Lean中实际上是`(x : TypeScriptAny) (h : x ∈ T)`。
当然也可以把它理解为Lean中的subtype。

这样一来，我们写下`x:T`的时候其实最有技术含量的那部分工作是提前证明定义了`T`的那个谓词对`x`的确成立，或者，如果已知`x:T`，那就是知道定义了`T`的那个谓词对`x`的确成立。
因此Typescript中的类型检查仍然可以看成是逻辑推理，但type judgement`x:T`不再应该理解为“命题`T`有证明”而应该理解为“`x`属于`T`”这一命题本身。
这个观察可以通过纯粹语法地将一个Type judgement看成命题而不是命题-证明对来得到，也可以通过在Lean内部工作，而注意到subtype给我们增加了很多证明`x`是否真的满足对应谓词的工作而得到。

## Concepts

另一些工业语言没有对应于Lean中的subtype（指的是子集表达式，不是`Coe`）或者说Typescript中的interface的概念，但是有对应于`Type -> Prop`的概念。这就是C++的模板中的concept。
interface约束值，而concept约束类型。

用concept可以模拟interface（定义一个模板函数，它接受一个类型参数`T`但`T`需要满足一定的concept，这样就对输入此函数的值提出了要求）。

concept（或者说interface）可以看成最广义的typeclass（如Lean中的）的一个特例，因为总是可以定义一个类似于
```Lean
def Concept : Type -> Prop := --...

class ConceptClass (α : Type) where
  concept : Concept(α)
```
的typeclass；反之，concept只要足够强，也可以用来代替typeclass（即在concept的定义中写下具有特定性质的函数的存在性）。

这两个功能具体到工业语言中会演变出不同的变体。

- 一些语言如Haskell的typeclass，由于缺乏关于类型的谓词，主要是关于具有特定签名的函数的存在性的。Haskell还要求typeclass instance的唯一性，相对应的也可以理解成typeclass的函数名只能被定义一次，从而模拟了C++的“某类型需要有某方法”的要求，因为一个类型只能有一个同名方法。实际上typeclass instance的唯一性还要再更强一些，因为它也可以要求二元函数（最典型的是等号）具有唯一性。
- 另一方面，C++的concept还能限制一个类型的长度等，等于说是允许typeclass里面有Prop成员，这个Haskell标准语法是做不到的。
- 函数式语言通常无法施加“某结构体一定要有名字叫某的字段”的要求，因为它们的底层理论并不给字段命名

concept或者trait或者typeclass的谓词性意味着在它们上面做交运算不会有什么争议。
由此，很多语言都提供typeclass的继承。

## Set theoretic types and runtime

由于我们通常希望$(A \cup B) \cup B = A \cup B$以及类似的集合恒等式，union type或者intersection type不能做成nominal type。

这马上意味着一件事：当我们拿到一个term形如`x:A`而`A`有子类型的时候，对`A`调用多态函数实际上要求运行时派发，因为只看着类似于`f(x:A) = ...`这样的函数定义，根本不知道在`f`的函数体内部对`x`调用多态函数的时候需要调用哪个版本。

## 子类型和set theoretic type的关系

set theoretic type上自然的有子类型关系。
然而这里的子类型关系和具体类型之间的基于数据类型转换的子类型关系还不太一样，后者的集合语义是“嵌入”（考虑到具体类型往往是nominal的），而基于set theoretic type的子类型关系的最为典范的语义应该就是子集关系。

# 面向对象编程

## 复制粘贴代码

经典的面向对象编程是基于继承的。继承这个事情和subtyping不完全一样。

所谓类`A`继承类`B`有的时候就是说把类`B`的代码复制粘贴到类`A`里面。
这么一搞以后，数据类型转换总是安全的，从而子类型关系似乎成立。
但我们是否真的想要给编译器一个对应的`Coe`实例呢？没有理由认为一定要这么做。

## 基于数据类型转换的方法继承

另一方面，如果认可基于数据类型转换的subtyping，则可以自然地获得方法或者说行为的继承。
Lean中很容易做到一件事，即子类型上的函数如果没有定义，则调用父类型的函数。

这个任务只使用intersection type是不好做的。设`A <: B`。
如果`B`定义为不同类型的并集，那么我们可以在`B`上面定义一个方法，这个方法的定义可以依赖根据`B`的定义而能使用的各种函数。这是一个extensional的设计。
可是这个函数的名字如果和定义在`A`上的方法的名字是一样的，那这个方法无法获得extensional的定义，因为定义在`A`和`B`上的同名函数的返回值可以不一样。

然而Lean中有typeclass可以解决这个问题。
如果`A`和`B`都是具体类型，从而都是nominal的（各自带有各自的类型标签），且存在从`A`到`B`的数据类型转换，且`f`在`A`和`B`上都有定义（类型标签的存在意味着extensional semantics不受威胁，函数仍然可以诠释为集合论意义上的函数），那么函数调用`f(obj)`在任何一个头脑正常的人写出来的编译器里面都会被诠释为`f(obj:A)`，因为调用定义在`A`上的函数不需要typeclass synthesis而调用定义在`B`上的函数需要。
反之，如果`f`在`A`上没有定义而在`B`上有定义，则typeclass synthesis会发生，而定义在`B`上的函数会被调用。

我们这样就让子类型继承了父类型的方法。
请注意这里的继承和“复用父类型的内部结构”是两回事。

这个模拟不能完全捕捉面向对象编程的全部行为：`B obj2 = new A()`这行代码现在就不对了，因为它会导致`obj`被转化为类型`B`，从而完全调用不到`A`上的方法。
换而言之，这里我们只有继承，而没有完整的subtype polymorphism。

（另一方面，`B obj2 = new A()`在把`B`理解为`A`和其他东西的并集的时候是可以的，但这样如果一个函数在`B`上有定义，不好做在`A`上的特化定义。）



## 在未知对象具体类型时的动态方法派发

子类型的功能除了数据类型转换以外，还包括对一个被标记为某个类型的对象做基于其具体类型而非标称类型的动态方法派发。
如果`A <: B`，则有如下的代码
```java
A obj = A();
B obj2 = obj;
obj2.method_defined_in_A_and_B(); // The method called is defined in A and not B
```
我们提到subtype polymorphism的时候通常指的是这个行为，虽然继承其实也可以看成polymorphism，因为显然重载发生了。

这个要使用类似Lean的东西来实现是不容易的，但通过typeclass仍然能够凑活着模拟出来。见下例。

```Lean
-- α is understood as a concrete class that is a subclass of Animal
-- This typeclass defines what OOP classes can be considered a subclass of Animal
class Animal (α : Type) where 
  speak : α -> String
  move (_ : α) : String := "walks"
  coat : α -> String

-- The collection of all OOP objects that can be considered an Animal
-- With proof (inst) of it truly is an Animal 
structure AnimalClass where 
  α : Type
  inst : Animal α
  val : α

-- α is understood as a concrete class that is a subclass of Dog
-- This typeclass defines what OOP classes can be considered a subclass of Dog
class Dog (α : Type) extends Animal α where 
  speak (_ : α) : String := "woof"
  trick (_ : α) : String
 
-- The collection of all OOP objects that can be considered a Dog
-- With proof (inst) of it truly is a Dog
structure DogClass where 
  α : Type
  inst : Dog α
  val : α

-- α is understood as a concrete class that is a subclass of GoldenRetriever
-- This typeclass defines what OOP classes can be considered a subclass of GoldenRetriever
class GoldenRetriever (α : Type) extends Dog α where
  coat (_ : α) : String := "golden"
  trick (_ : α) : String := "Get the ball for me."

-- The collection of all OOP objects that can be considered a GoldenRetriever
-- With proof (inst) of it truly is a GoldenRetriever
structure GoldenRetrieverClass where 
  α : Type 
  inst : GoldenRetriever α
  val : α

-- Because GoldenRetriever is a concrete class,
-- a concrete instance of it can be constructed
structure GoldenRetrieverConstruct
instance : GoldenRetriever GoldenRetrieverConstruct where

-- α is understood as a concrete class that is a subclass of Bird
-- This typeclass defines what OOP classes can be considered a subclass of Bird
class Bird (α : Type) extends Animal α where
  move (_ : α) : String := "fly" -- This doesn't seem to work

-- The collection of all OOP objects that can be considered a Bird
-- With proof (inst) of it truly is a Bird
structure BirdClass where 
  α : Type 
  inst : GoldenRetriever α
  val : α

-- α is understood as a concrete class that is a subclass of BlueJay
-- This typeclass defines what OOP classes can be considered a subclass of BlueJay
class BlueJay (α : Type) extends Animal α where
  coat (_ : α) : String := "blue"
  speak (_ : α) : String := "jay-jay"
  move (_ : α) : String := "fly"

-- The collection of all OOP objects that can be considered a BlueJay
-- With proof (inst) of it truly is a BlueJay
structure BlueJayClass where 
  α : Type
  inst : BlueJay α
  val : α

-- Because BlueJay is a concrete class,
-- a concrete instance of it can be constructed
structure BlueJayConstruct
instance : BlueJay BlueJayConstruct where

def baredog : GoldenRetrieverConstruct := {}
-- GoldenRetriever dog = new GoldenRetriver()
def dog : GoldenRetrieverClass := ⟨GoldenRetrieverConstruct, inferInstance, baredog⟩
-- Dog dog2 = dog
def dog2 : DogClass := ⟨GoldenRetrieverConstruct, inferInstance, dog.val⟩
-- Animal dog3 = dog
def dog3 : AnimalClass := ⟨GoldenRetrieverConstruct, inferInstance, dog.val⟩

#eval Animal.move baredog -- "walks": Method from grandparent class
#eval Animal.speak baredog -- "woof" Abstract method from grandparent class implemented in parent class
#eval Dog.trick baredog   -- "Get the ball for me" Abstract method from parent class implemented in this class
#eval Animal.coat baredog -- "golden" Method from this class
```

如果仔细思考一下，会注意到面向对象开发中的一个抽象类，如`Animal`，实际上对应两个东西，一个是一个typeclass `Animal`，它指定了何者能算一个`Animal`，第二个是`AnimalClass`，它可以粗略地看成全体能算`Animal`的对象的集合，它的每一个成员都记录了一个被说成`Animal`的对象实际上是哪个具体类（上面代码中的`α`）建立的，并且记录为什么这个对象被说成是`Animal`（上面代码中的`inst`）。
这里我们的做法其实和前面的把`{x : int, y : int}`的类型定义看成“至少具有`x`, `y`两个字段”的concept的做法非常像，但是使用typeclass的默认函数实现来完成定义“父类中的方法”。
对一个具体类，如`GoldenRetriever`，还有第三个概念，就是`GoldenRetrieverConstruct`，它对应于`Animal.α`需要记录的东西。

这样，所谓的`Dog dog = GoldenRetriever()`实际上是`dog : DogClass := ⟨GoldenRetrieverConstruct, inferInstance, baredog⟩`，其中`baredog`由`GoldenRetrieverConstruct`建立。

不过这个模拟并不是很完美，原因有几个。最严重的问题是，Lean中如果typeclass`A`extend typeclass`B`而两者都有对某个函数的默认实现，则**不会**发生默认实现的覆盖。这个需要通过修改typeclass的行为（也再次体现subtype polymorphism有多容易出错）。
第二个问题是，要调用一个方法，必须给出这个方法第一次被定义的typeclass（这就是那些`Animal.move`, `Dog.trick`中的`Animal` `Dog`等名称的由来）。
另一个严重的问题是，上面的代码中，只能调用子类方法，无法调用父类方法（如我们无法让一个鸟做到`walk`）。
这个问题显然和前面所说的extensional semantics有一些关系，因为既然要调用`move`方法必须写`Animal.move`，确实没有办法区分我们到底在调用哪个`move`函数。

对第二个问题的一个解决方法是定义函数
```Lean
def speak [Animal α] (_ : α) := Animal.speak _
```
来自动地将`speak`函数调用派发到某个typeclass instance上面。
不过这么写是要报错的，因为Lean要求必须在类型检查的时候就能做完typeclass synthesis，换而言之typeclass不能是核心语言的一部分。
这也是为什么Rust的trait有静态trait和trait object的区分。

还有一个小问题是`#eval Animal.move dog.val`不能工作。这个似乎和typeclass synthesis的机制有关系，因为报错是`failed to synthesize instance of type class Animal dog.α`。
虽然`example : dog.α = GoldenRetrieverConstruct := by eq_refl`不报错，但两者相等的信息好像并不能告诉typeclass synthesis，`dog.α`就是`GoldenRetrieverConstruct`。

使用目前标准版本的Lean，为了解决extends的问题，只能做下面的修改

```Lean
-- We need a macro to copy requirements in Animal here
class Dog (α : Type) where 
  speak (_ : α) : String := "woof"
  trick (_ : α) : String

-- And then copy things defined in Dog to Animal
def Dog.toAnimal {α : Type} (dog_impl : Dog α) : Animal α := 
  {
    speak := dog_impl.speak,
    -- ... 
  }

instance {α : Type} [Dog α] : Animal α :=
  Dog.toAnimal ‹Dog α›
```

这要涉及一些宏编程，但总的来说是体力活。我懒得做了，但理论上肯定是可行的。

因此三种常见的polymorphism来自很不一样的机制。parametric polymorphism其实就是类型函数，而普通重载可以看作intersection type也可以看作typeclass，而subtype polymorphism是typeclass+typeclass synthesis的副产品。
由此也可以看出subtype polymorphism属于很容易出错的东西，因为typeclass synthesis似乎并没有一个典范的定义，所以不同的人凭借直觉做出来的subtype polymorphism可能会有各种细小的差别。

这里定义的所谓subtype polymorphism和`Coe`也即数据类型转换没有直接关系，因为在这里被extend的是typeclass，就是什么`Animal`这些。
当然，的确可以在`AnimalClass`和`DogClass`之间定义一个嵌入关系，但没什么要求我们必须提前定义好这个关系。
但我们仍然在见证一种子类型关系，因为如果能把一个值放进`DogClass`，那也能把它放进`AnimalClass`。

## 面向对象中的继承

现在的情况是面向对象中的继承把mixin，基于数据类型转换的方法继承（在某方法有父类实现没有子类实现的时候调用父类方法），以及方法派发（即将一个子类的对象声明为父类的对象，但与此同时有子类方法时调用子类方法）这三个东西强行用单独的功能实现了。
没有理由认为这三者必须要同时出现。
基于数据类型转换的方法继承完全可以不尊重一个对象的内部结构，也即，数据类型转换的流程未必一定要是根据mixin的定义自动构建的：如我们可以想象子类型是array of structs而父类型是struct of arrays，然后当一个方法在子类型上没有定义的时候，可以先把数据转化为struct of arrays然后调用父类型上针对此结构写的函数。
（这样肯定有性能损失，这里只是举一个例子）
方法派发也可以不依赖于数据类型转换（例如Julia中很多传统上使用继承做的行为就是靠数据类型转换做的）。

此处的论证也可以用来反对语言内置子类型，因为能称为子类型的行为非常多，彼此没有必然的关系。将它们统一称为子类型可能误导语言设计者将它们强行融合为一个功能。

除了继承和多态（指方法派发）以外，面向对象编程的特征还包括封装。
可以使用闭包作用域来模拟封装，因此这其实也不是一个“最小”的特征。

## 接口

经典的面向对象编程有接口，但接口是nominal的而不是structural的。
当然，这个可以使用给每个结构体加一个`implemented_interfaces`字段——然后让每个面向对象接口带一个`name ∈ implemented_interfaces`的约束。

## 设计模式

虽然（面向对象的）继承混合了太多本应正交的特征进了一个单独的功能里面，不甚优雅，但如果你手上只有面向对象语言可以用，也无可设法。
这里指出一些可以用于面向对象简单模拟的特征。

tagged union可以使用sealed class模拟，即指定一个类只有数量有限的子类。
我们知道类名是一个类型标签，从而可以起到tagged union里面的构造器的作用。

