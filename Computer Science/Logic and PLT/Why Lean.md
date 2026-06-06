时隔六年自己来回答一下。

我是外行，当时是，现在还是。我当时问这个问题的动机其实和类型论和集合论的比较没有直接关系，而是没搞懂“类型论到底好在哪里”。这里体现出很多关于形式方法的科普文的一个问题：相当多的写这些文章的要么是程序语言理论专家，要么是做行外人看来非常abstract nonsense数学的数学家。这两类人对一般通过的“我只是想把我的证明敲进电脑里”的好奇者（如我）的知识储备往往是不了解的。

比如说你现在去找一个主流proof assistant的介绍，开头很可能就会出现这样的话：“某某prover既是一个逻辑框架又是一个编程语言”。入门者到这里就蒙了：为什么要自带一个编程语言？

稍微懂一点的人知道有Curry Howard correspondence，但还是对怎么把一个命题编码到一个类型系统里面不知道。套用集合论中的习惯，一个初学者可能会觉得一个形如P(a, b)的命题应该编码成类似于(mk a b) : P这样的形式（知乎上有用这种办法在Haskell里面做定理证明的文章）。然后一看，不知道为什么很多prover里面都有一个Prop类型。说好的命题就是类型呢？又蒙了。

这还没提现代同伦论呢……

我这里写一些我作为外行人所看到的从较为粗浅的、本科级别的数学实践角度出发的motivation。



类型是一个几乎必然出现的概念。拿到一个数学对象的集合论或者二进制反序列化编码以后你并不知道能对它做什么事情，所以最好给它带上一个描述它在干什么的标签，这个就是类型。然而实际上没有什么东西要求“类型”一定要发展成常规意义上的“类型论”。例如Mizar有一个类型系统，它的描述可见Mizar’s Soft Type System一文。其主要功能实际上是在不支持用户定义tactic的情况下提供证明自动化。如考虑如下的registration：cluster FinSequence-like -> finite set for set，它告诉Mizar，看到具有FinSequence-like形容词的set，要自动意识到它也是有限的。常规编程语言的类型系统没有这个功能。

所以为什么需要把proof assistant的基础理论选成dependent type theory其实还是需要解释的。

对数学对象——而非逻辑——而言，dependent type theory倒是不难理解。贴标签这个做法在范畴论中也常见。 
$\prod_{x:A} B(x)$看着就像纤维丛的全体截面的集合。此外一个实用的基础理论最好带有一定的可计算性，否则类似于4+12=16这样的命题也要掰着手指头这样地证明。所以让基础理论包含dependently typed lambda calculus是自然的。（然而其实这也并不是唯一的出路：我们也可以想象让用户写函数去和Mizar内核对话，而on the fly地自动证明一个很长的等式成立。）

下一个问题是逻辑要怎么理解。当然我们有C-H同构。但实际上直接把命题当作类型而把证明当作命题内的term不是唯一可能的做法。例如Isabelle有元语言和对象语言的区分，逻辑推理不是在simply typed的元语言里面做的，从而我们并不把命题按照裸的Isabelle的C-H同构形式化。除此以外还有很多同时有计算能力和逻辑的proof assistant的架构，例如ACL2。

所以其实备选技术有很多。我能力有限，没法做一个全面的比较，这里只是提一下为什么Lean版本的calculus of inductive constructions (CIC)是一个（并非唯一）符合数学实践的选择。



先说逻辑。

C-H同构的一个好处是可以把性质塞进typeclass里面。例如Lean mathlib中对群的定义是这样的：

```Lean
class Group (G : Type u) extends DivInvMonoid G where
  protected inv_mul_cancel : ∀ a : G, a⁻¹ * a = 1
```

“一个群结构包含一个DivInvMonoid结构，加上逆元素乘以一个元素总是单位元这一性质。”

然后给Group G定义instance就是“给G赋予群结构”。由于编译器不会为我们自动寻找typeclass instance，实际上一个instance声明是在定义“当下语境下通常所说的那个群结构”，而[Group G]可以用来指代这个群结构。

我们无须为怎样定义数学上说的结构引入任何新语法，typeclass的语法都可以复用。

另一个复用函数式编程的基础设施的例子是，使用inductive type递归地定义谓词。这样的定义在数学实践中不少见，在集合论语言中需要依赖不动点定理，然后引入某些语法糖来使得我们能写出下面的定义。在一个dependent type theory中可能底层的基础理论也没那么直观，但因为inductive type在定义数据类型的方面是刚需，谓词的递归定义需要的语法不用另外单独做一套。

```
inductive Even : Nat → Prop
| zero : Even 0
| add_two : ∀ n, Even n → Even (n + 2)
```

第三个例子是，按照A和B的类型的不同，$\forall x:A, B$可以理解为函数，实质蕴涵，谓词，和有前置条件的term的类型。



不过完全不区分命题和常规的数据类型有若干不方便之处。其一是proof term可能很大。其二是$\forall x:A, B$所在的类型宇宙是A和B两个类型的宇宙中较大的那个，因此关于Type n中的类型的term的命题也会至少出现在Type n中。这会让我们面对罗素曾经面对过的一个丑陋现象，即在每个宇宙中都能做一模一样的理论，可是就是无法统一处理他们。其三是，设想我们想要refinement type，即让一个可计算的函数接受一个term以及关于它的一些性质的证明，如果后者被做成了一个普通的类型的term那实际上这个函数可以依赖证明的细节，这个听着不太对劲。

这些问题可以通过引入一个Prop宇宙来解决，在其中不管你对来自哪个类型宇宙的term说什么话，都不会跳出Prop。此外我们还通常会引入proof irrelevance，即将两个对同一命题的不同证明视同相等。这样一个接收refinement type的函数就没法（不自然地）依赖证明的细节了。

对一个普通用户，有Prop宇宙以及proof irrelevance以后他其实可以假装自己在使用普通的谓词逻辑。现在形如 p : f(a) = f(b)这样的judgement你可以凑和地理解成“命题f(a)=f(b)已经证明了，然后用p给它标个号”——因为p的内部结构在证明完成以后就不重要了。

这有一个代价，就是从此我们没法从一个存在命题的证明拿到具体的存在的那个东西了。proof irrelevance意味着命题是computationally irrelevant。对数学实践来说这倒不是什么很大的代价，只是从此我们要区分$\exist x:A, P(x)$和$\sum x_A, P(x)$，其中P是谓词。

一阶逻辑以外我们还有高阶逻辑特性，因为可以把谓词传来传去；这个其实等价于集合，见后文。



然后我们来看类型论和集合论的关系。不是所有的类型论都有直截了当的集合论诠释，例如System F就没有（见Polymorphism is not set-theoretic一文）。但是就Lean（以及Coq）使用的CIC而言，可以证明“ZFC+可数个不可达基数”和“可数个Type n宇宙的Lean+类型论版选择公理+proof irrelevance+quotient type”可以互相构造对方的模型（见Sets in Types, Types in Sets一文，以及Mario Carneiro的硕士论文The Type Theory of Lean；Prop不能nontrivial地诠释成一些集合，但我们也不需要它们被解释为集合），从而两个基础理论是等价的（文献中常见“这两个基础理论是equiconsistent的”的说法，但这里我们有明确的把数学对象和命题从两个理论往对面搬运的构造所以这里的结论其实更强一些）。因此Lean的一致性强度要强于ZFC从而更可能不自洽，但是对范畴论而言，不可达基数有其意义，否则无法字面地定义Set范畴。

一个稍微麻烦一些的事情是，要看出一份Lean证明是否用到了超越ZFC的工具并不容易，因为即使被证明的命题的叙述中没有出现Type 1或更高的宇宙，证明过程里面仍然可以使用它们。显然的例子是“ZFC是自洽的”是一个算术命题，从而不涉及高阶类型宇宙，但它可以在Lean中证明，而显然不能在ZFC中证明。检查证明过程中用到了哪些类型宇宙是不够精确的，因为集合论运算在CIC中要编码成函数，从而本质上是ZFC以内的操作有的时候会涉及Type 1。社区现在还没动向去研究怎么确保一份Lean证明是足够“简单”的。

[foundations - Lean and inaccessible cardinals - Proof Assistants Stack Exchange](https://proofassistants.stackexchange.com/questions/2728/lean-and-inaccessible-cardinals)

但无论如何Lean，或者说其它可以归结为CIC+Choice的系统和主流数学的实践是相对一致的，而且可以说是兼顾各方需要。而且要说基础理论的一致性强度过高，Mizar可是有完整的Tarski-Grothendieck集合论，这个比ZFC+countable inaccessible cardinals可是强得多……

（需要强调：这里所谓和主流数学相一致、能表示出Set范畴、构造出ZFC的模型的都是CIC+Choice。纯CIC的强度要弱很多，而且没有类型论版选择公理以后，类型宇宙的等级和inaccessible cardinal的等级没有明确的对应。）
在探索了Lean的强度之后，我们会发现它们在一些地方甚至要更加贴近数学实践。历史上公理化集合论的motivation就是避免使用没有限制的分离公理（否则罗素悖论），因此要定义一个集合，就是说要先使用某些造集的公理定义足够大的集合，然后在后者上应用一次分离公理来得到想要的集合。在Lean中分离公理是免费的：把用来定义集合的谓词当作集合本身就行（官方文档："Set α. A set is defined as a predicate, i.e. a function α → Prop."）。
配对、无穷公理用来justify的操作，使用inductive type可以轻松做到。需要幂集公理做的事情靠$A \to \mathsf{Prop}$（显然，可以理解成A的全体子集的集合）以及函数定义也能轻松做到。所以相比看起来有些杂乱的集合论公理，简洁的inductive types+dependent arrow types+universes的类型论反而看起来更接近很多数学家日常写的东西。

一个不如集合论基础简洁的地方是我们现在需要决定一个集合要编码成一个类型还是一个谓词。一个大致的rule of thumb是，“不知道从哪来的集合”（如一个任意的拓扑空间）应该当作类型处理，而在此之上应用分离公理得到的集合要当成谓词（然后使用refinement可以据此定义新类型）。Lean中两个任意的类型无法取交、并，但是可能我们也没有对两个不知道哪来的集合算交集并集的需求。



所以总结下来，使用CIC做基础理论有若干好处：自动化（不是必须CIC或者typed lambda calculi，但这些肯定能用）；不需要为逻辑语句和数学对象分开设立两套语法，像typeclass，inductive type这些东西很自然的就是两用的；通过引入proof irrelevance可以一比一复刻常规的一阶逻辑（代价是放弃了证明的计算性，但做数学的人本来也不在乎这个）；通过引入类型论版本选择公理可以复刻ZFC+countable inaccessible cardinals，相对没什么争议；得到的系统相较于严格的公理化集合论，观感上更加接近数学实践。

其实上面列举的好处并不是原则上不能在别的系统中做到。接下来是否会有别的发展我们可以拭目以待，但做平台重要的是生态，而现在Lean在数学圈子里有了一定名气，所以大概这条路还会继续被走下去。

---

顺带，基于Church's Simple Type Theory的高阶逻辑（HOL）其实也有集合论对应，即Mac Lane set theory（见Thomas Forster的Weak Systems of Set Theory related to HOL一文，[此处的讨论](https://cstheory.stackexchange.com/questions/38556/is-simply-typed-lambda-calculus-equivalent-to-primitive-recursive-functions)，以及Mathias and set theory by Akihiro Kanamori）。
这个其实是一个很自然的一致性强度，例如它和罗素的类型论似乎是等价的（见[此处](https://mathoverflow.net/questions/498078/what-is-the-consistency-strength-of-russell-whiteheads-principia-mathematica)；当然，HOL的拥护者未必是罗素式的逻辑主义者，他们可能大部分都不是，例如现代意义上的HOL基本上都是有无穷公理的，而从不觉得有必要论证无穷公理是纯逻辑的、不涉及任何实体的公理）。
HOL中没有$\mathsf{Prop}$但有$\mathsf{bool}$，因此命题和谓词（从而集合）在HOL中是term。
与CIC不同的是，HOL中没有proof term，即我们有$1+1=2 : \mathsf{bool}$，但是并没有$p : 1 + 1 = 2$。
也就是说HOL中可以把命题拿来拿去做讨论，但命题的证明不是可以被操作的对象：如果$\Gamma \vdash \phi : \mathsf{bool}$，则可以讨论$\Gamma \vdash \phi$或者$\Gamma \vdash \neg \phi$，但不能在HOL**内部**把$\phi$的证明当作一个term，比如给它命名什么的。
（这可能也就是为什么HOL往往被实现在一个元语言里面）
当然，CIC在有propositional extensionality+排中律+proof irrelevance的情况下，实务上和HOL在逻辑部分也没有什么区别，主要区别在于是否有universe以及是否有依赖类型。

某种意义上Lean+经典公理对应于某种数学基础的极大主义，即试图字面解读$\mathsf{Set}$范畴、序数分析等，而HOL对应某种数学基础的极小主义。
有关不同版本的HOL的关系（以及一些看着像语法糖的东西是不是真的是语法糖）可见Safety and Conservativity of Definitions in HOL and
Isabelle/HOL一文。
有关Isabelle/HOL中加入的polymorphism和typeclass是否是保守扩张，可见Proof-Theoretic Conservative Extension of HOL with Ad-hoc Overloading by Arve Gengelbach and Tjark Weber，以及Safety and conservativity of definitions in HOL and Isabelle/HOL by Ondřej Kunčar, Andrei Popescu.
（注意Isabelle里面的参数多态不是System F这么强的）