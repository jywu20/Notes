# Topics in syntax (and *informal* semantics)

## Inside a CP: The structure of clauses

Inside a CP:
- The CP layer(s)
  - [The function of the left peripheral](#structure-and-function-of-sentences-and-clauses)
- The TP layer(s)
- The vP layer(s)
  - [Argument structure](#argument-structure-of-verbs)

## Recursion involving CP

CP embedded into 
- [a subordinate clause of a sentence](#linked-clause) TODO: "that he is mad since he got so stimulated in that event" is a clause, yet it has one linking clause attached to it. What category will Dixon put it into? A sentence, or a clause?

## Semantic roles, grammatical statuses and morphological marks

Generally speaking, sematic information is mapped into grammatical relations in a *lossy* way, and the morphology just roughly reflects the syntactic structure. 
Examples include:
- [the case of argument labels](#a-note-about-argument-labels-used-here)

## Word classification and DM category labels

# Note on terminology

## Abbreviation

| abbreviation | meaning |
| :---- | :---- |
| BLT | [Basic Linguistic Theory](basic-linguistic-theory.md) | 
| DM | distributed morphology |

## "Heads"

The term *head*, in a more descriptive context, means something that somehow "dominates" a phrase. 
For example, the head of an NP is the central noun, because it means the NP must have case, gender, number, etc.
The head of a PP, arguably, is also the noun, because the preposition may be viewed as an additional marker of the case of the noun. 

This results in the definition of [NPs](#general-structure-of-noun-phrases) and [VPs](#verb-phrases), which seem trivially reasonable, especially under a functionalist perspective.
However, to say that when verbs are involved, this notion of heads may involves some subtlety.
In languages like English, a verb can be turned into a gerund, which is almost a noun and can do whatever nouns do.
How would we name a phrase with a gerund head? An NP or a VP?
If we consider it as a VP, then we have to classify English as a language allowing a verb to be a predicate. 
Dixon himself may argue that, since the gerund behaves just like a 3sg uncountable noun, we should label a phrase with a gerund head as an NP.
But recall that in [Basic Linguistic Theory](basic-linguistic-theory.md) Sec. 3.5 (12), the phrase be.large-ARTICLE is seen as a VP, and Dixon claims that this means Nootka allows verbs to be arguments.
Can we just claim that a verb in Nootka should undergo a *zero*-derivation to become an argument?

Dixon may reject this analysis by saying that in English, the gerund no longer keeps its verbal features (say, tense and aspect), so it is noun, but since be.large-ARTICLE will never appear in a predicate position, we do not know whether it keeps its verbal features, and the simplest way is just to analyze it as a whole as an NP.
Here we see a seemingly arbitrary distinction between syntax and morphology: we would happily agree that a gerund is a noun, but when nominalization is achieved by a syntactic device, we would be hesitate about what label we give to it.
As we know, the distinction between syntax and morphology is often blurred: very informal oral French may be analyzed as a polysynthesis language, for example.
Dixon may reject analyzing an argument verb as a zero-deviation of a verb into a noun, which involves invisible morphological derivation, but he accepts the analysis that an NP headed by an adjective may be seen as headed by a null noun head!
We can definitely see some self-contradiction here.

## "Verb phrase"

Here the term *verb phrase* means something like *could have been planning*. In the context of generative syntax, this is the VP shell *minus* all arguments. It is NOT the VP in S → NP VP: the latter *contains* all arguments (beside the subject). The VP shell is usually one or more complete phases and in this sense may be considered as a syntactic phrase.

# Nouns

Despite some morphological and syntactic varieties, all languages have nouns. A noun is typically a head of a phrase filling a predicate argument slot - this distribution feature [in clauses](#inner-structure-of-clauses) is the prototype role of nouns, and also an important criteria to recognize a noun class.

Nouns include
- **Common nouns** that are about a class of objects
- **Proper nouns** with unique referents, usually with more limited syntactic and morphological properties

A noun may have a specific semantic type, for example:
- human
- non-human
- animate
- flora
- artifacts

The sematic type of a noun may influence TODO: hyperref
- the form of possession
- an obligatory possessor
- classification markers (for example, grammatical gender system)

# Verbs

Similar to the case of [nouns](#nouns), all languages have verbs, which typically appear in the head of a predicate - this distribution feature [in clauses](#inner-structure-of-clauses) is the prototype role of verbs, and also an important criteria to recognize a verb class.

Note that the verb category may be a closed category, sometimes only a few dozen, but in this case, they can usually be enriched with certain affixes.

Verbs may be classified according to the [argument structure](#argument-structure-of-verbs).

A verb may have a semantic type, which, just like the semantic type of nouns, may have syntactic consequences. 
To name a few verbs:
| sematic type | roles of arguments |
| :----- | :----- |
| affect (for example, hit, burn) |  Agent Target Manip(Thing manipulated) |
| giving (for example, give, lend) | Donor Gift Recipient |
| speaking (for example, speak, tell) | Speaker Addressee Message Medium |
| thinking (for example, remember) | Cogitator Thought |
| attention (for example, see, hear) | Perceiver Impression |
| liking (for example, like, love, hate) | Experiencer Stimulus |

Just like the case in noun phrases, the semantic role may be mapped to some *verb classifiers*, for example light verbs, and the argument alignment may reflect this fact. 
It should be noted that in a specific language, not all these semantic labels have syntactic consequences. 
For an ideal nominative/accusative language, for example, we only have one light verb, and the arguments are just S, A, O and E.
Even if the case is not that simple, the light verb for liking and thinking and attention may be the same.

Secondary concepts describe some details (how the event is started or stopped, for example) about a primary verb.
They can be verb affixes in some languages and lexemes in others (for example, English).

# Adjectives

Adjective is a highly heterogeneous category. It may be
- type 1: verb-like
  - in that it can be the head of a [VP](#verb-phrases), i.e. form the main part of a predicate, just like an intransitive verb
  - which may be slightly different from typical verbs in 
    - how it is modified when acting as a predicate 
    - that it can be a modifier
    - that it can appear in comparative constructions
    - that it can form adverbs
- type 2: noun like
  - in that 
    - it may head an NP
    - it has similar morphological properties like a noun
  - which may be slightly different from typical nouns in
    - that fewer modification possibilities exist for it than for nouns
    - that it can appear in comparative constructions
    - that it can form adverbs
- type 3: sharing properties with both verbs and nouns
  - in that it can both
    - appear in the head of a predicate, and
    - inflect like a noun when in an NP
- type 4: different from nouns and verbs
  - in that it can neither appear in the head of a predicate nor behave like a noun in an NP

A language may have two adjective classes, and the adjective class in a language can be closed and highly restricted.

The size of the adjective category is often related to the [semantics of adjectives](#adjective-function-and-semantics).

# General notion of morphology

## The Lepzig Glossing Rules

The rules can be found [here](https://www.eva.mpg.de/lingua/pdf/Glossing-Rules.pdf).

- affixes are labeled as
  > they-OBL-GEN
- clitics are labeled as
  > priest=and shopkeeper=and
- 

# Word derivation

## Derivation into adverbs

# Structure and function of sentences and clauses

A sentence is made by
- a [main clause](#main-clause)
- zero, one more more [linked clauses](#linked-clause)

The syntactic role of a clause may be
- The [main clause](#main-clause) in a sentence
- Embedded clause which looks like adjectives or nouns
  - [Relative clause](#relative-clause)
  - [Complement clause](#complement-clause)
- Linked clause which are after conjunctions like ", and ..." in English
  - [Temporal clause](#temporal-clause)
  - [Contrast clause](#contrast-clause)
  - [Consequence clause](#consequence-clause)

A sentence has one of the following pragmatic function-related *mood*:
- a statement, with [declarative mood](#declarative)
- a command, with [imperative mood](#imperative)
- a question, with [interrogative mood](#interrogative)
  - a content question
  - a polar question, or in other words, a yes/no question (some languages lack "yes" and "no")

Note that the same meaning may be expressed by different *syntactic* moods. For example, *Would you mind ...* is interrogative but it actually is a command.

---
**Note** In generative linguistics, these *moods* are usually called *Force* to distinguish them from the indicative/subjunctive *Mood* (which is called *modality* in a more descriptive context).

---

The mood, if grammatically marked, is usually marked on the [main clause](#main-clause). TODO: how mood is marked 

## Declarative

Declarative mood is typically unmarked.

## Imperative

Imperative mood is often shown by a verbal suffix.

## Interrogative

An interrogative sentence may be marked by one or more features in the following:
- intonation
- word order change
- interrogative affix or particle

## Main clause

A main clause is a clause which on its own makes up a sentence.

# Relative clause

A relative clause is a modifier in an NP. 

# Complement clause

A complement clause is an [argument](#argument-structure-of-verbs) in another clause.

# Contrast clause


# Consequence clause

# Inner structure of clauses

A clause's inner structure may be
- a "complete" one, consisting of 
  - a predicate or [none](#verbless-clause), typically a verb or including a verb or something like a verb
  - zero, one or more arguments
    - core arguments, which are either stated or easily inferred from the context 
    - peripheral arguments
- not "complete", with only some NPs

There is generally no clear distinction between "core" arguments and peripheral arguments.
The term *adjunct* is best avoided, both for theoretical reasons (only one Merge operation in MP) and for empirical reasons. See the end of Sec. 3.2 of BLT. 
However, the term *core argument* is still handy because there are often arguments that
- are obliged to appear, and
- cannot undergo many movements (for peripheral arguments, we have [In the forest], I was caught ~in the forest~), and
- are selected by the predicate verb (for example, the complement clause of *want* must be infinite and the complement clause of *suggest* must be subjunctive), and
- often leave marks on the predicate verb when the language has complicated morphology 

Arguments may be filled by 
- a phrase with a [noun](#nouns) head (which is attested in all languages); this is the *prototype* function of nouns
- a phrase with a [verb](#verbs) head

The predicate may be 
- a [verb](#verbs) (which is attested in all languages); this is the *prototype* function of verbs
- a [noun](#nouns) (where morphological markers, if any, will be added to the predicate noun)
  - attested in Nenets (see [Basic Linguistic Theory](basic-linguistic-theory.md) Sec. 3.5 (7-8))
- a [adjective](#adjectives)

From the perspective of generative (morpho)syntax, the core arguments can be seen as specifiers of inner vP layers.
They are obliged to appear, because otherwise the verb cannot get spelt out (we can reasonably assume that due to some general cognitive reasons, in the lexicon we can only find entries like [Do [Trans √V]] for transitive verbs).
This also explains why they are strongly selected by the predicate verb and why they leave marks on the predicate verb, both of which can be introduced in the spellout process.
They cannot undergo certain movements, because there is a phase layer between them and the peripheral arguments (which may in the TP layer), or because there is some constraints prohibiting long-range movements.

## Typical verb clauses, the corresponding verb types and the core arguments

A clause with a verb as its predicate has some possible structures (here we only list the core arguments):
- transitive, in which there is 
  - a [transitive](#transitive-verb) predicate
  - a transitive subject labeled as A
  - a transitive object labeled as O
- intransitive, where there is 
  - an [intransitive](#intransitive-verb) predicate
  - an intransitive subject labeled as S
- extended transitive, sometimes called [ditransitive](https://en.wikipedia.org/wiki/Ditransitive_verb), where there is 
  - a extended transitive predicate
  - a transitive subject labeled as A
  - a transitive direct object labeled as O
  - an "indirect" object labeled as E (though the term is [problematic](./语言共性和语言类型（第二版）笔记.md#语法关系))
    - Note that the role of E may not be a typical dative argument. 
- extended intransitive, where there is 
  - a extended transitive predicate
  - an intransitive subject labeled as S
  - an extended argument labeled as E (example can be seen in Sec. 3.2 (9) in BLT)
    - the role of E may be 

## Copula clause

A copula clause contains 
- a copula verb
- a copula subject labeled as CS
- a copula complement labeled as CC, which may be an identity of the subject, an attribution, or a location

CS can be realized like an S, but in some case (e.g. Ainu), it can be realized as similar to A and different from S.
The behavior of CC generally is different from other arguments (for example, no bound pronouns can be an CC in known languages).

Sometimes the copula can be omitted. 

## Verbless clause

Some languages support a clause made up solely by two NPs, which are 
- verbless clause subject (VCS) and
- verbless clause complement (VCC) argument

## A note about argument labels used here

The labels S, O, A, etc. used here are coarse-grained and are not simple aliases of generative concepts. 
They are coarse-grained so that they can immediately influence syntax, but they themselves do not directly 
indicate any surface syntactic structure. O may behave like SpecTP in an ergative language (disagreement between syntax and semantics, and maybe morphology and semantics as well), or just morphologically marked like S (disagreement between semantics and morphology).
The definition of these labels, however, are related to the syntactic derivation of a sentence. (See the discussion around Sec. 3.3 (6-7) of BLT)
So we'd better think of these labels as phenomenological concepts. 

The definition of these labels in active sentences is 
- A means something with a closer meaning to "agent", 
- while O means something with a closer meaning to "theme". 

If we believe ergativity only comes from a different strategy to promote an argument to SpecTP and the inner light verb shell is the same, then the S, O, A labels are just aliases of specifiers of light verbs.
What really is important 

In passive sentences, it is consistent to 

# Argument structure of verbs

## Transitive verb

## Intransitive verb

## Ambitransitives of type S = A

A verb may both be transitive and intransitive, where its intransitive subject takes the same function as its transitive subject. An English example is *knit*, as in *She knits* and *She knits socks*.
This is called **ambitransitives of type S = A**.

## Ambitransitives of type S = O.

Similar to [ambitransitives of type S = A](#ambitransitives-of-type-s--a) but the intransitive subject functions as the transitive object.
An English example is melt, as in *The butter melted* and *She melted the butter*.

## Unaccusative verb

TODO: microparameter of unaccusativity and macroparameter of ergativity

## Unergative verb

# Verb valence decreasing

# Verb valence increasing 

# Verb morphology

## Person and number affix on a verb

# General structure of noun phrases

A noun phrase can be made up by 
- a head [noun](#nouns), or 
- a pronoun or a demonstrative,
  
and zero, one or more NP modifiers, which may be
  - [adjectives](#adjective), which may be in comparative or superlative form, or participles TODO: infinite, participles, norminalization
  - a cardinal or ordinal number, and/or a [quantifier](#pro-forms), and/or a [demonstrative](#pro-forms) (which may be analyzed as a subclass of adjectives in some languages, for example in English)
    - Note that a demonstrative seemingly as a modifier may actually be an apposition, like *[that one]* in
      > I like [that one], [the read dress]
  - one or more nouns, the type of which is usually limited, specifying sex, composition, purpose, etc.
  - a [possessive phrase](#possessive-phrases)
  - a [relative clause](#relative-clauses)
  - an NP or PP for [time or location](#space-and-time), intended purpose, etc.

## Possessive phrases

## Relative clauses

## Demonstratives as modifiers

# Noun morphology

# Pro-forms

Here the word *pro-forms* takes the meaning [here](https://en.wikipedia.org/wiki/Pro-form). 
The term *pronoun* is used differently in Basic Linguistic Theory and in this Wikipedia page.
In Basic Linguistic Theory, the term *pronoun* is used to denote *personal pronouns*, while in the Wikipedia page personal pronouns are not discussed, and the term *pronoun* is used to denote any pro-form referring to a noun.

Generally speaking, pro-forms are more limited in possible modifiers. For example, in English, pronouns cannot be modified by [temporal or spacial phrases](#space-and-time).

## Personal pronouns

All languages have 1st and 2nd person pronouns. There is almost always a number distinction in a pronoun system, while it is possible that some numbers share one pronoun form (i.e. in English).

The 1st person pronoun may have a distinction between inclusive and exclusive when in the plural form.
Soe languages have a "me and you" pronoun.

It is possible that a language both have free pronouns, which are single words, and bound pronouns, which are clitics or affixes [attached to the verb](#person-and-number-affix-on-a-verb) or the end of the first constituent of the clause.

## Demonstratives

A few languages have just one nominal demonstrative: "this".
All languages seem to have at least two adverbial demonstratives, "here" and "there".

## Interrogatives

Note that words belonging to "interrogatives" may have different word classes, but somehow they have shared properties (for example inducing an interrogative affix on the verb).

# Adjective function and semantics

When the number of adjectives is just a dozen or so, there are likely to be adjectives about
- dimension: big, small, long, short
- age: old, young
- color: black, white, red
- value: good, bad

When there are more members:
- physical property: raw, hard, heavy

larger classes:
- human propensity: clever, rude

# Space and time

See Sec. 3.8 of Basic Linguistic Theory.

Phrases about space and time appear both in [NPs](#general-structure-of-noun-phrases) and as a peripheral argument in a clause.
For example, in English, we have 
> John will examine [the photo in that room]
> 
> John will examine [the photo] [in that room]

If we replace [the photon] by *it*, then we only have the second reading, because a pronoun cannot be modified by a spatial phrase.

Both spatial and temporal information can be introduced by a word, a phrase or a clause.


## Temporal clause

