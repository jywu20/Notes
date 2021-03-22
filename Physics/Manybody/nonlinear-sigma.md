---
author:
- 吴晋渊
title: 连续自旋模型和它们的场论
---

非线性$\sigma$模型
==================

**非线性$\sigma$模型**包含$N$个场，用下标$a$标记它们，配分函数为
$$Z = \int \prod_{a=1}^N \mathop{}\!\mathcal{D} \phi_a \delta(\sum_a \phi_a^2(\boldsymbol{r}) - 1) \exp(- \frac{\beta}{2} \sum_a \int \dd^d{\boldsymbol{r}} (\grad{\phi_a})^2 ).$$
看起来似乎各个场是彼此独立的，但是约束条件意味着它们实际上有耦合。
我们引入拉格朗日乘子，将约束写成
$$\delta(\sum_a \phi_a^2(\boldsymbol{r}) - 1) \propto \int_{-\infty}^\infty \dd{\lambda} \exp(- \frac{\mathrm{i}}{2} \lambda (\phi^2(\boldsymbol{r}) - 1 )),$$
每一点的拉格朗日乘子均可不同，这样我们得到一个辅助场：
$$Z = \int \prod_{a=1}^N \mathop{}\!\mathcal{D} \phi_a \int \mathop{}\!\mathcal{D} \lambda \exp(- \frac{1}{2} \int \dd^d{\boldsymbol{r}} \left( \beta (\grad{\phi})^2 + \mathrm{i}\lambda (\phi^2 - 1) \right) ).$$
我们对$\phi$做一个尺度变换并适当调整常数，就有
$$Z = \int \prod_{a=1}^N \mathop{}\!\mathcal{D} \phi_a \int \mathop{}\!\mathcal{D} \lambda \exp(- \frac{1}{2} \int \dd^d{\boldsymbol{r}} \left( \beta (\grad{\phi})^2 + \mathrm{i}\lambda (\phi^2 - N) \right) ).$$
由于不同的$\phi_a$之间并没有直接的相互作用，我们可以将上式写成
$$Z = \int \mathop{}\!\mathcal{D} \phi \int \mathop{}\!\mathcal{D} \lambda \exp(- \frac{N}{2} \int \dd^d{\boldsymbol{r}} \left( \beta (\grad{\phi})^2 + \mathrm{i}\lambda (\phi^2 - 1) \right) ).
    \label{eq:nonlinear-sigma-lambda}$$

大$N$展开
---------

[\[eq:nonlinear-sigma-lambda\]](#eq:nonlinear-sigma-lambda){reference-type="eqref"
reference="eq:nonlinear-sigma-lambda"}的求解是非常不容易的，我们此处使用大$N$展开来处理它，即将$N$看成一个很大的量，即使它并不那么大。
