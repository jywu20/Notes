# Existing results: global and local set theoretic equivalence

Studying equivalences between foundations of mathematics is beneficial for e.g. importing and exporting of theorems from one foundation to another.

Regarding Lean, famously,
there is an equi-interpretability (or bi-interpretability) theorem between Lean and ZFCω (ZFC + $\{\text{there exists n inaccessible cardinals} | n \in \mathbb{N}\}$, sometimes also known as ZFC + countable inaccessible cardinals, although the latter may be misunderstood as allowing the inaccessible cardinals to be collected into a single set),
which is discussed [here](../Computer%20Science/Logic%20and%20PLT/Lean.md).
This interpretation is intuitive and straightforward,
but it is not strictly *equivalence*:
suppose $\phi$ is a theorem in ZFCω and is translated to Lean and then translated back, and we have no reason to expect the resulting form to be the same as $\phi$.

Regarding stricter equivalence theorems,
a proof theoretic equivalence meta-theorem proven for Lean and ZFC+PFIRS is given [here](Lean%20and%20PFIRS.md),
which establishes the equivalence between "global statements" in ZFC+PFIRS (i.e. statements in which quantified variables are *not* necessarily introduced in the manner of $\forall x \in V (\cdots)$) and set theoretic statements relativized to Lean ZFSets.

Another equivalence theorem about what is known as "local statements" (in which quantified variables *do* need to belong to pre-defined sets and hence the quantifiers are "restricted" or "bounded") is given [here](https://proofassistants.stackexchange.com/a/6543).
This theorem directly relates theorems in ZFSets in Lean 
and theorems in $V_\kappa$ universes in ZFCω,
based on the standard interpretations between Lean with $n$ universes and ZFC with $m$ inaccessible cardinals. 
The Lean part of the theorem is prettier and does not take the $\hat{\sigma}_0 \lor \hat{\sigma}_1 \lor \cdots \hat{\sigma}_n$ form.

It can be seen that equivalence of local statements is easier to get 
(because in this sense, ZFCω and ZFC+PFIRS both have the same local statements as Lean does).
On the other hand, equivalence of global statements has only been established between Lean and ZFC+PFIRS.

But this doesn't mean that ZFC+PFIRS represents what Lean proves better in all scenarios.
One thing all the theorems above do not cover 
is Lean set theoretic statements with *multiple* universe parameters.
Such Lean statements appear most naturally translated to set theoretic statements with bounded quantifiers,
and doing so naturally involves relating ZFSet in Lean with inaccessibles in ZFCω.
Or perhaps we are to relate universes in Lean with inaccessible in ZFCω.
Hence discussions here: https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/near/625675114

# What is left to be done?

All the results above allow structure-preserving round trips of theorem translation:
suppose $\phi$ is a set theoretic statement,
and the equivalence theorems always have the following form: 
"$\phi$ holds in one foundation, if and only if, $\hat{\phi}$ holds in another."

## The problem of translating idiomatic Lean

The next question is if such a translation can be generalized to all mathematics, and not just set theoretic statements.
That's to say, we would like to know if a formalized theory in Lean that utilizes things beyond ZFSets can be easily translated to a formalization in, say, ZFC+PFIRS,
and if such a translation, if it exists, allows structure-preserving round trips of translation.
The translated theory in set theory obviously doesn't have to have the same constructs that are conventionally accepted in set theoretic formalization of mathematics (for instance the inductively defined natural numbers in Lean aren't necessarily translated to the usual von Neumann encoding, depending on how inductive types are translated)
but this ultimately is not due to the translation, but due to the existence of multiple formalizations of the same idea *within* set theory.

Unfortunately, existing equivalences between the whole of Lean and set theories does not always have structure-preserving translation round trips.
The famous "Sets in Types, Types in Sets" paper and Mario's master thesis are all bipartite: 
first, it is shown that $\mathsf{Lean}_n$ satisfies a construct in $\mathsf{ZFC}_n$, 
and second, the reverse is proven.
And yet no connection between the two translations is given,
and there is no guarantee that a statement $\phi$ can be first translated from one theory to another and then translated back with its form preserved.

These equivalence theorems are therefore only useful to prove Lean's consistency strength
(which has to be the same as that of ZFCω and also that of ZFC+PFIRS). 

## Encoding of idiomatic Lean into ZFSet-heavy Lean

An intuitive approach to have a more fine-grained translation between Lean and a certain (ZFC-related) set theory is to attempt to translate what is done in idiomatic Lean to ZFSet-heavy Lean,
the latter having been proven to be equivalent to ZFCω or ZFC+PFIRS in various senses.
Intuitively, ordinary mathematics formalized in Lean using the first $n$ universes can always be mechanically formalized in a higher ZFSet,
and thus we have shown that the expressiveness of idiomatic Lean is a subset of ZFSet-heavy Lean,
which is equivalent to ZFC+PFIRS or ZFCω in various senses.

What we get therefore is a one-direction embedding of idiomatic Lean into set theoretic foundations (which may be ZFSet heavy Lean or ZFCω or ZFC+PFIRS).
For those more interested in the *abstract* expressiveness of Lean,
this embedding is satisfactory: 

- the local equivalence theorem of set theoretic statements means that ZFSet-heavy Lean and ZFCω have the same expressiveness and consistent behaviors. 
- The standard embedding of idiomatic Lean constructs into ZFSet-heavy Lean mean that idiomatic Lean construct neither enrich nor contradict ZFSet-heavy Lean.

And thus it is reasonable to say that ZFSet-heavy Lean is equivalent to ZFCω in expressiveness.

What is *not* answered, however, is if ZFSet-heavy Lean is also not strictly stronger than idiomatic Lean.
That's to say, what is not answered is whether we **have to** use ZFSet Lean in certain scenarios.
One way to see this is to notice that this seemingly trivial and yet convincing approach is still one-way,
and there are questions that are statable but not answerable in idiomatic Lean (with the standard axioms).
Once translated, their set theoretic counterparts can however be answered,
and the obvious issue is then these set theoretic counterparts cannot be translated back.

See discussions in https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/with/626506484

Questions to be asked include 

1. Type comparison issues like "is N=Z?" (trivially answerable in ZFSet-heavy Lean or ZFC, but the answer depends on the detail of encoding)
2. Questions regarding the choices made by the global choice function, like "is the chosen real number positive?" (Not sure what is meant here)
3. Size ambiguities of the set-theoretic heights of the universes, like "Does the first universe type correspond to the first inaccessible cardinal?" (not answerable because there is no way to connect the two)

Lean does not stipulate the answers to these questions.
The easiest way forward is to introduce more axioms to pin down the behaviors of idiomatic Lean
so that it has strict correspondences with its set theoretic counterparts.
Thus one may want to 

1. Introduce some axiom that systematically rejects nonprovable equalities of types 
2. Replace Classical.choice with the conjunction of Classical.axiomOfChoice and unique choice (not sure what this means)
3. Demand the universes be consecutive inaccessibles, like demanding the first universe be at the first inaccessible, or demanding the first universe be either the first inaccessible or some limit-ordinal-indexed inaccessible, to avoid deriving anti-large cardinal results. 

Elliot's Astra [suggests](https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/near/625675114) the following:

```Lean
axiom consecutiveUniverses.{u} :
    (∀ κ : Cardinal.{0}, ¬ κ.IsInaccessible) ∧
    (∀ κ : Cardinal.{u + 1},
      κ.IsInaccessible → κ ≤ Cardinal.univ.{u, u + 1})
```
Note that this is an axiom about *idiomatic* Lean:
the type `Cardinal` is defined independently to `ZFSet`.