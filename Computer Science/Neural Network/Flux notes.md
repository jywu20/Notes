# Auto differentiation in Flux.jl

## How implicit parameters in a model are tracked?

### Determine implicit parameters

ASTs of functions can be retrieved using `code_lowered`, and it's easy to tell global variables (or other implicit dependency to variables outside the function scope) in the function definition from explicit parameters. 

### Gradient calculation

Note that there is *no automated copying* with assignment in Julia, which enables us to collect all implicit parameters of a function into a `Params` object.
Updating the `Params` object is just updating the implicit parameters, and vice versa.
For example:
```julia
W = [1, 2, 3]
ps = params(W)
W[1] = 2
```
Now `ps` is `Params([[2, 2, 3]])`.
Reassignment will break this relation:
```julia
W = [1, 2, 3]
ps = params(W)
W = [1, 2, 4]
```
Now `ps` is still `Params([[1, 2, 3]])`.

Since in Julia, access to the AST of a function is available *in the runtime*, and any element - for example, an expression containing an implicit parameter - of the AST can be evaluated in the runtime, an auto differential program can build identification between variables in a `Params` and implicit parameters in the function to be differentiated.
That's why we are able to write down expressions like 
```julia
Flux.gradient(ps) do
    loss(d...)
  end
```
where `ps` is a `Params`. Since differentiation is based on identification of references of variables, the order of variables doesn't matter when creating a `Params`: both `params(W, b)` and `params(b, W)` work.

If a function depends on a global variable $x$, then the auto differentiation of the function with respect to $x$ is dependent to the same global variable $x$.
When $x$ changes, both the original function and the derivative function give different results.

It can be seen that Julia language features are essential for a neat implementation of auto differentiation.
Runtime access to ASTs, no auto copying with assignments, dynamic evaluation of AST trees enable an elegant auto differentiation framework.
Implementing auto differentiation in many other languages usually ends up into creating a new language ("computational graph"), while in our case with Julia, the language itself is the computational graph.

## The `gradient` function

There are two ways to use `gradient` and its return values:
- For explicit parameters:
  ```julia
  f(x, y) = x^2 + y^2
  gradient(f, 1, 1) # => (2, 2)
  ```
- For implicit parameters:
  ```julia
  W = randn(3, 5)
  b = zeros(3)
  x = rand(5)

  y(x) = sum(W * x .+ b)

  grads = gradient(()->y(x), params([W, b]))

  grads[W], grads[b]
  ```
  The mechanism can be found [here](#how-implicit-parameters-in-a-model-are-tracked). Note that implicit parameters must have **trainable components**, i.e. there must be a certain method named `trainable` defined on them, which returns objects that can be updated without assignment, for example arrays, but not scalars. 

# Layers and models

## How to define a layer

In Flux.jl neural network layers like `Dense` are defined in a quite ingenious way.
They are defined as 
```julia
struct Dense{F,S<:AbstractArray,T<:AbstractArray}
  W::S
  b::T
  σ::F
end
```
, as a `struct`, but on the other hand we have a method definition like
```julia
function (a::Dense)(x::AbstractArray)
  W, b, σ = a.W, a.b, a.σ
  σ.(W*x .+ b)
end
```
that takes in the input data and returns the prediction.

So layers in Flux.jl have two roles: first as a package of neural network parameters, and second as a function that takes in inputs and generates predictions.

## `Dense` and sparcified layers

`Dense` layer definition:
```julia
Dense(in, out, σ=identity; bias=true, init=glorot_uniform)
Dense(W::AbstractMatrix, [bias, σ])
```



## Defining a stateful layer

`Flux.Recur` defines a stateful layer. The usage:

```julia
x = rand(Float32, 2)
h = rand(Float32, 5)

m = Flux.Recur(rnn, h)

y = m(x)
```
`h` is the hidden state.

# Dataset, training and testing

## Dataset definition

The input to a neural network is usually a vector. A batch of input data is usually represented with a matrix of which each *column* is an input vector.
That's understandable because if we have
$$
\bold{W} \bold{x}_i = \bold{y}_i,
$$
then
$$
\bold{W} \underbrace{\begin{bmatrix}
  \bold{x}_1 & \bold{x}_2 & \cdots \bold{x}_n
\end{bmatrix}}_{\bold{X}} = \underbrace{\begin{bmatrix}
  \bold{y}_1 & \bold{y}_2 & \cdots \bold{y}_n
\end{bmatrix}}_{\bold{Y}}.
$$

Therefore, usually a dataset 

The loss function is usually defined as 
$$
\mathcal{L}(\bold{y}, \hat{\bold{y}}) = \sum_{i} l(y_i, \hat{y}_i),
$$
and the risk function is
$$
\mathcal{R} = \sum_i \mathcal{L}(\bold{y}_i, \hat{\bold{y}}_i),
$$
and then it is quite obvious that we have
```julia
risk(Y, Ŷ) = sum(l(Y, Ŷ))
```
Therefore, we can just define the loss function as a generic one:
```julia
loss(y, ŷ) = sum(l(y, ŷ))
```
and do not need a separate `risk` function.
The regularization term can be dealt in a quite similar way.
