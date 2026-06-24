Isabelle, and Isabelle/HOL
===========

# The HOL theory

## Why HOL: its relation with weak set theories

The relation between HOL - Higher Order Logic, in its modern sense - and (classical) CIC and set theory has been discussed [here](Why%20Lean.md).
Long story short, HOL (with axioms of infinity and choice) is equivalent to Mac Lane set theory, in terms of proof theoretic strength and consistency,
and hence is a good foundation of concrete mathematics.

Papers regarding the equivalence:
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
There seems to be some misinformation about Bourbaki using standard ZF, which isn't true.

## Relation with the type theory of Lean

It's possible to derive HOL by applying constraints to classical Lean:
see [here](https://news.ycombinator.com/item?id=14744167)
and [here](https://www.reddit.com/r/ProgrammingLanguages/comments/1aigns2/comment/koxkfhw/).
In the same way MAC+Choice is a fragment of ZFC+countable inaccessible cardinals.

So we have a hierarchy: HOL < ZFC < classical Lean.
ZFC gains its popularity largely because of its meta-mathematics properties.
It's weak for category theorists if they're to be taken literally,
and overly strong if one wants to ignore Mathias's advice.

The main disadvantage of HOL, when it comes to strength, is that it's not possible to use universes in HOL without additional axiomatization.


## Further enrichments

In Isabelle/HOL, both parametric polymorphism and ad hoc polymorphism have been introduced into HOL.
The parametric polymorphism mechanism adopted is conservative in the sense that it can be "compiled away",
just like C++ templates (perhaps I should say Hindley–Milner style polymorphism).

Ad hoc polymorphism is realized by type classes.
In dependent type theories like Lean, a type class is merely a record with a type parameter that lists the mathematical structure of the type (multiplication operation, and its properties, for instance).
Because Isabelle is not dependently typed,
type classes are somehow considered constraints imposed on types (like how it's done in Haskell).

This is handy (for defining +, or `0`), but has a history of bringing inconsistent behaviors!
See A Consistent Foundation for Isabelle/HOL by Ondřej Kunčar, Andrei Popescu.
The question then comes whether the system after the modifications merely undergoes a conservative extension.
The issue, together with the issue of making definitions in a safe way in general,
is then discussed in  Safety and conservativity of definitions in HOL and Isabelle/HOL by Ondřej Kunčar, Andrei Popescu 
and  Proof-Theoretic Conservative Extension of HOL with Ad-hoc Overloading by Arve Gengelbach and Tjark Weber.


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
and a rule of inference has the type of $\mathsf{thm} \to \cdots \to \mathsf{thm}$. 
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

## Peculiarities of Isabelle: weakened HOL as meta-logic

HOL4 and HOL Light use ML programming languages as the meta-logic.
Despite having some components *implemented* in ML, Isabelle's meta-logic is *not* ML, but something called Isabelle/Pure.
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
Any type definition (via `typedecl` keyword with `judgment` and `axiomatization` statements describing its behaviors) is axiomatic, and should be considered as a part of the definition of the object logic.
The only way to define things in Isabelle/Pure is by `definition`, which basically is just $\coloneqq$.

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

## Non-HOL logics encoded in Isabelle

A list of logics available in Isabelle can be found in its documentation.
Mizar can also be implemented within [Isabelle](https://link.springer.com/article/10.1007/s10817-018-9479-z),
although the TG set theory behind Mizar is the strongest among underlying calculi of all mainstream proof assistants. 

## Type definitions in HOL

We emphasize again that any definition in Isabelle/Pure is axiomatic,
in that Isabelle/Pure gives us no way to define new types without risking extending the strength of the system.
However, Isabelle/HOL is *supposed* to support definitions, i.e. introduction of new concepts into the system in a predefined way that is known to be conservative.
But then notice that in the process of embedding HOL into Isabelle/Pure, we have only utilized `typedecl`,
and have never introduced any primitives for making (conservative) definitions in Isabelle/HOL. 

Thus, keywords like `datatype` that allow us to make (conservative) definitions
are implemented in the *ML* part of Isabelle/HOL:
the architecture of Isabelle allows users to enrich the syntax,
and different object logics have different front-end commands that are translated to primitive provided by the corresponding logics behind the scene.

Similarly, in Isabelle/HOL, saying that "theorem $A \to B$" holds is actually saying theorem $\mathsf{Trueprop (A \to B): \mathsf{prop}}$ holds.

These procedures are yet another layer, a syntactic sugar layer over the object logic.
It's possible to have buggy code in this layer too that misleads readers of a proof to believe something has been proven,
although what is proven behind the scene is something different.


# Isar

There's also another component in Isabelle's system: Isar, a proof language that allows users to write proofs in the style mathematicians use everyday,
and not the purely tactic-based style.
Isar is ignorant to object logics and is built directly on top of Isabelle/Pure, 
but it interacts with logic-specific ML front-end packages that give us `datatype` etc. perfectly:
type definitions never appear in Isar, and proofs don't appear in type definitions.

## How HOL is defined in Isar

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
These rules perhaps do not need any explanation.

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

## Type classes and locales 

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
