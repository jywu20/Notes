Lean prover: the theory
=========

# Some vague intuitions

## ZFC and beyond

It's often accepted that ZFC is the foundation of classical modern math.
Most working mathematicians can't really recite the axioms of ZFC.
That said, the statement isn't necessarily wrong.
ZF is quite intuitive, while the axiom of choice both sounds intuitive and is vital 
in proving propositions that look right (e.g. "existence of bases for vector spaces").

That said, after 1950s, ZFC has shown several weaknesses.
The most well known issue is it's not straightforward to formalize generic category theory in ZFC:
the category $\mathsf{Set}$ can't be defined within ZFC
for the very reason that "a set containing all sets" is ill-defined.
Similarly, some structures in modern homotopy theory are too large to be formalized in ZFC.

For mathematicians who like concrete calculations,
the standard workaround is to extend ZFC *conservatively* (as in NBG etc.).
For mathematicians who want more elegant formulation,
Grothendieck universes are the accepted way to move forward.

In the latter case what we're looking at are essentially large cardinal axioms.
Adding large cardinals into ZFC makes it able to prove consistency of ZFC
(as a model of ZFC can now be constructed within the theory),
and therefore increases the consistency strength of the theory,
resulting in a non-conservative extension of ZFC.

## Motivation for introducing type theories

For non-set theorists, concepts like large cardinals are not straightforward to grasp.
It is desirable if the complexity can be hidden behind more "tame" notations.

Another issue with set theories - including ZFC and its extensions - is they're hard to automate.
If we take the idea that everything is encoded into sets seriously
then it's rather hard for a proof tactic - an algorithm - to decide what the next step should be taken.
Given two numbers 2 and 5, a mathematician naturally thinks about adding them together or doing division with remainder,
but if we're looking at their set theoretic encoding...
it's hard to know what can be done to them.

The Mizar prover solves this problem by introducing a type system:
a type tag is attached to each mathematical object to instruct the prover to see what likely are going to be done to the object.
Mizar has a rather delicate system built around this system (Grabowski et al. 2010):
for instance it's possible to define adjectives ($\texttt{natural}$ as in $\texttt{natural number}$).
Then one proves something like 
```
registration
let X be finite set;
cluster-> finite Subset of X;
coherence
...
end;
```
Which *registers* the combination (*cluster*) of the concepts $\texttt{finite}$ and $\texttt{Subset}$ and in the $\texttt{coherence}$ proof, the user shows that finite sets have finite subsets.

Mizar is a successful formalization of a large proportion of the everyday mathematical vernacular.
Still one may want better, user-defined tactics.
It is therefore desirable to have a built-in programming language in a prover... 

And theories allowing us to do this already exist. Here enter *type theories*.

(Note: there're still developments based on more traditional first-order logic and set theory. See e.g. [here](https://proofassistants.stackexchange.com/questions/1528/open-source-proof-assistants-for-first-order-logic-with-equality-and-set-theory).
It is also theoretically possible to embed a scripting language into Mizar,
or refactor Mizar to make it easy to add new tactics into the system,
given that it's now [open-sourced](https://github.com/MizarProject/system).
Another motivation for using type theories to formalize mathematics is experiences from category theory, in which objects and hom sets of a category do not overlap,
which is equivalent to saying each of them carries a type tag.)

# Lean as type theory and as ZFC + countable inaccessible cardinals

There are a lot of systems that are known as type theories.
It appears as long as a system is a typed lambda calculus that is expressive enough,
it can be considered as a a type theory.
(Russell's type theory on the other hand is quite unlike modern day type theories:
his types are more like universes)
Some type theories are quite unlike what is considered ordinary mathematics.
This article mostly focuses on Lean,
which has gained considerable popularity recently.
One of the reasons is it is quite classical:
the developers made it clear that [""intuitionistic logic support" PRs"" are of "lower priority"](https://leanprover.zulipchat.com/#narrow/stream/270676-lean4/topic/Compartmentalization.20of.20axioms.20in.20Lean.204).
This is also [the impression of users](https://proofassistants.stackexchange.com/questions/1115/how-usable-is-lean-for-constructive-mathematics).

Below, I give a sketch of the underlying theory of Lean (Carneiro 2019), and how it compares with set theoretic math.

## Propositions

The first thing in question is how are propositions encoded.
From Curry-Howard correspondence, a proposition should be conceived as a type,
and its proof should be regarded as something of that type.
"If ... then ..." is just a function signature $A \to B$ ("if $A$ can be proven then $B$ can be proven on top of a proof of $A$").

Philosophically, we expect that if rules of inference in typed lambda calculi are the only primitives we're allowed to have,
then we're doing intuitionistic or in other words constructive logic.

As a concrete example, in Haskell, all properties $P(a)$ can be encoded as attaching a type tag $P$ to $a$.
Arithmetic can be defined in the following ways:
```Haskell
-- Haskell has no dependent types so we have to encode values as types...
data Z
data S n

-- With S and ZERO it's already sufficient to construct all natural numbers.
-- Note that unlike the usual definition of natural numbers in type theories, 
-- what is being defined here is actually a predicate: 
-- "Nat n" = "n is a natural number".
-- Note that n is a type variable.
data Nat n where 
  Zero :: Nat Z               -- axiom: Z is a natural number 
  Succ :: Nat n -> Nat (S n)  -- axiom: if n is a natural number, then so is S n

-- Now we prove that two - namely S (S Z) - is a natural number
(Succ (Succ Zero)) :: Nat (S (S Z))

-- Equality is defined as a type inhabited by all pairs containing equal numbers
data Equal m n where 
   Equal_Zero :: Equal Z Z                         -- axiom: Z and Z are equal 
   Equal_Succ :: Equal m n -> Equal (S m) (S n)    -- axiom: if m and n are equal then m + 1 and n + 1 are equal

type a === b = Equal a b

-- Proof: equality is reflexive
refl :: Nat n -> n === n
-- ...
```
It's easy to see that propositions defined in Haskell boil down to compiling-time computation.
For dependent type theories, propositions boil down to computation in general.
A proof of an existential proposition $\forall x:A \exist y:B . P(x, y)$
is a function that takes a $x:A$ and returns a term from the type $\exist y: B. P(x, y)$,
the latter is a pair of some $y: B$ and a term in the type $P(x, y)$ - a proof of it, if $P$ is a proposition.

Although this looks elegant, the above scheme has several issues.
An obvious issue is probably that when we have type universes ($\texttt{Type}_0, \texttt{Type}_1$, ...) which are essential if we want to treat types as first-class citizens,
then in each type universe, we can define a set of logic. 
This brings up back to the delimma faced by Russell
(which he resolved by introducing the axiom of reducibility,
essentially collapsing the hierarchy of types).

Therefore most mainstream proof assistants, Lean included, have a dedicated *proposition type* $\texttt{Prop}$.
The proposition is "simple" in the sense that 
$\forall x:A . P : \texttt{Prop}$ if $P: \texttt{Prop}$
(in Carneiro 2019, this is expressed by $\mathrm{imax}(m, 0) = 0$).
On the other hand, if $A: \texttt{Type}_i$ and $B: \texttt{Type}_j$,
a common practice is $\forall x:A. B : \texttt{Type}_{\max(i, j)}$.

$\texttt{Prop}$ is further simplified by *proof irrelevance*,
which asserts that if two proofs prove the same proposition then they're the same
(that's to say, if we have $p: \texttt{Prop}$ and $h: p$ and $h': p$, then $h \equiv h'$; Carneiro 2019 sec. 2.2).
This means for each proposition (that's to say, for each term $p: \texttt{Prop}$),
either it's inhabited (i.e. proven), or not (e.g. can't be proven).

(But note that $\texttt{Prop}$ is not $\texttt{Bool}$,
as different *propositions* are not equal to each other.)

We note that this is consistent with the usual intuition of mathematicians but is against homotopy type theory.
Suppose $P: \texttt{Prop}$. The expression $p: P$ actually means $p$ is a proof of $P$,
but can be conveniently understood as giving $P$ a label $p$.
It also invalidates the computational interpretation of proofs:
for instance, when multiple things satisfying the same property exist,
what should be returned by the proof of the statement that "things satisfying the property exist"?

(This is mentioned in the official documentation: ["Introducing a proof-irrelevant Prop and marking theorems irreducible represents a first step towards separation of concerns. The intention is that elements of a type p : Prop should play no role in computation, and so the particular construction of a term prf : p is “irrelevant” in that sense. "](https://lean-lang.org/theorem_proving_in_lean4/Axioms-and-Computation/#axioms-and-computation))

$\texttt{Prop}$-based proofs do have *some* differences from the usual first-order logic+ZFC system
in how certain things are defined.
In the former, $P \to Q$ means $\forall p: P. Q$.
In first-order logic we first have a definition of $p \to q$ - in which $p$ and $q$ are kind of equal - and then quantify the proposition.
However, in Lean, $P$ is treated as the type of a proof $p$,
and from every $p$, a term of $Q$ - a proof of $Q$ - follows.
That said, typically we don't need to really mention the $p$ variable
(which isn't relevant because of proof-irrelevance anyway)
and we can just treat Lean propositions as "ordinary" first-order logic sentences.

Moreover, a statement like 
$$
\forall x (x \in \mathbb{N} \land P(x) \to Q(x))
$$
should now be formalized as 
$$
\forall x: \mathbb{N} (\forall p: P(x) (Q(x))).
$$
There is now a somehow artificial distinction between how atomic propositions like $x \in A$ and other atomic propositions are formalized in Lean (and other type theories with $\texttt{Prop}$).
This issue is on the other hand non-existent in set theories.

This distinction isn't as weird as it seems.
It is possible to define a *subtype* based on a predicate (i.e. a function from a type to $\texttt{Prop}$).
The syntax is almost identical to set-theoretic set comprehension:
```Lean
def even (n : ℕ) : Prop := n % 2 = 0

def even_numbers := { n : ℕ // even n }
```

The subtype is actually an existential type $\exist x : \mathbb{N} (\mathrm{even}(x))$.
Here `even` is a predicate.
A term from $\exist x : \mathbb{N} (\mathrm{even}(x))$ is a pair $\langle x, p \rangle$
where $x: \mathbb{N}$ and $p$ is a proof of $x$ being even
(or we can also understand $p$ as the label of the proposition `even x`,
given proof irrelevance discussed above).

The flow of subtyping is unidirectional: from a type and a predicate we can construct a subtype,
but we can't just write a set comprehension expression out of nothing.
This is consistent with standard axiomatic set theories,
in which we have only restricted comprehension, i.e. axiom of separation.

However because terms in a subtype contain additional information about why they belong to the subtype,
partial functions in Mizar aren't easily definable. See below.

## Set theoretic semantics

It can be proven that the type theory of Lean is equivalent to ZFC + countable inaccessible cardinals.
Here "ZFC + countable inaccessible cardinals" means ZFC + "for every $n > 0$, there exists $n$ inaccessible cardinals, one smaller than the other".
Suppose $\mathrm{ZFC}_n$ means ZFC with $n$ inaccessible cardinals,
and $\mathrm{CIC}_n$ means calculus of inductive construction with $n$ universes
with type theoretic axiom of choice and law of exclusion of middle.
Werner 1997 proves that $\mathrm{CIC}_{n+1}$ is interpretable in $\mathrm{ZFC}_n$
and $\mathrm{ZFC}_n$ is interpretable in $\mathrm{CIC}_{n+2}$.
Hence ZFC + countable inaccessible cardinals and CIC with infinite universes can be interpretable in each other.
Carneiro (2019) further proves that Lean (with its own classical axioms) with infinite universes and ZFC + countable inaccessible cardinals are interpretable in each other as well.
Hence all three systems are equiconsistent.

There are some subtleties about the correspondence between each stage of the three theories,
which are discussed in detail in Carneiro (2019).

We note that $\mathtt{Prop}$ is impredicative,
in the sense that a proposition $P : \mathtt{Prop}$ can be defined by quantifying over $\mathtt{Prop}$.
For instance, what is falsehood?
Falsehood is a statement $F$ from which all propositions can be derived.
Note the definition: $F$ itself belongs to "all propositions".
Impredicative types can't be naively interpreted as sets,
but becaues of proof-irrelevance this does not matter.
The interpretation of $\mathtt{Prop}$ is simply $\{0, 1\}$.

Non-$\mathtt{Prop}$ types on the other hands are sets.
Functions are set-theoretic functions (dependent $\forall$ types are interpreted as fiber bundles).
Inductive types are translated to inductive definitions of sets
and the strict positivity condition assumes that we have a monotone operator over sets that admit a least fix-point.
The same goes for inductive predicates.

The above construction can be done in each stage $V_i$.
Grothendieck universes are introduced to interpret `Type`'s.
As is said by [Mario Carneiro](https://leanprover.zulipchat.com/#narrow/channel/116395-maths/topic/Consistency.20strength.20bounds.20from.20Lean.20proofs/near/517227725), 

> because Type is just another set. It's definitely got to be interpreted as a set, interpreting it as V doesn't work. Either you say that the set is a grothendieck universe and now you need an inaccessible cardinal (this is the easy way), or you interpret it as an almost-universe and check that the proof doesn't do any concrete construction that violates the almostness of the universe.

Interpretation of set theory in type theory is more complicated.
A straightforward interpretation would be an inductive definition:
"given a type (in universe $n$) and a function that maps elements in the type to sets, we can construct a new set".
The main problem is, with this definition,
the type containing all sets should be in universe $n+1$.
Thus CIC in which every type except `Type 0` is in one type universe i.e. `Type 0` is interpretable in ZFC with no inaccessible cardinal,
but ZFC with no inaccessible cardinal is to be interpreted in CIC with two type universes,
the second of which contains the type `Set`.
The type `Set` has to be mentioned to define union sets and power sets etc.
and therefore the type of `Set` and also the types of these operations are going to be in `Type 1`,
and discussion on composition of these types inevitably contains a lot of occurrences of `Type 1`.

This is a common phenomenon, [not restricted to formalization of set theory](https://leanprover.zulipchat.com/#narrow/channel/116395-maths/topic/Consistency.20strength.20bounds.20from.20Lean.20proofs/near/517231107).

(Note: in Lean's mathlib sets are defined as predicates, which are not dedicated standard ZFC sets. The latter are formalized as `ZFSet`.)


## Inductive types

Besides universes, the proposition type and functions,
everything else in Lean belongs to an inductive type.
This means the sigma type $\Sigma x:A . B$ is also defined as an inductive type,
which is [trivially](https://lean-lang.org/theorem_proving_in_lean4/Inductive-Types/#inductive-types)

```Lean
inductive Sigma {α : Type u} (β : α → Type v) where
  | mk : (a : α) → β a → Sigma β
```

Inductive types is consistent with the usual mathematical vernacular:
"something is generated by this, this and this ways and only by these ways..."

The phrase "only by these ways" can be formalized in first-order logic too: 
basically it says 

$$
x \in A \leftrightarrow ((\exist y \in B, x = f(y)) \lor \ldots)
$$

where $B$ may contain $A$ (and some sort of well-formedness check is needed).
This is equivalent to 
$$
x \in A \to \exist y \in B, x = f(y) \lor \ldots
$$
and 
$$
\forall y \in B (f(y) \in A) \lor \ldots
$$
The second line is the "forward" part of the definition of $A$.
An inductive type definition mimics this sentence
while implicitly allows us to take $y$ from $x$ using $x \in A \to \exist y \in B, x = f(y) \lor \ldots$.

The appearance of $A$ in the right hand side of the definition is more non-trivial and requires some subtle discussions about the "smallest" fixed point.


## Functions and termination

Because Lean is a typed lambda calculus,
there's a problem of termination, i.e. whether evaluation of a term halts eventually.
(Functions utilizing data from e.g. axiom of choice are not computable and are labeled as such,
but they too can involve dead loops.)
Termination is related to consistency of type theories:
a well-typed constructive term that doesn't terminate gives us a false impression that an object represented by that term exists,
which is enough to cause inconsistencies.

(Note: when we compare Lean and set theories, we ignore the embedded programming platform in Lean.
Historically set theories have no computational interpretations,
although the situation is changing and realizability of set theories and classical logic is currently under investigation.
We just emphasize that not much meaningful comparison regarding *computational power* of set theories and type theories has been made.)

All functions defined in Lean therefore have to provably terminate.
This means Lean is not Turing complete (i.e. it's not partially recursive).
Actually, the "meta" part of Lean - used to write tactics - is Turing complete,
but functions defined in this way can't be used in theorem proving.

It should be noted that this doesn't mean Lean expresses all total recursive functions.
It clearly does not express all total recursive functions without termination proofs:
this essentially assumes that the Lean prover is able to automatically check if a program halts.
Further, we note that the universal halting problem - the problem whether a recursive function halts for every input - is $\Pi_2^0$ and in fact is [$\Pi_2^0$-complete](https://en.wikipedia.org/wiki/Halting_problem#Halting_on_all_inputs),
meaning that all $\Pi_2^0$-problems can be converted to problems about whether a recursive function is total.
Now we note that consistency of Lean (and ZFC, and others) is a $\Pi_1^0$ formula,
and thus also a $\Pi_2^0$ formula due to the properties of the arithmetical hierarchy.
Because Lean (and all provers) are unable to show its own consistency,
there is a $\Pi_2^0$ formula not provable in Lean
and hence there is a total recursive function that does halt whose termination however is not provable in Lean.

We can actually construct this function: it takes a natural number $n$ and does a scan to see if an inconsistency of Lean can be found within $n$ steps, and if an inconsistency is found, it goes into a dead loop, otherwise it returns.
Consistency of Lean is therefore equivalent to the function being total, which however is not provable in Lean.

(This is a reminder of how complicated arithmetic actually is.)

Partial recursive functions aren't easily formalized in Lean. 
Lean allows us to explicitly define partial functions,
but they're treated as opaque objects whose internal details are not reasoned by the prover.
It's possible to prove that two functions are using data from one partial function in the same way
and thus the two functions are equal to each other,
but it's not possible to reason "into" the structure of the partial functions.
To study partial functions, it seems one should first define the formal semantics of the language in which the partial functions are to be written,
and then define partial functions within that language, instead of within the native programming language of Lean.

The lack of ability to define partial functions also means 
problems like "evaluating the domain of a function" is not straightforwardly formalizable in Lean.
In a ZFC oriented textbook, for instance, one may ask
"what's the domain of $x \mapsto \sqrt{1 - x^2}$?"
Here because $x$ does not appear with other variables,
it's implicitly understood as the identity function.
$1 - x^2$ therefore is composition between ^, - and constant function $1$.
$\sqrt{}$ is a function - defined as a special kind of set theoretic relations - with a domain $[0, \infty)$.
By the definition of function composition, we know the domain of the function is $[-1, 1]$.
This is not doable in Lean:
because $\mathbb{R}$ is now a type and its non-negative subtype consist of pairs $(x, p)$ where $p$ is a proof of $x >= 0$,
it feels awkward to define a square root function on this subtype,
and hence the return value of $\sqrt{}$ when the input is negative is set to a garbage value,
typically zero,
and users are asked to argue about $\sqrt{}$ always with a precondition "its input value is non-negative".

# How canonical is Lean?

## Inaccessible cardinals as Grothendieck universes

Von Neumann’s Cumulative Hierarchy $V$, defined as
$$
V_0 = \emptyset, \quad V_{\alpha + 1} = P(V_\alpha), \quad V_\lambda = \bigcup_{\beta < \lambda} V_\beta,
$$
where $\alpha$ runs over all ordinal numbers and $\lambda$ is a limit ordinal,
is commonly taken to be *the* standard model of ZFC,
and gives people strong faith in the consistency of ZFC for lack of paradoxical self-references in it,
presumably more than any proof theoretic work does
(as a perfectly consistent system may prove its own inconsistency due to existence of non-standard natural numbers, and an inconsistent system proves its own consistency).

Inevitably, the discussions above - indeed many arguments in metamathematics -
are *physical* in the sense that they're not formalized in a well-defined theory
and often are impossible to be taken at face value.
"Von Neumann's universe is constructed by taking the union of all $V_\lambda$ where $\lambda$ runs over all ordinals".
One wonder what is an ordinal and in which theory it is defined.

Let's first restrict $\alpha$ to ordinals definable in ZFC.
Each stage $V_\alpha$ is definable in ZFC, although the union of them is not.
Now we ask: can we find an index $\kappa$ so that $V_\kappa$ is the union of all $V_\alpha$ 
in which $\alpha$ is an ordinal definable in ZFC?

Obviously, $\kappa$ should be larger than all ZFC $\alpha$ and shouldn't be constructable with them.
It - if it exists - actually should be a strongly inaccessible cardinal
(the difference between weakly and strongly inaccessible cardinals is related to generalized continuum hypothesis and is independent to ZFC + countable inaccessible cardinals).
Because $\bigcup_{\alpha \text{ ZFC}} V_\alpha$ itself is beyond all ZFC sets,
naturally we can set $\kappa$ to be cardinality of $V_\kappa$ (as its cardinality indeed can't be achieved using any ordinary set theoretic method).

$V_\kappa$ is a Grothendieck universe.
It is the set containing all objects of the $\mathsf{Set}$ category that catches the structure of ZFC.

But that's not the end of the story.
Now we may wonder in which universe a category describing the structure of $V_{\kappa_0}$ resides.
Further, what's $\kappa_0$, exactly?
Is it in $V_{\kappa_0}$? It shouldn't, or otherwise $\kappa_0$ can be constructed from ordinary ZFC sets.
So we want to find yet another universe containing $\kappa_0$.
Hence we define $V_{\kappa_1}$ and let $\kappa_1$ be the next inaccessible cardinal.
Repeating this over and over again, we get ZFC + countable inaccessible cardinals,
equivalent to Lean.

Thus introducing a countable series of inaccessible cardinals is canonical in the eyes of category theorists.
One user on Stack Exchange [says](https://math.stackexchange.com/questions/79343/is-the-axiom-of-universes-harmless)

> If you only need one ‘level’ of classes, then NBG may provide a satisfactory solution. Mac Lane only assumes the existence of one universe in Categories for the Working Mathematician. But the truth of the matter is that the working categorist would rather have at least a countable infinity of levels, so that we can talk about such things as the category of all functors CRing→Set
 (relevant, for example, in Grothendieck's functor of points approach to algebraic geometry).

Category theorists are often conservative on the issue of Choice.
On the other hand, in analysis, Choice is important, but large cardinals are not.
For a working mathematician used to standard analysis but still wanting to do category theory without being afraid,
it appears ZFC + countable inaccessible cardinals is a good and natural compromise.
 
## Consistency

Despite Grothendieck's ideal, adding large cardinals into ZFC does increase its consistency strength
(making it more likely to be inconsistent),
and whether to accept large cardinals is not without controversy.
Accepting *what* kinds of large cardinals is also not without controversy.

A discussion on *consistency* can be found [here](https://mathoverflow.net/questions/73121/recent-claim-that-inaccessibles-are-inconsistent-with-zf) and also [here](https://math.stackexchange.com/questions/79343/is-the-axiom-of-universes-harmless).
We have reasons to believe that ZFC + countable inaccessible cardinals is consistent (regardless of whether you think it's good math)
but just like we have no way to uncontroversially *prove* consistency of ZFC,
it's not something that has a commonly accepted proof.

## Necessity of Grothendieck universes

Back to the issue of formalizing category theory.
Although category theorists want Grothendieck's universes for narrating theorems,
there is a widely spread opinion stating that when solving a reasonable problem,
the appeal to universes can be eliminated.
In the comment section of [this post](https://mathoverflow.net/a/35749), we find claims like this:

> For etale cohomology all of that universe stuff is entirely irrelevant. I say this not as an "article of faith", but because I've read all of the proofs of the theorems of etale cohomology. Perhaps if one wants to make a super-general theory of cohomology for "all" topoi there are these problems, but if one only cares about more "real" examples such as etale cohomology then there are no issues. 

In the comment section of the question we also read

> The Stack Project develops a huge amount of Grothendieck style mathematics, including a lot of etale cohomology, using only ZFC (specifically, NOT using universes). If anyone has any doubt that this can be done, I suggest that they look at it. 

So it appears that, despite being used to construct the generic framework of category theory, topoi and things like that,
in proving concrete math theorems, we should generally expect a ZFC-only proof,
which [already exists](https://math.stackexchange.com/a/79354).
It therefore seems alluring to develop some size checking mechanism in Lean or in a fork of it
that rigorously tests if a proof is strictly within ZFC.

(But again, a lot of  things provable in ZFC are also provable within Peano arithmetic.)

## Competing systems

Even if ZFC + countable inaccessible cardinals is consistent and is widely used in category theory,
there are reasons to not accept it.
Besides the concerns expressed in the last section (i.e. the universes being unnecessary in concrete problems),
there are ways to construct competing systems.

The most obvious alternative is to accept axiom of determinacy (hence axiom of choice can't be true),
and this gives us a system equiconsistent to ZFC + there exists infinitely many Woodin cardinals.
Another way out is to drop axiom of choice but not to accept axiom of determinacy either.
Reinhardt cardinal is logically incompatible with axiom of choice but 
is not known to imply axiom of determinacy.

Because Reinhardt cardinal is powerful,
there are set theorists who think introducing more and more powerful cardinals is the purpose of set theory research now doubting the appropriateness of axiom of choice.
One can also argue that it's possible to combine universes with set theories even weaker than ZF.

There are also theories strictly stronger than Lean.
Mizar uses TG set theory,
a theory containing a proper class of inaccessible cardinals
(by introducing the Tarski axiom or the axiom of universes)
and thus stronger than ZFC + countable inaccessible cardinals.
If one is willing to accept Mizar, then they should also be willing to accept Lean.

## Doing math strictly in ZFC in Lean

One may still want to do proofs that are strictly within ZFC in Lean.
Someone for instance once claimed Fermat's last theorem [was not a "theorem" before uses of universes in the proof were removed](https://proofassistants.stackexchange.com/a/2755).
Is demonstrably restricting oneself in ZFC in Lean possible?

An obviously wrong answer is to work only with statements that involve only `Type 0`,
as the proposition affirming the consistency of ZFC [resides in `Type 0` too](https://proofassistants.stackexchange.com/a/2730)
and thus a proposition involving only objects in `Type 0` proves $\mathrm{Con}(\mathrm{ZFC})$.

One may then want to make sure only objects from `Type 0` appear in *proofs* (and not just statements of propositions).
It's close (as is said above in the comparison between Lean and ZFC + countable inaccessible cardinals) but not exact:
$\mathrm{CIC}_1$ (i.e. `Type 0`-only) can be interpreted in standard ZFC,
but a straightforward formalization of standard ZFC can only be done in $\mathrm{CIC}_2$,
as operations like union or intersection most naturally are encoded as functions that talk about the type containing all ZFC sets,
and hence belong to `Type 1`.
This is known as universe-to-universe correspondence [up to a fence post error](https://proofassistants.stackexchange.com/questions/2728/lean-and-inaccessible-cardinals).

Therefore, if a strictly ZFC proof is desirable, we need to 
find a segment of Lean's type system that's *exactly equivalent to* standard ZFC,
something that hasn't been done yet.
We can try to make up for the fence post error and ask Lean to report danger 
whenever a proof utilizes `Type 1` concepts beyond the standard ZFC operations.
This however is a rather ugly solution as it's essentially inserting ZFC axioms manually into the system.

Even after this is done, there are technical complicities.
Lean doesn't store the whole proof tree,
and it's possible that some tactics used in the proof implicitly refer to higher universes on the run.

It appears formalizing a theorem in Lean while making sure we're only using ZFC is not an easy task.

One can also argue that it's the mainstream mathematics community that needs to change, not Lean.
That said there are good reasons to think that restricting ourselves to ZFC is a good idea.
Back to the Fermat's last theorem affair, [it is noted that](https://leanprover.zulipchat.com/#narrow/channel/116395-maths/topic/Consistency.20strength.20bounds.20from.20Lean.20proofs/near/516032657)

> Wiles does use etale cohomology. The very first references for etale cohomology were Grothendieck's SGA4 and SGA5 which famously use universes because they develop a hugely general machine using topoi which could be used to construct all sorts of exotic cohomology theories, for example fpqc cohomology which does have foundational subtleties. However etale cohomology was then used to prove the Weil conjectures and in order to demonstrate to the mathematical community that universes were not used in the proof of the Weil conjectures, Deligne wrote SGA4.5, which developed etale cohomology without all the topos-theoretic framework and demonstrated that the proof of the Weil conjectures did indeed work fine in ZFC. The situation then stayed like this for 20 years, and several other books were written developing etale cohomology in ZFC for example Milne's book and Freitag-Kiehl.

This is not a coincidence. It is noted that ["the Stacks project operates to stay inside ZFC"](https://leanprover.zulipchat.com/#narrow/channel/116395-maths/topic/Consistency.20strength.20bounds.20from.20Lean.20proofs/near/515945050).
[This is done by](https://leanprover.zulipchat.com/#narrow/channel/116395-maths/topic/Consistency.20strength.20bounds.20from.20Lean.20proofs/near/516036671) 

>  The general phenomenon that you want to take care of is when you want to define a cohomology theory by taking some kind of limit over covers but that limit is not a set. In SGA4 Grothendieck just took the limit anyway, and his cohomology group was defined one universe level up. In SGA4.5 Deligne showed how you could take the limit over a set and still get the same answer (that's the basic idea but it's more complicated than this, you also have to show that everything you want to do with the cohomology theory also descends, but this is the basic idea). Joel has been proving general results of the form "if hom types in a category descend to a smaller universe then various constructions which you make using this category also descend". But if you want to get a proof of FLT into ZFC then you need to show that these techniques apply. Set theorists understand this problem well; a reference for how it works in algebraic geometry is in the Stacks project: the set-theoretic input is [here](https://stacks.math.columbia.edu/tag/000F) and the application to schemes is [here](https://stacks.math.columbia.edu/tag/000H). In particular it's not something which you get "for free", there is content here.

Peter Scholze has a [long discussion on the issue](https://mathoverflow.net/questions/382270/reflection-principle-vs-universes).
In his post he says 

> Instead, (see Tag 000H say) it effectively weakens the hypothesis that κ
 is strongly inaccessible, to something like a strong limit cardinal of uncountable cofinality, i.e.: for all λ<κ
, one has 2λ<κ
, and whenever you have a countable collection of sets Si
 of size <κ
, also the union of the Si
 has size <κ
. ZFC easily proves the existence of such κ
, and almost every argument one might envision doing in the category of abelian groups actually also works in the category of κ
-small abelian groups for such κ
. If one does more complicated arguments, one can accordingly strengthen the initial hypothesis on κ
. I've had occasion to play this game myself, see Section 4 of www.math.uni-bonn.de/people/scholze/EtCohDiamonds.pdf for the result. From this experience, I am pretty sure that one can similarly rewrite Lurie's "Higher Topos Theory", or any other similar category-theoretic work, in a way to remove all strongly inaccessible cardinals, replacing them by carefully chosen κ
 with properties such as the ones above.

So there are discussions above that.

## Tentative summary

- Lean's underlying theory has a set theoretic counterpart, namely ZFC + countable inaccessible cardinals, that is weaker than the TG set theory (used in Mizar).
- Lean's underlying theory is canonical for a mathematician with a canonical college math education who also uses category theory.
- That said, consistency is still a concern for some, and there're people saying concrete math problems can always be proven within ZFC or even Peano arithmetic.

As a tentative summary,
- It is desirable to utilize the full power of Lean for expressing the generic theory of categories; it is also desirable if Lean is able to check whether a proof uses ZFC only.

# Lean and the math vernacular

## Variables

In everyday math notation "variables" are rather vague concepts.
In writing the overall skeleton of proofs, like "suppose $x \in \reals$. ... $P(x)$ and thus $\forall x \in \reals , P(x)$",
the variable $x$ is a proper parameter in natural deduction.

When doing calculations variables are placeholders in function definitions.
Thus in "suppose $x \in \reals... \| f(x, y) \|_{L^2, x} \leq ...$",
$\| f(x, y) \|_{L^2, x}$ (or orally, "the $L^2$ norm of $f(x, y)$ with respect to $x$") should be interpreted as $\| x \mapsto f(x, y) \|_{L^2}$,
where $y$ is considered a parameter.
Formalizing notations like this is not always easy.
$x$ can be understood either as a projection function from an implicit "space of states" (when $x$ and $y$ appears together, $\reals^2$),
or just a parameter without exact meaning, waiting to be quantified by what is essentially a $\lambda$ expression.

In Lean, "suppose $x \in \reals$. ... $P(x)$ and thus $\forall x \in \reals , P(x)$" is automatically taken care of by the keyword `variable`:
if we have `variable a : T` declaration before a theorem using `a`,
then the theorem is automatically universally quantified.

The "L^2 norm of $f(x, y)$ with respect to $x$" or "$\int \dd{x} x^2$" use of variables is also definable in Lean.
The trick is to first formalize the precise idea behind the notation as an operator taking a function,
and then define a notation that captures the "with respect to" concept.
Below is an example:

```Lean
notation3"∫ "(...)" in "a".."b", "r:60:(scoped f => intervalIntegral f a b volume) => r
```

The user can define $\|\|_{x}$ and similar notations following the logic.

## Infrastructural definitions

A set in Lean's mathlib (not ZFC sets discussed above when proving equivalence between Lean and ZFC + countable inaccessible cardinals) is defined as 


## Writing proofs: forward

The default *forward* style of proof (term mode) in Lean is *not* natural deduction.
Suppose we want to prove that $P \to Q$.
With lemmas $h_1: P \to R \lor S$ and $h_2: R \to Q$ and $h_3: S \to \bot$.
The proof term is a tree of composition of $h_1$, elimination of $\lor$, invocation of law of exclusion of the middle, and finally $h_2$.
For examples, see [here](https://lean-lang.org/theorem_proving_in_lean4/Quantifiers-and-Equality/#quantifiers-and-equality).
Below is a proof of a trivial logic statement:

```Lean
example (α : Type) (p q : α → Prop) :
    (∀ x : α, p x ∧ q x) → ∀ x : α, p x :=
    fun h: ∀ x : α, p x ∧ q x =>
      fun y : α =>
        (h y).left
```
Note that we have never applied universal quantifier introduction and elimination rules.
Instead, a proof of $\forall x : \alpha, p (x)$, given the condition,
is constructed by directly writing a lambda expression
`fun y :  α => (h y).left`.
All variables in the proof are always bound by $\lambda$ i.e. `fun`.
Elimination of $\land$ is done by `.left` which is a syntactic sugar of 
elimination of an inductive type with only one constructor which takes two arguments
by picking out the first argument.
Therefore introduction and elimination of $\forall$ are done using lambda calculus,
and introduction and elimination of all other quantifiers and logic connectives
are done using inductive types
(which is not surprising as everything in Lean besides universes and dependent arrows [is built by inductive types](https://lean-lang.org/theorem_proving_in_lean4/Inductive-Types/#inductive-types)).

The proof is then expanded
($\lor$ for example is defined as an inductive predicate so it eventually boils down to a `match` operation),
resulting in a term checked by the kernel of the prover that is
not truly human readable when the proof is large.

Lean has several syntactic sugars to make proofs resemble informal proofs.

First we have `show` keyword that makes the thing being proven explicit.
It is often followed by `from`, which supplies the proof term.
The proof above can be rewritten as 

```Lean
example (α : Type) (p q : α → Prop) :
    (∀ x : α, p x ∧ q x) → ∀ x : α, p x :=
    fun h: ∀ x : α, p x ∧ q x =>
      fun y : α =>
        show p y from (h y).left
```

The last line is essentially `(h y).left : p y` but Lean doesn't allow us to write unnecessary type annotations after $\forall x : \alpha$.
The `show ... from ...` syntax makes what's being proven clearer.

Second, we have `have` keyword placed before the actual proof terms for introducing lemmas.
Consider the following proof:
```Lean
example : ∃ x : Nat, x > 0 :=
  Exists.intro 1 (Nat.zero_lt_succ 0)
```
The proof term `(Nat.zero_lt_succ 0)` proves that $1 > 0$.
But in the form of the proof shown above its purpose is not clear.
Thus we rewrite the proof as 
```Lean
example : ∃ x : Nat, x > 0 := 
  have h : 1 > 0 := Nat.zero_lt_succ 0
  Exists.intro 1 h
```

Some proofs can be done by mechanical calculation - in lambda calculus.

```Lean
example : 1 + 1 = 2 := 
  calc 1 + 1
```



## Writing proofs: backward

Most provers - "interactive provers", Lean included - offer users a *backward* and arguably more human readable way of constructing proofs.
Given the goal $Q$, a *tactic* convinces the prover that a list of other goals imply $Q$,
and the proof is finished when tactics have been applied to transform $Q$ into goals that can be trivially deduced from $P$.

In Lean, to enter the *tactic mode*, we start a proof by the `by` keyword.
(In Lean 3 there was a `begin end` block,
which is removed in Lean 4.)
The same logic tautology above can be proven in the tactic mode in the way below:

```Lean
example (α : Type) (p q : α → Prop) :
    (∀ x : α, p x ∧ q x) → ∀ x : α, p x := by
    intro h
    have r : ∀ x : α, p x := by {
      intro y
      have : p y := (h y).left
      exact this
    }
    exact r
```

Here `intro` gives the condition `(∀ x : α, p x ∧ q x)` a name `h`,
`exact` means a current goal is identical to one of the hypotheses.
`this` refers to the conclusion of an anonymous `have` command.

Although the tactic mode is for proving things backwardly,
By using multiple `have` statements to outline the sketch of a proof,
we're able to carry out a forward proof.
We can even do something like this:
```Lean
have h1: ... := proof_term_1
have h2: ... := proof_term_2
...
exact hn
```

(Note that because `show... from...` or `show... by...` is just another way to write a term,
the syntax is not available in tactic mode.)

The `apply` keyword checks if the current goal is consistent with the conclusion of a statement supplied to `apply`,
and shifts the goal to the condition of the statement.

# Lean as programming language

We have seen that functions defined in Lean that are used in proofs have to terminate
(which means Lean doesn't admit all functions that actually terminate for every input).
Besides that, there are a lot other details worth noting in Lean as a programming language.

## Local definitions

Because the underlying theory of Lean is a dependent type theory,
the rules of inference for function definition and function calls and `let ... in` are not the same.
The former is known as $\beta$-reduction, and the latter, 
in the context of the study of underlying theories of Coq or Lean, is known as $\zeta$-reduction.

The main difference between the two is that the typing rule for the latter is 
"if $e[e' / x] : \alpha$ then $\texttt{let } x : \alpha = e' \texttt{ in } e \equiv e[e' / x]$".
Note that the local variable $x$ is allowed to appear wherever it wants in $e$,
and in $e$ we may see a definition like $y : x$;
whether this is considered well-typed is determined by the form of the expression *after* substitution.
On the other hand, $(\lambda x : \alpha. e) e'$ has to be proven to be well-typed
before we know what exactly $e'$ is: $(\lambda x : \alpha. e)$ should always be well-typed.

We can quickly have a view of how an example distinguishing $\zeta$-reduction from $\beta$-reduction can be constructed based on this observation.
[Consider](https://lean-lang.org/theorem_proving_in_lean4/Dependent-Type-Theory/#local-definitions)
```Lean
def foo := let a := Nat; fun x : a => x + 2
```
This definition is well-typed, because after substituting `a` with `Nat`, we get 
`fun x : Nat => x + 2`, a perfectly legitimate expression.
On the other hand, 

```Lean
def bar := (fun a : Type => fun x : a => x + 2) Nat
```

is *not* well formed, because when looking at `(fun a : Type => fun x : a => x + 2)`, we do not know if `a` supports `+` operation.
That it actually supports `+` is known only after `Nat` is supplied to the function.

This is a problem also seen in languages with type systems weaker than that of Lean.
Indeed, even if we do not have dependent types,
as long as types are being passed around as values in certain types of functions (like C++ templates),
the difference between $\beta$- and $\zeta$-reductions appears.
`let` expressions are more flexible in what you can do *within* them,
but not flexible at all in what $e'$ can be in `let x = e'`.

## Type classes

To introduce the flexibility of `let` into lambda expressions,
we may want to enable users to impose some constraints on the type input of a function,
like "`a` should support `+`".
Actually this can be done in a rather elegant way.
Suppose type `α` supports function `add: α -> α`.
This is true, [if and only if we're able to construct a term belonging to the type](https://lean-lang.org/theorem_proving_in_lean4/Type-Classes/#type-classes) (recall that `structure` is also a reduced case of inductive types)
```Lean
structure Add (α : Type) where
  add : α → α → α
```
We can also add constraints regarding the properties `add` should have:
```Lean
structure Add (α : Type) where
  add : α → α → α
  add_with_nat : α → Nat → α
  trans : ∀ a b : α, add a b = add b a
  -- more properties about how to convert Nat to α and hence compatibility between add_with_nat and α
```
This has a clear correspondence in set theoretic foundation of mathematics,
where an instance of `Add` may be called something like a transitive structure
(the term *structure* here means something different from structures in data types).
In Lean because we have `Prop`, proofs of propositions constraining `add` can just be added as a part of the content of the structure.
Now we can write `fun α : Type => fun add_struct : Add α => fun x : α => add_struct x + 2`,
which is perfectly well typed.
Then we can pass different `α` and `add_structure` to the function above.

Note that the `add_structure` argument plays the role of a namespace specifying which version of addition operation is being done here.
When this is not necessary, that's to say, when we're quite sure there's only one function for each type that can be reasonably called `add`,
Lean - as well as many other languages - has a mechanism called *type classes*
that reflects this uniqueness requirement.
Instead of explicitly asking for a `add_struct` argument,
we write 
```Lean
class Add (α : Type) where
  add : α → α → α

instance : Add Nat where
  add := Nat.add
```
and then write something like 
```
def double [Add α] (x : α) : α :=
  Add.add x x
```
The brackets ask Lean to find registered instances of "structure" (i.e. type class) `Add` implicitly.
Once such a instance `add_str` is found, `Add.add` is interpreted as `add_str.add`.

# References

Grabowski, Adam, Artur Kornilowicz, and Adam Naumowicz. "Mizar in a nutshell." Journal of Formalized Reasoning 3.2 (2010): 153-245.

Carneiro, Mario. The Type Theory of Lean. Master thesis. 2019.

Werner, Benjamin. "Sets in types, types in sets." International Symposium on Theoretical Aspects of Computer Software. Berlin, Heidelberg: Springer Berlin Heidelberg, 1997.