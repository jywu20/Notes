Isabelle, and Isabelle/HOL
===========

# The HOL theory

## Why HOL: its relation with weak set theories

The HOL formalism has been documented [here](https://hol-theorem-prover.org/docs/trindemossen-2/Logic/syntax).
The formalism looks reasonable for someone trained in elementary mathematics,
perhaps more reasonable than ZFC:
we have "individuals" i.e. "dots" to represent abstract mathematical objects whose internal structures we're not interested in,
and we have true and false and also equality,
on top of which we can build functions and prove things about them.
But the actual strength of this intuitive environment is not per se intuitive.

We note that unlike Coq and many other dependent type provers,
HOL is classical, just like Lean, which has a constructivist core calculus but its ecosystem has been built on top of classical axioms.
A brief summary on why a classical logic is preferable in formalizing ordinary mathematics can be found in arXiv 1804.07860.

The relation between HOL - Higher Order Logic, in its modern sense - and (classical) CIC and set theory has been discussed [here](Why%20Lean.md).
Long story short, HOL (with axioms of infinity and choice) is equivalent to Mac Lane set theory, in terms of proof theoretic strength and consistency,
and hence is a good foundation of concrete mathematics.

A rather unfortunate fact is most introductory materials of HOL (and indeed most other provers) 
do not specify the metamathematic status of the underlying calculus they use.
Thus in this article, we start with a discussion about the strength of HOL.

Papers regarding the equivalence between HOL and MAC set theory, that is, Zermelo set theory with only bounded separation:
-  Weak Systems of Set Theory related to HOL, Thomas Forste, which explicitly constructs mutual interpretations between HOL and TST
- Comparing Type theory and set theory, John Lake, Mathematical Logic Quarterly 21 (1):355-356 (2010), which shows that if TST (with Inf, or Inf+AC) has a model, then so is MAC (MAC + Inf, MAC + Inf + AC).
  It calls MAC Z0. 

It's easy to interpret a type theory in a set theory. Just give everything a tag.
It is much more difficult to give a set theory a type theoretic interpretation.
In order to interpret MAC in HOL, 
it is sufficient to first construct a model of MAC(+Inf) based on a model of TST(+Inf),
and then construct a model of TST in a model of HOL.
Further we need to interpret TST in HOL.

The second step is straightforward.
Type 0 of TST is interpreted as any type we please in HOL, and type $n+1$ is interpreted as type $\alpha \to \mathsf{bool}$ where $\alpha$ is the HOL type that interprets TST type $n$.

The first step is much harder.
The issue essentially is that we're *not* supposed to interpret the set theoretic universe as a single type (which is not possible as this requires HOL to prove the consistency of MAC).

Suppose we have a model $M$ of TST, in which $D_n$ is the collection of objects of type $n$,
and $\in_n \subseteq D_n \times D_{n+1}$.
Each type $n+1$ object $y \in D_{n+1}$ is a subset of $D_n$.
Now, obviously, it is possible to embed $D_n$ into $D_{n+1}$, as for each element $x \in D_n$, set comprehension $\{ y | y = x \}$ is of type $n+1$.
And obviously there exists a mapping from objects in $n+1$ of the form $\{ y | y = x \}$ back to $D_n$.
In this way we get an equivalence relation $\sim$ spanning all type levels.

Now we attempt to construct a model of MAC in $V = \bigcup_{n} D_n / \sim$.
All elements of $V$ are equivalence classes. Suppose $[x], [y] \in V$, where $x$ and $y$ are in certain TST types $D_i$ and $D_j$.
We say $[x] \in^* [y]$, if and only, there exists $x' \sim x$, $y' \sim y$, such that $x' \in_n y'$ for some $n$ in the original model $M$ of TST.
(Here we use $\in$ is in meta theory, $\in^*$ in the model of MAC, and $\in_n$ in the model of TST.)

Now we can check whether all axioms of MAC hold for $(V, \in^*)$. Extensionality holds trivially. 
The axiom of infinity can't be proven out of purely logical principles of HOL and has to be derived by inserting an axiom of infinity into HOL, an instance of which can be found [here](#how-hol-is-defined-in-isar).
The existence of an empty set is guaranteed by existence of an empty set in $D_1$.
Pairing between $[a]$ and $[b]$ can be done by finding two representatives $a', b'$ in the same type $n$ and do pairing in TST there, and the equivalence class of the result is just $\{[a], [b]\}$.
Union and powerset can be done similarly by just moving up and down in the type hierarchy.

What is interesting - and also what makes TST intuitively equivalent to MAC, and not full Zermelo - is how the Axiom of Separation is proven.
Suppose we have an element $A = [a]$ in $V$, and a bounded formula $\varphi$ which contains variables $x, y_1, \ldots, y_n$,
where all $p_i$ variables are introduced by a quantifier followed by $p_i \in A_i$,
where $A_i = [a_i]$ are all elements of $V$.
It's not hard to see that $\varphi$ can always be translated into a formula in TST,
because when we say $\forall X \in A_i, \ldots$, the type of the lowest representative $x$ such that $X = [x]$ is inferrable from the type of the lowest representative $a_i$ such that $A_i = [a_i]$, and hence $\forall X \in A_i, P(X)$ is just another way to say $\forall x : (n-1) (x \in_{n-1} a_i \to P'(x))$, where $P'$ can be derived from $P$ by recursively applying this kind of $V^*$-to-$D_n$ transition.
On the other hand, in an expression like $\forall X, \ldots$,
we do not know what type the lowest representative of $X$ is, so it's not possible to translate this formula to TST.

Replace $D_n$ in the construction above by the interpretation of $(\cdots((T_0 \to \mathsf{bool}) \to \mathsf{bool}) \to \cdots \to \mathsf{bool})$,
and we have already constructed a model of MAC in a model of HOL+Infinity.

In conclusion, HOL+Infinity is equi-interpretable with MAC, i.e. bounded Zermelo.

According to Lake, HOL+Infinity+Choice is also equi-interpretable with MAC+Choice.
What kind of Choice axiom we're using involves some subtlety.
The Axiom of Choice used in Isabelle/HOL can be found [here](#how-hol-is-defined-in-isar) 
and it gives us type-level choice in TST - which means in a model of HOL+Infinity+Choice we're able to construct a model of MAC+(ordinary) Choice.

Henceforth, unless mentioned otherwise, "HOL" just means HOL+Infinity+Choice.
This means HOL is not an ideal foundation of mathematics pertaining to logicism a la Russell,
as it contains *substantial* axioms, namely Infinity and Choice and is not pure logic.
(Interestingly, Lawrence Paulson mentions this in his paper arXiv 1804.07860.)

Note: to ensure that Choice can be implemented simply as `SOME t`,
we typically demand all types in HOL to be non-empty.
This does not hinder our attempt to construct a model of MAC in a model of HOL,
as what is conceived as an empty set in the model of MAC is the equivalence class of a predicate that always returns `false`,
which is not of an atomic type $a$ but of type $a \to \mathsf{bool}$.

## Why MAC, then?

Given that ZFC+countable inaccessible cardinals is the naive reaction of ZFC-based mathematicians to the rise of category theory (in which we want a category of all sets, but once this is definable, we also want a category containing small sets in $\mathsf{Set}$ and larger sets that we can define by newly introduced axioms about $\mathsf{Set}$,
so eventually we need a series of universes, each larger than the previous one).
One may wonder why the much, much weaker theory of MAC is a decent choice for formalizing everyday mathematics.

The consistency strength of bounded Zermelo set theory [happens to be a quite natural one](https://mathoverflow.net/questions/498078/what-is-the-consistency-strength-of-russell-whiteheads-principia-mathematica).
But this level of consistency strength perhaps is already enough to formalize all undergraduate mathematics *deemed valuable by the very authoritative guys in mathematics*.

In an article named [The Ignorance of Bourbaki](https://link.springer.com/epdf/10.1007/BF03025863?sharing_token=0CFKROkKerGClxdlDdz4ffe4RwlQNchNByi7wbcMAY4dt4oIuuMYWHjvdiI7ujvJzAWGFM1v3erzW4ZGAECcvzyFlgPQnRhe4yFHPa43a2AihK3rSNmHvUv391pkzYuCMEqvRwsuzfWM2ubqK6hEsg%3D%3D),
Mathias criticizes the Bourbaki group for ignoring Godel's incompleteness theorem and hence modern mathematical logic (and in general, the ignorance of French mathematicians at that time, even in 1948; an issue Mathias attributes to their intellectual nationalism and also an unwillingness to give up a naive view of logic and foundation of mathematics),
and also points out that the foundation of mathematics the Bourbaki group used is essentially Zermelo set theory + Choice (which is explicitly considered a decent foundation theory in "The foundations of mathematics for the working mathematician"),
which fails to capture all mathematics, contrary to what Bourbaki insisted.
This foundation for instance is unable to provide us with general transfinite recursion and also fails to host ordinal arithmetic,
both of which David Hilbert held dear ("no one should expel us from the paradise that Cantor has created for us").
He attributes Bourbaki's indifference towards this part of mathematics to an attitude that can be described as de-emphasizing "arithmetic" and focusing solely on "geometry".
Mathias also observes that MacLane has almost an identical attitude on this matter to that of Bourbaki.

Mathias talks about Bourbaki and MacLane's view of mathematics in a dismissive manner.
If one, however, is willing to accept the Bourbaki view of mathematics,
then HOL should be a good foundation of mathematics for them.
This is explored by Paulson, an early developer of Isabelle, [here](https://lawrencecpaulson.github.io/2022/01/26/Set_theory.html),
and my feeling reading his blogpost is that he's perhaps much closer to the very important guys who Mathias despises.

Back to Bourbaki. To their credit, [there is a brief mentioning of Godel about the impossibility to prove consistency of a system in itself](https://math.stackexchange.com/questions/929303/is-the-bourbaki-treatment-of-set-theory-outdated).
Although, as one person in the discussion thread notices, Bourbaki's Set Theory's most important purpose is perhaps to prove existence of things.
The notation of his Set Theory is terrible (but well-defined and in principle can be implemented without confusion in a proof assistant, with even a system of weight to decide the associativity order).
The actual theory of sets he adopts starts at chapter 2.
The axioms he gives include the follows (in the same order): extensionality, axiom of pairing, axiom of ordered pairs (not necessary, as we have ${a, {a, b}}$), power set, infinity.
(A list can be found at the end of the book.)
Because the first chapter of the book builds logic on top of Hilbert's $\epsilon$-calculus
they also have the Axiom of Choice as a theorem.
A strange choice, though not without merit, [as it is a smart way to get Choice, first-order logic and bound variables at once](https://mathoverflow.net/questions/14356/bourbakis-epsilon-calculus-notation).

The Axiom of Replacement is indeed nowhere to be found (something noticed mentioned by comments in the discussion thread above). 

This doesn't mean claims of Bourbaki's set theory is more or less equivalent to ZFC purely misinformation.
Because of $\epsilon$-calculus being stronger than ordinary first-order logic,
it is possible to prove all the axioms of ZFC except the Axiom of Regularity within their system,
which is done in On Bourbaki’s axiomatic system for set theory by Maribel Anacona, Luis Carlos Arboleda, and F. Javier Pérez-Fernández.
Moreover, they have proven that it's also possible to interpret the Bourbaki system within ZFC minus Regularity.
Because Bourbaki doesn't use any ill-founded set, 
perhaps it makes no substantial difference to just add Regularity as one of his axioms.

Therefore we should perhaps not be surprised to see that in his Theory of Sets,
transfinite induction is indeed mentioned,
which is not possible in Zermelo alone.
So the absence of Axiom of Replacement in the list of axioms Bourbaki considered necessary perhaps is more a misunderstanding,
as the underlying logic framework assumed in his work is not ordinary first-order logic.

This seems to weaken the claim that HOL is enough for formalizing concrete mathematics.
It remains to be seen how much Replacement is used in the subsequent Bourbaki volumes.

## Relation with the type theory of Lean

Conceptually we can derive HOL by applying constraints to classical Lean:
see [here](https://news.ycombinator.com/item?id=14744167)
and [here](https://www.reddit.com/r/ProgrammingLanguages/comments/1aigns2/comment/koxkfhw/).
In the same way MAC+Choice is a fragment of ZFC+countable inaccessible cardinals.
(But note that HOL is extensional, while Lean is not.
So there are differences in how equality is treated, although this does not influence consistency strength and interpretability.)

So we have a hierarchy: HOL < ZFC < classical Lean.
ZFC gains its popularity largely because of its meta-mathematics properties.
It's weak for category theorists if they're to be taken literally,
and overly strong if one wants to ignore Mathias's advice.

The main disadvantage of HOL, when it comes to strength, is that it's not possible to use universes in HOL without additional axiomatization.


## Further enrichments

In Isabelle/HOL, both parametric polymorphism and ad hoc polymorphism have been introduced into HOL.
The parametric polymorphism mechanism adopted is basically let-polymorphism and is conservative in the sense that it can be "compiled away",
just like C++ templates (perhaps I should say Hindley–Milner style polymorphism).

Ad hoc polymorphism is realized by type classes.
In dependent type theories like Lean, a type class is merely a record with a type parameter that lists the mathematical structure of the type (multiplication operation, and its properties, for instance).
Because Isabelle is not dependently typed,
type classes are somehow considered constraints imposed on types (like how it's done in Haskell).

This is handy (for defining +, or `0`), but has a history of bringing inconsistency!
See A Consistent Foundation for Isabelle/HOL by Ondřej Kunčar, Andrei Popescu.
The question then comes whether the system after the modifications merely undergoes a conservative extension.
The issue, together with the issue of making definitions in a safe way in general,
is then discussed in  Safety and conservativity of definitions in HOL and Isabelle/HOL by Ondřej Kunčar, Andrei Popescu 
and  Proof-Theoretic Conservative Extension of HOL with Ad-hoc Overloading by Arve Gengelbach and Tjark Weber.

Other conservative extensions include `typedef` (defining new types based on a set, i.e. a predicate), `datatype` (which enables inductive), and the like. All these are conservative. 

How all the conservative extensions are introduced will be discussed [later](#conservative-extensions).
The governing philosophy of the HOL community is to avoid extending the consistency strength of HOL at any cost.
In [Paulson's own words](https://lawrencecpaulson.github.io/2025/11/02/Why-not-dependent.html),
"we have to choose whether to spend our time developing formalisms or instead to choose a fixed formalism and see how far you can push it." 

## Implementations

Due to lack of Curry-Howard correspondence, implementation of HOL typically needs to be done in a simpler calculus for stating theorems, giving assumption names, storing proofs somewhere, etc.
(The benefit of the proof-as-term concept, when we work with classical logic, is when $x:T$ and $T : \mathsf{Prop}$, $x$ basically becomes a label for $T$, and we get all housekeeping mechanisms for free.)

The HOL prover family traditionally relies on the LCF architecture, to be discussed in the next section.

There is also a recently developed [Acorn project](https://github.com/acornprover/acorn),
which, according to the author, is [also based on HOL](https://www.reddit.com/r/math/comments/1ic9ifz/comment/m9ppds4/).

# The LCF-style Isabelle prover

## The LCF architecture

Historically HOL had been implemented in HOL4 and HOL Light, 
both of which are LCF (logic of computable functions)-style provers.
The term LCF initially meant what it means literally, that is, a logic system that has computable functions in it and also allows us to say something about the functions.
Later, due to how the original LCF was implemented, the term was used to refer to a certain architecture style of proof assistants.

A LCF system is a pluggable logic system, which serves the infrastructural role of e.g. natural deduction or sequent calculus;
in this way a LCF system is a *meta-logic*, in which mathematicians define *object logics*.
Although note that if the LCF system is to be considered as a meta-theory,
it's typically very weak, and proves nothing interesting about the object logic;
in a serious metatheoretic analysis of the resulting logic system (about e.g. proof theoretic strength),
perhaps the LCF infrastructure (the *kernel*) and the object logic should be analyzed together.

What makes LCF different from "ordinary" logical frameworks like natural deduction based on $\frac{A}{B}$ is that this infrastructure is within a functional programming language:
$\Gamma \vdash \phi$ is translated into "$\phi$ can be constructed in type $\mathsf{thm}$ using pre-declared components in $\Gamma$",
and something like $\phi_1, \phi_2, \ldots, \phi_n \vdash \psi$ is encoded into a term with the type $\mathsf{thm} \to \cdots \to \mathsf{thm}$. 
If the input arguments don't allow the rule of inference to conclude anything, typically an error is thrown.

One advantage of this approach is its incremental nature:
if a bug appears, it's either a bug in implementation of the LCF kernel, 
or a bug in encoding of the object logic.
And it's always easier to make a small kernel highly trusted.
Anyone with experience writing symbolic code knows it's very easy to write buggy code,
and the LCF architecture means the codebase we have to trust is as small as possible.

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

And here comes the second advantage of LCF:
it serves logics that do not rely on Curry-Howard correspondence well.
Without C-H, we need to manually build infrastructures like labels for statements, interfaces for external programs to engineer proofs, etc.
and all these naturally lead to the need for a meta-logic.

## Peculiarities of Isabelle: weakened HOL as meta-logic

HOL4 and HOL Light use ML programming languages as the meta-logic.
Despite having some components *implemented* in ML, Isabelle's meta-logic of object logics is *not* ML, but something called Isabelle/Pure.
In this way Isabelle deviates from traditional LCF provers in that it has a minimal kernel of logic as well,
and not just a minimal kernel of logic *checker*.

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

Isabelle/Pure has no type definition mechanism.
Any type definition ( `typedecl` keyword with `judgment` and `axiomatization` statements describing its behaviors) is axiomatic, and should be considered as a part of the definition of the object logic.
Actually even term definitions in it look like axioms, although the design of Isabelle makes sure they're conservative.
A new symbol is introduced by `consts`, like `consts a :: t => t`, where `t` is a type already defined.
Then a lambda expression in the form of `defs f x ≡ g x + 1` can be done.
See [more discussions here](#introducing-conservative-extensions).

The meta-language used to define Isabelle/Pure is ML;
the meta-language used to define object logics is Isabelle/Pure.
Therefore $\phi_1, \ldots, \phi_n \vdash \psi$ *in the object logic* is encoded as $\Lambda x_1 \cdots \Lambda x_n (\phi_1 \Longrightarrow \phi_2 \Longrightarrow \cdots \Longrightarrow \psi)$,
while each of $\phi_i$ or $\psi$ can have internal structures like $\forall y_1 (P \to Q)$.
The transition between $\Lambda x_1 \cdots \Lambda x_n (\phi_1 \Longrightarrow \phi_2 \Longrightarrow \cdots \Longrightarrow \psi)$ and $\forall x_1 \forall x_2 \cdots \forall x_n (\phi_1 \to \cdots \phi_n \to \psi)$ is only possible with user-defined rules written in the definition of the object logic.
On the other hand, $\Lambda x_1 \cdots \Lambda x_n (\phi_1 \Longrightarrow \phi_2 \Longrightarrow \cdots \Longrightarrow \psi)$ in Isabelle/Pure is *not* identical to $\phi_1, \ldots, \phi_n \vdash \psi$ *in Isabelle/Pure*, not in the eyes of the ML meta-logic used to encode Isabelle/Pure, and the transition between the two has to be enabled by moves allowed by the ML kernel that implements Isabelle/Pure.
This double-layered structure looks confusing but thanks to the simplicity of Isabelle/Pure, automation eases the burden to translate across layers.

Note that one benefit of having Isabelle/Pure as the meta-logic is there is no need for the designer of an object logic to take time to get things like variable binding and scope right.
The big lambda has done it once and for all.

An interesting thing is, Isabelle/Pure seems to support much more than sequents ($\phi_1 \Longrightarrow \cdots \Longrightarrow \phi_n \Longrightarrow \psi$) and rules of inference ($(\cdots \Longrightarrow \cdots) \Longrightarrow (\cdots \Longrightarrow \cdots) \Longrightarrow \cdots \Longrightarrow (\cdots \Longrightarrow \cdots)$, used together with beta-reduction):
there is no limit on how many layers of embedded arrow types there are.
Thus, it is actually much stronger than a platform encoding sequent calculus or natural deduction.
These higher rank arrow types aren't used frequently in formalizing "ordinary" logics.
They definitely aren't needed in formalizing HOL.
Their proper use is meta-programming about rules - but this is something more properly done by writing ML extensions.
Perhaps the main reason to have such a strong logical framework - though an incredibly weak meta *theory* - is just to make the prover looks conceptually uniform.

## Recovering the full power of HOL

Now how HOL should be embedded into Isabelle/Pure?
Intuitively one may want to modify the behaviors of $\mathsf{prop}$ and $\Longrightarrow$, but this won't work.
This is partly because the semantics of $A \Longrightarrow B$ is supposed to be a rule of inference and not a "if-then" proposition,
and partly because modifying the behaviors of these things destroy the separation between the highly trusted meta-logic kernel and pluggable object logics.
Indeed, the way Isabelle/Pure is implemented does not allow any direct modification of $\mathsf{prop}$ and $\Longrightarrow$ at all.

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

It can be seen that what Isabelle/Pure gives to HOL is actually making it possible to write a sequent $\phi_1, \ldots, \phi_n \vdash \psi$ for HOL, in the form of $\Lambda x_1 \cdots \Lambda x_n (\phi_1 \Longrightarrow \phi_2 \Longrightarrow \cdots \Longrightarrow \psi)$.
See the discussion in the last section.

## Non-HOL logics encoded in Isabelle

A list of logics available in Isabelle can be found in its documentation.
Mizar can also be implemented within [Isabelle](https://link.springer.com/article/10.1007/s10817-018-9479-z),
although the TG set theory behind Mizar is the strongest among underlying calculi of all mainstream proof assistants.
(Another implementation of TG can be found [here](https://github.com/kappelmann/Isabelle-Set/).) 

## Introducing conservative extensions 

We emphasize again that most definitions in Isabelle/Pure are axiomatic,
in that Isabelle/Pure gives us no way to define new types without risking extending the strength of the system.
However, Isabelle/HOL is *supposed* to support definitions, i.e. introduction of new concepts into the system in a predefined way that is known to be *conservative*.
But then notice that in the process of embedding HOL into Isabelle/Pure, we have only utilized `typedecl`,
and have never introduced any primitives for making (conservative) definitions in Isabelle/HOL. 

Thus, keywords like `datatype` that allow us to make (conservative) definitions
are implemented in the *ML* part of Isabelle/HOL, and *not in Pure*:
the architecture of Isabelle allows users to enrich the syntax,
and different object logics have different front-end commands that are translated to primitive provided by the corresponding logics behind the scene.
We overview these syntactic extensions [here](#conservative-extensions).

Similarly, in Isabelle/HOL, saying that "theorem $A \to B$" holds is actually saying theorem $\mathsf{Trueprop (A \to B): \mathsf{prop}}$ holds.

These procedures are a syntactic sugar layer over the layer of the object logic.
It's possible to have buggy code in this layer too that misleads readers of a proof to believe something has been proven,
although what is proven behind the scene is something different.

Actually it is also possible to have a syntactic sugar layer over the layer of Isabelle/Pure.
The `definition` command for instance is not a primitive in Isabelle/Pure.
It appears that if a command is not a primitive,
then if you move your mouse cursor over it in the webpage view of Isabelle's library,
and the command gets highlighted, then it's not primitive.
It's not hard to find some commands obviously targeting Isabelle/Pure that get highlighted.

# Isar

There's also another component in Isabelle's system: Isar, a proof language that allows users to write proofs in the style mathematicians use everyday,
and not the purely tactic-based style.
Isar is ignorant to object logics and is built directly on top of Isabelle/Pure, 
but it interacts with logic-specific ML front-end packages that give us `datatype` etc. perfectly,
as Isar is mostly about having a disciplined way to write Isabelle/Pure code and does not interfere with anything in the object logic.
Almost every line of code users of modern Isabelle write is in the Isar framework.

Thus the architecture of Isabelle ecosystem is like this.
1. A trusted core implementing Isabelle/Pure in the LCF way, written in ML.
2. Definition of object logics, like Isabelle/HOL or Isabelle/ZF, written in Isabelle/Pure. 
3. Tactics for constructing backward proofs, written in ML. Note that a lot of these tactics are not object logic-dependent, especially the primitive proof tactics. Automation tactics on the other hand are often heavily tuned to a specific object logic. A lot of them don't need to be used with Isar in theory.
4. Commands like `typedef` or `datatype`, written in ML, developed both for Isabelle/Pure and for object-logic-specific packages.
5. The Isar user interface, providing commands like `theorem`, `proof`, `qed`, and the like, written in ML and is not logic-specific.

Below we go over each part of Isar, hence focusing mainly on the logic-independent parts.

## Defining an object logic: HOL as an example

Below we present some code snippets about how HOL is defined using Isar notation.

The main body of HOL's rules of inferences is defined in [theory `HOL`](https://isa-afp.org/browser_info/current/HOL/HOL/HOL.html).
The file starts with a long list of ML file imports,
but let's focus on the core logic first.

```Isabelle
typedecl bool

judgment Trueprop :: "bool ⇒ prop"  (‹(‹notation=judgment›_)› 5)

axiomatization implies :: "[bool, bool] ⇒ bool"  (infixr ‹⟶› 25)
  and eq :: "['a, 'a] ⇒ bool"
  and The :: "('a ⇒ bool) ⇒ 'a"

definition True :: bool
  where "True ≡ ((λx::bool. x) = (λx. x))"

definition All :: "('a ⇒ bool) ⇒ bool"  (binder ‹∀› 10)
  where "All P ≡ (P = (λx. True))"

definition Ex :: "('a ⇒ bool) ⇒ bool"  (binder ‹∃› 10)
  where "Ex P ≡ ∀Q. (∀x. P x ⟶ Q) ⟶ Q"

definition False :: bool
  where "False ≡ (∀P. P)"

axiomatization where
  impI: "(P ⟹ Q) ⟹ P ⟶ Q" and
  mp: "⟦P ⟶ Q; P⟧ ⟹ Q" and

  True_or_False: "(P = True) ∨ (P = False)"
```
These rules perhaps do not need any explanation,
and are just materialization of the idea [here](#recovering-the-full-power-of-hol).

---

Hilbert Choice is introduced [here](https://isa-afp.org/browser_info/current/HOL/HOL/Hilbert_Choice.html):

```Isabelle
axiomatization Eps :: "('a ⇒ bool) ⇒ 'a"
  where someI: "P x ⟹ P (Eps P)"
```
This looks like Global Choice, although parametric polymorphism in Isabelle/HOL is to be compiled away
and eventually it's not possible to talk about a *single* choice operator in a meaningful way.

---

Then sets can be [defined](https://isabelle.in.tum.de/library/HOL/HOL/Set.html).
```Isabelle
typedecl 'a set

axiomatization Collect :: "('a ⇒ bool) ⇒ 'a set" ― ‹comprehension›
  and member :: "'a ⇒ 'a set ⇒ bool" ― ‹membership›
  where mem_Collect_eq [iff, code_unfold]: "member a (Collect P) = P a"
    and Collect_mem_eq [simp, code_unfold]: "Collect (λx. member x A) = A"
```
Introduction of sets is still axiomatic, although this looks just like a conservative extension.

---

The Axiom of Infinity is not introduced here, but introduced in [theory `Nat`](https://isabelle.in.tum.de/library/HOL/HOL/Nat.html)

```Isabelle
typedecl ind

axiomatization Zero_Rep :: ind and Suc_Rep :: "ind ⇒ ind"
  ― ‹The axiom of infinity in 2 parts:›
  where Suc_Rep_inject: "Suc_Rep x = Suc_Rep y ⟹ x = y"
    and Suc_Rep_not_Zero_Rep: "Suc_Rep x ≠ Zero_Rep"
```

So we basically ask there to be an "individual" type that's supposed to be infinite,
and by saying it's infinite we mean that it *at least* contains a natural-number like series.

Nature numbers can then be defined by comprehension
```Isabelle
inductive Nat :: "ind ⇒ bool"
  where
    Zero_RepI: "Nat Zero_Rep"
  | Suc_RepI: "Nat i ⟹ Nat (Suc_Rep i)"

typedef nat = "{n. Nat n}"
  morphisms Rep_Nat Abs_Nat
  using Nat.Zero_RepI by auto
```
Note that we're turning a set (essentially a predicate) to a type.
This is because of one conservative extension of HOL.

## Isar theories

An Isabelle theory is a basic modular unit.
The syntax has a Pascal flavor, in that the top-level syntax is `theory ... import ... begin ... end`.
An Isabelle theory also corresponds to a LaTeX file, with format markup commands `chapter`, `section`, `subsection` and `subsubsection`.
Informal discussions are introduced by the `text` command.

A lemma looks like something like this:
```Isabelle
lemma my_lemma:
  fixes x :: nat
  assumes A: "P x"
  shows "Q x"
```
Basically `fixes` introduces a variable and `assumes` introduces a condition.
The theorem is essentially `⋀x::nat. P x ⟹ Q x`:
recall that Isar works only with Isabelle/Pure, and therefore the underlying representations of variables, conditions etc. introduced by Isar are all in Isabelle/Pure.

The statement `⋀x::nat. P x ⟹ Q x` should be understood as $x : \mathsf{nat}, P(x) \vdash Q(x)$ *in the object logic* (but not the corresponding sequent in Isabelle/Pure, which in Isar cannot be expressed explicitly);
it takes an additional step to show $\forall x : \mathsf{nat} (P(x) \to Q(x))$ in the object logic.

To prove a universally quantified statement in HOL - and not Pure - we can use the universal quantifier introduction rule
```Isabelle
lemma allI:
  assumes "⋀x::'a. P x"
  shows "∀x. P x"
```
which can be proven from the definition of $\forall$:
```Isabelle
definition All :: "('a ⇒ bool) ⇒ bool"  (binder ‹∀› 10)
  where "All P ≡ (P = (λx. True))"
```
Then we can have 
```Isabelle
lemma "∀x::nat. x = x"
proof (rule allI)
  fix x :: nat
  show "x = x"
    by simp
qed
```
or even 
```Isabelle
lemma "∀x::nat. x = x"
proof
  fix x :: nat
  show "x = x"
    by simp
qed
```
The strong automation of Isabelle makes it painless for user-defined quantifiers to "inherit" their quantifier introduction rules from that of big lambda in Pure,
which has it done once and for all.

# Conservative extensions

A list of packages extending the HOL calculus can be found [here](https://isabelle.in.tum.de/library/HOL/HOL/index.html).

## Set

The first extension we need to introduce to HOL is probably sets:
(sub)sets of existing types.
The typical way to do so in type theoretic foundations is to just regard predicates as sets - 
so we get Axiom of Separation for free.

The practice in Isabelle/HOL is to define sets by [axioms](https://isabelle.in.tum.de/dist/library/HOL/HOL/Set.html).
There's an one-to-one mapping between `'a set` and `'a => bool`,
and existence of such a relation is exactly the axioms specifying the behaviors of `set`.
This is a conservative extension obviously.

The reason to have sides alongside predicates is practical.
In [Lawrence Paulson's words](https://lawrencecpaulson.github.io/2025/11/21/Typed_Set_Theory.html),

> Early versions of Isabelle/HOL maintained separate types for sets and predicates. At some point about 20 years ago, somebody had the idea of abolishing the distinction, presumably to avoid some duplication. This change persisted for a couple of releases before being laboriously reversed. Sets and predicates are simply not the same.

He does not explain why, but we can think of several reasons.
One reason is, we expect automation tools to be optimized differently for sets and for predicates:
for sets, we have an algebra based on $\cup$, $\cap$, rules pertaining to which should be a part of `simp`;
it sounds rather unnatural to have these rules for predicates, and mixing rules from the two worlds may slow down automation.

## Type comprehension

After having sets, it's natural to demand the ability to define new types via set comprehension:
that's to say, to convert a set (which basically is a predicate, so we get axiom of separation for free) into a type.
This is necessary, or otherwise we can't even have a natural number type and can only have a natural number set (in the `ind` type).
(Sure, we can always define natural by induction, but that requires its own language extension too; see next section.)

Type definition by comprehension should be a conservative extension because suppose the type $A$ is defined as $\{x : B | P(x) \}$, where $P : B \to \mathsf{bool}$,
and we find $\forall x:A (\ldots)$ can be translated using a guard construct to $\forall x:A(P(x) \to \ldots)$,
and a function $f: A \to D$ can be replaced by a function that returns some garbage value when the input value $x$ does not satisfy $P(x)$,
and a statement $Q(f(x))$ can be translated to $P(x) \to Q(f(x))$.

Type comprehension is [implemented as a part of Isabelle/HOL](https://isabelle.in.tum.de/library/HOL/HOL/Typedef.html), and is often known simply as "type definition".

## Inductive types

Inductive definitions are typically justified by some fixed point theorems.

## Type classes and locales 

One thing very good about Lean (and other dependently typed programming languages)
is you're able to define a mathematical *structure* - like a group structure (not to be confused with `struct`s, although with dependent types they're related) that contains properties:
because proofs are terms of propositions,
the fact that the multiplication operation of a group has associativity can be treated just like an ordinary member of the group structure.

To achieve the same in Isabelle one needs so-called *locales*.
This is not a math term but a term in Isar.
An introduction can be found [here](https://isabelle.in.tum.de/dist/Isabelle/doc/locales.pdf).

A locale represents a proof context, and is literally just a predicate containing constraints between the arguments,
but it has a system of auxiliary functionalities and automation built around it 
(see [here](https://lawrencecpaulson.github.io/2022/03/23/Locales.html)).
Type classes are claimed to be implemented as a special case of locales in the article (Constructive Type Classes in Isabelle).



## "Dependent types"

Dependent types are clearly needed if you want to *straightforwardly* formalize concepts like $\real^n$.
That said, whether it is *necessary* is much less clear.
Some discussions can be found [here](https://news.ycombinator.com/item?id=45791772) and [here](https://lawrencecpaulson.github.io/2025/11/02/Why-not-dependent.html).

The paper Theorem Proving in [Dependently-Typed Higher-Order Logic by Colin Rothgang, Florian Rabe, and Christoph Benzmüller](https://link.springer.com/chapter/10.1007/978-3-031-38499-8_25#FPar1)
has already shown that it's possible to compile away limited dependent types in HOL,
and HOL with dependent types can be treated as a preprocessor layer.
The calculus they propose can be seen as CIC trimmed down 
(and because `Type 0` and `Type 1` are no longer terms,
$a : \mathsf{Type} \ 0$ is now a type judgement and `Type 1` expressions can only appear in "theories" declarations that set up the environment).

The procedure compiling away dependent types, intuitively, is quite close to how we show that [type comprehension](#type-comprehension):
a dependent type $A$ is "broadened" to $\bar{A}$ to remove all value dependence,
and whether a term belongs to a certain dependent type (like `Vec 3`) is checked by a guard $A^*$.
$\forall x : A (\cdots)$ is translated to $\forall x : \bar{A} (x A^* x \to \cdots)$ where $A^*$ is a PER that encodes both well-formedness of the term and also equality in the dependent type.
(The paper does not assume axiom of infinity and therefore gives no example of how a concrete dependent type is compiled into a simple type plus a PER guard;
it just demonstrates that by having simple types and defining PER guards we can simulate dependent types.)

As they mention in the paper,

> The result is structurally close to what a native formalization of categories in HOL would look like, but somewhat clunkier.

This makes type checking in HOL (note that in HOL this does not involve theorem proving and should be an easy task) undecidable as equality check - the basis of reasoning in HOL, expectedly undecidable - is now a part of type checking.

Note also that because we do not need types to encode propositions, they have no difficulty including subtypes in their calculus.

This dependent HOL calculus (DHOL) can further [have polymorphism](https://arxiv.org/pdf/2605.00295) and [choice operator](https://arxiv.org/pdf/2410.08874).

---

Therefore translating a formalization of a mathematical concept using dependent types to a formalization of it without dependent types is a routine task.
The PER and the "broadened" $\bar{A}$ type naturally can be stored together in a locale.
Thus at the end of [this presentation](https://www.cl.cam.ac.uk/~lp15/papers/Alexandria/Bordg-talk_schemes.pdf) it is asked 

dependent types $\stackrel{?}{\simeq}$ simple types + locales/predicates

More often than not, though, we find we do not even need this "dependently typed formalization followed by removing dependent type" protocol.

---



https://arxiv.org/pdf/2104.09366



