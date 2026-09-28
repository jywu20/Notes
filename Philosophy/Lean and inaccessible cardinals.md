# Existing results: global and local set theoretic equivalence

Studying equivalences between foundations of mathematics is beneficial for e.g. importing and exporting of theorems from one foundation to another.

Regarding strict bidirectional equivalence theorems (that at least roughly allow statements to be brought back and forth with its structure preserved after a round trip),
a proof theoretic equivalence meta-theorem proven for Lean and ZFC+PFIRS is given [here](Lean%20and%20PFIRS.md),
which establishes the equivalence between "global statements" in ZFC+PFIRS (i.e. statements in which quantified variables are *not* necessarily introduced in the manner of $\forall x \in V (\cdots)$) and set theoretic statements relativized to Lean ZFSets.
This metatheorem is slightly awkward,
because it states that a set theoretic statement $\sigma$ (FOL statement involving only $=$ and $\in$) in ZFC+PFIRS holds, if and only if,
there exists a natural number $n$ (in the metatheory) such that in Lean, $\hat{\sigma}_u \lor \hat{\sigma}_{u+1} \lor \cdots \hat{\sigma}_{u+n}$ holds, with $u$ being a freely chosen universe parameter;
this long sequence of disjunctive statements looks ugly, though it does not prevent us from extracting a common schema $\sigma$ from it and finding that $\sigma$ holds in ZFC+PFIRS.
Because no internal structure constraint is applied to $\sigma$,
this is a metatheorem about global equivalence of set theoretic consequences of Lean and ZFC+PFIRS.

Another equivalence theorem about what is known as "local statements" (in which quantified variables *do* need to belong to pre-defined sets and hence the quantifiers are "restricted" or "bounded") is given [here (see the discussions after "Since there have been questions about Elliot's 'local statements' comment")](https://proofassistants.stackexchange.com/a/6543).
The theorem states that for a set theoretic statement $\sigma$,
ZFCω proves the statement obtained by bounding $\sigma$'s quantifiers to a certain $V_{\kappa}$,
if and only if, Lean proves the statement obtained by bounding $\sigma$'s quantifiers to a certain ZFSet.
This theorem directly relates theorems in ZFSets in Lean 
and theorems in $V_\kappa$ universes in ZFCω,
and the Lean part of the theorem is prettier and does *not* take the $\hat{\sigma}_0 \lor \hat{\sigma}_1 \lor \cdots \hat{\sigma}_n$ form.

It can be seen that equivalence of local statements is easier to get 
(because in this sense, ZFCω and ZFC+PFIRS both have the same local statements as Lean does;
see the link above).
On the other hand, equivalence of global statements has only been established between Lean and ZFC+PFIRS.

But this doesn't mean that ZFC+PFIRS represents what Lean proves better in all scenarios.
One thing all the theorems above do not cover 
is Lean set theoretic statements with *multiple* universe parameters.
Such Lean statements appear most naturally translated to set theoretic statements with bounded quantifiers,
and doing so naturally involves relating ZFSet in Lean with inaccessibles in ZFCω.
Or perhaps we are to relate universes in Lean with inaccessible in ZFCω.
Hence discussions here: https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/near/625675114
I don't on the other hand see any fundamental difficulty to generalize the local equivalence theorem to the multi-universe parameter situation.

# What about non-set theoretic statements?

All the results above allow structure-preserving round trips of theorem translation:
suppose $\phi$ is a set theoretic statement,
and the equivalence theorems always have the following form: 
"$\phi$ holds in one foundation, if and only if, $\hat{\phi}$ holds in another."

The next question is if such a translation can be generalized to all mathematics, and not just set theoretic statements.
That's to say, we would like to know if a formalized theory in Lean that utilizes things beyond ZFSets can be easily translated to a formalization in, say, ZFC+PFIRS,
and if such a translation, if it exists, allows structure-preserving round trips of translation.
The translated theory in set theory obviously doesn't have to have the same constructs that are conventionally accepted in set theoretic formalization of mathematics (for instance the inductively defined natural numbers in Lean aren't necessarily translated to the usual von Neumann encoding, depending on how inductive types are translated)
but this ultimately is not due to the translation, but due to the existence of multiple formalizations of the same idea *within* set theory.

Here we can define two styles of Lean.
- ZFSet-heavy Lean is defined as proving theorems about set theoretic statements in which each quantifier is bounded to a certain ZFSet.{u} (but proofs are not restricted to ZFSet),
- while idiomatic Lean means the style to do formalization without relying on ambient ZFSet.

A good example is how cardinals are defined in Lean:
the type `Cardinal` is defined via quotient type and obviously
the rough idea behind the definition is to treat Lean types as things roughly comparable to sets;
but `ZFSet` does not appear in the definition.

Unfortunately, translation round trips are much harder between idiomatic Lean and set theoretic foundations. We discuss why in the rest of this note.

# The standard ZFCω interpretation of Lean statements

A third metatheorem (which is needed in proofs of the two metatheorems above) that shows that Lean and set theoretic foundations are more or less equivalent can be found in the famous "Sets in Types, Types in Sets" paper and Mario's master thesis.
The theorem states that there is an equi-interpretability theorem between Lean and ZFCω (ZFC + $\{\text{there exists n inaccessible cardinals} | n \in \mathbb{N}\}$, sometimes also known as ZFC + countable inaccessible cardinals, although the latter may be misunderstood as allowing the inaccessible cardinals to be collected into a single set),
which is discussed [here](../Computer%20Science/Logic%20and%20PLT/Lean.md).

From this equivalence theorem, Lean's consistency strength is proven to be the same as that of ZFCω and also that of ZFC+PFIRS. 

The metatheorem is different from the global and local theorems in several ways:
the global and local theorems are only about set theoretic statements introduced above,
but the one sketched in the famous "Sets in Types, Types in Sets" paper and Mario's master thesis covers all Lean statements.
Further, importantly, this third metatheorem does not allow structure-preserving round trips:
suppose $\phi$ is a theorem in ZFCω and is translated to Lean and then translated back, and we have no reason to expect the resulting form to be the same as $\phi$:
this is because we have interpretations in both directions 
and yet no connection between the two translations is given.

To see why we do not have a structure-preserving round trip from the existing construct, let's consider a simple example.

Suppose we have an idiomatic Lean statement $\phi$, which looks like, say, "for every $x : A$, there exists $y : B$, such that...";
to make things easy we assume that in each quantifier $\forall x:A$ or $\exist x:A$ in $\phi$, $A : \mathsf{Type} \ 0$.

Now we can translate $\phi$ to a set theoretic statement $\phi'$ in which $A$ and the like are translated to their set theoretic counterparts in the standard way.
Now what should you do to translate $\phi'$ back?
Note that there is no a priori way to know that the sets involved in $\phi'$ have Lean counterparts;
we're just faced with a statement like $\forall x' (x' \in A' \to \exist y' (y' \in B' \land \cdots))$.
In the most generic case, we have to translate the statement back to Lean as 
$\phi'' = \forall x : \mathsf{ZFSet}.\{0\} (x \in A'' \to \exist y : \mathsf{ZFSet}.\{0\} (y \in B'' \land \cdots))$.

We immediately notice two things off:
(a) the resulting Lean statement is a ZFSet-heavy statement, not $\phi$,
and (b) we have a universe level bump because $\mathsf{ZFSet}.\{0\} : \mathsf{Type}\ 1$ while in $\phi$, all types quantifiers are bounded to are in $\mathsf{Type}\ 0$.

$\phi''$, if regarded as an idiomatic Lean statement, will become a statement involving $\mathsf{Type} \ 2$ statements after another round trip; using the local equivalence theorem, we alternatively show that $\phi''$ is equivalent to something like $\forall x (x \in V_{\kappa_0} \land x \in A''' \to \exist y (y \in V_{\kappa_0} \land y \in B''' \land \cdots))$;
note that here the definitions of $A'''$, $B'''$ etc. have to be understood in $V_{\kappa_0}$;
if $A, B$ are sufficiently "small", $A = A'''$, and the like, but when they are "large", the two have different encodings.
Now *this* statement can be brought back and forth and undergo translation loop trips with its form preserved.

The demonstration above essentially proves that idiomatic Lean can be translated into ZFSet-heavy Lean (that's to say, $\phi''$), often with an increased universe level.
This is a one-direction embedding of idiomatic Lean into set theoretic foundations (which may be ZFSet heavy Lean or ZFCω or ZFC+PFIRS) that demonstrates that idiomatic Lean does not behave substantially differently from ZFSet-heavy Lean,
which in turn behaves identically to ZFCω if we restrict ourselves to local set theoretic statements,
and behaves identically to ZFC+PFIRS if we focus on global set theoretic statements and Lean ZFSet statements with a single universe parameter.
For most purposes, we find that satisfactory.

# What the ZFCω translation does not say

What is *not* answered in the construct above is the exact expressiveness of idiomatic Lean.
This is a vague concept but we may wonder in which non-set theoretic situations we **have to** use ZFSet (or similar constructs). 
When a formal definition of idiomatic Lean is lacking,
we ideally still need a full proof theoretic bidirectional translation between the whole of Lean and set theoretic foundations.

And this is not given by any of the three metatheorems.
None of the metatheorems tells us how to translate a set theoretic statement to an "idiomatic" Lean statement, without ZFSets being inserted into the Lean translation.
(For arithmetic statements, a translation from ZFSet-heavy Lean to idiomatic Lean is almost trivial, but not all set theoretic constructs can be translated to idiomatic Lean.)

And indeed, if everything is taken literally, then with the current version of Lean,
there are obviously questions that are statable but not answerable in idiomatic Lean (with the standard axioms),
which, once translated, can however be answered,
and the obvious issue is then these set theoretic counterparts cannot be translated back.

Perhaps we can just argue that things you can't prove in idiomatic Lean 
but can prove in ZFSet heavy Lean or set theoretic foundations are not natural.

These problematic Lean questions are discussed in https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/with/626506484 
Some of them are

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

# Tentative summary

So it appears that set theoretic foundations prove things that Lean don't prove (N is not Z, and the like).
On the other hand, only ZFSet-centric Lean statements have straightforward set theoretic counterparts;
but a non-ZFSet-centric Lean statement can be mapped to a ZFSet-centric one by first giving it a standard set theoretic translation as in Sets in Types, Types in Sets,
and then translating it back to Lean using the local set theoretic translation.
An idiomatic Lean statement $\phi$ is provable in Lean,
if and only if, its ZFSet-centric version is provable.
And yet there is no way to translate all set theoretic statements back.
