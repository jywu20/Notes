It seems many occurrences of topology in condensed matter physics are not that related.

On how a gauge field emerges from a quantum dimer state: Fradkin 

Chern-Simons theory is actually not that strange. By putting a liquid (in the everyday sense) in a magnetic field, 
we can naturally get a Chern-Simons effective theory. Susskind 2012

Topological order, emergent gauge fields, and Fermi surface reconstruction

目前已经理清楚的东西：
- 分数化和拓扑序没有必然联系，但是带约束的分数化常常导致演生规范场，从而产生拓扑序（或者无能隙量子序）
- 弦结构和拓扑序没有必然联系（如XY模型），但是有弦结构的东西引入强烈的量子涨落之后常常能够产生拓扑序，即前者是后者的前体
- 在适当的表象下剧烈量子涨落的“基质”（如FQHE中的电子、自旋液体中的自旋）会被隐藏起来，留下一个很干净的像是Chern-Simons理论这样的东西；也有一些时候基质仍然很显眼，如toric-code模型中那样，交换相位就是靠$\sigma^x$和$\sigma^z$的不对易引入的（结果是生成两套行为差不多的基础anyon，所谓quantum double）
  - 问题：有拓扑序一定有弦结构吗？（Chern-Simons理论中有吗？）一定可以通过“弦的量子涨落”（如$\sigma^x$和$\sigma^z$的不对易）引入相位吗（比如说一个由Chern-Simons理论描述的拓扑序要怎么用这种方式引入）？
    - Chern-Simons理论中我们自始至终没有碰过算符不对易、系统的基态是弦网凝聚态、anyon是特定的规范场构型之类的问题，这些构造在Chern-Simons理论中是怎么样的？
    - 弦算符大体上应该是Wilson loop，但是前者是有动力学的意义的，就是能够搬运anyon，后者只是一个“探测器”
  - 有拓扑序一定有像Chern-Simons理论那样的路径积分表述的有效理论吗？
    - 比如说Z2拓扑序，交换相位就是靠$\sigma^x$和$\sigma^z$的不对易引入的，那么如果朴素地做Trotter分解，要么看得清$\sigma^x$要么看得清$\sigma^z$，好像不能够同时看清楚两者，那么如何能够同时看清楚e激发和m激发呢？更别提引入交换相位了
    - 而且，靠$\sigma^x$和$\sigma^z$的不对易引入类似的两套准粒子，这似乎是Levin-Wen模型的特点，就是说如果产生Chern-Simons序，那产生的也是doubled Chern-Simons理论
- 当然这两套东西的表现力不一样其实也正常，AKLT和能带不还都是SPT……
- 纤维丛先生说要看hep-th/9110057；关于string-net和Turaev-Viro的关系，见1106.6033

关于dirac monopole的问题。
- 弦构造是artificial的还是有一定意义的？
- 一个monopole是拓扑孤子还是别的什么东西？
- 和Chern-Simons理论中$K$的取值范围是整数有关联吗？后者和重整化群流有离散的不动点有关，前者呢？
- 弦结构和toric-code类似吗？Real-space observation of emergent magnetic monopoles and associated Dirac strings in artificial kagome spin ice

Levin-Wen模型中$U(1)$规范场的弦上面放置整数是什么意思？

多体系统中有演生Berry phase，一定说明有规范场吗？

https://arxiv.org/pdf/1604.08400.pdf quantum skyrmion

一些临时性的笔记
- 首先基本上可以确定electric monopole和magnetic monopole就是electric charge和magnetic flux
- 然后问题有：
  - Z2规范场中为什么光子缺席了
- ~似乎磁单极子量子化确实是一个量子力学有关的东西~确实是的
- 费米场产生玻色涡旋；费米涡旋？？
- 涡旋有涡旋场，所以量子理论中某种“涡旋”——磁单极子or something——是量子化的也不奇怪；奇怪的乃是经典的涡旋也可以是量子化的，这两者会有什么关系吗？我真的是白痴，当然是有关系的。比如说超流中有XY模型实际上是因为超流的物质场有相位（注意这个相位的概念具有二次量子化的意义），其取值范围在0到$2\pi$之间，这是一个纯粹量子的东西；但是在已经有了这个量子的东西以后，要看出涡旋存在只需要经典的论证。
理论中有一些经典的计算并不是什么疑难点，谐振子的能级量子化也可以赋予一定的经典意义。
- 类似的，磁单极子被导出实际上是“物质场的相位的涡旋诱导出了特定的规范场构型”，与上面是类似的。
- 涡旋被要求量子化以后，能够通过Hubbard-Stratonovich变换写下涡旋场，在纯粹经典的语境下，这似乎很奇怪，因为一个离散的自由度变成连续的了；但是在量子场论中涡旋场有它自己的“粒子”，所以最后拓扑和代数的运算符合得很好；这似乎是很非平庸的？因此XY模型的KT相变确实也可以是某个量子相变的机制

磁单极子和skyrmion的拓扑结构类似？？

量子霍尔效应、磁单极子、Chern-Simons理论中的某种量子化

让我感到奇怪的是，似乎从来没有人讨论过FQHE这个最有名的系统能不能够被某种弦网模型实现。
这里的问题应该有两个：
- 一个是自统计怎么用弦的不对易性编码进去
- 还有一个是边界态的问题，就是FQHE有横向霍尔电阻，所以需要无能隙的边界态，但是弦网液体的边界上无非就是一根弦插在那里，多出来一个任意子

一种可能的理解方式是，将Z2中的e和m激发看成拓扑孤子一类的东西，既然规范势不能连续地变动，没有光子，所以系统能谱是gapped的；compact-U(1)能谱中应该也有孤子？它们对应e和m吗？

曾经有人认为平带不可能有拓扑非平庸性（为什么）？但是QHE明显地表明，事情不是这样的；通过Moire bilayer twisted material可以弄出来和IQHE类似的平带，同时具有拓扑性质，通过bilayer TMD也可以；拓扑能带+非整数填充=FQHE

TODO: Classical topological order in the kinetics of artificial spin ice
