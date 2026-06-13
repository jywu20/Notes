Isabelle, and Isabelle/HOL
===========

# The HOL theory

The relation between HOL - Higher Order Logic, in its modern sense - and (classical) CIC and set theory has been discussed [here](Why%20Lean.md).
Long story short, HOL (with axioms of infinity and choice) is equivalent to Mac Lane set theory, in terms of proof theoretic strength and consistency,
and hence is a good foundation of concrete mathematics.

# LCF

Historically HOL had been implemented in HOL4 and HOL Light, 
both of which are LCF (logic of computable functions) provers.
A LCF system is a pluggable logic system, which serves the infrastructural role of e.g. natural deduction or sequent calculus;
in this way a LCF system is a *meta-logic*, in which mathematicians define *object logics*.
Although note that if the LCF system is to be considered as a meta-theory,
it's typically very weak, and proves nothing interesting about the object logic;
in a serious metatheoretic analysis of the resulting logic system (about e.g. proof theoretic strength),
perhaps the LCF infrastructure (the *kernel*) and the object logic should be analyzed together.

What makes LCF different from "ordinary" logical frameworks like natural deduction based on $\frac{A}{B}$ is that this infrastructure is within a functional programming language:
$\Gamma \vdash \phi$ is translated into "$\phi$ can be constructed in type $\mathsf{thm}$ using pre-declared components in $\Gamma$",
and a rule of inference has the type of $\mathsf{thm} \to \cdots \to \mathsf{thm}$. 
If the input arguments don't allow the rule of inference to conclude anything, typically an error is thrown.

One advantage of this approach is its incremental nature:
if a bug appears, it's either a bug in implementation of the LCF kernel, 
or a bug in encoding of the object logic.
And it's always easier to make a small kernel highly trusted.

Encoding of logic into LCF differs from Curry-Howard correspondence.
In the former, a proposition is a term *only*, and not a type:
that a proposition is proven doesn't not correspond to any proof term;
by default, no term in the prover "memorizes" the whole proof tree.
This does not need to be the case in Curry-Howard correspondence,
in which proofs are just terms can be engineered.
That said, if we have proof irrelevance, a proof term is nothing more than a "label" for the proposition it proves,
and therefore for users, LCF and C-H correspondence no longer has any "theoretical" difference,
and the main difference is implementational and technical,
with proof checking in LCF being at runtime and proof checking in C-H correspondence being at compilation.

# Peculiarities of Isabelle: weakened HOL as meta-logic

HOL4 and HOL Light use ML programming languages as the meta-logic.
Despite having some components *implemented* in ML, Isabelle's meta-logic is not ML, but Isabelle/Pure.
Interestingly, Isabelle/Pure essentially is a segment of HOL;
it is actually an intuitionistic logic, but this doesn't matter, as it's not supposed to be used to prove anything other than what can be proven in the object logic.

Isabelle/Pure has only three primitives in term building: $\Lambda x:A. P(x) : A \Rightarrow B$, $\equiv$, and $A \Longrightarrow B: \mathsf{prop}$.
Note that $\Rightarrow$ is for defining function signatures and $\Longrightarrow$ defines a term that is propositional.
It's not hard to see how $\Lambda$ and $\equiv$ are used to encode rules of inference.
Propositions in an object logic therefore should all be encoded into $\mathsf{prop}$.
In HOL, a term with type $\mathsf{prop}$ is propositional and participates in logic reasoning.
Note that in standard HOL, if $\phi : \mathsf{prop}$, then $\phi$ being proven does not correspond to $\Gamma \vdash t : \phi$, and just $\Gamma \vdash \phi$. 
This behavior can again be reproduced by assuming proof irrelevance as $\Gamma \vdash \phi$ has nothing different from $\Gamma \vdash \_ : \phi$, and LCF essentially is moving type checking of a term allegedly with the type $\phi$ out from the type system; see [here](Why%20Lean.md).
The correspondence between proposition $\phi$ and the typed term $\phi : \mathsf{prop}$ is for defining predicates as terms in HOL.

# Recovering the power of HOL

Now how HOL should be embedded into Isabelle/Pure?
Intuitively one may want to modify the behaviors of $\mathsf{prop}$ and $\Longrightarrow$, but this won't work.
This is partly because the semantics of $A \Longrightarrow B$ is supposed to be a rule of inference and not a "if-then" proposition,
and partly because modifying the behaviors of these things destroy the separation between the highly trusted meta-logic kernel and pluggable object logics.
Instead, we define a new $\mathsf{prop}$ - known now as $\mathsf{bool}$ with a true value and a false value,
and $\rightarrow$ is introduced as an abstract function $(\rightarrow) : \mathsf{bool} \Longrightarrow \mathsf{bool} \Longrightarrow \mathsf{bool}$.
These are axiomatic and have no true definitions. 
The price of this is $A \to B$ is now a non-propositional term,
and therefore in order to turn it into a $\mathsf{prop}$,
we need an additional axiomatic function $\mathsf{Trueprop}$.

We emphasize that $\mathsf{bool}$ and $\mathsf{prop}$ live in *the same type space*.
Indeed this is how we're able to write $\mathsf{Trueop} : \mathsf{bool} \Longrightarrow \mathsf{prop}$.
Similarly, Isabelle/Pure terms and Isabelle/HOL terms live in the same *term* space.
In this way, saying that Isabelle/Pure is a meta-*language* may be a little misleading,
as in classic metamathematics, propositions of an object language are often encoded as strings or numbers in the metalanguage,
but Isabelle/HOL terms are *not* encoded into a single `HOLTerm` type in Isabelle/Pure.

# Non-HOL logics encoded in Isabelle

A list of logics available in Isabelle can be found in its documentation.
Mizar can also be implemented within [Isabelle](https://link.springer.com/article/10.1007/s10817-018-9479-z),
although the TG set theory behind Mizar is the strongest among underlying calculi of all mainstream proof assistants. 

# Type definitions in HOL

We emphasize that any definition in Isabelle/Pure is axiomatic,
in that Isabelle/Pure gives us no way to define new types without risking extending the strength of the system.
Instead, HOL is *supposed* to support definitions, i.e. introduction of new concepts into the system in a predefined way that is known to be conservative.
But then notice that types provided by Pure and HOL - now a package containing axiomatic definitions in Pure - live in the same space,
and hence there's no primitives for defining things in Isabelle/HOL either.

Actually, keywords like `datatype` are implemented in the ML part of Isabelle/HOL:
different logics have different front-end layers translating definitions into the object logics.

Similarly, saying that "theorem $A \to B$" holds is actually saying theorem $\mathsf{Trueprop (A \to B): \mathsf{prop}}$ holds.

These procedures are yet another layer over the object logic.

# Isar

There's also another component in Isabelle's system: Isar, a proof language that allows users to write proofs in the style mathematicians use everyday,
and not the purely tactic-based style.
Isar is ignorant to object logics and is built directly on top of Isabelle/Pure, but it interacts with logic-specific ML front-end packages that give us `datatype` etc. perfectly:
type definitions never appear in Isar, and proofs don't appear in type definitions.

# Type classes and locales 

One thing very good about Lean (and other dependently typed programming languages)
is you're able to define a mathematical *structure* - like a group structure (not to be confused with `struct`s, although with dependent types they're related) that contains properties:
because proofs are terms of propositions,
the fact that the multiplication operation of a group has associativity can be treated just like an ordinary member of the group structure.

To achieve the same in Isabelle one needs so-called *locales*.
This is not a math term but a term in Isar.
A locale is literally just a predicate containing constraints between the arguments,
but it has a system of auxiliary functionalities and automation built around it 
(see [here](https://lawrencecpaulson.github.io/2022/03/23/Locales.html)).
Type classes are claimed to be implemented as a special case of locales in the article (Constructive Type Classes in Isabelle).
