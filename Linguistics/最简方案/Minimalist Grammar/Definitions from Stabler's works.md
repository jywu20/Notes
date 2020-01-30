# Basic definitions of minimalist grammar

The **Minimalist Program** (MP) is a predominant grammar framework currently in the field of syntax research. **Minimalist Grammar** elaborated by Edward Stabler is a formalization of it, providing mathematical rigor description. 

It seems MG does not allow explicit rightward movement. That is problematic because rightward movement exists in many languages.

Also, MG does not have mechanism of deletion.

## Preliminaries

### Grammar
A *grammar* is a specification of a lexicon and generating functions for building complex expressions. That is, a *grammar* $G=(V, Cat, Lex, F)$, where 
- $V$ is a set of non-syntactical features, and
- $Cat$ is a set of syntactic features, and
- $Lex$ is a set of expressions built from $V$ and $Cat$, which is called the *lexicon*, and
- $F$ is a set of functions from tuples of expressions to expressions.

In MG expressions belong to a subcategory of finite binary ordered trees with labels only at the leaves.

The *language* defined by $G$ is the closure of the lexicon under all structure building functions, that is, $L(G)=CL(Lex, F)$.

### Trees

#### $\triangleleft$-relations, that is, parent-child relations
Let $\tau$ be a finite binary ordered tree. For nodes in a finite binary ordered tree we define dominant relations:
- $x \triangleleft y \quad$ x is the parent of y
- $x \triangleleft^+ y \quad$ x properly dominates y
- $x \triangleleft^* y \quad$ x dominates y

The set of leaves $L_\tau$ is $\{x|\neg \exists y (x \triangleleft y)\}$.

#### $\prec$-relations, that is, order relations of nodes in a tree
Since our tree is an ordered one, we can define
- $x \prec y\quad$ x immediately precedes y
- $x \prec^+ y \quad$ x properly precedes y
- $x \prec^* y \quad$ x precedes y

We introduce the assumption that precedence is inherited through dominance:
$$
\forall w, x, y, z, \; x \prec^* y \; \mathrm{and} \; x \triangleleft^* w \; \mathrm{and} \; y \triangleleft^* z \; \rightarrow \; w \prec^* z.
$$

#### $<$-relations, that is, positions of heads in a tree or endocentric structures

An additional relation is added in MG because in every phrase we can distinguish a *head*, therefore, in each level in a syntax hierarchy, one node is closer to the head then another, that is, one node *projects over* the other. For example, in
$$
[_\text{TP} \; \alpha \; [_\text{T'} [_\text{T} \; \beta \;] \; \gamma \;]]
$$
$\text{T'}$ projects over $\alpha$, and $\text{T}$ projects over $\gamma$. We define
- $x<y \quad$ x immediately projects over y
- $x<^+y \quad$ x properly projects over y
- $x<^*y \quad$ x projects over y

We can deduce from the those definitions that
$$
\forall x, \; (\exists y (x \triangleleft y)) \; \rightarrow \; (\exists y \forall z (x \triangleleft z \rightarrow y < z))
$$
Actually here $z$ is unique, so when a node $n$ has a child, there is a unique child that projects over every child of $n$.

#### Properties of MG-derivation tree
Any MG derivation tree can be decided by a set of nodes, parent-child relation, node order and positions of heads, that is, 
$$
\tau = (N_\tau, \triangleleft^*_\tau, \prec^*_\tau, <^*_\tau).
$$

TODO

### Notations

- $t[\mathrm{f}]$ is a tree with the first feature $\mathrm{f}$ at its head.
- $t\{t_1/t_2\}$ is the result of replacing $t_1$ by $t_2$ in $t$
- $t_1^>$ is the maximal projection of the head of $t_1$
- $\epsilon$ is a node with no syntactic or phonetic features

## Definition of MG framework

A *Minimalist Grammar* is a generative grammar with a *Lexicon* and $\mathrm{merge}, \mathrm{move}$ as its generating functions.

*Lexicon* $Lex \subset \Sigma^* \times \{::\} \times F^*$, a finite set of 1-node trees.

### Definition of the vocabulary
*Vocabulary* $\Sigma$ is a set of pairs of phonetic and semantic features; $\Sigma = P^* \times I^*$.

*Phonology features*: $P = \{\text{/marie/}, \text{/speaks/}, \ldots\}$.

*Interpreted or semantic features*: $I = $\{\text{(marie)}, \text{(speaks)}, \ldots\}$.

The shorthand $\text{word}$ is introduced to stand for $\text{/word/}\text{(word)}$.

*Types* $T = \{::, :\}$, where "::" means the item is lexical and ":" means the item is derived;

### Definition of syntactic features
Each entry in the lexicon have a series of *syntactic features* , which can be grouped into four types:
- C, T, D, N, C, P, ..., which are selected categories or base categories - they correspond to the ordinary concept of parts of speech;
- =C, =T, =D, ..., which are selector features;
- +wh, +case, +focus, which are licensors;
- -wh, -case, -focus, which are licensees.

The second to fourth types of categories represent three ways of selecting a constituent from one category in the first type.

#### Selectors
$\text{=n}$ indicates the simple selection of a noun phrase;

$\text{=N}$ indicates that a noun phrase is selected and the phonetic features of the head of the noun phrase are moved to be suffix to the sequence of phonetic features of the selecting head;

$\text{N=}$ indicates a noun phrase is selected and the phonetic features of the head of the noun phrase are moved to be prefixed to the sequence of phonetic features of the selecting head.

$select = \{=x, =X, X=\ | x \in base\}$

#### Licensees
In a movement, a head assigns a feature +f to a -f constituent that moves *covertly* to its specifier, or else a feature +F is assigned to a -f constituent that moves *overtly* to its specifier.

Licensees are features attached to constituents that may be moved.
$$
licensees = \{-\text{case}, =\text{wh}, \ldots\}
$$

Licensors are features attached to heads that may select one constituent and move it. They are triggers of phrasal movement.

$$
licensors = \{+\text{case}, +\text{CASE}, +\text{wh}, +\text{WH}, \ldots\}
$$

=X, X=, +X features are sometimes called strong features because they cause phonetic material to move along with the affected syntactic features. The strong-weak distinction provides information for how much structure moves along with the features that are canceled by the structure building rule.

#### Label
Features of non-leaf nodes in a parsing tree in MG such as NP, V' or something like these can be automatically computed and thus providing no additional information, therefore only leaf nodes should be labeled.

The set of all labels is $select*(licensors)select*(base)licensees*P*I*$.

### Generating functions
$$
\mathrm{merge}(t_1[=\mathrm{f}], t_2[\mathrm{f}]) = \left\{
    \begin{aligned}
        [< t_1 t_2], &\text{if} \;t_1 \; \text{has exactly 1 node}, \\
        
    \end{aligned}
\right.
$$

### What can be obtained from a MG
*Expressions* $E$ is a set of trees with non-root nodes and leaves with the form of $\Sigma^* \times T \times F^*$;


## MG with phonetic features

## Equivalence with generative tradition

X-Bar and so on.

## Notes on expressivity of MG

Can any natural language's grammar be written in a MG formalization?