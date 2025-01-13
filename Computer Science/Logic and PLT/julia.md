# 类型系统

Jeffrey Werner Bezanson的博士论文Abstraction in Technical Computing（此文中的记号已经和目前的Julia不一样了，这里以目前的语法为准）中明确提到，
> Our goal is to design a type system for describing method applicability, and (similarly) for
> describing classes of values for which to specialize code. Set-theoretic types are a natural
> basis for such a system. A set-theoretic type is a symbolic expression that denotes a set of
> values. In our case, these correspond to the sets of values methods are intended to apply
> to, or the sets of values supported by compiler-generated method specializations. Since set
> theory is widely understood, the use of such types tends to be intuitive.

## 概况

- 就类型本身而言，Julia的类型和主流类型论中的类型有所不同（虽然理论上仍然可以看成某种类型论的一个特例）。例如，subtyping在Julia的类型系统中是重要且自然的，虽然它在类型论中是一个相当棘手的feature；又比如Julia允许轻易地创建“只含有一个元素的类型”，可以很容易地做类型的union等。
- 但是Julia的类型系统和集合论也是不同的。由于类型本身也是对象，我们同时有`Any <: Any`以及`Any :: Any`；如果想将Julia的类型解释为通常的集合论的集合，那么不能将`::`简单地理解为$\in$；除去这一点，抽象类型可以大致视为集合。
- 就类型系统的作用而言，Julia的类型直接决定多重派发怎么做，而不仅仅是保证程序的正确性；挪用静态类型的术语，这意味着Julia的类型是intrinsic的，因为类型是语义的一部分。当然，正确性保证也是有的，比如说把一个字符串传给一个没对`String`定义过方法的函数，肯定就报错了。
- 因此，Julia的类型和集合论的更大的区别在于集合论中的一个值就是一个值，但是Julia中的一个值理论上会有一个tag与之绑定，指示对这个值调用函数的时候应该调用什么函数
- 这又意味着Julia是nominal typing的而不是structural的；这和类型用于决定多重派发怎么做有关。
  Julia类型描述“一个对象是准备用来干什么的”，而不是“一个对象的内部结构是什么”。
  这可能也和Julia是科学计算语言这件事有关。
- 就静态-动态的区分而言，Julia的类型系统是动态类型的：类型不兼容导致的不是程序被直接拒绝，而是运行时错误。

## Julia中会出现的各种类型

### 具体类型

每一个对象都有一个最准确的类型，即`typeof(x)`，它返回一个concrete type。
这个就是前面所说的tag，用Bezanson的话说：

> Next we add data objects with structured tags. The tag of a value is accessed with typeof (x). 

每个tag的形式是`Name{E1, E2, ..., En}`。
例如，一维数组的tag是`Array{Float64, 1}`。
确定tag，或者说具体类型（concrete type）的具体方式如下。对本身不是一个Julia类型的值而言，

- 如果`x`是某个primitive type的元素，那么`typeof(x)`就是该primitive type。
- 如果`x`是通过下面的方式创建的，那么`typeof(x)`是`DataType`：
  - `primitive type ... end`块，此时`isprimitivetype(x)`求值为`true`，否则为`false`
  - `abstract type ... end`块，此时`isabstracttype(x)`求值为`true`，否则为`false`
  - `struct ... end`块和`mutable struct ... end`块，此时`isstructtype(x)`求值为`true`，否则为`false`

应当注意一个类型（无论是具体类型还是抽象类型）本身也是一个Julia值，从而：

- 如果`x`是通过`Union{...}`创建的那么`typeof(x)`是`Union`；
- 如果`x`是通过`... where {...}`创建的那么`typeof(x)`是`UnionAll`。
- 所有可能是`typeof`输出的东西都具有类型`DataType`。它包括：
  - 全体primitive types（或者说，`DataType`的元素中有`Int64, AbstractFloat`这些东西）
  - 全体structs和mutable structs
  - 全体unions
  - 全体UnionAll
- `Any`是以下东西的类型：
  - 全体primitive types（或者说，`Any`的元素中有1, 2, 3, 'a', 1.3这些东西）
  - `DataType`
  - `Type{DataType}`

按照上面的做法，`Any`本身是一个合法的类型，从而是Julia中的对象，但是它自己无法确定类型。所以我们只能让`Any::Any`。
这样一来，`::`就不再是$\in$了。类似的，`DataType::DataType`也必须是正确的，否则只能让`typeof(DataType)`求值为`Any`，但是一个具体的对象的类型不应该是`Any`。

### 抽象类型的声明

我们可以将将一个具体数据类型`T`**声明**为某个抽象数据类型`T'`的子类型。抽象类型的主要用处是用来做多重派发。

### Union

有时需要根据输入值的不同，产生不同类型的输出值（例如，如果输入值是ATGC四个字母组成的字符串那么输出一个表示DNA序列的结构体，否则输出原本的字符串）。
Union在这里就有用了。

应当注意，Union类型不是nominal的；这点和Rust中的Union就是完全不一样的，后者中如果一个值属于`Option<T>`类型，它就不可能属于`T`类型。
此外，即使两个struct的结构一样，只要它们的名字不一样，就是不同的类型；可是对Union，我们有如下结果：
```
julia> A = Union{Int, Float64}
Union{Float64, Int64}

julia> B = Union{Int, Float64}
Union{Float64, Int64}

julia> A == B
true

julia> 1::A
1

julia> 1::B
1
```
进一步，Union无视构造它时的嵌套结构：
```
julia> Union{Union{Float64, Int}, Float32}
Union{Float32, Float64, Int64}
```
这意味着Union倒是确实可以看成集合： `Union{T1, T2, ...}`可以看成$\cup_{i} T_i$。

应注意Union不被视为具体类型，可是也不被视为抽象类型：
```
julia> isabstracttype(Union{Int, Float64})
false

julia> isconcretetype(Union{Int, Float64})
false
```

Julia支持的其它集合运算包括：`typeintersect`，交集；`typejoin`。
`where`表达式也可以用于构造union类型：
```
julia> Union{Int64, X} where X <: AbstractFloat
Union{Int64, X} where X<:AbstractFloat

julia> 1 :: Union{Int64, X} where X <: AbstractFloat
1

julia> Float16(0.1) :: Union{Int64, X} where X <: AbstractFloat
Float16(0.1)
```
这样我们可以构造空集：
```
julia> Union{}
Union{}
```

在多重派发中，Union的优先级比抽象类型高：
```
julia> f(x::AbstractFloat) = "abstract"
f (generic function with 1 method)

julia> f(x::Union{Float64,Int}) = "64bit"
f (generic function with 2 methods)

julia> f(1.0)
"64bit"
```
当然，在函数签名中不应该滥用Union，否则很容易导致语义模糊的函数调用：
```
julia> f(x::Union{Float64, Float32}) = "float"
f (generic function with 3 methods)

julia> f(1.0)
ERROR: MethodError: f(::Float64) is ambiguous.

Candidates:
  f(x::Union{Float64, Int64})
    @ Main REPL[60]:1
  f(x::Union{Float32, Float64})
    @ Main REPL[63]:1
```

### `where`表达式和`UnionAll`

`where`表达式和数学中的习惯记号是一样的：A where B一方面给出了一个函数关系，一方面给出了全体满足B的变量取值下A构成的集合。
后者之前已经讨论过了，前者就是类型构造器；不过前者的类型在Julia中并不能定出来（见下）。

### 函数无法定typed $\lambda$ calculus中的类型

Julia的编程范式让一件事变得不可能：给函数确定类型，因为这要求我们能够对任意一个指向函数的名称`func`确定类型，但是`func`名下可以有多个方法。
更进一步，我们可以定义这样的方法：
```
julia> function (x::Float64)(y)
       x + y
       end

julia> a = 1.0
1.0

julia> a(2)
3.0
```
所以在Julia中，函数只能定singleton类型：
```
julia> typeof(sin)
typeof(sin) (singleton type of function sin, subtype of Function)
```
这相当于是在获取*名称*`sin`的类型，而它除了一个singleton以外不可能是别的东西。

因此Julia的类型系统并不是typed $\lambda$ calculus描述的。
我们实际上可以手动搞出来arrow type，通过如下方法：
```Julia
struct Arrow{A, B}
    f::Function
end

(func::Arrow{A, B})(x::A) where {A, B} = func.f(x)

```
然后可以针对`Arrow`做派发：
```Julia
function Base.map(f::Arrow{A, B}, vec::Vector{A})::Vector{B}
    # ....
end
```
可以定义一些宏使得创建`Arrow`对象更加容易。

### Julia的类型作为集合

Julia的具体类型首要地应当视为指明如何使用它们包含的对象的标签；于是，一个Float64和两个Float32组成的二元组究竟还是不同的，因为两者和不同的方法关联在一起。

不过，Julia的类型系统确实是有集合语义的。
有关这一点可以看Abstraction in Technical Computing一文的4.2节。具体来说：
- 一个具体类型的集合语义可以看成是以这个具体类型为tag的全体值的标签
- 一个抽象类型的集合语义可以看成是被声明为这个抽象类型的子类型的全体类型对应的集合的交集
- `Any`类型的集合语义就是全体可能的值
- `Union{}`类型的集合语义就是空集
- `Union`的集合语义由并集给出
- `UnionAll`（也即`where`表达式）的集合语义由$\cup$给出
- 如果一个值`A`是类型，那么`Type{A}`以`A`为元素的集合
  - 请注意这里不能说`Type{A}`是只以`A`的集合语义为元素的集合，因为这意味着`A`的集合语义是`Type{A}`的集合语义的子集，从而导致`A <: Type{A}`，但这是错误的。
- `A <: B`求值为`true`，当且仅当`A`的集合语义是`B`的集合语义的子集。
- `x :: T`在`x`属于`T`的集合语义时求值为`x`。
  - 如果`typeof(x)`是`T`并且`T <: T'`，则`x::T'`求值为`x`。
  - 如果`x :: DataType`求值为`true`，则`x :: Type{x}`求值为`x`
  - 其余情况下`x::T`求值时抛出一个`TypeError`

不过，为了判断一个值是不是类型，引入了`DataType`类型，它满足
- `DataType :: DataType`求值为`DataType`
此外，关于`Any`也有如下的额外法则：
- `Any :: Any`求值为`Any`
- `Any :: DataType`求值为`Any`

以上种种似乎说明`DataType`的集合语义自己属于自己，这在ZFC中是不允许的。
由于Julia没有提供概括规则，这样是不会弄出罗素悖论的。
实际上，我们也没有真的导致$A \subset A$，因为`DataType :: DataType`不报错这件事只能说明`DataType`是`DataType`的集合语义的成员，并没有说明`DataType`的集合语义是`DataType`的集合语义的成员：
在前者的情形中，`DataType`的集合语义里面正好有`DataType`这个标签在，但是这个标签也只是一个标签而已，并不是它所代表的那个集合。

在上面的讨论中我们把Julia中的值和它的集合语义混在一起了，从而一个类型标签可以本身作为一个（数学中的）对象出现在它或者别的东西的集合语义中。
也许一个更好的方式是，把上面定义的“集合语义”当成一个（数学中的，也即元语言中的，而不是Julia语言中的）函数，它“解释”一个Julia类型为它所包含的值。

### 关于`Tuple`的种种

前面已经说了Julia的类型系统可以用集合论的术语描写。
下面让我们看Julia中的Tuple。
`Tuple`类型可以看成裸的、没有加标签的struct，几乎就是集合论意义上的元组。
为了保证多重派发的正常运行，Julia也给`Tuple`赋予了`Tuple`类型。

## 动态类型系统和强类型

Julia可以被看成动态语言引入了一些看似静态的机制的产物，具体来说是能够声明变量的类型。
如果我们扭曲自己的脑子，也可以看成将它往静态语言（可以认为Julia中变量默认是`Any`类型）中插入动态性（类型不匹配导致运行时错误，并非语法错误）的产物。

### Julia作为强类型语言

如前所述，Julia的*每个*值实际上都是一个二元组，包括这个值的某种表示，加上类型标签。
于是，我们说，Julia是*强类型*的：它和Python之类的语言很类似。
另一方面，在C语言中，如果一个值被赋给了一个`void *`类型的变量，然后再被强制转换成别的类型，于是我们就可以说它的类型标签已经被抹去了；我们说C语言是*弱类型*的。

强/弱类型这个术语其实没有公认的定义；我们上述所谓的是否可以把值的类型标签扔掉，可以扔掉就是弱类型，不能扔掉就是强类型的。
这个定义是一种常见的定义，不过也有很多人采用一些别的定义。



### Julia的“静态性”：类型标注

Julia有变量类型声明（`a::T`）、类型定义（定义`struct`等），这些东西写起来很像（但并不是）静态类型语言：例如`a::T`实际上有三种意思：
  - 在一个变量被初始化的时候，用来指示当它再次被赋值的时候应当试图做数据类型转换，如下：
  ```julia
  let x::AbstractFloat = 1
  y::Int = 2
  x = y
  println(x)
  end
  ```
  输出结果是浮点数2.0，而不是整数2。

  `struct`中的类型定义与之相似。
  - 出现在表达式中时，`a::T`断言`a`有类型`T`，并返回`a`；如果实际情况不是这样就报错——请注意此处我们看到Julia的动态性了，见[此处](#julia到底还是动态语言)。
  - 出现在函数签名中时，`a::T`用来指导多重派发，因此假如函数签名中有`x::T`，那么`x`的具体类型要么是`T`，要么以`T`为父类型；为了多重派发，我们不能允许赋值时的数据类型转换发生，否则将无法决定调用哪个方法。
  
### Julia到底还是动态语言

在静态类型语言中，如果一个具有某种类型的表达式被赋给了与之不兼容的一个变量，那么这个程序就不是正确的程序：我们可以说，它语法不对（回忆常见的类型论，如归纳构造演算的定义方式：我们是靠推理规则来定义它的）。
可是在Julia中，如果一个具有某种类型的表达式被赋给了与之不兼容的一个变量，会抛出一个错误，这个错误是可以被捕获的：
```
julia> try
       x::Int = 0.1
       catch e
       println(e)
       end
InexactError(:Int64, Int64, 0.1)

julia> try
       x::Int = ""
       catch e
       println(e)
       end
MethodError(convert, (Int64, ""), 0x00000000000082b7)
```

这意味着Julia确确实实是动态语言，虽然并非“理想”的动态语言。

不过，我们还是可以找到Julia的一个子集，其中所有变量的类型都是可以提前确定的，并且确保不会有类型不兼容的错误。
这是Julia容易优化的原因之一，即很容易找到一个Julia的能够理解成静态类型语言的子集，后者很容易优化。

### 关于类型系统的一般的评论

以上讨论实际上说明了一件事：实用的语言的类型系统其实更适合理解成它的operational semantics的一部分，而未必要使用类型论的那种（语法的）方式理解；实际上，前者的数学性质也[常常并不好](#函数无法定typed-calculus中的类型)。
所谓弱的类型系统允许没有类型标注的值，一个强的类型系统不允许。
类型标注的主要目的是函数派发；例如，尽管一个字符串也可以看成一个数，可是如果`a`和`b`被标记为了字符串，那我们就希望`a * b`是字符串拼接，如果`a`和`b`被标记为了数，则`a * b`就是乘法。

这样，与其说动态类型语言是只有一个类型的静态类型语言，不如说每个静态类型语言都可以看成某个动态类型语言的能够通过静态分析推导出变量类型并且确定不会报类型错误的子集。

## “Dependent type”

Julia的“类型”（或者说“tag”）可以被像普通的值一样传递和处理。
这个特征意味着我们可以写下如下的代码：
  ```
  julia> getT(::Array{T}) where {T} = T
  getT (generic function with 1 method)

  julia> getT([1, 2, 3])
  Int64
  ```
可见$x : T$中的类型$T$自己也可以当作$x$来看。

如果我们把Julia当成静态类型语言看待，我们要说，它允许一定的dependent type；例如前述`getT`就是一个从term到type的函数。
不过，dependent type这个概念主要还是适用于静态类型语言，而Julia是动态类型的——见[此处](#julia到底还是动态语言)。
此外，应注意这并不是所有的动态语言都有的特征；例如JavaScript中我们可以从一个Number object得到其类型Number，可是我们只有`typeof(1) == "number"`，但是作为primitive type的number本身却不是JavaScript中的term。

## 类型函数：从类型到类型

Julia的类型函数——从类型到类型的操作——受到一定限制。我们有
```
julia> function return_type(x::String)
           T = if x == "String"
               String
           elseif x == "Int"
               Int64
           end

           struct A 
               x::T
           end
           
           A
       end
ERROR: syntax: "struct" expression not at top level
Stacktrace:
 [1] top-level scope
   @ REPL[45]:1
```

一个完全的动态语言应该允许这样的操作：定义一个函数，读入一个未知的数据，然后动态地产生一个`struct`。
可是可以看到，这在Julia中是不被允许的。
也许这也就是需要在`(args)`之外再引入`{args}`的原因之一：一个依赖于类型参数的struct不能看成一个从类型到类型的函数。
大部分的模板函数的类型参数都可以作为普通的`(args)`参数传入（即[多态](#函数的类型参数)），而模板结构体则必须要用`{args}`。

## 多态

### 函数的类型参数

Julia允许如下写法：
```
julia> convert(Int, 1.0)
1
```
由于Julia有[某种意义上的dependent type](#dependent-type)，类型参数`Int`无需用专门为类型参数保留的括号`<>`之类的东西引入（反之，Java和C++却需要`<>`符号）。


### 多重派发：both ad hoc polymorphism and subtype polymorphism

Julia还有一种更加复杂的多态：多重派发。
为了简化代码编写，我们需要允许不同的函数共享一个名称。其结果是，当一个函数调用出现时，需要有某个机制来决定运行哪一份代码。Julia中通常将共用一个名字的不同函数称为不同的“方法”。也即，需要有一个机制将一个函数调用派发到特定的方法上。

理论上，可以采取如下方式来做派发：如JavaScript只有一个“+”，它内部也许会根据输入的操作数的类型不同选择不同的处理流程，也许会有数据类型转化。
Julia当然支持这种做法。不过，实际上，Julia通过多重派发满足这个需求。常见的面向对象语言使用单重派发，也即，当看到一个类型为`T`的对象`obj`上出现了一个函数调用`obj.method(x)`时，根据`obj`的实际类型（可能是`T`的某个子类型）来决定调用哪一个方法。
多重派发则没有“对象上的方法”这个概念：或者说它相当于`(x1, x2, ...).method()`。
回到前述`+`的例子：在Julia中，有好多个完全指定了操作数的类型的“+”，在“a+b”形式的表达式被求值时，调用哪一个加法由多重派发机制自动决定。

子类型在纯粹的类型论研究中是比较讨厌的一个东西，因为它不能像其它常见feature一样，通过一个引入规则和一个消去规则非常干脆利落、和其它feature确定正交地被引入。
但在一些情况下子类型是非常有用的。Julia的多重派发就算是一个例子。多重派发机制显然要求能够有一个比较符合直觉的方式决定一个函数调用发生时哪一份代码被执行，而子类型产生的类型树显然是一个非常方便的选择。

实际上，Julia的子类型机制也就仅仅满足这个目标而已：具体类型不能够以具体类型为父类型，即所有的具体类型都是final的。
这样一方面可以为多重派发提供方便，一方面可以尽可能避免各种subtle的细节，比如说关于继承的种种复杂之处。

容易看出，Julia的多重派发机制融合了三种常见的多态机制：ad hoc polymorphism （如加法的重载），subtype polymorphism （依照定义如此），以及parametric polymorphism （即类型参数，或者说模板）。

应当注意，一个变量是不是被声明为属于某个抽象类型和union*不影响*多重派发；
只有这个变量的值的具体类型，以及函数签名中的类型（具体，抽象，union）影响多重派发。

### 多重派发是运行时的

Julia的多重派发机制似乎很像一个有强大的类型推导的模板机制：很多时候无需手动指定类型参数，多重派发会自动找到应该调用的方法。
这两者本质的差别在于Julia的“模板机制”本质上还是一个运行时的现象。
如果一个函数调用中的所有参数的类型是能够静态确定的，那么哪个方法会被调用也是能够静态确定的；反之，这个函数被调用时的行为就不是完全确定的。
例如，设想我们有一个函数，它读入两个字符串，如果能够将这些字符串转成数，就把它们相乘，否则做字符串拼接。
那么这个函数内部的`a * b`具体是哪个方法，就是不能提前知道的。

这一点在面向对象语言中很常见。例如Java中如果类`A`的一个方法`f`在子类`B`中被重载了，那么如果一个`B`对象被赋值给了`A`类型的变量，那么其上调用的`f`方法仍然来自`B`对象，尽管静态地说，这个变量的类型是`A`。
类似的行为在Julia中也能看到：
```
julia> f(_::AbstractFloat) = "Abstract"
f (generic function with 1 method)

julia> f(_::Float64) = "64"
f (generic function with 2 methods)

julia> let x::AbstractFloat = 1.0
       f(x)
       end
"64"
```

这个特征让开发变得灵活了。
例如，`sum`函数可能是一个模板函数，读入一个可以相加的类型，输出一个具体的求和函数（或者说，所有参数的类型都是具体类型的方法）。
类型推导意味着我们可以写`sum(arr)`而不显式给出类型参数的值，但是为了正确推导类型，`arr`的类型必须要知道；当然，也许`arr`的类型也没有显式声明，但是生成`arr`的子程序的返回类型必须要知道……这样一路向前追溯，最终必须能够追溯到一些类型常量，只有这样才能够在编译期将所有的类型确定下来。
反之，在Julia中，完全可以写出诸如这样的代码：从一个文件读入一个序列，根据这个序列中的数有没有小数点决定是把它转化为一个`Array{Int64}`还是一个`Array{Float64}`，然后传给`sum`求和。
换句话说，`sum`直到运行期都保持模板函数的特性，只有当一个`Array{Int64}`或是一个`Array{Float64}`被传入时才决定执行哪个版本。

注意，此处的“静态”一词和静态类型/动态类型的区分是相对独立的；静态类型语言仍然可以有上述的“动态”的派发机制，例如Java就是这样。

## 对类型的多重派发实际上是模式匹配

`Int <: Type{Int}`这件事意味着实际上函数可以对类型变量做模式匹配。
这样没有必要写
```Julia
function func(T::DataType, x)
    if T == Int
        # ...
    elseif T == Float64
        # ...
    end
end
```
而是可以写
```Julia
function func(::Type{Int}, x)
    # ...
end

function func(::Type{Float64}, x)
    # ...
end
```
从而极大地增强了可扩展性。

这也是Holy trait的工作原理。

# 赋值和可变性

可变`struct`一般是很少用到的，但这不会让代码变得奇怪，因为有内部状态的“容器”（如`Dict`, `Array`）足以承担大部分可变性。
修改它们不需要赋值。

# 宏

Julia具有非常像Lisp的宏。主要的不同之处在于Julia宏操作的AST的格式并非S expression那种`(+ 1 2)`型的，而是由`Symbol`, `Expr`等类型的对象组成的；分号用`LineNumberNode`表示。