Reading note of Comprehensive Grammar of English Language
======

This is a reading note of CGEL (Quirk 1985), with some commentaries with regard to its implication in generali linguistics. 

# Organization of grammar

Modern generative morphosyntax is highly feature-based and fine-grained. In CGEL, however, like other 
descriptive works, constructions are *not* anatomized as small as possible. An example can be found 
in Sec. 2.16. Sec. 2.16 is about clause types, or to be clear, about obligatory arguments. The authors 
simply list all possible argument configurations (see Table 2.16). A generative grammarian may then 
go on to discuss how subjects, objects, complements, and adverbials are introduced by different 
functional heads (i.e. how "subjectness, objectness, complementness and adverbialness" features are 
introduced into the syntactic tree and whether and how they are licensed by the main verb). 
But you don't see this in CGEL.

This is kind of like construction grammar in that constructions are basic units, but unlike construction
grammar, the authors focus solely on *structures*, not form-meaning pairs. Nor do they claim anything like 
"network of constructions" or the role of domain-general cognitive processes (Hoffmann and Trousdale 2013).
In a word, it's more like PSG. We can rephrase Table 2.16 and Fig. 2.25 as 

- S → Subject Verb
- S → Subject Verb Object
- S → Subject Verb Complement
- S → Subject Verb Adverbial
- S → Subject Verb Object Object
- S → Subject Verb Object Complement
- S → Subject Verb Object Adverbial
- Subject → NP
- Verb → VP
- Object → NP
- ...

Similar examples can be found in Sec. 2.28. 

Grammatical relations beyond PSG (i.e. long range dependencies, like agreement or wh-movement, or relation between arguments) are introduced in an informal way. 
Table 2.19 is an example.
These relations means the grammar framework needed for describing natural languages is stronger than PSG.
On the other hand, we don't have rules like

> S → left-parenthesis Subject Verb Object right-parenthesis

and it's very rare that constructions of the same type involve completely different sets of tags. (For example, 
all sentences listed in Sec. 2.16 have a subject)
This is because each constituent is introduced by a functional head, and we have a stable functional hierarchy. 
So the grammar framework needed for describing natural languages is also more restricted than PSG used to describe 
programming languages. Dependencies beyond surface phrase structures are often derived by some kind of movement.

Here we give a brief mapping between the BLT-like approach here and the DM-like feature-based generative morphosyntax:
- PSG ≈ the surface form of a projection hierarchy
- list of possible constructions ≈ allowed feature combination
- transformational relation between two constructions ≈ the first few steps of derivation are the same (example: same vP structure)
- local grammatical relations ≈ Agree, post-syntactic morphological process, etc.

# Terms and definitions

We first do a brief sketch of the description framework of CGEL. Many terms have [different meanings](../methodology/morphosyntax-points.md#note-on-terminology) in 
descriptive grammar and in formal generative grammar, and from the terminology used we can also see how authors organize the grammar.

- The **verb phrase** means the predicate complex, not [V O] (see Sec. 2.3) Though the generative [ Aux1 [ Aux2 ... ] ] analysis can also be seen in, for example, Fig. 3.21
- But the **predicate** means V plus O, while in basic linguistic theory (BLT), *predicate* means *verb phrase*
- The term **preposition phrase** is used, as opposed to Dixon's advice. But note that in English, peripheral arguments like locative or comitative can only be filled by PPs (or in Dixon's
  terms, by "NPs with peripheral case"), so we have the following table:
  
  | | preposition | core argument | peripheral argument |
  | :----- | :------ | :------ | :----- |
  | NP | - | + | - |
  | PP | + | - | + |

  So we have the following implicational rules:
  > For a phrase with mostly nominal contents:
  > 
  > - if it has a preposition, then it can only fill a peripheral argument slot, and vice versa, and
  > - if it doesn't has a preposition, then it can only fill a core argument slot, and vice versa.

  So the concept *prepositional phrase* is useful, because it highlights the role of the preposition.

  A side note: now I find Dixon's argument is 
  interesting and persuasive, because in a clause "I was in that house yesterday", obviously the copula complement is "in that 
  house" as a whole, and by no means I am exactly that house. Well, Dixon may argue that [that house] is in a
  locative case, similar to Latin locative ablative, and the structure of the sentence is 
  > was<sub>copula, past tense</sub> I<sub>CS</sub> [in that house]<sub>Locative</sub> 

  (See Sec. 2.8) 

  Well, this sounds pretty generative :) But on the other hand, analyzing PP in generative syntax as headed by a preposition also makes senses in a functionalist context, because the preposition may be regard as a part of the predicate. This, again, shows the opaqueness of what's the head when doing syntactic annotation.
- **Headedness** is defined in a sense different from generative morphosyntax, BLT and,
  quite strangely, the conventional notion that assigns V as the head of VP, N the head of NP, and P the 
  head of PP. In CGEL, a PP is *not* seen as headed (Sec. 2.26), because both P and NP are obliged to appear.
  NPs are VPs are regarded as not prototypically headed or non-headed.

  It seems the term *head* is defined as "the only word in a phrase that is obligatory". If there are more than
  one obliged constituents, then there is no head.
- **Form and function** have meanings unlike their meaning in a more theoretical context. Here, *form* means the internal structure of a constituent, while *function* means its external environment
- **Complement** is defined in Sec. 2.16. It's not used in the sense of X-bar theory. Nor is it used as a 
  catch-all term of all sorts of things that looks like arguments. TODO: is there a term "complement clause"?
- **Adjunct** is defined in Sec. 2.15:
  > ... which are more closely integrated with the rest of the clause ...
  
  Again, the term is not used in the sense of X-bar theory (though strongly related to the original motivation of the X-bar scheme). 
  Together introduced are the following terms:
  - **disjunct**: comment on the form or content of the clause ("To my regret, ...")
  - **conjunct**: connective adverbs, like "However, ..."
  - **subjunct** TODO 

  The detailed discussion can be found in Sec. 8.39, 8.51, 8.79, 8.104. 
- **Nominal** seems to be synonym of "being able to be an argument". TODO: not quite, see Sec. 15.3
- **Adverbial** means "being able to modify an action". TODO: Are so-called adverbs included?
- **Adverbs** are not recognized as a uniform class. CGEL introduces and classifies them according to 
  their functions and distributions (see, for example, Sec. 8.97 to 8.106).
- **Phrases** *do not* include clauses.

# Clause structure 

This section is a brief review and reconstruction of Chapter 2. 

## Core arguments, verb classification and clause types

Chapter 2 analyzes clauses according to obliged elements in their inner structures. Clauses can also be classified 
according to whether they are finite and which kind of non-finite clauses they are. For that 
classification, see Sec. 14.5-9. The classification given in this section is completely 
orthogonal to the finite-non-finite distinction, with no implicational relations. (For example, 
it's not the case that SVO clauses can't be non-finite)

There are seven general types of clauses, which also gives seven general types of verbs (Sec. 2.16).
There are multiple subcategory under each type of clauses. 

## Objection to Table 2.19's treatment of the adverbial

Note that adverbials may have scopes over the whole sentence and may be regarded as a 
"relative clause describing the main clause" (Sportiche 2017). For example, consider the 
following sentence:

> A cow is missing [in the barn]<sub>adverbial</sub> .

The cow is highly likely not in the barn; what this sentence really means is 

> [a cow is missing]<sub>event</sub> [in the barn]<sub>describing the event</sub> 

So Table 2.19 [7] seems to be not that correct, since A is not necessarily Ao. The following example
> They treated her kindly

also reflects the same problem, since *kindly* is about the action, not the object.
It's in a MannerP position, not directly linked to the subject or the object.

## Distinction between obligatory adjuncts and complements

Typical (optional) adverbs and peripheral arguments seems to be projections in the TP layer (Rizzi and 
Cinque 2016, Schweikert 2005), and that's why they are called adverbials. On the other hand, 
for copular verbs, complements and obligatory adverbials are generated in their argument slots (Myler 2018). 
This creates a list of problems:
- Theoretically, why are some adverbials obligatory at all, since they are in the TP layer?
- Why for copular verbs, complements and obligatory adverbials are distinguished?
- Are there further relation between obligatory adverbials and optional ones? In other words, does the label 
 *adverbial* concern only the *inner* structure of a phrase (i.e. "An adverbial is what usually plays the role 
 of optional adverbials"), or does it have any structural implications?

The first question concerns the nature of obligatory adverbials. The second question concerns the relation 
between obligatory adverbials and optional adverbials. The third question concerns the relation between 
obligatory adverbials and optional adverbials (or in other words, why obligatory adverbials are called 
as adverbials after all). The answers to these questions are correlated:
- If obligatory adverbials have the same syntactic position as optional adverbials, then
  - the second and the third problem is solved, but
  - it is now a huge problem why sometimes, especially in SVC and SVA clauses, complements and adverbials are so similar (Note that PPs may also function as complements (Sec. 10.11), which is a case of gradience between complement and adverbial.), and 
  - it is also a huge problem why obligatory adverbials are obligatory.
- If obligatory adverbials have similar positions to complements, then 
  - the second and the third problems now need an answer, and 
  - it remains to be explained why PPs can appear in very different positions

Answering these questions requires knowledge in syntactic cartography. Crosslinguistic comparison may be a hint.
If, for example, we are able to find a language in which PPs in the vP layer are marked different from sentential
(TP) PPs, then it's a strong support to the claim that obligatory adverbials are similar to complements.

## Gradience between nouns, adverbs and prepositional phrases

The syntactic distribution of nouns, adverbs and prepositional phrases can be summarized as (see Sec. 2.25)

| construction type | topic | subject | object | complement | adverbial | topic |
| :------ | :----- | :---- | :------ | :------ | :----- | :------ |
| noun | + | + | + | + | - | + |
| prepositional phrase | + | -? (Sec. 10.15) | - | -? (Sec. 10.11) | + | + |
| adverbs | +? | -? (Sec. 10.15) | - | - | + | +? |

Here the "topic" column is not mentioned in Sec. 2.25, as the section is about core arguments. 
Nonetheless, the (syntactic) topic position is still worth mentioning here because it bridges 
an adverbial constituent and a nominal one, making an adverbial constituent appearing like a 
subject and therefore able to "sink" into the argument structure. 

Actually, if we split nouns according to their cases, we will find nominative NPs, accusative NPs 
and PPs have almost complementary distributions, so PPs are better classified as NPs with peripheral cases.
However, since the English case system has almost completely eroded, it's wise to merge NPs 
with core cases into one class and name them as NPs, and put NPs with peripheral cases into another type, 
and name them as PPs. 

# Non-finite verb forms

In CGEL, verb forms are listed in Sec. 3.2. 
- -*ing* participle 
- -*ed* participle

## Elimination of the term *gerund*

Note that "gerunds" is classified as "nominal -*ing* clauses" (Sec. 15.12)
This is because the distinction between the gerund and the present participle used as a noun or an adjective no longer makes sense in English.

First we need to check the distributional difference between the term *gerund* and the term *participle* in other English grammars. 
People may say a gerund is more like a noun, while a participle is more like an adjective. 
These claim are correct metaphorically but not literally. (see Sec. 15.12) 
The gerund is *not* the nominalization of the verb, because the gerund takes the same arguments as the verb in the same form as the verb,
and the subject of the gerund may appear in the accusative case, not the genitive case. 
The nominal property of a gerund comes from its being a *nominal clause*. 
The *-ing* suffix can be used in real nominalization, as is in 
> John's playing of the national anthem,
> 
> *John's having played of the national anthem

We see here *playing* is totally nominalized: it can't take an argument in the typical verbal way (the argument has to be 
carried out by *of*), and it doesn't generalize for the perfect aspect of *have*.
But this construction is restricted in its productivity. For example, we have 
> renormalize *v*. - renormalization *n*. - \*renormalizing *n*.

but *renormalizing* is still the correct form when in a gerund clause. 

On the other hand, the present participle appears in the following environments:
- appearing as a modifier of an NP, describing an action going on of an NP:
  > a swimming man

- used after *when*, *if*, etc. 
  > When developing a software, you'd better keep good documentation. 
- appearing in the progressive aspect: be doing sth. 

The third function can be seen as grammaticalized version of [√BE sb. V-ing ], and can be merged with the first function.
Under this analysis, a present participle can be seen as a *relative construction*: 
> a swimming man = a man *who* is in the status of swimming

So now we see why it's often said that a particle works like an adjective: because it lacks a subject and therefore 
has to be linked to an NP. A gerund may also be a modifier in an NP, but it has a different role. Consider the 
following comparison:
> a swimming pool ~ an apple tree  (\*The pool is swimming. \*The tree is apple.)
> 
> a swimming man ~ a strong man (The man is swimming. The man is strong.)

In languages like Latin, gerunds and participles have morphological differences. 
But nominal and relative clauses are also marked differently. 

Now we turn to check the second function of present participle. It's not relative construction, and 
its role is similar to a sentence-level adverbial. TODO

In conclusion, for Latin, we have the following table:

| | nominal clause | relative clause | adverbial clause |
| :------ | :------ | :------ | :------|
| finite verb | + | + | + |
| participle | - | + | + (ablative absolute) |
| gerund | + | - | - |

Since participle clauses and gerund clauses have different morphological marking on the main verb, 
the difference between a present participle clause and a gerund clause is not just their distribution in 
the clause, so it may be a wise idea to keep the participle-gerund distinction.

In English, however, we have

| | nominal clause | relative clause | adverbial clause |
| :------ | :------ | :------ | :------|
| finite verb | + | + | + |
| -*ing* verb | + (so-called gerund) | + (so-called present participle) | + (so-called present participle) |

so the only meaningful distinction between *gerund* and *present participle* is their syntactic distribution.
We will not give finite clauses acting as nominal clauses one name and finite clauses acting as relative clauses
another, so distributional test decides it's better to classify all clauses with -*ing* verb form under the 
tag of *-ing clause* and to use "nominal" and "relative" instead of "gerund" and "present participle".

# References

Haspelmath, M. (2014). Arguments and adjuncts as language-particular syntactic categories and as comparative concepts. Linguistic Discovery, 12(2), 3-11.

Hoffmann, Thomas and Trousdale, Graeme. Construction Grammar: Introduction. In *The Oxford Handbook of Construction Grammar*, 2013.

Myler, N. 2018. Complex copula systems as suppletive allomorphy. Glossa: a journal of general linguistics, 3(1).

Quirk, Randolph, Sidney Greenbaum, Geoffrey Leech, & Jan Svartvik. A Comprehensive Grammar of the English Language, Longman, 1985.

Rizzi, Luigi & Cinque, Guglielmo. 2016. Functional Categories and Syntactic Theory. Annual Review of Linguistics. 2. 139-163. 10.1146/annurev-linguistics-011415-040827. 

Schweikert, W. 2005. The order of prepositional phrases in the structure of the clause (Vol. 83). John Benjamins Publishing.

Sportiche, D. 2017. Fewer adjuncts: more relatives. In *A Schri to Fest Kyle Johnson*, 341.
