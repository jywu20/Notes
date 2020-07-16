参考文献：

- Pavel Caha.Nanosyntax: some key features.

总之目前和Antisymmetry结合的NS非常魔怔就对了。

# Nanosyntax理论

## Nanosyntax的结构

1. 抽象概念，包括但不限于抽象的词根、functional heads等；
2. 句法，将抽象特征组合起来，其操作就是我们熟悉的Merge，Agree，Move等等；
3. 词库，每个条目有三个部分组成：一个句法树，一个语音，一个语义；
4. 语音实现，即将句法树的一部分使用一个词库条目替代；
5. 音系学，不必过多解释。

Nanosyntax，如同其它最简方案下的理论一样，是cyclic的。换而言之，句子的生成是一系列操作循环地进行的结果。

## 语音实现

语音实现即spellout。在Nanosyntax中，被spellout的可以是一个句法树子树而不是terminal nodes。

Nanosyntax中的spellout操作是cyclic的，它和Merge交替进行。
现在设有一个树要被spellout，那么会这样在词库中寻找对应的条目：

1. **Overspecification**，或者说**The Superset Principle**：首先，当且仅当将要被语音实现的句法树是一个词库条目的子树（含有的特征一致、树的结构相同，等等）时，此句法条目才能够成为candidate之一；
2. **The Elsewhere Condition**：在上一步获得的多个candidate中，和要被语音实现的句法树最为贴近的词库条目获胜，也即，含有最少的要被语音实现的句法树中没有的特征的词库条目获胜；
3. **The Principle of Cyclic Override**：上面讲到“子树”，但是哪些子树应该被spellout？一般认为是自下而上地spellout，先spellout子树再spellout父树，如果子树能被整体spellout，父树也能被整体spellout，那么父树的spellout结果覆盖子树的。这就导致了**The Biggest Wins Theorem**：能被直接spellout的最大的结构会被spellout。例如，这解释了为什么会有形态变体，如go的过去式是went：因为go-ed是动词、tense后缀被分别spellout的，而went是整体被spellout的，因此实际上应该使用went而不是go-ed。

总之，以上规则意味着：

1. 在所有能够被spellout的子树当中，选择最大的子树；
2. 在所有能够spellout该子树的条目中，选择能够完全包含该子树的条目；
3. 在上一步选取的条目中，选择那些含有特征最少的条目。

这些又可以导出下面的结论：

- **Exhaustive Lexicalization Principle**: 一个句法树中的所有特征全部会显式地反映在其语音实现中；
- 

Nanosyntax框架本身并不特别关注phase，但是phase是很容易可以加入的，我们只需要认为有一些短语非常特殊，它们一旦被spellout就完全固定了（并且在这个时候被转移到PF/LF）即可。

## Nanosyntax的spellout

# 与最简方案有关的话题

## Agree

大概也要依靠feature copying来实现Agree；前提是，Nanosyntax允许出现unvalued features。

## Affix lowering和Head movement

我们只需要认为所谓Affix lowering或Head movement的landing site实际上是一个树即可，它和据说是被移动的成分发生了Agree

## 所谓Adjunct

# 与Distributed Morphology的关系

不知道是不是我的错觉，我觉得Nanosyntax相比Distributed Morphology来说更加“最简方案一些”……

Nanosyntax和DM的相同点主要有：

- Late insertion
- Syntax all way down

不同点主要有：

- Nanosyntax只有一个词库，但是DM实际上有三个；
- Nanosyntax的句法实际上是先于词库的：一开始，句法操纵的只是完全抽象的概念（这相当于DM中的List A），然后从词库中抽取条目来实现这些概念；DM的句法的输入就是词库，因此句法后于词库；
- Nanosyntax中已经被语音实现好了的语音-句法树-语义组合可以放进词库里，而DM中不那么简单
- Nanosyntax中没有真正的形态操作：所有的形态学都是spellout过程中自然而然产生的；DM中还是有专门的形态操作的
- Nanosyntax中完全没有feature bundle；DM中，形态操作，以及一些特殊的词库条目，可以引入feature bundle

可以看到NS相对DM其实更加“简化”了。
首先，NS肃清了词汇主义（即认为参与句法推导的词全部都是正确地被屈折变形好了的）的残余：

- 虽然DM是syntax all the way down的，但是还是引入了额外的形态学操作，而NS则完全消除了这个额外因素；
- Feature bundle的存在实际上等于是在Merge以外引入了一个新的generative的操作，实际上是“词库操作”的遗存，而NS直接把它消除了。

# 疑难话题

## 混成词

**混成词**（portmanteau）指的是在语义上是多个意思组合起来的产物，但是形态上却是单一的的语法单位。
例如，拉丁语名词后缀同时携带了格和数的特征，因此属于混成词。

如果组成一个混成词的terminal nodes构成一个constituent，那么并没有任何疑难：只需要认为词库中有某个条目的句法部分是这么一个constituent就可以了。
但如果我们有下面的句法树：

[X [Y [Z ] ] ]

而最后形成了这样的结构：

[XY] Z,

其中[XY]指一个混成词，那么就麻烦了——显然[X [Y [Z ] ] ]无论如何不会和一个只含有X和Y的句法条目匹配。
拉丁语名词后缀就是这样的东西。

## 词界

为什么竟然会有“词”的概念？

## Agree运算和特征驱动的移位

## 参数和语言演化

所谓“参数”（Principle and Parameter那个“参数”）实际上就是词库中保存的条目的特征。

## 俚语、俗语

俚语、俗语作为一整个树被保存在词库中，由The Biggest Wins Theorem，它们“覆盖”了它们的字面意思。
