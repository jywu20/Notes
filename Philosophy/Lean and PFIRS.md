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
- $\sigma^{V_\kappa}$: relativization of $\sigma$ in $V_\kappa$. That's to say, $\forall x$ in $\sigma$ is replaced by $\forall x (x \in V_\kappa \to \cdots)$, and $\exist x$ in $\sigma$ is replaced by $\exist x (x \in V_\kappa \land \cdots)$. Informally, $T \vdash \sigma^{V_\kappa}$ may be written as "$T$ proves that $\sigma$ holds in $V_{\kappa}$", or sometimes $T \vdash (V_{\kappa} \vDash \sigma)$.
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
Now applying PFIRS to $\lnot \sigma \land \exists \lambda_0 (\mathrm{Inacc}(\lambda_0) \land (\lnot \sigma)^{V_{\lambda_0}})$ we get $\exist \lambda_1 (\mathrm{Inacc}(\lambda_1) \land (\lnot \sigma)^{V_{\kappa_1}} \land \exist \lambda_0 (\lambda_0 \in V_{\lambda_1} \land \mathrm{Inacc}(\lambda_0) \land (\lnot \sigma)^{V_{\lambda_0}}))$.
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
In this way, what we have shown in in fact that $\mathsf{ZFC}+\mathsf{PFIRS} \vdash \sigma$, if and only if, there exists $n$ such that $\mathsf{Lean} \vdash_{.\{u\}} \hat{\sigma}_{u} \lor \hat{\sigma}_{u+1} \lor \cdots \lor \hat{\sigma}_{u+n-1}$.
Here $u$ is a universe parameter *within* Lean.

Furthermore, we have observed that the length of the shortest $\mathsf{Lean} \vdash \hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$ sequence is not greater than $m+1$, where $m$ is the number of instances of PFIRS being invoked in the set theoretic side of the proof.
Depending on what $\sigma$ exactly is, the disjunctive sequence in Lean can be further shortened.
For instance, the links in the beginning of this note show that Lean and ZFC+PFIRS prove the same arithmetic statements, and thus for these statements $n=1$.

We note that in this translation between Lean and ZFC+PFIRS, 
statements can be moved between Lean and ZFC+PFIRS back and forth with their structures preserved.
The only subtlety is, if we have a set theoretic statement $\phi$ that holds in a known ZFSet in Lean, then it holds in ZFC+PFIRS, but when it is translated back we only know it holds in *some* ZFSet in Lean without knowing which; but after that moving that weakened statement back and force does not change its form.

This translation is a "global" translation, in that no assumption has been made to the internal structure of $\sigma$.
The more well known equivalence between Lean and ZFC+countable inaccessible cardinals
(which is arguably more beautiful as it does not involve the aforesaid disjunctive sequences),
if we want it to allow structure-preserving translation round trips,
applies only to "local" statements, i.e. statements where quantifiers are bounded to universes.

One example demonstrating the difference between global and local statements, given by [Elliot](https://x.com/ElliotGlazer/status/2019194039829135843?s=20), is the follows.

Consider the statement A: "if there is a proper class of inaccessibles, then Con(TG)."
A is a global statement because "if there is a proper class of inaccessibles" is not a statement in which the existential quantifier sweeps through the whole set theoretic universe, and not just a certain $V_\kappa$.
The set theory TG contains the hypothesis and thus can’t prove the conclusion (to avoid violating Godel's incompleteness theorem).
Now, it is easy to see that A, if understood as a Lean set theoretic statement (where "there exists..." mean "there exists ... in a certain ZFSet"), holds in ZFSet.{0}
(that's to say, "if there is a proper class of inaccessibles in ZFSet.{0}, then natural numbers defined using the standard set theoretic encoding in ZFSet.{0} does not encode a proof of TG's inconsistency").
It is easy to prove in Lean that ZFSet.{0} is a model of ZFC - and if there is a proper class of inaccessibles, then obviously there's a model of ZFC+"there is a proper class of inaccessibles", i.e. a model of TG,
and thus, the consistency of TG is proven (the translation between TG's consistency encoded in the natural number set in ZFSet.{0} and TG's consistency encoded in idiomatic Lean is conceptually trivial). 
So Lean proves sentence A.

By the global set theoretic equivalence between Lean and ZFC+PFIRS, 
the Lean version of A has a counterpart in ZFC+PFIRS, which reads just like A.
But by the local set theoretic equivalence between Lean and ZFC+countable inaccessible cardinals,
A also has a counterpart in the latter.
But this counterpart is something like "if there is a proper class of inaccessibles in one $V_\kappa$, then Con(TG)".
Now *this* is a safe statement to have in ZFC+countable inaccessible cardinals and hence in TG, because you can't insert a proper class of inaccessibles into one $V_\kappa$.

