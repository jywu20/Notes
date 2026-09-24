A proof of the equivalence between Lean and ZFC+PFIRS for set theoretic statements
==========

See 
- https://leanprover.zulipchat.com/#narrow/channel/621470-lean4lean/topic/Set.20theoretic.20model/near/614077114
- https://x.com/ElliotGlazer/status/2019200804859875381
- https://proofassistants.stackexchange.com/questions/6541/what-is-the-exact-set-of-arithmetic-statements-provable-in-lean/6543
- https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/

This note is written with the help of ChatGPT.

# Notation 

- $\sigma$: a set theoretic statement, i.e. a sentence in the set theoretic language $\mathcal{L}_\in$
- $\sigma^{V_\kappa}$: relativization of $\sigma$ in $V_\kappa$. That's to say, $\forall x$ in $\sigma$ is replaced by $\forall x (x \in V_\kappa \to \cdots)$, and $\exist x$ in $\sigma$ is replaced by $\exist x (x \in V_\kappa \land \cdots)$.
- $\hat{\sigma}_n$: the Lean statement that $\sigma$ holds in universe $n$. That's to say, a Lean statement obtained by replacing $\forall x$ in $\sigma$ by $\forall x : \mathtt{ZFSet}.\{i\}$ and replacing $\exist x$ in $\sigma$ by $\exist x : \mathtt{ZFSet}.\{i\}$.


# The theorem to prove 

Definitions:

- PFIRS = parameter-free inaccessible reflection scheme, that's to say, for every set theoretic statement $\varphi$ that does not contain parameters, $\varphi \rightarrow \exists \kappa (\mathrm{inaccessible}(\kappa) \land \varphi^{V_\kappa})$. This is an axiom scheme, in which $\varphi^{V_\kappa}$ is algorithmically definable.
- Lean = Lean with the three classical axioms

The metatheorem to prove is the follows: suppose $\sigma$ is a set theoretic statement.
Then $\mathsf{ZFC}+\mathsf{PFIRS} \vdash \sigma$, if and only if, $\exist n \in \mathbb{N}, \mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$.

Note that the right hand side is not $\exist n \in \mathbb{N}, \mathsf{Lean} \vdash \hat{\sigma}_n$:
this is because from $\mathsf{Lean} \vdash p \lor q$ we don't really know if $\mathsf{Lean} \vdash p$ or $\mathsf{Lean} \vdash q$.
It may be the case that Lean proves none of the two but knows at least one of them is correct.

Of course, if Lean proves $\hat{\sigma}_i$, then it also proves $\hat{\sigma}_{i+1}$.
But this alone doesn't guarantee that if $\mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$ then Lean has to prove one of the branches.

# Lean $\Rightarrow$ ZFC+PFIRS

Suppose for some $n$, $\mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$.
The proof may use far more universes than $n$ but by virtue of being of a finite length, there has to be an upper bound - say $N$ - of the number of universes used (as Lean doesn't allow quantifying over universes).
That's to say, $\mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$ is provable in the subtheory of Lean, $\mathsf{Lean}_\sigma$, that contains finite universes.

Suppose towards contraction that the theory $T = \mathsf{ZFC} + \mathsf{PFIRS} + \lnot \sigma$ is consistent.

We now start building along the following procedure in $T$.
Applying PFIRS, we have $\exists \lambda_0 (\mathrm{Inacc}(\lambda_0) \land (\lnot \sigma)^{V_{\lambda_0}})$.
Now applying PFIRS to $\lnot \sigma \land \exists \lambda_0 (\mathrm{Inacc}(\lambda_0) \land (\lnot \sigma)^{V_{\lambda_0}})$ we get $\exist \lambda_1 (\mathrm{Inacc}(\lambda_1) \land (\lnot \sigma)^{V_{\kappa_1}} \land \exist \lambda_0 (\lambda_0 \in V_{\lambda_1} \land \mathrm{Inacc}(\lambda_0) \land \sigma^{V_{\lambda_0}}))$.
We can repeat this process over and over again, and this means that for an arbitrary $m$, we have 
$\exist \lambda_0 \exist \lambda_1 \cdots \exist \lambda_m (\lambda_0 \in V_{\lambda_1} \land \lambda_1 \in V_{\lambda_2} \land \cdots \land \lambda_{m-1} \in V_{\lambda_m} \land (\lnot \sigma)^{V_{\lambda_0}} \land (\lnot \sigma)^{V_{\lambda_1}} \land \cdots \land (\lnot \sigma)^{V_{\lambda_m}})$.
This means that in ZFC+PFIRS, we can find a finite chain $\kappa_0 < \kappa_1 < \cdots < \kappa_{N-1}$
such that for every $i < N$, $(\lnot \sigma)^{V_{\kappa_i}}$, where $N$ can be arbitrarily big.

(Note that "repeating this process over and over again" means induction in the metalanguage and not in ZFC+PFIRS:
we are performing induction over proofs in ZFC+PFIRS).

Now, by the standard correspondence between Lean with finitely many universes and ZFC+finitely many inaccessible cardinals,
a model of $T$ is also a model of $\mathsf{Lean}_\sigma$ - and yet in such a model $\sigma$ holds in no Lean universe. Contradiction. Thus $T$ cannot be consistent and thus $\mathsf{ZFC} + \mathsf{PFIRS} \vdash \sigma$.

# ZFC + PFIRS $\Rightarrow$ Lean

Suppose $\mathsf{ZFC}+\mathsf{PFIRS}\vdash\sigma$.
The proof uses only finitely many PFIRS instances, say
$$\mathsf{PFIRS}_{\varphi_j}:\quad \varphi_j\to\exists\kappa\bigl(\mathrm{Inacc}(\kappa)\land\varphi_j^{V_\kappa}\bigr)
\qquad(j<m),$$
where each $\varphi_j$ is a sentence without parameters.
Thus $\mathsf{ZFC}+\{\mathsf{PFIRS}_{\varphi_0},\ldots,\mathsf{PFIRS}_{\varphi_{m-1}}\}\vdash\sigma$.
We note that we do NOT need to know how these PFIRS instances are utilized. 
We don't need $\varphi_i$ to be provable or not. 
All we know is that some PFIRS instances are used in the proof and that's enough for us to complete the proof below.

We then note that the only way for $\mathsf{PFIRS}_{\varphi_i}$ to fail is for $\varphi_i$ to hold but $\neg \exist \kappa (\mathrm{Inacc}(\kappa) \land \varphi_i^{V_\kappa})$.
Now suppose that in a certain $\mathtt{ZFSet}.\{u\}$, $\varphi_i$ holds (i.e. we assume in Lean that $\hat{\varphi_i}_u$) but $\neg \exist \kappa (\mathrm{Inacc}(\kappa) \land \varphi_i^{V_\kappa})$ also holds. 
Now, a very intuitive lemma in Lean is that, if a set theoretic statement holds in $\mathsf{ZFSet}.\{u\}$, then it should hold in a certain inaccessible $V_\kappa$ in $\mathsf{ZFSet}.\{v\}$ where $v$ is greater than $u$.
(Am I right here? I remember seeing it somewhere.) 
And thus, if $\mathsf{PFIRS}_{\varphi_i}$ fails in $\mathtt{ZFSet}.\{u\}$, it also means that $\varphi_i$ holds in $\mathtt{ZFSet}.\{u\}$,
and this precise fact already means that in higher $\mathtt{ZFSet}.\{v\}$, there exists an inaccessible $V_\kappa$ such that $\varphi_i$ holds in $V_{\kappa}$.
And thus $\mathsf{PFIRS}_{\varphi_i}$ holds in all higher $\mathtt{ZFSet}.\{v\}$ universes.

From this observation, it immediately follows that, given a finite successive list of $\mathtt{ZFSet}.\{u_\text{min}\}, \mathtt{ZFSet}.\{u_\text{min}+1\}, \ldots, \mathtt{ZFSet}.\{u_{\text{max}}\}$, for every $\mathsf{PFIRS}_{\varphi_i}$, Lean proves that $\mathsf{PFIRS}_{\varphi_i}$ fails in at most one of these universes.
(Note that this statement can be rephrased as something like "the statement fails in this universe but not others, or that universe but not others, or..." and there is no need to quantify over any universe index.)

Now, suppose we pick $m+1$ successive universes in a row. 
Lean proves that every $\mathsf{PFIRS}_{\varphi_i}$ fails at most once in the sequence.
Applying the pigeonhole argument *in Lean* we find that Lean proves that there exists one $u_{\text{min}} \leq u \leq u_{\text{min}} + m$ such that $\mathsf{ZFSet}.\{u\}$ satisfies all $\mathsf{PFIRS}_{\varphi_i}$ statements. 
(Again, this statement can be expanded into a finite disjunctive statement, in the form of "in this $\mathsf{ZFSet}.\{u\}$, all $\mathsf{PFIRS}_{\varphi_i}$ statements hold, or in that $\mathsf{ZFSet}.\{u\}$, $\mathsf{PFIRS}_{\varphi_i}$ statements hold, or ...")
Now in this ZFSet universe, ZFC axioms hold, and all PFIRS instances hold, and therefore $\sigma$ holds in this ZFSet.
Thus, we have shown that Lean proves 
$$
\hat{\sigma}_{u_{\text{min}}} \lor \hat{\sigma}_{u_{\text{min}}+1} \lor \cdots \lor \hat{\sigma}_{u_{\text{min}}+m},
$$
which is precisely what we expect.
Setting $u_{\text{min}} = 0$ and we get the equivalence metatheorem promised above.
 

# Discussion

We have shown equivalence between provable set theoretic statements in Lean and in ZFC+PFIRS.
The correspondence is not as regular as what we may imagine,
as the counterpart of $\sigma$ at the Lean side is something like $\hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$.
It's also possible to replace $\hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$ by $\hat{\sigma}_{u_{\text{min}}} \lor \cdots \lor \hat{\sigma}_{u_{\text{min}+n-1}}$.

Furthermore, what we actually have shown is that the length of the shortest $\mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$ sequence is not greater than $n=m+1$, where $m$ is the number of instances of PFIRS being invoked in the set theoretic side of the proof.
Depending on what $\sigma$ exactly is, the disjunctive sequence in Lean can be further shortened.
For instance, the links in the beginning of this note show that Lean and ZFC+PFIRS prove the same arithmetic statements, and thus for these statements $n=1$.

We note that this translation between Lean and ZFC+PFIRS is proof theoretic.
Thus statements can be moved between Lean and ZFC+PFIRS back and forth with their structures preserved (the only subtlety is, if we have a set theoretic statement $\phi$ that holds in a known ZFSet in Lean, then it holds in ZFC+PFIRS, but when it is translated back we only know it holds in *some* ZFSet in Lean without knowing which; but after that moving that weakened statement back and force does not change its form).
Existing equivalences between Lean and set theories are on the other hand model theoretic (basically, how $\mathsf{Lean}_n$ satisfies a construct in $\mathsf{ZFC}_n$, and vice versa) and there is no guarantee that a statement $\phi$ can be first translated from one theory to another and then translated back with its form preserved.
These equivalence theorems are more useful to prove Lean's consistency strength. 

The next question is if this translation can be generalized to all mathematics, and not just set theoretic statements.
That's to say, we would like to know if a formalized theory in Lean that utilizes things beyond ZFSets can be easily translated to a formalization in, say, ZFC+PFIRS.
The translated theory in set theory obviously doesn't have to have the same constructs that are conventionally accepted in set theoretic formalization of mathematics (for instance the inductively defined natural numbers in Lean aren't necessarily translated to the usual von Neumann encoding, depending on how inductive types are translated)
but this ultimately is not due to the translation, but due to the existence of multiple formalizations of the same idea *within* set theory.

An intuitive approach in this direction is to attempt to show that idiomatic Lean formalizations can all more or less be done by heavily relying on ZFSet.
Then, by the standard model construction of Lean's type theory, 
it appears that ordinary mathematics formalized in Lean using the first $n$ universes can always be mechanically formalized in a higher ZFSet.
Thus we have shown that the expressiveness of idiomatic Lean is a subset of ZFSet-heavy Lean,
the latter, if we ignore the ugly form $\hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$,
being equivalent to ZFC+PFIRS to a certain extent.

There are several difficulties we have.

The first is that developers of Mathlib have no problem using universes,
so a typical Lean version of a mathematical theorem often contains universe parameters whose values can be freely chosen.
Note that the equivalence theorem above is about statements being provable in *some* ZFSet.{u}.

Second, there are statements that are not answerable in Lean (with the standard axioms) but can be answered if translated according to standard translations.

https://leanprover.zulipchat.com/#narrow/channel/236446-Type-theory/topic/Lean.20and.20ZFC.2BPFIRS/with/626506484

1. Type comparison issues like "is N=Z?"
2. Questions regarding the choices made by the global choice function, like "is the chosen real number positive?"
3. Size ambiguities of the set-theoretic heights of the universes, like "Does the first universe type correspond to the first inaccessible cardinal?"

I could suspect these 3 ambiguities could be filled in respectively via:

1. Some axiom that systematically rejects nonprovable equalities of types (Mario suggests to me this might be better-behaved than the opposite disambiguation: trying to declare the type-theoretic universe behaves like the cardinality model),
2. Replace Classical.choice with the conjunction of Classical.axiomOfChoice and unique choice,
3. It might be possible to demand the universes be consecutive inaccessibles, but I'm less sure about that. The way universe-indexing works in Lean is still confusing to me. (Also, rather than demanding the first universe be at the first inaccessible, I think it would be preferable to demand the first universe be either the first inaccessible or some limit-ordinal-indexed inaccessible, to avoid deriving anti-large cardinal results. This would lead to better translation properties between this extension of Lean vs ZFC).


