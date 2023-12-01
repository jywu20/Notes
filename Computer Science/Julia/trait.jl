# The so-called Holy trait is one way to group 
# types into ad hoc sets, 
# which are then used to decide how to do dispatch. 
# Unlike the typeclass-like Rust trait, 
# Holy trait doesn't check whether certain methods are implemented for a type
# -- although this mechanism can definitely be introduced manually

# Below we show an example of 
# classifying concrete types into 
# four categories: Continuous, Ordinal, Categorical, and Normable.
# The example is from https://www.juliabloggers.com/the-emergent-features-of-julialang-part-ii-traits/

abstract type StatQualia end

struct Continuous <: StatQualia end
struct Ordinal <: StatQualia end
struct Categorical <: StatQualia end
struct Normable <: StatQualia end

# When a value is passed to `statqualia`,
# the latter decides whether the type of the value is 
# Continuous, Ordinal, Categorical or Normable.
statqualia(::Type{<:AbstractFloat}) = Continuous()
statqualia(::Type{<:Integer}) = Ordinal()

statqualia(::Type{<:Bool}) = Categorical()
statqualia(::Type{<:AbstractString}) = Categorical()

statqualia(::Type{<:Complex}) = Normable()

# Below we define a function that dispatch on the trait StatQualia, 
# instead of the concrete type 

using LinearAlgebra

# Re-depaching: when the value of StatQualia is detected for xs,
# the control flow is redirected to corresponding methods. 
bounds(xs::AbstractVector{T}) where T = bounds(statqualia(T), xs)

# These functions dispatch on the trait
bounds(::Categorical, xs) = unique(xs)
bounds(::Normable, xs) = maximum(norm.(xs))
bounds(::Union{Ordinal, Continuous}, xs) = extrema(xs)

# The trait can be extended:
# here we specify that AbstractVector is Normable, 
# and when we call `bounds([1, 2, 3])`,
# the control flow is automatically redirected to 
# bounds(::Normable, xs)
statqualia(::Type{<:AbstractVector}) = Normable()

# The main problem of this design pattern, in my opinion, 
# is that its functionality somehow overlaps with that of abstract types.
# And indeed consider this post:
# https://discourse.julialang.org/t/why-does-julia-not-support-multiple-traits/5278/9