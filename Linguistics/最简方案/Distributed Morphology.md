DM = Distributed Morphology
LMP = Lexicalist Minimalist Program
VI = Vocabulary Item

符号约定：√ROOT表示一个没有范畴的实义词根；斜体字母*root*表示语音实现；functional head用普通字体表示。

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

1. 一些语素从List A中被取出（numberation，“从思想的云朵里落下一阵语素的雨”），发生Merge，Move等操作；
2. 第1步得到的结果进入PF，发生形态操作，如fusion，merger等；
3. 第2步运算得到的抽象句法结构被语音实现，即发生Vocabulary Insertion；
4. 第3步运算得到的语音形式发生音系操作；
5. 第1步中运算得到的抽象句法结构被转化为逻辑结构，即进入LF；
6. PF和LF的结果共同和概念-意向系统连接。

这基本上就是经典的Y型模型，只不过Y的两臂最后都接在概念-意向系统上。
以上推导过程都是cyclic的，包括Vocabulary Insertion也是cyclic的，所以后加入的词缀能够“看到”先加入的词缀。这当然是合理的——拉丁语的变格、变位法就是这样的东西。
换句话说Vocabulary Insertion和句法推导实际上是交替进行的。

# 基本操作

除了纯句法的Merge和Move以外，还有下面的一系列操作。DM中通常不认为有必要单独列出head movement，因为DM不区分head Merge和phrasal Merge；至于传统上用head movement解释的现象，在DM中使用形态操作来解释。

## 形态学操作

形态学操作是PF操作，因为它对逻辑结构没有影响。虽然如此，它并不是语音学操作，因为它涉及的不完全是发音。

### Merger

Merger将几个构成同一个constituent的terminal node合并。例如，名词被加上前缀、后缀就是Merger的作用。
通常被作用Merger的terminal nodes都是相邻的（类似于[ X [ Y [ Z ] ] ]的形式），此时的merger称为adjacent merger。

问题：怎么限制merger的使用？如何避免过度生成？可能还是需要选择特征或者unvalued feature之类的东西。
例如，T,v,V的merger是这样的：

1. [<sub>T'</sub> T [<sub>vP</sub> DP v V ] ]
2. [<sub>TP</sub> DP T [<sub>vP</sub> <del>DP</del> v V ] ]
3. 最关键的一步：T,V,v被作用了merger，合并为一个node——请问是什么决定了这个node应该放在原本v的位置或者原本T的位置？

一种可能的思路：affix lowering和(upward) head movement实际上都是feature assignment而已，即v具有未求值的feature（或者如果我们要求每个head只带有一个feature，那么就是v带有）

### Fusion

Fusion将一些terminal node合并成同一个terminal head。例如，AGR（包含人称和数）和T（包含时态）被合并。

### Fission

Fission将一个terminal node拆分成几个不同的terminal nodes。

## Vocabulary Insertion

语音实现的方式是每个terminal node被符合这一terminal node携带的特征的VI代替。
无论怎么样，Vocabulary Insertion应该遵从以下原则：

- 插入一个node的VI不应该含有比这个node还要多的特征（因为在语义上有贡献的特征只出现在node中）；
- 虽然VI未必含有该node具有的所有特征，一旦插入完成，这个node具有的特征就应该被认为是全部完全实现了（这些特征全部被discharge了；这个过程称为exponent）；
- VI可以对该node周围的其它node具有的特征敏感。

以上原则当然还不能够完全确定如果有多个VI互相竞争，应该使用哪一个。还有下面的原则：
1. Subset Principle: 如果两个VI都能够插入同一个node，那么含有较多specified features的VI优先（正如上面所说的los先于el）；
2. 如果有两个VI实现了同样数目的特征，那么需要一定的机制在它们中间挑选出来一个。常见的一种理论是说：Universal Hierarchy of Features: VIs that realize features higher on the hierarchy are preferred for insertion. 比如说我们可以认为第一、第二人称比第三人称重要。

VI被插入当然依赖于被插入的那个node（这种现象称为primary exponent）；但也可以依赖于附近的一些node（称为secondary exponent），例如同样是过去时后缀，我们说wanted而不是\*wantt，却又可以说burnt。
这可能是因为Agree让附近的node的一些特征扩散到了正在被插入的node上面。
例如，一些functional head c-command了一个特定的root，发生feature assignment（注：如果我们严格地认为DM中每个head不应该携带多于一个特征，那么就不会发生任何Agree，没有feature assignment；这种时候我们说，secondary exponent是由直接管辖目标node的那个functional head决定的；但我们会发现这种说法和认为存在Agree运算完全等价，因此这只不过是notation的问题），导致插入到这个root中的VI被唯一确定（举例：T c-command了V，从而让V带上了过去时的属性，那么如果V是√EAT，插入的VI就是*ate*而不是*eat*），这导致了**licensing**。
上面的机制意味着，即使是实词词根也可能会彼此竞争，因为*eat*没有明确的时态，那么根据underspecification的原则用它实现一个带有过去时的√EAT好像也没有什么不可以。
如果我们认为实词词根不会相互竞争，那么eat->ate之类的现象就需要使用readjustment来分析。
Syntax within the Word认为实词词根的VI也会互相竞争。

不同VI的互相竞争这一步是可以出差错的，实际上这就解释了“想着一个东西说出了另一个”这一现象。

### Readjustment

Readjustment产生形态变体，但是是因为morphology的原因而不是phonology的原因。例如drive->drove, ride->rode。Readjustment作用在一个或者一类VI上面。
请注意实际上有好多种不同的readjustment，而不像Merger或者Fusion又或者Fission一样虽然触发条件在不同语言中不同但是操作是相同的。

# 常见疑难问题的解答

## 俚语、习语

一些短语如*kick the bucket*, *buy the farm*, *rain cats and dogs*需要被整体认读，因为它们的意思并不是组成它们的每个词的意思。
还有一些俚语甚至根本就算不上短语：比如说“the hell out of”。
TODO

## 形态变体

有些词的变形并不规则，例如mouse->mice。如果mouse的复数是规则的，那么应该发生下面的derivation：

1. 组装形成[<sub>NumP</sub> [PLURAL] [<sub>nP</sub> n √MOUSE ] ]
2. √MOUSE的VI被插入，这个VI要求名词性的环境，而n允准了这一点，即我们说“n licenses the insertion of the VI of √MOUSE”，插入之后形成[ [PLURAL] *mouse* ]
3. [PLURAL]被语音实现，变成后缀-s
4. NumP整体被语音实现，发生形态操作Merger，-s被附加到mouse后面，形成mouses

当然，如果名词不是mouse，那么以上过程就没有任何问题；所以我们需要解释，*mice*这种特殊的形态变体是怎么产生的。
最直接了当的分析当然是readjustment: 我们可以认为英语有一个特殊的语法规则，即“带有[PLURAL]属性的*mouse*”应当被重新分析为*mice*。

问题在于，这样基本上什么也没有解释；而且我们单独为了一个不规则复数专门建立了一条语法规则，属实繁冗。


# DM的粗粒化

TODO：什么时候可以将DM中的东西看成普通的词？

Head movement constraint = adjacent merger，因为被作用merger的heads必然构成一个constituent，从而所有head一个c-command另一个，等效来看相当于head movement只能是最短距离，即[<sub></sub> X [<sub>YP</sub> Y ] ] -> [<sub></sub> [X Y] [<sub>YP</sub> <del>Y</del> ] ] 
