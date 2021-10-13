# 包冲突

hyperref之类的包最好放在最后，xr-hyper包应该放在hyperref前面

# 蜜汁实现方式导致的错误

## physics

使用physics包时，不要写出`_\vb*{a}`之类的东西，使用`_{\vb*{a}}`代替。

## gb4e

`\lb`的正文是文字模式的不是数学模式的。正确的代码示例如下：

```TeX
\lb{\alpha}\lb{\alpha} $\alpha$ $\beta$ ]\lb{\beta} example]]
```

## xr-hyper

使用xr-hyper进行跨文档引用时最好不要在caption或是section中插入自定义命令或是长的数学公式，否则很可能出错。
有一些标点符号也会出错，比如说破折号`——`。

# 编码支持

# 关于一些包中的过时代码

## gb4e

在使用\al, \lb等指令时可能出现`Command \rmfamily invalid in math mode`之类的错误，这是因为大约在gb4e.sty文件的100行左右有这样一行代码：

```TeX
\@ifundefined{new@fontshape}{\def\reset@font{}\let\mathrm\rmfamily\let\mathit\mit}{}
```

在Tex Live 2015之后有关的兼容被移除了，只需要注释掉这行代码即可。