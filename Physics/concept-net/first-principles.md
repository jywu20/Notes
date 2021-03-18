凝聚态系统的底层机制
======

$
\newcommand{\pair}[1]{\langle #1 \rangle}
\newcommand{\ii}{\mathrm{i}}
\newcommand{\ee}{\mathrm{e}}
\newcommand{\const}{\mathrm{const}}
\newcommand{\suchthat}{\quad \text{s.t.} \quad}
\newcommand{\argmin}{\arg\min}
\newcommand{\argmax}{\arg\max}
\newcommand{\normalorder}[1]{: #1 :}
\newcommand{\pair}[1]{\langle #1 \rangle}
\newcommand{\fd}[1]{\mathcal{D} #1}
$

记号约定：费米子的产生湮灭算符为${c}^\dagger$和${c}$，而如果是关于位置的产生湮灭算符，则为${\psi}^\dagger$和${\psi}$。

本文提到的费米子主要是电子，使用一个三维坐标$\boldsymbol{r}$（或者三位动量$\boldsymbol{p}$），以及只有向上和向下两种选择的自旋就可以描述一个电子。

单电子自旋算符为

$$  {\boldsymbol{S}} = \sum_{\alpha, \beta} \ket{\alpha} \boldsymbol{\sigma}_{\alpha \beta} \bra{\beta},$$

其中$\alpha$和$\beta$取遍$\uparrow$和$\downarrow$，$\sigma$为泡利矩阵。

由于本文不涉及相对论性过程，设$\boldsymbol{a}$为一个矢量，则使用$a$表示其模长。

本文取普朗克单位制，即认为$\hbar=c=1$，且$4\pi\epsilon_0=1$，$k_B=1$。

$\text{h.c.}$表示厄米共轭，$\text{c.c.}$表示复共轭。

对离散格点系统，使用$\pair{i, j}$表示最接近的一对格点。（只求和一次，即认为$\pair{i, j}$和$\pair{j, i}$相同）

在不涉及自旋-轨道耦合的场合，在书写哈密顿量时我们直接略去自旋的下标，这是合理的，因为只需要把不考虑自旋的哈密顿量中的各个产生湮灭算符根据自旋守恒的性质机械地加上自旋下标再求和就能够得到完整的哈密顿量。

在需要实际计算粒子数时就不能这么做了；需要计算总能量时当然也不能这么做。

若无特殊说明，$f(z)$定义为近独立费米子的分布函数，即
$$
f(z) = \frac{1}{\ee^{\beta z} + 1}.
$$

# 电子

普通的固体、液体、气体由一系列原子组成。通过实验和计算可以发现，原子的最外层电子在各种过程中容易发生重新排列，称为**价电子**；内层电子和原子核（合称为**离子实**，或者不至于引起混淆时也可以称为原子）则通常保持为一个整体，也即，其内部状态发生变化的物理过程的描述需要使用QCD，其涉及的能标远高于价电子发生变化涉及的能标。

本文基本上只分析涉及价电子低能运动的物理过程，即只讨论非相对论极限下的电荷-电磁场耦合系统，而忽略强相互作用、弱相互作用和引力。
此时，带电粒子由薛定谔场完全描述，系统具有$U(1)$规范对称性且无粒子数生灭，有确定的粒子数，于是可以原则上实物粒子部分可以直接用单粒子量子力学描述。
进一步，我们假定系统中没有变化特别快的电磁场，这意味着实际上我们可以积掉电磁场并且得到一个延迟不明显的相互作用，那就是说，我们可以把所有电磁相互作用都用静电学和静磁学处理。由于无论是电子还是离子实都是非相对论性的，电子-电子相互作用、电子-离子实相互作用、离子实-离子实相互作用几乎完全是库伦相互作用。

## 有限温下的开放物质系统

### 电子动能和电子间库伦相互作用

设有$N_e$个价电子，$N_i$个离子实（i表示离子），固体的不考虑外界扰动的一次量子化哈密顿量为
\begin{equation}
    {H} = {H}_\text{e} + {H}_\text{i} + {H}_\text{ei},
    \label{eq:many-body-hamiltonian}
\end{equation}
其中${H}_\text{e}$表示仅涉及价电子的哈密顿量，${H}_\text{i}$表示仅涉及离子实的哈密顿量，最后一项则是两者的相互作用，所有相互作用是库仑相互作用。
诸价电子组成的系统就好像由电子组成的气体，称为\concept{相互作用电子气}。单体哈密顿量为电子的动能项加上单体势能项。在物质不受外界作用时当然不应该有单体势能项，于是
$$
    {H}_\text{e1} = \frac{{\boldsymbol{p}}^2}{2m},
$$
在坐标表象下它就是
$$
    {H}_\text{e1} = - \frac{\laplacian}{2m}.
$$
二体哈密顿量为电子两两作用而产生的库伦势能是
$$
    {H}_\text{e2} = \frac{e^2}{\abs{\boldsymbol{r}_1 - \boldsymbol{r}_2}},
$$
从而价电子本身的能量以及它们之间发生库伦相互作用的能量就是
\begin{equation}
    {H}_\text{e} = \sum_{i=1}^{N_\text{e}} \frac{{p}_i^2}{2m_\text{e}} + \frac{1}{2} \sum_{i\neq j} \frac{e^2}{\abs{\boldsymbol{r}_i - \boldsymbol{r}_j}}.
\end{equation}
使用类似的方法，离子实的组成的系统（如果是晶体那就是晶格）的哈密顿量为
\begin{equation}
    {H}_\text{i} = \sum_{\alpha=1}^{N_\text{i}} \frac{{p}_\alpha^2}{2m_i} + \frac{1}{2} \sum_{\alpha\neq\beta} V(\boldsymbol{R}_\alpha-\boldsymbol{R}_\beta).
\end{equation}
由于离子实中的内层电子结构复杂，离子实之间的相互作用能写不出特别简单的表达式（我们相当于把内层电子的自由度也积掉了）。请注意这个相互作用能是平移不变的，这是当然的，因为QED是平移不变的；但是实际的固体在短距离上并不是平移不变的，因为在低能下有对称性自发破缺。
离子实和价电子的相互作用则是
\begin{equation}
    {H}_\text{ei} = \sum_{\alpha, i} V_\text{ei}(\boldsymbol{r}_i-\boldsymbol{R}_\alpha). 
\end{equation}
分别使用$i$表示价电子，用$\alpha$表示离子实；由于价电子和离子实不全同，不需要加上$1/2$系数。
同样我们还是假定了相互作用本身的平移不变性。
本文仅仅讨论固体（实际上主要是晶体）的物理，因此我们将假定离子实的位移始终局限在非常小的范围内。

在大部分过程中，由于原子核的质量比电子的质量大至少三个数量级，涉及价电子的过程通常比涉及离子实的过程发生得快很多，从而在价电子的时间尺度上，诸离子实的位置可以看成是给定的。
从而，在分析价电子时我们可以将${H}_i$项直接略去，而将${H}_\text{ei}(\boldsymbol{r}_i-\boldsymbol{R}_\alpha)$项对$\boldsymbol{R}_\alpha$求和得到$V_\text{ext}(\boldsymbol{r}_i)$（使用ext为下标是因为离子实相当于是给相互作用电子气施加了一个外场）。这个近似称为**玻恩–奥本海默近似**。这样一来相互作用电子气的一次量子化哈密顿量在坐标表象下就是
\begin{equation}
    {H} = \sum_{i=1}^{N_\text{e}} \left( - \frac{\laplacian}{2m_\text{e}} + V_\text{ext}(\boldsymbol{r}_i)\right) + \frac{1}{2} \sum_{i\neq j} \frac{e^2}{\abs{\boldsymbol{r}_i - \boldsymbol{r}_j}},
    \label{eq:electron-gas-hamiltonian}
\end{equation}
从而二次量子化哈密顿量为
\begin{equation}
    \begin{aligned}
        {H} = &\sum_{\sigma} \int \dd[3]{\boldsymbol{r}} {\psi}_\sigma^\dagger(\boldsymbol{r}) \left( - \frac{\laplacian}{2m} + V_\text{ext}(\boldsymbol{r}) \right) {\psi}_\sigma(\boldsymbol{r}) \\
        &+ \frac{1}{2} \sum_{\alpha, \beta} \int \dd[3]{\boldsymbol{r}_1} \int \dd[3]{\boldsymbol{r}_2} 
        {\psi}_\alpha^\dagger (\boldsymbol{r}_1) {\psi}_\beta^\dagger (\boldsymbol{r}_2) \frac{e^2}{\abs{\boldsymbol{r}_1 - \boldsymbol{r}_2}} {\psi}_\beta (\boldsymbol{r}_2) {\psi}_\alpha (\boldsymbol{r}_1). 
    \end{aligned}
    \label{eq:electron-gas-hamiltonian-sq}
\end{equation}
其中${\psi}^\dagger(\boldsymbol{r})$是薛定谔场的场算符，它也是在位置为$\boldsymbol{r}$的位置产生一个电子的产生算符。这个哈密顿量当然也可以通过QED的低能近似得到，但并没有必要这么做。请注意电子是费米子。
\eqref{eq:electron-gas-hamiltonian-sq}实际上不是对角的，因为它的单粒子项涉及一个梯度算符。

需要注意的是实际上仍然可能有电子和离子实的相互作用（即电子-声子相互作用），因此波恩-奥本海默近似中的电子质量和电子-电子相互作用的具体形式可能出现和该相互作用相关的跑动，此时\eqref{eq:electron-gas-hamiltonian-sq}中的所谓“电子”已经是一种准粒子了。

最后我们指出，由于固体始终可以和外界交换电子——外界的电子可以进入固体，固体中的电子可以溢出——固体中电子气本身的哈密顿量\eqref{eq:electron-gas-hamiltonian-sq}不足以充分描述系统。
本文将只研究近平衡系统，因此这种与外界的相互作用可以使用化学势描述，即我们需要在\eqref{eq:electron-gas-hamiltonian-sq}中加入一项$-\mu {\psi}^\dagger(\boldsymbol{r}) {\psi}(\boldsymbol{r})$，这样得到的哈密顿量才是完整的。
换而言之，电子气完整的哈密顿量形如
\begin{equation}
    \begin{aligned}
        {H} &= \sum_{\boldsymbol{k}, \sigma} \Big( \underbrace{\frac{\boldsymbol{k}^2}{2m}}_{\epsilon_{\boldsymbol{k}}} - \mu \Big) {c}^\dagger_{\boldsymbol{k} \sigma} {c}_{\boldsymbol{k} \sigma} 
        + \int \dd[3]{\boldsymbol{r}} V_\text{ext}(\boldsymbol{r}) {\psi}^\dagger(\boldsymbol{r}) {\psi}(\boldsymbol{r}) \\ 
        &+ \frac{1}{2} \sum_{\alpha, \beta} \int \dd[3]{\boldsymbol{r}_1} \int \dd[3]{\boldsymbol{r}_2} 
        {\psi}_\alpha^\dagger (\boldsymbol{r}_1) {\psi}_\beta^\dagger (\boldsymbol{r}_2) \frac{e^2}{\abs{\boldsymbol{r}_1 - \boldsymbol{r}_2}} {\psi}_\beta (\boldsymbol{r}_2) {\psi}_\alpha (\boldsymbol{r}_1).
    \end{aligned}
    \label{eq:full-electron-gas-hamiltonian}
\end{equation}
在有些模型中有时也将外势场并入$\epsilon_{\boldsymbol{k}}$项。
为了简便起见，通常用$\xi$表示扣除了化学势的单电子能量，即
\begin{equation}
    \xi_{\boldsymbol{k}} = \epsilon_{\boldsymbol{k}} - \mu.
\end{equation}

\subsubsection{哈密顿量的一般形式}

以上我们都是将库伦相互作用加入薛定谔场中，可以说是给出了第一性原理计算需要的哈密顿量（虽然实际上从高能物理的角度这远非第一性原理，但对凝聚态理论来说通常已经够用了）。
但实际上还有以下机制没有考虑：
\begin{itemize}
    \item 作用在单体上的外场的束缚，离子实的束缚已经被计入考虑了，但是还有其它外场，比如说或许会有一个磁场，然后哈密顿量中将会有一项$-\boldsymbol{\mu} \cdot \boldsymbol{B}$；无论如何这会是一个二体算符。
    \item 电子-声子相互作用会引入一个二电子和一个声子发生相互作用的顶角，积掉声子自由度之后会留下一个等效的电子-电子相互作用，这会让\eqref{eq:full-electron-gas-hamiltonian}中电子-电子相互作用的系数发生变化，不再是严格的库伦排斥。
\end{itemize}
于是我们写出一般形式的相互作用电子气的二次量子化哈密顿量：
\begin{equation}
    {H} = \sum_{\boldsymbol{k}, \sigma} (T_{\boldsymbol{k}} - \mu) {c}^\dagger_{\boldsymbol{k} \sigma} {c}_{\boldsymbol{k} \sigma} 
    + \sum_{\boldsymbol{k}_1, \boldsymbol{k}_2, \sigma} V^\text{ext}_{\boldsymbol{k}_1 \boldsymbol{k}_2 \sigma} {c}^\dagger_{\boldsymbol{k}_1 \sigma} {c}_{\boldsymbol{k}_2 \sigma}
    + \sum_{\boldsymbol{k}_1, \boldsymbol{k}_2, \boldsymbol{q}, \alpha, \beta} {c}^\dagger_{\boldsymbol{k}_1+\boldsymbol{q}, \alpha} {c}^\dagger_{\boldsymbol{k}_2-\boldsymbol{q}, \beta} V_{\boldsymbol{q}} {c}_{\boldsymbol{k}_2 \beta} {c}_{\boldsymbol{k}_1 \alpha}. 
\end{equation}
相应的，热力学作用量为
\begin{equation}
    S = \sum_n \left( 
        \sum_{\boldsymbol{k}, \sigma} (-\ii \omega_n + T_{\boldsymbol{k}} - \mu) \bar{c}_{\boldsymbol{k} \sigma} c_{\boldsymbol{k} \sigma} 
        + \sum_{\boldsymbol{k}_1, \boldsymbol{k}_2, \sigma} V^\text{ext}_{\boldsymbol{k}_1 \boldsymbol{k}_2 \sigma} \bar{c}_{\boldsymbol{k}_1 \sigma} c_{\boldsymbol{k}_2 \sigma} 
        + \sum_{\boldsymbol{k}_1, \boldsymbol{k}_2, \boldsymbol{q}, \sigma} \bar{c}_{\boldsymbol{k}_1+\boldsymbol{q}, \sigma} \bar{c}_{\boldsymbol{k}_2-\boldsymbol{q}, \sigma} V_{\boldsymbol{q}} c_{\boldsymbol{k}_2 \sigma} c_{\boldsymbol{k}_1 \sigma} \right). 
\end{equation}
上式中的动能项和相互作用项的形式由对称性确定，具体系数可以暂时不设置具体值（因为直接从\eqref{eq:full-electron-gas-hamiltonian}出发做重整化群计算显然是非常困难的）。
处理这类模型的常用方法包括：
\begin{itemize}
    \item 直接做费曼图计算（需要注意由于库伦相互作用是瞬时的，通常将库仑相互作用顶角写成用虚线连接的两个顶角，每个顶角有一个电子入射和一个电子出射，虚线可以携带动量），由于相互作用是二体的，在相互作用较弱时计算一到二圈图就可以得到很好的效果，不过实际上相互作用并不总是那么弱，此时需要一些其它近似手段；
    \item 由于相互作用项是四阶的，可以使用Hubbard-Stratonovich变换引入一个辅助场，通过适当选取辅助场（通常要和某个有趣的序参量具有同样的对称性）并积掉电子自由度，则接近临界点时，辅助场满足的场论就给出了长程自由度；
    \item 做平均场计算并与实验或数值计算作比较（可以对原来的模型做平均场也可以对Hubbard-Stratonovich变换之后的辅助场做平均场）；
    \item 在定性论证出来一些现象后考虑其上的涨落，获得一个关于平均值附近涨落的理论（可以和平均场一起使用）；
    \item 近似处理，如忽略一部分动能（即忽略一部分电子跃迁项），或者简化相互作用形式。
\end{itemize}
无论如何，凝聚态模型通常都足够复杂，且可能有很强的相互作用，以至于分析方法多种多样，但是没有哪一种能够占有支配地位。

\subsubsection{外加电磁场}

现在讨论外加电磁场导致的哈密顿量变化，或者说“辐射和物质相互作用”导致的哈密顿量变化。
一般的，设系统被放置在电磁场$(\varphi, \boldsymbol{A})$中，则一次量子化哈密顿量（使用一次量子化哈密顿量是为了和经典的“一群电子定向移动”的物理图像对应上）为
\begin{equation}
    {H} = \frac{1}{2m} \sum_i ({\boldsymbol{p}_i} - q_i \boldsymbol{A}({\boldsymbol{r}_i}))^2 + \sum_i q_i \varphi({\boldsymbol{r}}_i) + {H}_\text{int},
    \label{eq:hamiltonian-with-eb-original}
\end{equation}
其中$\boldsymbol{p}$是正则动量，${H}_\text{int}$表示粒子间相互作用。
本文仅考虑外加电磁场产生的线性响应，于是考虑辐射场不很强以至于$\boldsymbol{A}^2$可以忽略的情况，也即，仅保留单光子过程，忽略一切$\boldsymbol{A}^2$项。
% TODO：真的吗？实际上，当辐射场强到非线性效应开始产生时，是不是应该单独列出来一个${H}_\text{int}$然后将物质和辐射做$U(1)$极小耦合已经很成问题了：
在\eqref{eq:hamiltonian-with-eb-original}中我们将电子间的库伦排斥能和辐射场引入的能量简单相加相当于将$({\boldsymbol{p}} - q \boldsymbol{A})^2$括号打开，丢弃$\boldsymbol{A}$的平方项，然后积掉非常高能的光子，这些光子的运动速度相比于物质来说非常快，以至于它们产生的等效电子-电子相互作用几乎就是瞬时的；剩下的光子可以诠释为辐射场。

对电子系统，$q=-e$，那么就有
\begin{equation}
    \begin{aligned}
        {H} &= \frac{1}{2m} \sum_i ({\boldsymbol{p}_i} + e \boldsymbol{A}({\boldsymbol{r}_i}))^2 - e \sum_i \varphi({\boldsymbol{r}}_i) + {H}_\text{int} \\ 
        &= - \frac{1}{2m} \sum_i (\grad + \ii e \boldsymbol{A}({\boldsymbol{r}_i}))^2 - e \sum_i \varphi({\boldsymbol{r}}_i) + {H}_\text{int}.
    \end{aligned}
\end{equation}
设$\Omega$是某个空间区域，电流密度为$\boldsymbol{J}$，则
\begin{equation}
    \int_\Omega \dd[3]{\boldsymbol{r}} {\boldsymbol{J}} = - \sum_i e {\boldsymbol{v}}_i,
\end{equation}
其中$\boldsymbol{v}_i$是电子移动的速度，满足
\begin{equation}
    {\boldsymbol{v}}_i = \pdv{H}{\boldsymbol{r}_i} = \frac{{\boldsymbol{p}}_i + e \boldsymbol{A}({\boldsymbol{r}}_i)}{m}.
\end{equation}
考虑到$\Omega$的任意性，我们就有以下近似表达式：
\begin{equation}
    {\boldsymbol{J}} = \underbrace{- \frac{e}{m} \sum_i ( \delta(\boldsymbol{r} - {\boldsymbol{r}}_i) {\boldsymbol{p}} + {\boldsymbol{p}} \delta(\boldsymbol{r} - {\boldsymbol{r}}_i) )}_{{\boldsymbol{j}}} \underbrace{- \frac{e^2}{m} {n}_\text{e}}_{{\boldsymbol{j}}_\text{D}} \boldsymbol{A}.
\end{equation}
${\boldsymbol{j}}$项特意被写成了厄米的形式；${\boldsymbol{j}}_\text{D}$已经做了一遍粗粒化了，将诸$\boldsymbol{A}_i$平均了一遍。
通常这是合理的，因为电磁波的波长通常不会特别小，从而不会有很大的空间起伏。（而如果有很大的空间起伏，我们就会使用cQED而不是经典电动力学讨论问题了）

现在写出略去高阶项的哈密顿量的形式。选取库伦规范，并认为$\varphi=0$，此时会发现，实际上我们有
$$
    {H} = \frac{1}{2m} \sum_i {\boldsymbol{p}}_i^2 + {H}_\text{int} + \frac{e}{m} \sum_i {\boldsymbol{p}}_i \cdot \boldsymbol{A}({\boldsymbol{r}}_i) - e \sum_i \varphi({\boldsymbol{r}_i}),
$$
$\boldsymbol{A}({\boldsymbol{r}}_i)$和${\boldsymbol{p}}_i$本来是不对易的，但是库伦规范下它们对易。
代入${\boldsymbol{J}}$的表达式并再次略去高阶项，就有
$$
    {H} = \frac{1}{2m} \sum_i {\boldsymbol{p}}_i^2 + {H}_\text{int} - \int \dd[3]{\boldsymbol{r}} {\boldsymbol{J}} \cdot \boldsymbol{A} - e \sum_i \varphi({\boldsymbol{r}_i}).
$$
至于含有电势的那一项，注意到电荷密度为
$$
    {\rho} = - e \sum_{i} \delta({\boldsymbol{r}}_i - \boldsymbol{r}),
$$
于是最后得到
\begin{equation}
    {H} = \frac{1}{2m} \sum_i {\boldsymbol{p}}_i^2 + {H}_\text{int} + \int \dd[3]{\boldsymbol{r}} \varphi {\rho} - \int \dd[3]{\boldsymbol{r}} {\boldsymbol{J}} \cdot \boldsymbol{A}.
\end{equation}
虽然物质本身的哈密顿量不是洛伦兹协变的（因为取了非相对论近似），但是物质和辐射的相互作用项却是洛伦兹协变的——对电磁场的描述一般都是如此。
以上哈密顿量实际上仅仅讨论了轨道部分，电子还有自旋磁矩
$$
    {H}_{\text{spin}} = \sum_i {\boldsymbol{\mu}}_i \cdot \boldsymbol{B}({\boldsymbol{r}}_i),
$$
我们可以如法炮制地将它写成
$$
    {H}_{\text{spin}} = \int \dd[3]{\boldsymbol{r}} {\boldsymbol{\mu}} \cdot \boldsymbol{B}.
$$
因此完整的哈密顿量实际上是
\begin{equation}
    {H} = - \frac{1}{2m} \sum_i {\boldsymbol{p}}_i^2 + {H}_\text{int} + \int \dd[3]{\boldsymbol{r}} \varphi {\rho} - \int \dd[3]{\boldsymbol{r}} {\boldsymbol{J}} \cdot \boldsymbol{A} + \int \dd[3]{\boldsymbol{r}} {\boldsymbol{\mu}} \cdot \boldsymbol{B}.
    \label{eq:hamiltonian-with-eb}
\end{equation}
所有和单粒子携带的电荷数量有关的量全部被藏在电荷密度和电流密度中了，上式在电荷正反变换下不变。

\eqref{eq:hamiltonian-with-eb}当然也可以非常容易地写成二次量子化的形式。
薛定谔场满足$U(1)$对称性，因此通过诺特定理可以得到守恒荷（当然就是电荷）
\begin{equation}
    \rho = - e \sum_\sigma {\psi}^\dagger_\sigma {\psi}_\sigma = - e {n}_\text{e},
\end{equation}
守恒流（也即电流密度）
\begin{equation}
    {\boldsymbol{j}} = - \frac{\ii e}{2m} \sum_\sigma ({\psi}_\sigma^\dagger(\boldsymbol{r}) \grad{{\psi}_\sigma}(\boldsymbol{r}) - (\grad{{\psi}_\sigma^\dagger}(\boldsymbol{r})) {\psi}_\sigma(\boldsymbol{r})) - \frac{e^2}{m} \boldsymbol{A}(\boldsymbol{r}) \sum_\sigma {\psi}^\dagger_\sigma(\boldsymbol{r}) {\psi}_\sigma(\boldsymbol{r}),
\end{equation}
而另一方面自旋磁矩为
\begin{equation}
    {\boldsymbol{\mu}} = {\psi}^\dagger_\alpha \boldsymbol{\sigma}_{\alpha \beta} {\psi}_\beta.
\end{equation}
这样就把三个对外加电磁场的线性响应全部写成二次量子化的形式了；我们可以用推迟格林函数计算出有关的响应大小。

由线性响应理论，我们有
$$
    \begin{aligned}
        \expval*{{J}_i}_A (t) &= \expval*{{J}_i}_0 + \ii \int \dd{t} \int \dd[3]{\boldsymbol{r}'} \theta(t-t') \expval*{\comm*{{J}_i(\boldsymbol{r}, t)}{{J}_j(\boldsymbol{r}', t')}} A_j(\boldsymbol{r}', t') \\
        &= - \frac{e^2}{m} \expval*{{n}_\text{e}} A_i + \ii \int \dd{t} \int \dd[3]{\boldsymbol{r}'} \theta(t-t') \expval*{\comm*{{j}_i(\boldsymbol{r}, t)}{{j}_j(\boldsymbol{r}', t')}} A_j(\boldsymbol{r}', t').
    \end{aligned}
$$
这里的$i, j$为维度脚标，并不表示粒子编号，且使用爱因斯坦求和约定；下标$A$表示有外场$\boldsymbol{A}$时的期望值；${j}_i$的无外场期望是零，这是对称性的结果。

实际上，电阻率定义为%
\footnote{$\boldsymbol{A}(\boldsymbol{r}, t)$完全可以不是时间、空间平移不变的，但是既然我们将$\boldsymbol{A}$当成扰动，只需要无扰动的系统的动力学时间、空间平移不变即可。}%
\begin{equation}
    J_i(\boldsymbol{r}, t) = \int \dd[3]{\boldsymbol{r}'} \int_{-\infty}^t \sigma_{ij}(\boldsymbol{r}-\boldsymbol{r}', t - t') E_j(\boldsymbol{r}', t'),
\end{equation}
于是为了避免繁琐的时间上的微积分我们切换到频域上，有
% TODO:确认记号问题

现在我们回到二次量子化的框架下，考虑怎么计算有关的推迟格林函数。

在虚时间路径积分中不能简单地将\eqref{eq:hamiltonian-with-eb-original}（从而，\eqref{eq:hamiltonian-with-eb}）做勒让德变换。
在这两个哈密顿量中有一个$U(1)$规范场$(\varphi, \boldsymbol{A})$，由于规范对称性的存在，实际上只有$\boldsymbol{A}$是独立的自由度，因此不能保证在Wick转动中含有$\varphi$的项是不变的。
最简单的从\eqref{eq:hamiltonian-with-eb-original}推导出虚时间路径积分的方法是最小耦合。我们知道$\varphi \rho$项会出现本质上是因为加入$U(1)$规范场之后需要将导数替换为协变导数，而可以验证以下替换
\begin{equation}
    \partial_\tau \longrightarrow \partial_\tau - \ii e \varphi, \quad - \ii \grad \longrightarrow - \ii \grad + e \boldsymbol{A} 
\end{equation}
给出了虚时间场论中的协变导数，于是在自由理论中做这个替换就得到了与电磁场发生相互作用的电子场的虚时间配分函数。

这样会带来一个疑难，就是Wick转动后电势前面多出来了一个负号；但是凝聚态理论中电子可以被放在一个势场中，显然Wick转动后势场前面不需要多出来一个负号。
这个疑难的解答是，含有$\ii e \varphi \rho$项的理论描述了一个电子场和一个电磁场的耦合，而“电子置于势场中”的模型中电磁场已经被积掉了。
如果将电磁场积掉，按照高斯积分的原理，$e \varphi \rho$项前面会多一个负号，并且要乘以系数$\ii$的平方，于是我们发现Wick转动后前面不需要多出来一个负号的势场出现了。

在以上的推导中，我们均取$e>0$为正的元电荷；在分析电子系统时，一个更加常见的记号是取$e<0$，令$\abs*{e}$为元电荷。
这样可以让电子系统的配分函数看起来更像是直接从$U(1)$规范不变性得到的，从而看起来更加接近高能物理中的记号。

\subsubsection{力学和热学性质}

固体系统常见的可测量量（这里不是指可观察量算符，而是指真的做量子测量能够测出来的物理量，比如说期望，等等）除了前一节提到的各种电学和磁学性质以外还包括热学性质和力学性质。

我们来计算

\subsection{近独立电子气}

\subsubsection{哈密顿量、分布和格林函数}

很难一上手就处理带有复杂相互作用的电子气，因此我们首先处理**近独立电子气**，也就是电子之间近似没有相互作用的电子气。此时我们可以单独考虑每个电子的哈密顿量
\begin{equation}
    {H} = \frac{{\boldsymbol{p}}^2}{2m_\text{e}} + V(\boldsymbol{r}).
    \label{eq:single-electron-hamiltonian}
\end{equation}
整团电子气的哈密顿量是关于各个电子的哈密顿量之和。
上式中的$V(\boldsymbol{r})$未必就是物理意义明确（比如由原子核施加的库伦能）的势能，而有可能是相互作用电子气在一定情况下产生的等效势能。
实际上，对任何一个相互作用系统，都可以找到赝势$V(\boldsymbol{r})$使得其能量近似可以写成\eqref{eq:single-electron-hamiltonian}的形式，但如果相互作用很强，即使往系统中放入一个电子，赝势$V(\boldsymbol{r})$的形式也会发生很大改变，因此将强关联系统看成近独立电子气并无意义。
本节主要讨论$V(\boldsymbol{r})$的形式基本上固定的情况，即电子间相互作用比较弱，与此同时电子数涨落不大的情况。

近独立电子气的基态是什么？使用巨正则系综%
\footnote{当然，我们认为系统能够达到统计平衡，就意味着电子之间不可能真的完全没有相互作用，否则能量无法传递。}%
，对很大的近独立费米子系统，处在能量本征态$\ket{n}$上的粒子数的平均值为%
\footnote{以下使用$\epsilon$表示单个电子的能量而使用$E$表示系统总能量。}%
\begin{equation}
    \expval*{{n}_n} = f(\epsilon_n) = \frac{1}{\ee^{\beta (\epsilon_n-\mu)} + 1}.
    \label{eq:fermi-dirac-distribution}
\end{equation}
我们让能量尽可能低，那就是要让$T\to 0$，也就是让$\beta\to \infty$，此时就有
\begin{equation}
    \expval*{{n}_n} = \begin{cases}
        1, \quad \epsilon_i \leq \mu, \\
        0, \quad \epsilon_i > \mu.
    \end{cases}
\end{equation}
这意味着，$T=0$时电子占据的所有状态就是
\begin{equation}
    \epsilon_i = \mu
\end{equation}
以内的所有能量本征态（这部分能量本征态称为\concept{费米海}）。在动量空间中这就是一个曲面，称为\concept{费米面}。位于费米面上的所有能量本征态共同组成了一个能量正好是零温化学势的能级，称为\concept{费米能级}，其能量称为\concept{费米能量}。与费米能级对应的动量称为\concept{费米动量}。
基态的表达式就是一个乘积态，为
\begin{equation}
    \ket{\Psi} = \prod_{\abs{\boldsymbol{k}} < k_\text{F}} {c}^\dagger_{\boldsymbol{k}} \ket{0}.
    \label{eq:ground-state}
\end{equation}

统计物理的论证只能把我们带到这里。具体化学势是多少需要根据
\begin{equation}
    \mu_i = \pdv{U}{N_i}
\end{equation}
计算。当然，化学势和粒子数、温度等因素都有关系。在$T=0$且电子数$N$给定时，常用的做法是显式地写出所有能量本征态，从小到大排列$N$个电子，从而计算出费米能量，然后我们就知道了$T=0$时的化学势。

不同粒子数对应的费米能量是不同的；并且，在分析有限温问题时，化学势不再是费米能量。然而，在温度不很高、粒子数很大时，不同粒子数对应的费米能量相差不大，并且化学势和费米能量（也就是$T=0$时的化学势）相差不大，因此有时会使用费米能量近似作为化学势。%
\footnote{关于本节的论述要着重指出一点：虽然我们采用了统计物理的论证来表明必然存在着一个费米面，从而有对应的费米能量，但统计物理的论证仅仅为我们提供了系统基态的性质，而无论系统是不是需要使用平衡态系综描述，它一定有一个基态。因此，费米面、费米能级等概念在任何情况下——无论是平衡态还是非平衡态、纯态还是混合态——全部是适用的。这些概念并不依赖统计物理的框架！}%
化学势的大小由系统中的电子数决定，或者也可以反过来说，化学势的高度决定了系统基态中哪些位置被电子填充。这个对应关系形象地展示如\autoref{fig:chemical-potential}，化学势越高，被描黑的态——也就是基态有电子填充的态——就越多。
再次强调，这个“电子能量形式固定，改变化学势往系统中填充电子”的物理图像不适用于强关联系统，因为在那里等效的电子能量形式\eqref{eq:single-electron-hamiltonian}随着电子填入会发生剧烈变化；相应的，从这个物理图像衍生出来的理论，如能带理论（见\autoref{sec:energy-band}）也不再适用。

\begin{figure}
    \centering
    \subfigure[$\xi_{\boldsymbol{k}}$和$\boldsymbol{k}$的关系]{
        \begin{tikzpicture}
        
            % 动量横轴
            \draw[->] (-3,0) -- (3,0) node[right] {$\boldsymbol{k}$};
            % 动能纵轴
            \draw[->] (0,-1.5) -- (0,2.5) node[above] {$\xi_{\boldsymbol{k}}$};
            
            % 画出$\xi_{\boldsymbol{k}}$曲线
            \draw[samples=50, smooth, domain=-3:3] plot(\x,{0.25*(\x*\x)-1});
            % 描黑被占据的部分
            \draw[samples=50, smooth, thick, domain=-2:2] plot(\x,{0.25*(\x*\x)-1});
    
            % 标出带底
            \draw[dash pattern=on5pt off3pt] (-2.5, -1) -- (2.5,-1) node[right] {$-\mu$};
    
            % 标出费米点
            \node[dot, label=above:$\boldsymbol{k}_\text{F}$] at (2, 0) {};
            \node[dot, label=above:$-\boldsymbol{k}_\text{F}$] at (-2, 0) {};
    
        \end{tikzpicture}
    }
    \subfigure[$\epsilon_{\boldsymbol{k}}$和$\boldsymbol{k}$的关系]{
        \begin{tikzpicture}
        
            % 动量横轴
            \draw[->] (-3,0) -- (3,0) node[right] {$\boldsymbol{k}$};
            % 动能纵轴
            \draw[->] (0,-1.5) -- (0,2.5) node[above] {$\epsilon_{\boldsymbol{k}}$};
            
            % 画出$\epsilon_{\boldsymbol{k}}$曲线
            \draw[samples=50, smooth, domain=-3:3] plot(\x,{0.25*(\x*\x)});
            % 描黑被占据的部分
            \draw[samples=50, smooth, thick, domain=-2:2] plot(\x,{0.25*(\x*\x)});
    
            % 标出费米面
            \draw[dash pattern=on5pt off3pt] (-2.5, 1) -- (2.5,1) node[right] {$\mu$};
    
            % 标出满带
            \draw[dash pattern=on5pt off3pt] (2, 0) -- (2,1);
            \draw[dash pattern=on5pt off3pt] (-2, 0) -- (-2,1);
    
            % 标出费米点
            \node[dot, label=below:$\boldsymbol{k}_\text{F}$] at (2, 0) {};
            \node[dot, label=below:$-\boldsymbol{k}_\text{F}$] at (-2, 0) {};
    
        \end{tikzpicture}
    }
    \caption{化学势和电子填充，描黑的态有电子填充}
    \label{fig:chemical-potential}
\end{figure}

近独立电子气的格林函数和它的谱函数如下。谱函数为
\begin{equation}
    A(\boldsymbol{k}, \omega) = \delta(\omega - \epsilon_{\boldsymbol{k}}),
\end{equation}
推迟格林函数为
\begin{equation}
    G^\text{ret}(\boldsymbol{k}, \omega) = \frac{1}{\omega - \epsilon_{\boldsymbol{k}} + \ii 0^+}.
\end{equation}
这些都和单电子计算出来的结果完全一样，当然也毫不意外。

\subsubsection{空穴}

虽然多电子态是将场算符作用在真空态上得到的，但由于本文讨论的电子都由薛定谔场描述，在任何一个物理过程中电子数都是守恒的。
换而言之，设有一个$N$电子的系统，这个系统实际可能具有的态矢量只是态空间的一小部分，即保持电子数为$N$的部分。
这个$N$电子空间$\mathcal{H}_N$当然可以使用一次量子化理论来描述，但能否使用二次量子化的语言描述？
费米子的特性让这一点成为可能。请注意由于泡利不相容原理，
$$
    {c}^\dagger_{\boldsymbol{k}} \ket{\Psi} = 0, \quad k < k_\text{F},
$$
而由产生湮灭算符的性质显然有
$$
    {c}_{\boldsymbol{k}} \ket{\Psi} = 0, \quad k > k_\text{F},
$$
因此如果定义%
\footnote{费米面上的态相对来说非常少，因此忽略。}%
\begin{equation}
    {b}^\dagger_{\boldsymbol{k}} = \begin{cases}
        {c}_{\boldsymbol{k}}, \quad k < k_\text{F}, \\
        {c}_{\boldsymbol{k}}^\dagger, \quad k > k_\text{F},
    \end{cases}
\end{equation}
那么基态$\ket{\Psi}$实际上是${b}^\dagger$产生的准粒子的真空态。${b}^\dagger$产生的是什么？当$k>k_\text{F}$时它产生的就是费米面以上的电子，而$k<k_\text{F}$时它产生的是费米海之内的空穴。
空穴的动量就是它占据的态如果有电子的话，这个电子的动量。
使用${b}^\dagger$写出的哈密顿量在省略一个无关紧要的常数之后为
$$
    {H} = \sum_{k > k_\text{F}} \xi_{\boldsymbol{k}} {b}^\dagger_{\boldsymbol{k}} {b}_{\boldsymbol{k}} - \sum_{k < k_\text{F}} \xi_{\boldsymbol{k}} {b}^\dagger_{\boldsymbol{k}} {b}_{\boldsymbol{k}},
$$
因此一个空穴的能量为$-\epsilon_{\boldsymbol{k}}$。以上的哈密顿量不是正定的，但这不会导致负能量疑难，因为费米海虽然很大，但大小有限，因此不会出现能量无限下降的问题。

使用${b}^\dagger$的结果是，保持电子数不变的相互作用需要被看成粒子数可变的，例如一个费米海中的电子被激发到费米海之上就意味着产生了一个电子-空穴对。

\subsubsection{自由电子气}

现在我们讨论最为简单的电子气，也就是$V(\boldsymbol{r})$在物体内部为常数（可以看成零）的情况。此时可以将价电子一个个分开处理，既然它们之间没有相互作用。

我们在坐标表象下处理问题。计算单个电子的波函数：
$$
    - \frac{\laplacian}{2m_\text{e}} \psi(\boldsymbol{r}) = \epsilon \psi(\boldsymbol{r}),
$$
这种方程的解当然是平面波解的线性组合。一个这样的平面波解形如
$$
    \psi(\boldsymbol{r}) \propto \ee^{\ii \boldsymbol{k} \cdot \boldsymbol{r}}.
$$
只能保证这个式子在物体内部成立，因为物体边界处$V(\boldsymbol{r})$不可能是常数。
然后我们归一化这些平面波。电子可以自发地溢出物体，但是这样的概率并不大，所以我们可以简单地认为电子只会出现在物体内部（也即，物体被放置在一个无限深势陷当中）。设物体体积为$V$，就有
$$
    \int \dd[3]{\boldsymbol{r}} \abs{\psi(\boldsymbol{r})}^2 = 1,
$$
于是
$$
    \psi (\boldsymbol{r}) = \frac{1}{\sqrt{V}} \ee^{\ii \boldsymbol{k} \cdot \boldsymbol{r}}, \quad \epsilon = \frac{k^2}{2m_\text{e}}.
$$
很容易看出这些波函数实际上是动量算符的本征态，$\boldsymbol{k}$实际上就是动量。另一方面，这些波函数定义在坐标空间中，坐标空间中的一切都和自旋算符对易，因此这些波函数也是自旋本征态。于是动量和自旋的一组共同正交本征函数为
\begin{equation}
    \psi_{\boldsymbol{k},\sigma} (\boldsymbol{r}) = \frac{1}{\sqrt{V}} \ee^{\ii \boldsymbol{k} \cdot \boldsymbol{r}}, \quad \epsilon_{\boldsymbol{k},\sigma} = \frac{k^2}{2m_\text{e}}.
\end{equation}
% 真的是这个名字吗？这些波函数称为\concept{布洛赫波函数}。
$\boldsymbol{k}$能够取什么值取决于边界条件。由于物体通常比较大，具体取什么样的边界条件对物体内部的过程毫无影响。

自由电子气的费米面是球状的（即\concept{费米球}）。对三维系统，态密度为
$$
    \dd{N} = 2 \frac{\dd[3]{\boldsymbol{r}} \dd[3]{\boldsymbol{k}}}{(2\pi)^3},
$$
因子$2$是因为电子有两个自旋。积掉无用的坐标自由度和动量角自由度之后得到
$$
    \dd{N} = \frac{V k^2 \dd{k}}{\pi^2}.
$$
由于
$$
    \epsilon = \frac{k^2}{2m},
$$
可以推导出
$$
    \dd{N} = \frac{V (2m)^{3/2} \sqrt{\epsilon} \dd{\epsilon}}{2 \pi^2}.
$$
这样就可以计算出总粒子数和费米能（即零温化学势）之间的关系：
\begin{equation}
    N = \int_{\epsilon=0}^{\epsilon_{\text{F}}} \dd{N} = \frac{V (2m)^{3/2}}{3 \pi^2} \epsilon_\text{F}^{3/2},
\end{equation}
以及总能量
\begin{equation}
    E = \int_{\epsilon=0}^{\epsilon_{\text{F}}} \epsilon \dd{N} = \frac{V (2m)^{3/2}}{5 \pi^2} \epsilon_\text{F}^{5/2} = \frac{3}{5} N \epsilon_{\text{F}}.
\end{equation}
对二维或者一维的自由电子气也可以使用类似的方法得到系数不同的结论。

# 晶格

晶格的振动产生[声子](excitation.md#声子)。