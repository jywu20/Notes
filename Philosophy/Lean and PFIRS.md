A proof of the equivalence between Lean and ZFC+PFIRS for set theoretic statements
==========

See 
- https://leanprover.zulipchat.com/#narrow/channel/621470-lean4lean/topic/Set.20theoretic.20model/near/614077114
- https://x.com/ElliotGlazer/status/2019200804859875381
- https://proofassistants.stackexchange.com/questions/6541/what-is-the-exact-set-of-arithmetic-statements-provable-in-lean/6543

This note is written with the help of ChatGPT.

# Notation 

- $\sigma$: a set theoretic statement, i.e. a sentence in the set theoretic language $\mathcal{L}_\in$
- $\sigma^{V_\kappa}$: relativization of $\sigma$ in $V_\kappa$. That's to say, $\forall x$ in $\sigma$ is replaced by $\forall x (x \in V_\kappa \to \cdots)$, and $\exist x$ in $\sigma$ is replaced by $\exist x (x \in V_\kappa \land \cdots)$.
- $\hat{\sigma}_n$: the Lean statement that $\sigma$ holds in universe $n$. That's to say, a Lean statement obtained by replacing $\forall x$ in $\sigma$ by $\forall x : \mathtt{ZFSet}\{i\}$ and replacing $\exist x$ in $\sigma$ by $\exist x : \mathtt{ZFSet}\{i\}$.


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
Applying PFIRS, in ZFC+PFIRS we have $\exists \lambda_0 (\mathrm{Inacc}(\lambda_0) \land (\lnot \sigma)^{V_{\lambda_0}})$.
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

Now, in Lean, we can always
fix the $m+1$ universes $U_i=\mathsf{ZFSet}.\{i\}$, for $0\leq i\leq m$.
(Note that here we do not need to quantify over universe indices in Lean to define the list $U$: it is finite, and therefore we can just construct its quantifier-free definition in the metalanguage and inject the definition into Lean.)
Each $U_i$ satisfies ZFC. 

We also have  the following fact: for each fixed $a<b$, there is an inaccessible cardinal $\kappa_{a,b}$ in $U_b$ such that $U_a$, with its membership relation, is isomorphic to $(V_{\kappa_{a,b}})^{U_b}$.

Here $V_\kappa$ is the collection of sets of rank less than $\kappa$, and the superscript means that this collection is computed in $U_b$.
Consequently, if a sentence $\theta$ holds in $U_a$, then $U_b$ has an inaccessible $\kappa$ for which $\theta^{V_\kappa}$ holds.
This is the only consequence of the fact that the counting argument needs.

Now we prove the following lemma: **Each PFIRS instance fails in at most one universe.** 

Fix $j<m$. If $\mathsf{PFIRS}_{\varphi_j}$ fails in $U_a$, then $\varphi_j$ is true there, but no inaccessible cardinal in $U_a$ witnesses its reflection.
For every $b>a$, the copy of $U_a$ inside $U_b$ supplies exactly such a witness.
Thus the conclusion of $\mathsf{PFIRS}_{\varphi_j}$ is true in $U_b$, so $\mathsf{PFIRS}_{\varphi_j}$ holds there.
In particular, $\mathsf{PFIRS}_{\varphi_j}$ cannot fail at two indices $a<b$.

Equivalently, the only possible failure is at the first chosen universe where $\varphi_j$ is true.
At earlier universes its premise is false; at later universes that first universe supplies a witness.
The sentence $\varphi_j$ itself need not stay true as we pass to larger universes.

There are $m$ instances, and each fails in at most one universe.
Together they therefore exclude at most $m$ of the $m+1$ universes.
(Note that the argument above is proven *in classical Lean* using pigeon principle, and we do not even need the PFIRS instances to be provable in Lean (a metatheoretic property).)
At least one $U_i$ satisfies every $\mathsf{PFIRS}_{\varphi_j}$.
Since it also satisfies the ZFC axioms used in the proof of $\sigma$, the same finite proof, interpreted in $U_i$, establishes $\hat{\sigma}_i$.
The successful universe may depend on this finite list of instances.
Hence
$\mathsf{Lean}\vdash\hat{\sigma}_0\lor\cdots\lor\hat{\sigma}_m.$.

**Proof of the fact about universes.** Fix $a<b$.
We construct an embedding $e:U_a\to U_b$ and show that its image is $(V_\kappa)^{U_b}$ for an inaccessible $\kappa$ in $U_b$.

ZFC sets in Lean are defined in the following ways:
first, a pre-set is defined as a family of other pre-sets labeled by labels from a given type,
and because different descriptions may represent the same set, a ZFC set (belonging to the type `ZFSet`) is defined by identifying descriptions that are extensionally equivalent.
There is an operation, [PSet.Lift](https://leanprover-community.github.io/mathlib4_docs/Mathlib/SetTheory/ZFC/PSet.html#PSet.Lift), which copies a description into a larger universe, replacing its labels by their copies under $\mathsf{ULift}$ and recursively lifting its members.

The lifting operation can now be defined as $e([p])=[\mathsf{PSet.Lift}(p)]$, where $[p]$ denotes the ZFC set represented by the pre-set $p$, and the lift is from universe $a$ to universe $b$.
Write $p\sim q$ for extensional equivalence ([PSet.Equiv](https://leanprover-community.github.io/mathlib4_docs/Mathlib/SetTheory/ZFC/PSet.html#PSet.Equiv)): each member description of $p$ has an equivalent member description in $q$, and conversely.
Induction on the recursive construction of $p$, with $q$ arbitrary, gives
$$\mathsf{PSet.Lift}(p)\sim\mathsf{PSet.Lift}(q)\quad\Longleftrightarrow\quad p\sim q.$$
Indeed, $\mathsf{ULift}$ gives a bijection between the original and lifted labels, so matching members before and after lifting reduces to the same equivalence for the smaller descriptions, where the induction hypothesis applies.
Since $[p]=[q]$ exactly when $p\sim q$, the right-to-left implication makes $e$ independent of the chosen description, and the left-to-right implication makes $e$ injective.

From the definition it follows that $e(x)=\{e(y):y\in x\}$.
Together with injectivity, this gives $e(x)\in e(y)\leftrightarrow x\in y$.
Thus $e$ preserves and reflects membership.

Define $\kappa$ to be the set in $U_b$ whose members are the images of all the ordinals in $U_a$.
This collection is a set in $U_b$ because the type of ordinals in $U_a$ lives in $\mathsf{Type}\,(a+1)$, and $a+1\leq b$.
Lifting preserves ordinals and their predecessors, so this set is transitive and all its members are ordinals.
Thus $\kappa$ is itself an ordinal in $U_b$, and the ordinals below it are exactly the lifted ordinals of $U_a$.
(The corresponding type theoretic ordinal is [Ordinal.univ](https://leanprover-community.github.io/mathlib4_docs/Mathlib/SetTheory/Ordinal/Univ.html#Ordinal.univ).)

Call a set in $U_b$ *small* if its members can be indexed bijectively by a type in $\mathsf{Type}\,a$.
For an ordinal $\alpha$ in $U_b$, this is equivalent to $\alpha<\kappa$.
Indeed, lifted ordinals are small; conversely, a well-order on such an indexing type has an order type in $U_a$, whose lift is $\alpha$.
This works even for a well-order supplied by $U_b$, since its relation takes values in $\mathsf{Prop}$.
In particular, $\kappa$ is not small, since that would imply $\kappa<\kappa$.

It follows that $\kappa$ is a cardinal: a bijection with a smaller ordinal would make it small.
Also $\omega<\kappa$, since $\mathbb{N}$ is an indexing type in universe $a$, after lifting if necessary.
More generally, a set $x$ in $U_b$ is small if and only if $|x|<\kappa$, by well-ordering its members.
Here cardinalities are computed inside $U_b$: bijections between types of members correspond to set theoretic bijections through their graphs, which are sets in $U_b$.

To prove that $\kappa$ is a strong limit, let $\mu<\kappa$ be a cardinal and choose a type $A:\mathsf{Type}\,a$ indexing $\mu$.
Subsets of $\mu$ in $U_b$ correspond exactly to predicates $A\to\mathsf{Prop}$, using membership in one direction and separation in the other.
These predicates form a type in $\mathsf{Type}\,a$, including those defined using parameters from larger universes.
Thus the power set of $\mu$ is small, so $2^\mu<\kappa$.

For regularity, consider any family $(\alpha_i)_{i\in I}$ of ordinals below $\kappa$ in $U_b$, with $|I|<\kappa$.
Index $I$ by a type in $\mathsf{Type}\,a$ and pull each $\alpha_i$ back to an ordinal $\beta_i$ in $U_a$.
We can collect the $\beta_i$ into a set in $U_a$: choose pre-set descriptions and use that indexing type as their labels.
Its supremum $\beta$ is an ordinal of $U_a$.
Since $e$ preserves ordinal order, $e(\beta+1)<\kappa$ strictly bounds every $\alpha_i$.
Thus every family of fewer than $\kappa$ ordinals below $\kappa$ is bounded below $\kappa$.
This proves regularity, and hence $\kappa$ is inaccessible in $U_b$.

We next prove that the image of $U_a$ under $e$ consists of exactly the sets of rank less than $\kappa$ in $U_b$.
This is the step that identifies it with $V_\kappa$.

First, for $x:U_a$, its set theoretic rank is an ordinal of $U_a$.
The equation $\mathrm{rank}(x)=\sup_{y\in x}(\mathrm{rank}(y)+1)$, together with the definition of $e$, shows by induction on membership that the rank of $e(x)$ in $U_b$ is the image of the rank of $x$ in $U_a$.
Here lifting preserves successor and the indicated supremum: the supremum of a family of ordinals is their union, and $e(x)$ has exactly the lifted members of $x$.
By the definition of $\kappa$, this lifted rank is less than $\kappa$.
Thus every lifted set belongs to $V_\kappa$ in $U_b$.

For the converse, we first observe that $|V_\alpha|<\kappa$ for every $\alpha<\kappa$, with the hierarchy and cardinalities computed in $U_b$.
This follows by transfinite induction: the successor step uses $2^\mu<\kappa$ for $\mu<\kappa$, and the limit step uses regularity to take the union of fewer than $\kappa$ sets, each of cardinality less than $\kappa$.
Consequently, any set $z$ of rank less than $\kappa$ has cardinality less than $\kappa$, since $z\subseteq V_{\mathrm{rank}(z)}$.
Its members therefore have an indexing type in $\mathsf{Type}\,a$.

Now apply induction on membership to such a $z$.
Every member of $z$ has smaller rank, so by induction each is the image under $e$ of a set in $U_a$.
Choose these preimages and collect them using the indexing type just obtained.
This constructs a set $x:U_a$ whose lifted members are exactly the members of $z$; hence $e(x)=z$.
We have therefore proved that $e$ gives a bijection from $U_a$ onto the elements of $V_\kappa$ in $U_b$, preserving and reflecting equality and membership.

For any fixed set theoretic sentence $\tau$, induction on its construction now shows that $\hat{\tau}_a$ is equivalent to $\tau^{V_\kappa}$ as interpreted in $U_b$.
Equality and membership agree under the bijection, and quantification over $U_a$ corresponds to quantification over the elements of $V_\kappa$ in $U_b$.
Since $\kappa$ is inaccessible there, we obtain the desired bridging theorem:
$\mathsf{Lean}\vdash\hat{\tau}_a\to\widehat{\exists\kappa(\mathrm{Inacc}(\kappa)\land\tau^{V_\kappa})}_b$.

(As before, $a,b$ are fixed universe indices in the metalanguage, and the induction on $\tau$ is an induction producing a Lean proof for each sentence.
The construction and the arguments about $\kappa$ take place in classical Lean.
When we say that a set theoretic statement holds in $U_b$, we mean its translation obtained by quantifying over $\mathsf{ZFSet}.\{b\}$, as in the earlier notation.)


# Discussion

We have shown equivalence between provable set theoretic statements in Lean and in ZFC+PFIRS.
The correspondence is not as regular as what we may imagine,
as the counterpart of $\sigma$ at the Lean side is something like $\hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$.

By the standard model construction of Lean's type theory, 
it appears that ordinary mathematics formalized in Lean using the first $n$ universes can always be mechanically formalized in a higher ZFSet.
(We need a theorem explicitly stating that ZFSets have inaccessible cardinals.)
Thus if we ignore the ugly form $\hat{\sigma}_0 \lor \cdots \lor \hat{\sigma}_{n-1}$,
then it appears that Lean and ZFC+PFIRS are indeed equivalent.
