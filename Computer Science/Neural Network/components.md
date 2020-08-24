不失一般性假定$\bold{x}$和$\theta$的分布是独立的，并且合理地假定不同样本的采集彼此独立，则做极大后验估计的方法就是
$$
\begin{aligned}
    \hat{\theta} &= \argmax_\theta p(\theta) \prod_i p(y_i | \bold{x}_i, \theta) \\
    &= \argmax_\theta (\sum_i \ln p(y_i | \bold{x}_i, \theta) + \ln p(\theta)).
\end{aligned}
$$

# 数据预处理

应当适当地对输入数据“洗牌”，来保证不同样本的采集彼此独立。

# 神经网络常用组件

---

**提示**

不少深度学习框架，比如tensorflow，的输入输出全部都是分batch的，所以可能输出会多出来一个batch维度。

---

## Dense

全连接层，它由以下参数确定：

- 全连接层中有多少神经元（设有$n$个）
- 预期上一层有多少神经元（设有$m$个）
- 激活函数

全连接层是$\mathbb{R}^m \longrightarrow \mathbb{R}^n$，具体来说，设输入为$\bold{x}$，输出为$\bold{y}$，那么
$$
\mathrm{Dense}:= \bold{x} \longrightarrow \bold{y} = f(\bold{A} \bold{x} + \bold{b})
$$

在TF中：

```Python
keras.layers.Dense(n, input_shape(m,))
```

## Conv

卷积层，它由以下参数确定：

- 卷积核的数目，也即，输出结果有几个通道
- 卷积核的长度核宽度
- 步长
- 是否在边缘填充零

与全连接神经网络相比，卷积神经网络的感受野是局域的、不同感受野的权值是共享的，因此它可以大大减小参数数目。

## Embedding

将一系列整数index转化为一个向量。它由以下参数确定：

- 总共有多少可能的index（比如说如果是word to vec，那么就是单词总数）
- 输出向量的维数

输入一个index序列，输出一个向量序列。输入被编码为一系列one-hot向量排成的矩阵（每一行都是一个one-hot向量），设共有$m$个可能的index，需要把它们embedding到$n$维空间中，输入序列长度为$l$，则我们有$\mathrm{onehot}(s) \in \mathbb{R}^{l \times m}$，而输出的$\bold{y}$则同样是将每个输入的index做embedding后得到的向量作为行向量排成的矩阵。
embedding的过程为
$$
\mathrm{Embedding} := s \longrightarrow \bold{y} = \bold{x} \bold{A}, \quad \bold{x} = \mathrm{onehot}(s), \quad \bold{A} \in \mathbb{R}^{m \times n}.
$$

Embedding实际上就是一个线性神经网络。

（至于为什么不将上式取一个转置，那是因为传统上我们认为$x[i]$应该表示“序列中第$i$个index”，那么第$i$个index应该对应$\bold{x}$的第$i$行）

# 常用损失函数和正则化

## 回归问题

考虑一个用于给数据贴标签的回归问题。记用于训练的样本为
$$
X = \{(y_i, \bold{x}_i) \},
$$
模型为
$$
\hat{y} = f(\bold{x};\theta).
$$
实际我们得到的样本通常含有一定噪声，即
$$
y = f(x;\theta) + \mathcal{N}(\sigma). 
$$
$\theta$本身在不同场景下可以发生变化，因此将它看成一个随机变量。这样
$$
p(y|\bold{x},\theta)  = \frac{1}{\sqrt{2\pi} \sigma} \exp \left( - \frac{(y - f(\bold{x};\theta))^2}{2\sigma^2} \right).
$$

代入正态分布表达式就得到
$$
\hat{\theta} = \argmax_\theta \left( - \frac{1}{2\sigma^2} \sum_i (y_i - f(\bold{x}_i;\theta))^2 + \ln p(\theta) \right),
$$
显然，这就意味着损失函数应该取为
$$
\mathcal{L} = \frac{1}{2} \sum_i (y_i - f(\bold{x}_i;\theta))^2  - \sigma^2 \ln p(\theta),
$$
认定$\theta$服从不同的先验分布，就可以得到不同的正则化项。正则化项会让$\theta$更加接近它比较可能出现的那些值。
例如如果有
$$
p(\theta) \propto \exp \left( - \frac{\|\theta\|^2}{2\tau} \right),
$$
即我们认为模型几乎总是简单的，那么损失函数就是
$$
\mathcal{L} = \frac{1}{2} \sum_i (y_i - f(\bold{x}_i;\theta))^2 + \lambda \|\theta\|^2.
$$

---

**结论**

如果我们认为回归问题中，$y$的采样存在一个正态分布的误差，那么应该使用**方差**为损失函数：
$$
\mathcal{L} = \frac{1}{2} \sum_i (y_i - f(\bold{x}_i;\theta))^2 ,
$$
如果我们认为$\theta$也服从正态分布，那么就应该使用以下正则化：
$$
\lambda \| \theta \|^2
$$

## 多分类问题

设有样本集合$\{\bold{x}_i\}$以及它们的分类$\{y_i\}$，后者是一系列整数。
记$\bold{y} = \mathbb{I}_y(1)$，神经网络归一化的输出为${f}(\bold{x}; \theta)$（这也是一个向量），那么有
$$
p(y|\bold{x}, \theta) = \bold{y}^\top f(\bold{x}; \theta) = \bold{y}^\top \hat{\bold{y}}. 
$$
考虑到$\bold{y}$是一个one-hot向量，我们有
$$
\ln p(y|\bold{x}, \theta) = \bold{y}^\top \ln f(\bold{x}; \theta).
$$
这就意味着
$$
\mathcal{L} = - \sum_i \bold{y}_i^\top \ln f(\bold{x}_i; \theta).
$$

---

**结论**

在多分类问题中应当使用**交叉熵**为损失函数。

# 常用metrics

