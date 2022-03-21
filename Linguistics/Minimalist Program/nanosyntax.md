参考文献：

- Pavel Caha.Nanosyntax: some key features.

总之目前和Antisymmetry结合的NS非常魔怔就对了。

# 术语和缩写

- fseq: functional head sequence
- SMS: 句法，形态和语义
- Syncretism: 不同的结构被同一个语音形式实现了（举例：法语的à可以翻译成to也可以翻译成at）
- paradigm: 一个词根屈折产生的所有词
- *ABA: 指的是不同语言中syncretism出现的一种共同模式：我们总是可以适当地排列与一个词根放在一起的其它特征，使得只有相邻的特征才会出现syncretism；换句话说，设有特征序列F1, F2, F3，则有可能出现F1-A, F2-B, F3-C的语音实现关系，或是F1-A, F2-A, F3-B，但从来不会出现F1-A, F2-B, F3-A。

# Nanosyntax理论

## Nanosyntax的结构

1. 抽象概念，包括但不限于抽象的词根、functional heads等；one head one feature（似乎不包括selectional features）；
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

## 参数

为什么会有parameter？我们认同The Borer–Chomsky Conjecture: 语言中所有的变化都可以归结到词库的不同。
换句话说，不同的语言就是以不同的词汇（语音形式，等等）实现同样的句法树。
这样，parameter就可以归结到词库的不同。

## Selection

是什么指导了Merge？一个简单的想法是，terminal nodes含有选择特征之类的东西，这些（语义无解的）特征驱动了Merge，可能也驱动了Move。
然而，语义无解特征的存在必定要求feature bundle。

可以认为错误的Merge产生的结构不能被正确地spell out，即把选择特征等东西全部放到词库中。具体来说，我们认为：

1. 抽象特征本身含有selectional features,这些未必是句法上的feature而可以来自一般的认知机制，因此不受one feature one head的影响，例如，“A打了B”可以写成
    [ [ [case:nom] ... ] [ 动作“打” [ case:acc ] ] ]
2. 

## Agree

大概也要依靠feature copying来实现Agree；前提是，Nanosyntax允许出现unvalued features。

## Affix lowering和Head movement

我们只需要认为所谓Affix lowering或Head movement的landing site实际上是一个树即可，它和据说是被移动的成分发生了Agree

## 所谓Adjunct

Nanosyntax是不是承认adjunct实际上反而和这个理论本身关系不大，而和与它一起使用的句子结构理论关系比较大。
如果我们将Nanosyntax和比较现代版本的Cartography一起使用，那么就不会存在adjunct，因为所有可选的论元都是被某个functional head携带出来的。

## Feature bundle和Word formation

凡是含有feature bundle的head都必须被分解成一系列分裂的heads。例如，英语中的T同时含有EPP和时间，那么就应该分析成

[<sub>EppP</sub> ... [EPP] [<sub>TP</sub> ... T ... ] ]

然后EPP驱动的movement让主语移动到EppP的specifier上。这是经典的head splitting分析；如果不需要这么细粒度的分析，考虑到remnant movement会让需要被合并为一个词的成分自然地聚集起来，也可以沿用过去的feature bundle分析。

那么，一个含有feature bundle的head的complements和specifier应该怎么分析（例如，一个动词将不同的theta role分发给specifier和complement）？实际上只要把这些complement和specifier分配给分裂出来的heads就可以了。
这里的过程非常类似于将管约论中的大NP分解成DP-NumP-ClP-NP的过程。

需要注意的是，由于我们总是可以像把人称和数组合起来一样，把多个的特征组合成单个特征，feature bundle不存在这个论断也是可以被部分绕开的。
但是，像人称和数的融合那样非常自然的融合是非常少见的，大多数情况下不同的语法范畴还是会以不同的方式呈现出来，这就是为什么“feature bundle”不存在这个说法还是有意义的。

无论如何，在实际分析时采用含有feature bundle的理论还是有必要的，否则真的过于冗长。例如，“某个名词只有和某个gender head放在一起时才在词库中有对应的lexical entry”等价于“这个名词自带一个gender feature”

# 与Distributed Morphology的关系

不知道是不是我的错觉，我觉得Nanosyntax相比Distributed Morphology来说更加“最简方案一些”……

Nanosyntax和DM的相同点主要有：

- Late insertion
- Syntax all way down

不同点主要有：

- Nanosyntax只有一个词库，但是DM实际上有三个；
- Nanosyntax的句法实际上是先于词库的：一开始，句法操纵的只是完全抽象的概念（这相当于DM中的List A），然后从词库中抽取条目来实现这些概念；DM的句法的输入就是词库，因此句法后于词库；
- Nanosyntax中已经被语音实现好了的语音-句法树-语义组合可以放进词库里，而DM中不那么简单
- Nanosyntax中没有真正的形态操作：所有的形态学都是spellout过程中自然而然产生的；DM中还是有专门的形态操作的（但应当指出的是，Nanosyntax使用诸如spellout-driven movement之类的东西来统一解释head movement和affix lowering现象，因此spellout的这一瞬间理论上也可以认为是形态操作）
- Nanosyntax中完全没有feature bundle；DM中，形态操作，以及一些特殊的词库条目，可以引入feature bundle

可以看到NS相对DM其实更加“简化”了。
首先，NS肃清了词汇主义（即认为参与句法推导的词全部都是正确地被屈折变形好了的）的残余：

- 虽然DM是syntax all the way down的，但是还是引入了额外的形态学操作，而NS则完全消除了这个额外因素；
- Feature bundle的存在实际上等于是在Merge以外引入了一个新的generative的操作，实际上是“词库操作”的遗存，而NS直接把它消除了。

# 疑难话题

除了Three challenges for nanosyntax以外，还有：

1. 关于NS的很多工作实际上都是形态学版本的Antisymmetry，然而，Antisymmetry本身假设了大量没有明显理由、可能违反公认的移位约束的移位，在理论上显得不够简洁，且已有研究表明Antisymmetry依赖的LCA可能在经验上是不合适的；是否有更加“传统”的NS研究进路？
2. 其次，为了解释诸如拉丁语中，名词“边缘”的、没有构成一个句法成分的格和数特征竟然被同一个词缀语音实现了，NS中存在两条进路：首先是假定存在spellout -driven的移位，将格和数的特征放到了同一个句法成分中，但这可能会碰到自然性的问题；其次是假定存在span spellout，即一系列一个c command另一个的head可以被语音实现为同一个词或者词缀，但这样又会产生下面所说的问题：
3. 如上，如果我们假定存在span spellout，似乎无法解释为什么拉丁语等语言的动词结构中即使有否定词，也不会阻止T v V这三个head被一并实现为“动词”，而显然否定词隔在T和v之间。换而言之，传统的最简方案中的affix lowering和head movement应当怎么实现？
4. NS中，Agree操作如何进行有待解释，既然NS禁止feature bundle。
5. 传统的特征驱动的移位在NS中似乎无法完成，因为不存在合适的c command关系，且也没有那个functional head能够携带EPP之类的特征。
6. 最后，NS似乎无法解释为什么竟然会有“词”这个概念，因为语音实现中没有任何自然的词界。

以上问题实际上可以归结为：NS到底有多“侵入性”？或者说，如果接受它，那么普通的最简方案分析能够保留多少？

## 为什么会出现堆叠的functional heads？

本质上，这是在以一种另类的方式实现“可赋值、可修改”的特征：向句法树中增加一个携带某种特征的functional head就是覆盖了这个特征之前的值。

## constituent lexicalization会遇到的问题

认为被spallout的只能够是一个constituent立刻会遇到所谓的containment problem。
例如，动词*ate*对应的树多半是[<sub>TP</sub> PAST [<sub>vP</sub> DO [<sub>VP</sub> EAT ] ] ]，但是实际上句法树是

[<sub>TP</sub> PAST [<sub>vP</sub> I DO [<sub>VP</sub> EAT [<sub>DP</sub> an apple ] ] ] ]

如果我们在TP外Merge一个EPP特征，那么I就被提前到了句子前面做主语了，到这里还没有问题。
但是接下来就有问题了：
宾语an apple一定是在TP当中的，从而*ate*不能够和这里的句法树匹配。
这就是**containment problem**：复合词内部含有的complement会让spellout不可能。

对这些问题的一个替代方案是spanning。
一串一个c-command另一个的functional head，比如说上面的X, Y就构成了一个span，认为词库中保存的实际上是span-语音形式对应的spellout方案就是spanning。
例如，如果我们认为PAST-DO-EAT这一个span应该被语音实现为ate，那么就解决了containment problem。

然而，spanning会引入新的问题。例如，似乎无法解释为什么拉丁语等语言的动词结构中即使有否定词，也不会阻止T v V这三个head被一并实现为“动词”，而显然否定词隔在T和v之间。
它也无法解释为什么一个span拼写而成的混成词通常是相邻两个词缩合为一个混成词（例如，法语有au ⇔ < À, LE >，du ⇔ < DE, LE >，而罗马尼亚语的冠词在名词之后，然后就没有介词加冠词的缩合），既然只要c-command关系正确就能够形成一个span。

实际上，在constituent lexicalization中可以用remnant movement解决containment problem。
我们假定会出现下面的movement：

1. 由于spellout movement，或者等价地，我们认为TP和一个能够吸引宾语的functional head Object发生Merge：   
   [<sub>DP</sub> an apple ]<sub>1</sub> [<sub>TP</sub> PAST [<sub>vP</sub> I DO [<sub>VP</sub> EAT <del>[<sub>DP</sub> an apple ]</del><sub>1</sub> ] ] ]
2. TP被一个更高的functional head（比如说，Mainverb）吸引，提前:
    [<sub>TP</sub> PAST [<sub>vP</sub> I DO [<sub>VP</sub> EAT ] ] ]<sub>2</sub> [<sub>DP</sub> an apple ]<sub>1</sub> <del>[<sub>TP</sub> PAST [<sub>vP</sub> I DO [<sub>VP</sub> EAT <del>[<sub>DP</sub> an apple ]</del><sub>1</sub> ] ] ]</del><sub>2</sub>
3. 主语被提前，可能是被EPP特征吸引上来的，或者也许是spellout movement（我们看到两者其实是等价的）： 
    I<sub>3</sub> [<sub>TP</sub> PAST [<sub>vP</sub> <del>I</del><sub>3</sub> DO [<sub>VP</sub> EAT ] ] ]<sub>2</sub> [<sub>DP</sub> an apple ]<sub>1</sub> <del>[<sub>TP</sub> PAST [<sub>vP</sub> I DO [<sub>VP</sub> EAT <del>[<sub>DP</sub> an apple ]</del><sub>1</sub> ] ] ]</del><sub>2</sub>

然后*ate*就可以和移动后的TP匹配了。这里可能还有一个问题，就是移动后的TP中还有一些trace，但这个主要是记号的问题：如果我们认为部分Move操作没有留下invisible copy，或者词库中和*ate*对应的树中允许有invisible copy（我是说，词库中的树可以是抽象的模式，未必是具体的树），那么就不会有问题。

注：以上分析只是演示性的，例如我们可以认为EPP层就在TP外面，这样宾语移出EppP后，整个EppP其实就已经可以语音实现了：TP被整体实现为主动词，EppP的specifier——也就是主语——也被语音实现了。
无论如何，上面的推导过程都和spellout有着非常紧密的关系，也就是说它最终生成的内容一定是可以被直接spellout的。

remnant movement的问题似乎在于，它的生成能力实在太强：我们只需要将EppP, MainverbP, ObjectP这一类的functional head任意排列（或者等价地说，任意地指定spellout-driven movement的次序），实际上可以产生任何我们想要的语序。
这样一来，生成语法实际上又回退到了“没完没了地精细描写语法现象”的老路，而解释不了什么，因为它可以容纳所有还算正常的自然语言现象，从而做不出任何有效的预言。
这又引出了另一个问题：为什么我们要有spellout-driven movement，或者要有EppP, MainverbP, ObjectP之类的结构？
移位的自然性问题非常大，因为缺乏显著的trigger。
缺乏trigger也意味着没法解释为什么有这样的remnant movement而不是那样的remnant movement。

另一个问题是，remnant中本身是有trace的，那么实际上remnant和它的lexical entry可能还是对不上。

一种比较好的方法是，在spellout中忽略trace和已经被spellout的成分，这样可以不使用无谓的、语义无解的remnant movement。
实际上如果我们忽略Antisymmetry，那么大部分所谓spellout-driven movement都是不必要的。
实际上，考虑到

## 混成词

KNUT TARALD TARALDSEN. Spanning versus Constituent Lexicalization.

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

为什么竟然会有“词”的概念？一种比较好的方法可能是在语音形式中强行引入“词界”，即#；还有一种方法是将区别什么是词的任务交给PF，即让音系学在合适的位置加入词界。
实际上，这等于复活了一部分纯morphology操作，因为实际上这就是fusion。

## 中缀、重复等神奇现象

中缀、希伯来型辅音词根中间有插槽的morphology可能也需要交给PF。这样一来，很大程度上Nanosyntax还是需要一定的形态学，那么维持如此radical的“绝对没有head movement”之类的要求其实也没什么必要。
类似的，“买包包”这种恐怕也需要音系学的参与（例如，可能会加上一个“可爱”特征，然后再音系学中[ [可爱] [包] ]被替换为“包包”）。

## spellout是非常局域的

也即，一个成分被spell out时不会参考同一个phase中的其它内容——那么怎么解释反身代词？？

## Agree运算

实际上，认为存在unvalued features和Nanosyntax本身没有任何矛盾，只要我们认为Agree实际上就是一个phase中的feature assignment。
这里还要提一句：如果我们认为unvalued features也可以被spellout（default现象），那么为什么不允许一个feature被多次value？

这里的麻烦之处在于，很多传统上认为是Agree造成的现象会被Nanosyntax传统中的作者当成通过head stacking之类的方式实现的。
例如，很多人认为格是通过以下机制产生的：名词性成分形如

[ K5 [ K4 [ K3 [ K2 [ K1 DP ] ] ] ] ]

由于词库中，主动词只有和特定的，主动词的论元会向外移位， TODO
然后K1被spell out成主格，K1 K2被spell out成宾格，等等。这种机制称为case stacking。
这很好地解释了动词的论元结构，且*ABA现象为这种说法提供了强有力的支持。
问题在于，这种方案没法难以自然地分析形容词-名词concord。如果concord只涉及单个feature，比如说gender（或者更进一步，classifier）之类，那么可以和经典的lexicalist MP一样解释为什么有concord。
但是如果一个“特征”实际上是一系列feature被spellout为同一个词/词缀而产生的，并且具体哪些features被spellout是由特定的movement决定的（正如case stacking展示的那样），那么concord就没法实现。
归根到底，在Nanosyntax中实际上有两种特征求值的方法，其一是case stacking然后movement，其二是标准的Agree；前者无法解释concord。

一种可能的解决方案是，要求论元形如

[ K [ K4 [ K3 [ K2 [ K1 DP ] ] ] ] ]

而形容词也有类似的序列。

functional head K的存在要求名词外有K4, K3, K2, K1这个序列（通过selector），又license

实际上，也许*ABA现象并不来自共时，而是来自一些特殊的历时过程。

## 特征驱动的移位

## 上下文有关的spell out

典型的例子包括同种语言中有不同的变格法，从而需要根据词干形式确定格后缀。通常这通过额外添加一个含有变格法的编号的functional head来解决，也许是一个Merge在N上的另一种functional head。然后KP和这个DeclensionP一起被实现为格后缀。

## 为何会出现主语不提前、某些投射没有显式形式等情况？

因为主语不提前、某些投射没有显式形式的句子结构被编码在了词库中，由于cyclic spellout，一旦这些结构形成就立刻被spellout了，于是主语提前、有那些投射的显式形式的句子结构就不会出现。
这实际上形式化了“language specific rules比较费力，能少就少”的想法：language specific rules全部是词库里面拿出来的，那么自然比较简单的结构被spellout了之后就不会出现比较复杂的结构。

## 参数和语言演化

所谓“参数”（Principle and Parameter那个“参数”）实际上就是词库中保存的条目的特征。

## 俚语、俗语

俚语、俗语作为一整个树被保存在词库中，由The Biggest Wins Theorem，它们“覆盖”了它们的字面意思。

## 论元结构

简单说就是引入DP的functional heads、动词本身组成的remnant必须出现在词库中，否则不合法。

# 总结

## Nanosyntax中没有争议的部分

Nanosyntax中没有争议、和主流最简方案完全兼容的部分基本上就是精细板、late insertion的句法制图。
语法的结构是抽象的、直接来自思维的feature被Merge，Move，Agree，形成句法树，在此过程中不断发生cyclic spellout；
spellout的过程满足superset principle（lexical entry对应的句法树是被spellout的句法树的超集；忽略trace和已被spellout的成分），elsewhere condition（lexical entry对应的句法树和被spellout的句法树要尽可能接近）。

spellout结束后我们会得到一个有方向的语素序列，这个序列被移送到PF中，发生词界划分、韵律等操作。
这一点，再加上Nanosyntax中可能有spellout-driven movement，意味着实际上Nanosyntax并不真的完全没有morphology，只不过morphology完全是syntax的附带现象罢了。
该语素序列还是有hierarchy结构，但是这个结构和spellout前的句法树未必一致，如T, v, V虽然是一个span，但是可能被spellout为同一个语素（如did），这就解决了句法制图和语感不一致时产生的“加括号悖论”：形态学上，T, v, V构成一个成分，但句法学上它们不构成一个成分。两种说法当然都是对的，它们在spellout之前不构成一个成分，但是spellout后可能就构成一个成分了，又或者，spellout后经过音系学加工就构成一个成分了。
Distributed Morphology中这使用post-syntactic operations解释，但是其实大可不必。

## 有争议的部分