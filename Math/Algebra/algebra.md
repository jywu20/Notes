Algebra in a modern perspective
========

# Concepts in set theory

- $\cup$, $\cap$, $\setminus$. $\{1, 2, 4\} \setminus \{3, 4, 5\} = \{1, 2\}$.
- Bijection, injection, surjection. Note that the codomain of a function has to be *declared* besides the set of $(x, f(x))$ pairs, 
  or otherwise there's no difference between injections and bijections.
  
  An injection is often drawn as $\hookrightarrow$. An surjection, $\twoheadrightarrow$.
- The product of two sets is typically defined as 
  $$
  A \times B = \{ (a, b) | a \in A, b \in B \}.
  $$
  Note that strictly speaking $(A \times B) \times C$ is *not* $A \times (B \times C)$ 
  although a bijection between the two trivially exists.
  Moreover, one can define a $n$-ary 
- For better generality we define  
  $$
  \prod_{i\in I} A_i = \{ f | f : I \to \bigcup_{i \in I} A_i, \forall i \in I, f(i) \in A_i \}.
  $$
  $f$ selects one element from each $A_i$.

  In this way there is no problem of orders of operations.
  But note that existence of such a choice function depends on axiom of choice.
- The disjoint union is defined as 
  $$
  \coprod_{i \in I} A_i = \bigcup_{i \in I} \{ (x, i) | x \in A_i \}
  $$
  The operation makes copies of $A_i$'s and makes sure that they have no overlap.
  The origin of each element of the disjoint union is traceable.
  
  Existence of the disjoint union is easily provable within ZF.
- Reflexivity, symmetry and transitivity defines equivalence relations. The equivalence class of $a \in S$ is 
  $$
  [a]_\sim = \{ b \in S | b \sim a \}.
  $$
  The quotient $S / \sim$ is the set of all equivalence classes.

Concepts above are defined in an element-based approach,
which is good to ensure proof of existence of various objects.
Once this is done, however, we can focus on more algebraic aspects of these concepts.

- $f : A \to B$ is a monomorphism if and only if for all sets $Z$ and functions $\alpha, \beta : Z \to A$, 
  $$
  f \circ \alpha = f \circ \beta \Rightarrow \alpha = \beta.
  $$

  Then, a function is an injection, if and only if it's a monomorphism,
  due to uniqueness of the preimage in relations in $f$.
- $f: A \to B$ is an epimorphism if and only if for all sets $Z$ and functions $\alpha, \beta : B \to Z$, 
  $$
  \alpha \circ f = \beta \circ f \Rightarrow \alpha = \beta.
  $$

  Then, a function is a surjection, if and only if it's an epimorphism.
- $g: B \to A$ is a left inverse of $f: A \to B$ if and only if $g \circ f = \id_A$.
  $f$ is injective if and only if it has a left inverse.
- $g: B \to A$ is a right inverse of $f: A \to B$ if and only if $f \circ g = \id_B$. $f$ is surjective if and only if it has a right inverse.

Some almost trivial examples.

- A natural projection $A \twoheadrightarrow A / \sim$ exists, which is obtained by sending every element to its equivalence class.
- A function $f: A \to B$ can always be decomposed into 
  $$
  A \twoheadrightarrow (A / \sim) \stackrel{\tilde{f}}{\rightarrow} \im f \hookrightarrow B
  $$
  where $\sim$ is defined as $\forall a, b \in \dom{f}, a \sim b \Leftrightarrow f(a') = f(b).$
  The first function maps an element into a set of elements which are mapped to the same value by $f$, and the bijection $\tilde{f}$ does that mapping, and the last function deals with the possibility that $B \neq \im f$.

# Categories: basic definitions

When people say category theory is related to foundation of math, they mean two orthogonal things.
- We can define elementary topoi within category theory, which have internal logics and a topos with desirable properties can be chosen as the foundation of math, and a theory that allows definition of topoi can be chosen as the meta-language.
This looks attractive but goes too far beyond what most working mathematicians do.
Some elementary discussions on the relation between category theory and type theory can be found [here](范畴论.md).
- Terms defined in category theory can be used as a unified language (within an already chosen "foundation") for most interesting math topics, just like all branches of math talk about ordered pairs, structures, etc.
This is what most working mathematicians care about.

To maximize the power of category theory we need to extend ZFC a little bit
because we'll need to talk about "the set of all sets", which strictly speaking is a proper class.
Typically this is done by a conservative extension, like NBG.

A category $\mathsf{C}$ consists of a class $\ob(\mathsf{C})$ called objects and 
for each two objects, a set $\hom_{\mathsf{C}}(A, B)$ called morphisms, and a composition operation $\circ$, such that  
- for all object $A$ of $\mathsf{C}$, there exists at least one morphism $1_A \in \hom_{\mathsf{C}}(A, A)$ such that for all $f \in \hom_{\textsf{C}}(A, B)$, $f \circ 1_A = f$, and for all $f \in \hom_{\textsf{C}}(B, A)$, $1_A \circ f = f$. Note that this implies uniqueness of the identity $\id_A$.
- The composition law is associative.
- $\hom_{\textsf{C}}(A, B)$ and $\hom_{\textsf{C}}(C, D)$ are disjoint unless $A=C, B=D$. Which means if $f \in \hom_{\textsf{C}}(A, B)$, then we know that $f$ is from $A$ to $B$ even when the latter are not specified.

Below we write $f \circ g$ as $fg$,
and omit the $\textsf{C}$ subscript of $\hom$ when it can be inferred.
(One can also modify the definition of a category and inscribe $\textsf{C}$ into all objects, just like how we define disjoint union above.)
When it doesn't cause confusion, $f \in \hom(A, B)$ is written as $f: A \to B$.

Note that $\ob(\mathsf{C})$ and $\hom_{\textsf{C}}(A, B)$ may all be proper classes.
A category is small if $\ob(\mathsf{C})$ and the union of all hom classes are sets and not proper classes.
A locally small category is a category such that for all objects $A, B$, $\hom(A, B)$ is a set.
Most categories we're going to meet are at least locally small.

Examples.
- The category $\textsf{Set}$ has all (ZFC) sets as its objects and functions as its morphisms.
- One can have a graph, and consider all vertices to be objects and all paths from one point to another to be morphisms between the two.

"Equations" in category theory involving long compositions of morphisms are usually depicted as commutative diagrams.
They're just ways to avoid writing confusing long equations.

- $\mathsf{C}^{\text{op}}$ is obtained by swapping all morphisms in $\mathsf{C}$
- subcategory

## Morphisms in a category

- Monomorphisms and epimorphisms are defined as above:
  $f \in \hom(A, B)$ is a monomorphism if and only if for all objects $Z$ and morphisms $\alpha, \beta \in \hom(Z, A)$, 
  $$
  f \circ \alpha = f \circ \beta \Rightarrow \alpha = \beta.
  $$

-   $f \in \hom(A, B)$ is a epimorphism if and only if for all objects $Z$ and morphisms $\alpha, \beta \in \hom(B, Z)$, 
  $$
  \alpha \circ f = \beta \circ f \Rightarrow \alpha = \beta.
  $$
- A split monomorphism is a morphism with a left inverse. A split epimorphism is a morphism with a right inverse.

A split monomorphism is always a monomorphism (trivially).
But a monomorphism is not necessarily a split monomorphism.
Proof: just delete the left inverse of the split monomorphism and some other morphisms and we have a counterexample.

Similarly a split epimorphism is always an epimorphism but an epimorphism is not necessarily a split epimorphism.

- An isomorphism is a morphism that is both a split monomorphism and a split epimorphism.
- A bimorphism is a morphism that is both a monomorphism and a epimorphism.

An isomorphism is always a bimorphism. A bimorphism is not necessarily an isomorphism.

**Theorem** The left and right inverses of a isomorphism $f: A \to B$ are unique and are equal to each other.

**Proof** Because $f$ is a split monomorphism, there exists $g: B \to A$ such that $g f = \id_A$.
Now if $h_1, h_2: B \to A$ are both right inverses of $f$, then
$$
f h_1 = \id_{B} = f h_2 \Rightarrow g f h_1 = g f h_2 = (g f) h_1 = (g f) h_2 \Rightarrow h_1 = h_2.
$$
Therefore the right inverse of $f$ is unique.
Similarly the left inverse of $f$ is unique.

Suppose $g_1, g_2: B \to A$. $g_1 f = \id_A, f g_2 = \id_B$. Then 
$$
g_1 = g_1 \id_B = g_1 (f g_2) = (g_1 f) g_2 = \id_A g_2 = g_2.
$$

Thus there exists a unique $g$ such that $g f = \id_A, f g = \id_B$, which we refer to as $f^{-1}$. □

It immediately follows that

**Theorem** $(f^{-1})^{-1} = f$, $(gf)^{-1} = f^{-1} g^{-1}$.

$A \simeq B$ (read: isomorphic) if and only if there is an isomorphism between them.

## Unique isomorphisms

Suppose $\{T_i\}_{i \in I}$ is a set of objects in a category, in which for any $i, j \in I$,
$\abs{\hom(T_i, T_j)} = 1$ and that unique morphism between the two object is an isomorphism.
The relations between one object in $\{T_i\}_{i\in I}$ - call it $T_1$ - and the rest of the objects in the category can be expressed as a giant commutative diagram,
and it's easy to find that replacing $T_1$ by, say, $T_2$ in this diagram just means renaming of things due to the uniqueness of the isomorphism between $T_1$ and $T_2$.
Due to the definition of a category, $\hom(T_i, B)$ and $\hom(T_j, B)$ are disjoint for different $T_i, T_j$,
which in turn means there exists a set theoretic isomorphism between $\hom(T_i, B)$ and $\hom(T_j, B)$.

To formalize this idea, we pick one object $T \in \{T_i\}_{i \in I}$, and for any object $I$, we define (which overrides the usual definition of function acting on a set)
$$
\hom(\{ T_i \}_{i \in I}, B) = \{ \{h \circ g | T' \in \{ T_i \}_{i \in I}, \text{$g$ is the unique isomorphism from $T'$ to $T$} \} | h \in \hom(T, B) \}.
$$
It's easy to verify that this definition actually does not depend on $T$ and therefore is indeed unique.
Note that 
$$
|\hom(\{ T_i \}_{i \in I}, B)| = |\hom(T, B)|.
$$
$\hom(B, \{ T_i \}_{i \in I})$ can be defined similarly.

More generally, suppose $\{ T_i \}_{i \in I}$ and $\{ S_j \}_{j \in J}$ are both sets of objects, in which two objects are connected by a unique isomorphism, we first pick $S \in \{ S_j \}_{j \in J}$ and $T \in \{ T_i \}_{i \in I}$, and define 
$$
\hom(\{ T_i \}_{i \in I}, \{ S_i \}_{j \in J}) = \{ \{ j \circ f \circ i | S' \in F, T' \in G, \text{$i$ is the unique isomorphism from $T'$ to $T$, $j$ is the unique isomorphism from $S$ to $S'$} \} | f \in \hom(T, S) \}.
$$
Again it's easy to prove that this definition does not depend on $S$ or $T$, and 
$$
\abs{\hom(\{ T_i \}_{i \in I}, \{ S_i \}_{j \in J})} = |\hom(T, S)|.
$$

The results we get above means it's okay to treat $\{T_i\}_{i \in I}$ as a single object,
and we can compute its morphism's composition with other morphisms or count its morphisms towards other objects without any subtlety.

## Functors

Another concept we need is the functor, which basically is a function mapping a category into another, while keeping the property of $\id_A$ and the associative law, that's to say, a functor $F: \mathsf{C} \to \mathsf{D}$ is a function that satisfies the following conditions:
for $A, B \in \ob(\mathsf{C})$ and $f \in \hom(A, B)$,
$$
F(\id_A) = \id_{F(A)},
$$
and for $f \in \hom(A, B), g \in \hom(B, C)$ in $\mathsf{C}$,
$$
F(g) \circ F(f) = F(g \circ f).
$$

# Universal properties 

## Universal properties

Objects linked together by a unique isomorphism can be seen as a single object in categorical language.
This fact inspires us to define concepts like product or coproduct in categorical language only,
and nasty issues - like the difference between $(A \times B) \times C$ and $A \times (B \times C)$ - resolve themselves as working in the categorical language guarantees that we can avoid building any argument on top of their difference.

This eventually leads to an important concept in category theory: universal properties.

Universal properties are properties that can be expressed solely in the language of category theory within the following scheme:

Suppose $F$ is a functor and $\mathsf{C}$ is a category.
Suppose $X$ is an object in $\mathsf{C}$.
A universal arrow from $X$ to $F$ is a pair $(A, u:X \to F(A))$, such that for all $A'$ in $\mathsf{C}$ and $f : D \to F(A')$ in $F(\mathsf{C})$, there exists a unique $h: A \to A'$, such that 
$$
\begin{matrix}
X & \stackrel{u}{\rightarrow} & F(A) & A \\
  & \stackrel{\searrow}{f}    & \downarrow F(h) & \downarrow h \\
  & & F(A') & A'
\end{matrix}
$$
commutes.

Similarly, we can reverse all arrows and define what it means to have a universal arrow from $F$ to $X$.

**Remarks** Here $X$ is the "input" to the universal construction (i.e. $A$ and $B$ when computing $A \times B$).
The "return value" is $A$ and $u$.
$u$ is needed because we need to know how $A$ interacts with the rest of $\mathsf{C}$.
Also, note that there is no guarantee that such universal arrows necessarily exist.
Uniqueness of $h$ is in $\mathsf{C}$ and not $F(C)$.

$(A, u)$ pairs are typically not unique.
This is not surprising, because if $A$ satisfies some universal properties and is unique in satisfying these properties in a category,
then we can always push one object $B$ into that category and draw a single (we can't have more than one isomorphism, or otherwise $X \to B$ morphisms - obtained by composition of the $X \to A$ and $A \to B$ morphisms - won't be unique) isomorphism between $A$ and $B$ and adjust other morphisms accordingly, and then $B$ will also satisfy that universal property.

However, 

**Lemma** if $(A_1, u_1)$ and $(A_2, u_2)$ both satisfy the same universal property from $X$ to $F$,
then they're isomorphic, and there actually exists a unique isomorphism between them.

**Proof** From the uniqueness from $A$ to all $A'$, 
setting $f$ to $u$ and $A'$ to $A_1$, we find that there exists only one morphism from $A_1$ to $A_1$, and it can only be $\id_{A_1}$.
Similarly there is only one morphism from $A_2$ to $A_2$, which is $\id_{A_2}$.

Similarly, setting $f$ to $u_2$ and $A'$ to $A_2$, we find there is a unique $h: A_1 \to A_2$ such that $u_2 = F(h) \circ u_1$, and similarly there is a unique $g: A_2 \to A_1$ such that $u_1 = F(g) u_2$.
Therefore $gh$ is a morphism from $A_1$ to $A_1$, and due to the uniqueness of morphism from $A_1$ to $A_1$ we find $gh = \id_{A_1}$, and similarly $hg = \id_{A_2}$.
From this we find $g$ and $h$ are indeed isomorphisms, and they're unique as discussed above. □


## Counting objects with terminal objects

To illustrate the concept of universal properties, we start with the simplest universal construction: terminal objects.
Here $F$ is trivial and maps $\mathsf{C}$ to a trivial category with one object and one isomorphism,
and the only heavy lifting part in the definition is the uniqueness condition.

**Definition** Let $\textsf{C}$ be a category. An object $I$ of $\textsf{C}$ is *initial*, if and only if for every object $A$ of $\textsf{C}$ there exists a unique morphism $I \to A$.

Similarly, an object $F$ is *final* if and only if for every object $A$ there exists a unique morphism $A \to F$.

**Theorem** Two initial objects are uniquely isomorphic.

**Proof** Suppose $I_1, I_2$ are initial objects.
It immediately follows that 
$$
\hom(I_1, I_1) = \{ \id_{I_1} \}, \hom(I_2, I_2) = \{ \id_{I_2} \}.
$$
Again because they're initial objects, there exists one $f: I_1 \to I_2, g : I_2 \to I_1$.
Since $f g \in \hom(I_2, I_2)$, it has to equal to $\id_{I_2}$, and hence $fg = \id_{I_2}$.
Similarly $gf = \id_{I_1}$.
Therefore $f$ is both a split monomorphism and a split epimorphism and hence is an isomorphism. 
Also note that by definition, $\hom(I_1, I_2)$ has only one element, so $f$ is the *only* isomorphism connecting $I_1$ and $I_2$. □

Similarly,

**Theorem** Two final objects are uniquely isomorphic.

Existence of an initial or final object therefore allows us to almost completely shunning talking about objects, and replace discussions on objects by discussions about $I \to A$ or $A \to F$.
Initial and final objects are known collectively as terminal objects.

**Remark**
Because objects defined using a universal property can be treated as a single object most of the time, based on the discussion above,
we write the equivalence class of all initial objects in a category as $0$,
and write the equivalence class of all final objects in a category as $1$.
This is because for any set, there exists a unique set theoretic function from the set theoretic encoding of the natural number 0 (which is $\emptyset$) to it,
and for any set, there exists a unique set theoretic function from it to the set theoretic encoding of the natural number 1 ($\{\emptyset\}$).

## Products and coproducts

We now generalize the concept of product of sets in category theory.

The intuition behind the definition of a product $A \times B$ is,
if we want to do something to one member of a pair $e \in A \times B$,
we need to take that member out of the pair first.
Therefore this means a commutative diagram like this:

$$
\begin{matrix}
 &  & S & & \\
 & \stackrel{f}{\swarrow} & \downarrow &  \stackrel{g}{\searrow}  \\
A & \leftarrow & A \times B & \rightarrow & B
\end{matrix}
$$

## 

# Relations between categories

