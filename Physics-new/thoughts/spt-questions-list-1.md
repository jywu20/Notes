关于SPT的有效场论的一些问题
======

- 在著名的1106.4772的I.C节中，$U(1)$ SPT states 据说是可以使用一个$U(1) \times U(1)$ Chern-Simons theory来描述。此文的公式(4)为
  $$
  \mathcal{L}=\frac{1}{4 \pi} K_{I J} a_{I \mu} \partial_{\nu} a_{J \lambda} \epsilon^{\mu \nu \lambda}+\frac{1}{2 \pi} q_{I} A_{\mu} \partial_{\nu} a_{I \lambda} \epsilon^{\mu \nu \lambda}+ \cdots. \tag{1}
  $$
  这就是说有演生规范场。然而，iTO中的演生规范场有很明确的意义（提供各种交换相位），但是SPT中的演生规范场似乎并没有。于是要问：
- **问题** SPT中的演生规范场起到了什么作用？据说为了保证不真的出现anyon，需要满足$\det K = -1$，这件事是怎么证明的？ 
- 我们知道SPT最常见的有效理论也可以是一个带有$\theta$-term的nonlinear $\sigma$-model。实际上，I.B节就给出了$SU(2)$保护的SPT的场论的一般形式
  $$
  S=\int \mathrm{d} \tau \mathrm{d}^{2} x \left(\frac{1}{2 \rho} \operatorname{Tr}\left(\partial_{\mu} g^{\dagger} \partial_{\mu} g\right)\right. \left.+\mathrm{i} \frac{\theta}{2 \pi^{2}} \frac{\epsilon^{\mu \nu \lambda}}{6} \frac{1}{2} \operatorname{Tr}\left[\left(g^{-1} \partial_{\mu} g\right)\left(g^{-1} \partial_{\nu} g\right)\left(g^{-1} \partial_{\lambda} g\right)\right]\right). \tag{2}
  $$
  I.C节的开头说：“The SPT states with $SU(2)$ symmetry can also be viewed as SPT states with $U(1)$ symmetry.” 所以就有如下的问题：
- **问题** 如何从$(2)$导出$(1)$？实际上在一些地方，比如说Fradkin (7.29)下面一段里面是有说Wess-Zumino term也称为Chern-Simons term的，关于它为什么是Chern-Simons term见(7.137)附近，但是我没太看懂他在干什么，而且也不是很清楚说的是不是一个事情。
- 实际上，IQHE好像也是有nonlinear $\sigma$-model加拓扑项的描述的，如Altland的(9.24)所示。这个理论称为Pruisken's action of IQHE。无论如何，从它总是应该可以推出来IQHE那个只和外部电磁场和电流有关的有效理论的。
- **问题** 这是怎么做的？怎么从Pruisken's action推Chern-Simons theory?
- IQHE其实还连带出来了一个关于短程纠缠的拓扑物态中的演生规范场的问题。$(1)$里面是有内部的规范场自由度的，然后它和某个nonlinear $\sigma$-model加上拓扑项等价；IQHE的那种Chern-Simons theory里面是没有内部的规范场自由度的，它也和某个nonlinear $\sigma$-model加上拓扑项等价。这么看，好像没有内部的规范场自由度的Chern-Simons theory可以看成有内部的规范场自由度的Chern-Simons theory的某种退化。的确，在
  $$
  S[A]=\frac{k}{4 \pi} \int \mathrm{d}^{3} x (\epsilon^{\mu \nu \rho} A_{\mu} \partial_{\nu} A_{\rho} + J^\mu A_\mu) \tag{3}
  $$
  里面取$m=1$，得到的霍尔电阻和
  $$
  S[A, a] = \frac{k}{2 \pi} \int \mathrm{d}^3{x} (2\epsilon^{\mu \nu \rho} A_\mu \partial_\nu a_\rho - \frac{m}{2} \epsilon^{\mu \nu \rho} a_\mu \partial_\nu a_\rho + J^\mu A_\mu )  \tag{4}
  $$
  当然是一样的。我不是很清楚$(3)$和$(4)$是不是真的等价……（David Tong的QHE讲义好像说是的，见(5.22)，我不知道有没有理解错）