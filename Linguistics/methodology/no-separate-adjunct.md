# 修饰成分

修饰成分，如名词性短语中的形容词，动词性短语中的副词、介词短语，常常被分析为adjunct，即“附加语”。
在最简方案中引入附加语可能会带来一些理论疑难，包括需要一种特殊的Merge运算专门用于处理附加语、需要引入特殊的句法机制来解释附加语之间的相互作用（如形容词通常按照其修饰的属性有一定的顺序，我们会说the big ugly bear而通常不说the ugly big bear）、在涉及Agree运算的搜索时需要人为指定附加语是不是纳入被搜索的范围内等等。
另一方面，一些原本会被认为是adjunct的结构（如话题）实际上属于完全普通的句法结构（如边缘层级）的一部分。
这让我们怀疑，也许所有的附加语实际上都是完全普通的句法结构的一部分，无需引入adjunct这个概念，也无需特殊的Merge运算。

首先我们来看动词短语中的修饰成分。考虑下面的句子：

The sheep is missed [<sub>PP</sub> in the barn].

PP是修饰成分。请注意介词实际上是一种谓词，它必定要有主语。如果我们认为PP是missed的adjunct，那么它们就形成了一个复合的predicate，这个predicate的主语是the sheep。
但这是不正确的，因为羊在谷仓中不见了不代表它一定就躲在谷仓中，也即未必有The sheep is in the barn.
如果我们认为PP是the sheep missed的adjunct，那么PP就没有主语。
为了让PP有主语，我们认为PP修饰的是“羊不见了”这件事，这样is missed的主语是the sheep，而in the barn的主语是the sheep。
因此我们有（下面只画出VP的结构，不考虑the sheep被提升到TP的主语位置，也不考虑T上的is一词）

[<sub>PP</sub> [<sub>VP</sub> [The sheep ] [<sub>V</sub> missed ] ] in the barn ]

然而，以上结构和通常我们对adjunct的期望不符。我们认为adjunct应该让被修饰的句子成分经过修饰之后性质不变，即VP还是VP，但在这里VP变成了PP，显然不正确——TP应当选择一个VP作为其complement，而不是PP。
因此我们认为PP实际上是VP的关系从句（或者考虑到PP不是CP，应该说是关系小句），这样同时满足VP是PP的主语，以及修饰之后所得结果还是VP这两个必要的特征，或者说adjunct的产生方式实际上是relativization。

现在的问题是，关系从句的结构是什么样的？对名词，应该是这样：D可以选择一个关系从句CP，被修饰的成分从CP内部移动到CP的边缘，DP指称的对象就是CP边缘的那个名词性短语。
例如：

[<sub>DP</sub> the [<sub>CP</sub> cat [<sub>C</sub> that] [<sub>TP</sub> is sleeping ] ] ]

如果考虑完整的边缘层级，cat应该位于Spec-ForceP的位置上。对于which从句应有

[<sub>DP</sub> the [<sub>CP</sub> cat [<sub>TP</sub> [<sub>DP</sub> which <del>cat</del>] is sleeping ] ] ]

即which cat首先从轻动词的主语的位置移动到TP的主语的位置，然后cat进一步往上移动到Spec-ForceP。
这样的分析和what或者who开头的宾语从句中的先行词what或者who应该位于Spec-ForceP的推论是一致的（见Analysing English Sentences一书）。
对动词，与D对应的应该是v吧？

考虑到extraposition，可能需要这样的结构：

[<sub>XP</sub> [<sub>DP</sub> ... ] [<sub>X'</sub> X [<sub>CP</sub> ... ] ] ]

这样被修饰的DP可以被提取出来。

## 名词性短语中的修饰成分

所谓的“adjunct”：

[<sub>NP</sub> [adjunct ]  [<sub>NP</sub> ... ] ]

实际上应该分析为

[<sub>XP</sub> [adjunct ] [<sub>X'</sub> X [<sub>NP</sub> ... ] ] ]

其中的X是用于引导adjunct的一个功能语类，例如所谓的时间后缀或者地点后缀。

下面要做的是分析X有哪些种类。比如说有时间性后缀、空间性后缀，等等。

# Cinque对副词的分析

在Adverbs and functional heads: a cross-linguistic perspective一书中，Cinque提出了一系列独创性的观点：

1. 所有的副词在动词短语中遵从一个固定的次序，这个次序对任何语言都是一样的；
2. 一个clause中携带不同功能的functional head的排列顺序也是一样的；
3. 以上两个顺序完全吻合。

作者如此声称：副词是

> the unique specifiers of distinct maximal projections, rather than as adjuncts

并且认为它们是

> the overt manifestation of different functional projections

这么做的主要原因是，副词不影响head movement，而head movement不能跨投射进行，因此副词只能是某一级投射的specifier。

Cinque最后认为，所有副词都必须遵守这样的顺序：

> Mood speech act > Mood evaluative > Mood evidential > Mod epistemic >T (Past) > T (Future) >
Mood (ir)realis > Mod root / Aspect habitual /T (Anterior) > Aspect perfect > Aspect progressive / Aspect
completive > Voice > V