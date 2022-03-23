关于群上同调和SPT的问题
======

已知事实：
- Haldane chain的topological nontrivial phase由nonlinear sigma model加上一个拓扑项描述
- IQHE本身没有什么对称性保护可言，是一个reversible iTO，可以使用Chern-Simons理论描述
  - 但是实际上也可以使用nonlinear sigma model来描述它，如Altland (9.24), Fradkin (12.84), 1006.4772的
- 在著名的1006.4772中，给出了如下的结论（见I.C）：
  - 可以使用群上同调构造一族exact solvable model，这些模型是bosonic SPT
  - SPT的低能有效理论可以通过nonlinear-sigma model给出，这些模型能够使用（和上一条完全一样的）群上同调分类
  - 因此，群上同调至少是分类了很大一类的SPT

问题：
- 正如Chern-Simons理论和nonlinear sigma model同时描述了IQHE一样，是否SPT也可以使用Chern-Simons理论描述？如果是的话，关于对称性的信息如何在Chern-Simons理论中体现？
  - 举例：1006.4772中的公式(4)；这个式子尤其奇怪的地方在于它不仅仅关于外加电磁场，而是有演生规范场，看起来似乎更像iTO而不是SPT）
  - Fradkin (7.29)下方有讨论说Wss-Zumino项也可以称为Chern-Simons项，Fradkin (7.137)附近大概就是在讨论这些东西
  $$
  \mathcal{A}\left(\Sigma^{+}\right)=\int_{0}^{1} \dd \tau \int_{0}^{\beta} \dd t \vec{n}(t, \tau) \cdot\left(\partial_{t} \vec{n}(t, \tau) \times \partial_{\tau} \vec{n}(t, \tau)\right) \equiv \mathcal{S}_{\mathrm{WZ}}[\vec{n}]
  $$
  也叫做Chern-Simons term
- 我们当中似乎没人真的知道为什么spin SPT的对称群应该当成$SO(3)$而不是$SU(2)$（袁天也不知道……）
- 有无直观的方式展示SPT在Haldane chain中的作用？