符号约定：

- DM = Distributed Morphology
- LMP = Lexicalist Minimalist Program
- VI = Vocabulary Item
- √ROOT表示一个没有范畴的实义词根；
- 斜体字母*root*表示语音实现；
- functional head用普通字体表示。

主要参考文献：

- Syntax within the Word: Economy, allomorphy, and argument selection in Distributed Morphology

# 动机

使用DM的动机：

- 在音系学中，efficiency和faithfulness这一对相互冲突的要求的相互作用是非常重要的，在历史语言学中也是如此，因此句法学需要某种类似于音系学的方案用于比较清晰地呈现这两者的冲突；
- 有必要解释为什么同样的features在不同的语言中以不同的方式展现出来，以及它们具体是怎么展现出来的；
- 有必要系统地梳理PF中到底发生了什么；
- lexicalist的模型需要额外的一个词法部分，但是这个部分和音系操作、句法操作等均不能够很好地分开；

# DM不同于LMP的地方

- Late Insertion: 句法操作的实际上是抽象的语法特征，比如说复数标记、过去时标记、特定概念等；语音形式是后面才被插入的；
- Morphosyntactic decomposition: 复合词的组装和短语的组装遵循同样的机制（如果有关的机制崩塌了，那就只剩单独的词），也就是所谓的syntactic hierarchal structure all the way down；至于为什么会有词和短语的区别那完全是因为VI的不同；
- Underspecification: 当一个VI插入某个node时，它不需要携带这个node具有的所有特征，如在西班牙语中，冠词el和los的作用类似，都具有阳性、定指性，但是前者没有数而后者有复数，因此原则上两者都可以出现在一个阳性、定值、复数的DP的D位置，虽然el不具有复数特征，因此不能被核查这个特征；实际上复数DP多用los的原因是Subset Principle：一个VI上的specified features越多，越好。

有以下理由能够论证LMP似乎是对的：

- 词的派生不总是能产的，而句法总是能产的，因此词的派生和句法不应该属于同一个元件；
- 派生前后的词没有稳定的词义联系，因此派生之后的词应该是被单独地存储在词库中；
- 派生后的词的category features发生了很大变化，但还是具有派生前的词的选择特征，这显然不是典型的短语的行为。

然而，有证据表明词的派生肯定和句法有关系。例如grow有两个义项，一个是自动词一个是使动词。
tomatoes' growth是合法的，而John's growth of tomatoes是不合法的。如果grow->growth的变换发生在词库中，那很难解释为什么正好一个义项可以发生名词化而另一个不行。
然而，如果我们认为grow->growth以及自动词grow->使动词grow的变换发生在句法中，那么就很容易解释为什么John's growth of tomatoes是不合法的：

1. 自动词grow->使动词grow的变换是通过增加一个使动的轻动词v<sub>cause</sub>实现的；
2. grow->growth是通过将动词grow加上一个名词化后缀-th实现的；
3. 名词化后缀-th不选择vP，而v也不选择名词；
4. 因此使动化和名词化是不相容的。

更进一步，我们会发现使动化和名词化实际上都来自某个functional head；而实际上自动词组装形成VP也涉及轻动词。实际上，动词grow有关的词族中就没有一个的生成不涉及functional head的。
既然如此，为什么我们还要坚持认为发生的一定是自动词->使动词的变换？为什么不能够是表示“生长”的词根√GROW衍生出了自动词grow，使动词grow和名词growth？

一旦接受了词的派生实际上是一个实义词根和一些（可能未必可见的）functional head组装而成这一说法，派生前后的词的词义没有固定联系也就毫不奇怪了，因为显然可以加入不同的不可见functional head，从而形成不同的词义。

实际上，一旦抛弃了“词”在句法推导中的核心地位，韵律词的存在也就不再令人疑惑了。以汉语为例，有些词太过长，以至于基本上会被分成好几个韵律词处理：“宁波市/精神病院”，有些词则太短，几乎总是被归并到临近的单位中：“一封/信”，实际上“一封信”这个例子还体现出了一件事：韵律词的结构甚至未必和句法树一致！显然“封”是修饰“信”的，实际上的结构是[<sub>NumP</sub> 一 [<sub>ClP</sub> 封 [<sub>NP</sub> 信 ] ] ]，但语音上根本不是这样的结构，“一封”被认为是一个独立的结构。
如果我们认为无论是词还是韵律词都只不过是句法推导中临时组装起来的成分，我们也就不会觉得韵律词和词不能一一对应，甚至不服从短语结构有什么奇怪的了。

从另一个方面看，无论是词还是短语都或者可以具有复合而成的意思（短语无需多说，词的例子包括“grammaticalization”），也可以有唯一确定的意思（如俚语）。

# DM的架构

一套语法需要下面的内容：

1. List A，即基本的root和functional head之类的语素，即Morphosyntactic features，需要注意的是不是所有的语素都具有明确的parts of speech，在DM中part of speech和gender、number一样只是普通的feature而已；
2. List B，即Vocabulary，指明一系列特征对应着怎样的语音实现（比如说“苹果”这个概念对应苹-果这两个字，“苹果[复数]”对应着apples，等等），每一个词条就是一个Vocabulary Item；
3. List C，即Encyclopedia，指明不同的特征对应什么概念，或者说“常识”

语言产出遵循这样的机制：

1. 一些语素从List A中被取出（numberation，“从思想的云朵里落下一阵语素的雨”），发生Merge，Move等操作，这一步是纯句法操作；
2. 第1步得到的结果进入PF，发生形态操作，如fusion，merger等，得到所谓的morphological structure，这一步还是不含有语音形式的，它们被安排在纯句法操作之后是因为它们不影响语义；
3. 第2步运算得到的抽象句法结构被语音实现，即发生Vocabulary Insertion，这一步就是spellout；
4. 第3步运算得到的语音形式发生音系操作；
5. 第1步中运算得到的抽象句法结构被转化为逻辑结构，即进入LF，然后发生类似于quantifier raising之类的操作；
6. PF和LF的结果共同和概念-意向系统连接。

这基本上就是经典的Y型模型，只不过Y的两臂最后都接在概念-意向系统上。
以上推导过程都是cyclic的，包括Vocabulary Insertion也是cyclic的，所以后加入的词缀能够“看到”先加入的词缀。这当然是合理的——拉丁语的变格、变位法就是例子。

可否认为句法推导、形态学操作和spellout实际上是交替进行的：在每个phase中，先发生句法推导，然后形态学操作，然后spellout，每个phase都不大，因此句法推导是比较局域的。

# 基本操作

除了纯句法的Merge和Move以外，还有下面的一系列操作。DM中通常不认为有必要单独列出head movement，因为DM不区分head Merge和phrasal Merge；至于传统上用head movement解释的现象，在DM中使用形态操作来解释。

## 形态学操作

形态学操作是PF操作，因为它对逻辑结构没有影响。虽然如此，它并不是语音学操作，因为它涉及的不完全是发音。

实际上，形态学操作大部分可以通过增加functional head并且利用Agree来完成。但既然它们并不影响逻辑结构，那么似乎也没什么必要这么做。

### Merger

Merger将几个在同一个个constituent内的terminal node合并。例如，名词被加上前缀、后缀就是Merger的作用。
通常被作用Merger的terminal nodes都是相邻的（类似于[ X [ Y [ Z ] ] ]的形式），此时的merger称为adjacent merger。
Merger的作用方式为
$$
[ \; X \; [ \; Y \; \ldots \; ] \; ] \longrightarrow [ \; \sout{X} \; [ \; [ \; X \;  Y \;] \; \ldots \; ] \; ] .
$$

问题：怎么限制merger的使用？如何避免过度生成？或者说，怎么确保merger是局域的？
可能还是需要选择特征或者unvalued feature之类的东西。
还有一种方法是采用phase-cased的方法，也就是每个phase含有的heads非常少，从而只能是局域的。

例如，T,v,V的merger是这样的：

1. [<sub>T'</sub> T [<sub>vP</sub> DP v V ] ]
2. [<sub>TP</sub> DP T [<sub>vP</sub> <del>DP</del> v V ] ]
3. 最关键的一步：T,V,v被作用了merger，合并为一个node——请问是什么决定了这个node应该放在原本v的位置或者原本T的位置？

显然，merger把affix lowering和head movement统一起来了。

如果要把merger做的事情放到句法中，一种可能的思路：affix lowering和(upward) head movement实际上都是feature assignment而已，即v具有未求值的feature（或者如果我们要求每个head只带有一个feature，那么就是vP中的某些AGR head有未求值的feature），然后通过和据说是被移动的functional head发生Agree。

不过，这么做其实很不自然，因为讲白了这就是四个参数画大象。

### Fusion

Fusion将一个constituent合并成一个terminal head。例如，在发生了主语-动词agreement之后，形成了[AGR T]结构，然后AGR（包含人称和数）和T（包含时态）被合并以产生英语第三人称单数之类的现象。
合并之后的terminal head含有多个特征，而不是只含有一个特征。
很多时候merger作用完之后，fusion运算会跟上。

如果我们认为Vocabulary Insertion中，一个VI可以代替一个树而不是一个node，那么就可以不使用fusion操作，因为所谓被聚合在一起的nodes可以整体被替换成一个VI，是不是有fusion操作无关紧要。
但这样一来必须把“什么样的树可以被整体替换”放进Vocabulary中，Vocabulary就会非常冗长。
因此引入fusion操作可以让理论更加清晰。

### Fission

Fission将一个terminal node拆分成几个不同的terminal nodes。
某种意义上Fission也可以看成特殊的AGR Node Insertion。

### AGR Insertion

通常认为一致性运算是在句法层面完成的，不过如果
TODO

## Vocabulary Insertion

语音实现的方式是每个terminal node被符合这一terminal node携带的特征的VI代替。
无论怎么样，Vocabulary Insertion应该遵从以下原则：

- 插入一个node的VI可以含有比这个node还要少的特征（即所谓的underspecification）；
- 插入一个node的VI不应该含有比这个node还要多的特征（因为在语义上有贡献的特征只出现在node中），也就是说可以underspecification不能够overspecification；
- 虽然VI未必含有该node具有的所有特征，一旦插入完成，这个node具有的特征就应该被认为是全部完全实现了（这些特征全部被discharge了；这个过程称为exponent）；
- VI可以对该node周围的其它node具有的特征敏感。

以上原则当然还不能够完全确定如果有多个VI互相竞争，应该使用哪一个。还有下面的原则：
1. Subset Principle: 如果两个VI都能够插入同一个node，那么含有较多specified features的VI优先（正如上面所说的los先于el）；
2. 如果有两个VI实现了同样数目的特征，那么需要一定的机制在它们中间挑选出来一个。常见的一种理论是说：Universal Hierarchy of Features: VIs that realize features higher on the hierarchy are preferred for insertion. 比如说我们可以认为第一、第二人称比第三人称重要。

不同VI的互相竞争这一步是可以出差错的，实际上这就解释了“想着一个东西说出了另一个”这一现象。

# 关于DM理论内部的一些差异

上面所说的DM理论和有些其它文献所阐述的还是有一定区别的，本节讨论这些区别。

## Readjustment

旧版DM中还有一个特殊的形态操作：readjustment。
Readjustment产生形态变体，但是是因为morphology的原因而不是phonology的原因。例如drive->drove, ride->rode。Readjustment作用在一个或者一类VI上面。
请注意实际上有好多种不同的readjustment，而不像Merger或者Fusion又或者Fission一样虽然触发条件在不同语言中不同但是操作是相同的。

可以假定所谓一个VI被readjust的VI后产生的VI变体实际上是不同的VIs，这样readjustment就不再需要了。

表面上看，移除readjustment规则会导致可学习性的问题：的确，孩子怎么会知道mouse和mice实际上指的是同一种东西呢？拥有互补（从而可能互相竞争）的functional head并不会导致可学习性的问题，例如，不同的系动词就不会产生可学习性的问题，因为儿童知道判断句中应该有一个系动词，那么不管那是am, is, are，无论如何那都是一个系动词。
但是儿童显然不可能一开始就知道mouse和mice是同一个动词。

问题在于，如果我们认为可学习性要求不能够有多个VI和同一个实义词根有关，我们很难解释go-went, person-people, wuuti-momoyam（霍皮语，“女人”的单复数）这样的现象。
换而言之实际上就是可以有多个VI和同一个实义词根有关。（这称为suppletion）

## Licensing

所谓licensing指的是，设有一个functional head c-command一个实义词根，则前者可以筛选后者的内容。
这是一个典型的secondary exponent现象，即VI的插入和附近的一些node都有关。
licensing可以用于解释为什么有些词只有名词形式没有动词形式，或者只有动词形式没有名词形式：因为n或者v筛选了可以和它们组合的实义词根，或者说它们license一些实义词根，而不license另一些。

然而，也可以采用这样的方式解释licensing：functional head和实义词根发生了fusion，fusion之后的结果作为一个整体被语音实现。
这样，一些词缺乏动词形式可以解释为相应的词根和v发生fusion之后，没有VI能够匹配得上所得结果。
这样可以大大简化理论，因为无需额外引入licensing的机制就会有licensing的现象。

## Secondary exponent

VI被插入当然依赖于被插入的那个node（这种现象称为primary exponent）；但也可以依赖于附近的一些node（称为secondary exponent），例如同样是过去时后缀，我们说wanted而不是\*wantt，却又可以说burnt。
这可能是因为Agree让附近的node的一些特征扩散到了正在被插入的node上面。
例如，一些functional head c-command了一个特定的root，发生feature assignment（注：如果我们严格地认为DM中每个head不应该携带多于一个特征，那么就不会发生任何Agree，没有feature assignment；这种时候我们说，secondary exponent是由直接管辖目标node的那个functional head决定的；但我们会发现这种说法和认为存在Agree运算完全等价，因此这只不过是notation的问题；此外，如果我们认为secondary exponent实际上是通过feature assignment——或者说得更加DM一些，通过某些fusion操作来完成的，那么它实际上就是特殊的primary exponent：因为fusion完成后的terminal node可以唯一确定将要插入哪个VI），导致插入到这个root中的VI被唯一确定（举例：T c-command了V，从而让V带上了过去时的属性，那么如果V是√EAT，插入的VI就是*ate*而不是*eat*），这就是**licensing**。
上面的机制意味着，即使是实词词根也可能会彼此竞争，因为*eat*没有明确的时态，那么根据underspecification的原则用它实现一个带有过去时的√EAT好像也没有什么不可以。
如果我们认为实词词根不会相互竞争，那么eat->ate之类的现象就需要使用readjustment来分析。

Syntax within the Word认为实词词根的VI也会互相竞争。这样的好处在于无需使用不同的机制来解释实词词根和functional head的语音实现；此外，licensing也可以很容易地分析：实际上这就是一个带有part of speech特征的functional head和实义词根发生了fusion，而如果VI正好带有part of speech特征，那么就需要两者的part of speech一致才能够发生Vocabulary Insertion。这就导致了licensing。

## Null head的使用

旧版DM中，即使是一个简单的名词，也需要这样的结构：

[<sub>NumP</sub> Num [<sub>nP</sub> n √MOUSE ] ]

为了一个有语音实现的词根，我们就引入了两个不可见的functional heads。
这些functional heads是绝对必要的，因为要让词根带上part of speech，还要触发licensing（这当然也可以看成让词根带上part of speech的附带结果）。 
DM中的null heads是如此之多，比其它理论中的null heads都要多。

本文中的DM也需要这么多的functional heads，但是它们并不是没有语音实现；相反，它们和附近的词根发生fusion，一并被语音实现了。

# DM和最简方案

本节讨论DM和最简方案中的一些比较general的概念的相容性。

## DM的粗粒化

TODO：什么时候可以将DM中的东西看成普通的词？

被语音实现完之后的nP可以看成NP

Head movement constraint = adjacent merger，因为被作用merger的heads必然构成一个constituent，从而所有head一个c-command另一个，等效来看相当于head movement只能是最短距离，即[<sub></sub> X [<sub>YP</sub> Y ] ] -> [<sub></sub> [X Y] [<sub>YP</sub> <del>Y</del> ] ] 

## Agree

Agree运算在DM中应该怎样实现？由于每一个head只携带一个特征，似乎很难使用通常的feature copying来实现。
不过实际上，只需要做以下处理即可：如果一个head可以发生Agree，那么它一定选择一个携带了一些未求值的特征的AGR head，这不会其它selection步骤，如下所示：

$$
[_\alpha \; \ldots \; \alpha ] \longrightarrow [_\alpha \; \ldots \; [_\alpha \; \text{AGR} \; \alpha ] ]
$$

即$\alpha$先和AGR发生Merge，再和别的成分发生Merge。当feature assignment发生时，AGR中的未求值成分被求值。
随后，在形态学操作中AGR可以和$\alpha$被fusion在一起，也可以分开语音实现。

这就是所谓的AGR node Insertion schema，即发生Agree时需要插入一个AGR node。
具体AGR插入的时间是句法推导中还是形态运算中其实并不重要，很多DM文献认为这是形态运算的一部分，即到了PF才出现AGR node insertion。

## Affix Lowering和Head Movement

这两个东西，正如别的形态操作一样，完全可以通过增加各种AGR head然后使用Agree来求值这些AGR heads。
一种可能的思路是将它们看成同一个特征的多个Copy，然后Chiain reduction。
这个思路也可以用于导出Merger

# 常见疑难问题的解答

## 形态变体

有些词的变形并不规则，例如mouse->mice。如果mouse的复数是规则的，那么应该发生下面的derivation：

1. 组装形成[<sub>NumP</sub> [PLURAL] [<sub>nP</sub> n √MOUSE ] ]
2. √MOUSE的VI被插入，这个VI要求名词性的环境，而n允准了这一点，即我们说“n licenses the insertion of the VI of √MOUSE”，插入之后形成[ [PLURAL] *mouse* ]
3. [PLURAL]被语音实现，变成后缀-s
4. NumP整体被语音实现，发生形态操作Merger，-s被附加到mouse后面，形成mouses

当然，如果名词不是mouse，那么以上过程就没有任何问题；所以我们需要解释，*mice*这种特殊的形态变体是怎么产生的。
最直接了当的分析当然是readjustment: 我们可以认为英语有一个特殊的语法规则，即“带有[PLURAL]属性的*mouse*”应当被重新分析为*mice*。

问题在于，这样基本上什么也没有解释；而且我们单独为了一个不规则复数专门建立了一条语法规则，属实繁冗。

## fusion何时失败？

为了在不使用secondary exponent的前提下描述licensing，我们认为functional heads和roots一定会发生融合，融合之后得到的单一terminal node被语音实现。
但实际上，也有一些时候functional heads需要自己被语音实现，否则第三人称单数这样的现象就不会出现了。
总之，在一些时候，我们要让fusion失败，从而能够有独立的functional head的语音实现，另一些时候我们要让fusion成功，从而产生suppletion。
这两种情况分别以普通过去时和不规则过去时为例子。

因此，我们需要仔细地考虑，一个head可以带有哪些特征，来指导形态操作。

一种可能的方案是，允许VI具有¬-specification，也就是指定哪些情况下一个VI不能被插入。
例如，考虑动词pick。我们假定VI为：

- [PAST] -> *-ed*
- √PICK ¬[PAST] [v] -> *pick*

现在有这样的复合体：[PAST] [v] √PICK，则应该怎么插入VI？

1. 不能插入*pick*，因为¬[PAST]和[PAST]冲突。
2. 尝试插入*-ed*。由于underspecification，可以插入，但是这样有词根没有被实现；
3. 实义词根不能不被语音实现，否则就有违faithfulness了。
4. 句法推导失败。

这表明不能够形成[PAST] [v] √PICK这样的复合node，于是转而尝试没有做过fusion的结构，也就是

[<sub>TP</sub> [PAST] [<sub>vP</sub> [v] √PICK ] ]

于是产生 *-ed* + *pick*，即*picked*。

当然，最直截了当的分析肯定是认为时态后缀具有不同的分类，它自己可以选择是参加fusion还是独立语音实现。
但是这样的分析实际上只是描写——我们要解释为什么会有这样的分类。
不过实际上，我还是觉得这种解释过于依赖“巧合”了，并不是完美的。

## 为什么需要Fusion

到现在为止我们还没有解释什么触发了fusion。实际上，由于fusion需要额外的语法操作，它加重了运算的负担。
然而，fusion在每一次句法运算中都会被触发——只有当它失败了，才尝试没有fusion的版本（见上一节）。
这一点的证据是不规则过去时的存在：如果fusion可以触发也可以不触发，那么就应该存在eated这样的不合法的过去时；实际上，我们几乎总是说ate，因此，fusion的优先级要比不fusion的优先级高。
一种可能的解释是这样一条原则：

**Minimize Exponence**: The most economical derivation will be the one that maximally realizes all the formal features of the derivation with the fewest morphemes.

fusion可以用一个VI覆盖尽可能多的features，所以fusion越多，Minimize Exponence被满足得越好，即说话人可以产生更大的信息流。
但是另一方面，fusion多了就需要更多的VI，这又让语言的理解变得更为困难。
因此，实际的语言在这两者之间有一个平衡。

## 构词

基本上，从基本的词根出发派生出新词的方法无非下面几种：

- 屈折，也就是说词在句中发生了一系列一致操作（通常要么是主语-动词agreement或者宾语-动词agreement，要么是名词性短语内部的concord）pick up了一些特征，然后发生了形态的改变；
- 派生，也就是词的形态改变完全是语义驱动的，不是在句法推导中和别的什么东西发生Agree而产生的。这个又分成两种：
  - 一种是词性变化，也就是名词变形容词什么的；
  - 一种是形成复合词，也就是是多个实义词根结合在一起。

当然这样的分析肯定是非常粗糙的，比如说黏着要算什么呢？比如说，日语的格助词你要算什么呢？

DM的基本框架并不区分这些构词方法。基本上，屈折

词性变化通常是依靠加入一些特殊的functional head来完成的，比如说加入-ize, -tion等；形成复合词实际上也需要特殊的functional head。

## Adjunct

DM不需要adjunct因为underspecification已经提供了足够用于描述“可选句法成分”的信息。

## 俚语、习语

一些短语如*kick the bucket*, *buy the farm*, *rain cats and dogs*需要被整体认读，因为它们的意思并不是组成它们的每个词的意思。
还有一些俚语甚至根本就算不上短语：比如说“the hell out of”。
TODO

与其说俚语需要被整体认读，还不如说无论是俚语还是普通的词都是被整体认读的。这就是概念-意向系统和语法的接口同时需要PF和LF的原因？
