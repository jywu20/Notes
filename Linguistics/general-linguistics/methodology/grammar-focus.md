# Topics in syntax (and *informal* semantics)

## Inside a CP: The structure of clauses

Inside a CP:
- The CP layer(s)
  - [The function of the left peripheral](#structure-and-function-of-sentences)
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

## Distributed morphology

# Word classification

## Nouns

Despite some morphological and syntactic varieties, all languages have nouns. A noun is typically a head of a phrase filling a predicate argument slot.

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

## Verbs

Note that the verb category may be a closed category, sometimes only a few dozen.

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

## Adjectives

# Structure and function of sentences

A sentence is made by
- a [main clause](#main-clause)
- zero, one more more [linked clauses](#linked-clause)

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

# Word derivation

## How to obtain adverbs

# Syntactic roles of clauses

The syntactic role of a clause may be
- The [main clause](#main-clause) in a sentence
- [Embedded clause](#embedded-clause) which looks like adjectives or nouns
  - [Relative clause](#relative-clause)
  - [Complement clause](#complement-clause)
- [Linked clause](#linked-clause) which are after conjunctions like ", and ..." in English
  - [Temporal clause](#temporal-clause)
  - [Contrast clause](#contrast-clause)
  - [Consequence clause](#consequence-clause)

## Main clause

A main clause is a clause which on its own makes up a sentence.

## Embedded clause

### Relative clause

A relative clause is a [modifier](#modifier). 

### Complement clause

A complement clause is an [argument](#argument-structure-of-verbs) in another clause.

## Linked clause

### Temporal clause


### Contrast clause


### Consequence clause

# Inner structure of clauses

A clause's inner structure may be
- a "complete" one, consisting of 
  - a predicate or [none](#verbless-clause), typically a verb or including a verb or something like a verb
  - zero, one or more arguments
    - core arguments, which are either stated or easily inferred from the context 
    - peripheral arguments
- not "complete", with only some NPs

Arguments may be filled by a [noun](#nouns), TODO

## Typical verb clause

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
  - an extended argument labeled as E (example can be seen in Sec. 3.2 (9) in [Dixon's book](./basic-linguistic-theory.md))
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

---
**Note** There is generally no clear distinction between "core" arguments and peripheral arguments.
The term *adjunct* is best avoided, both for theoretical reasons (only one Merge operation in MP) and for empirical reasons.

---

## A note about argument labels used here

The labels S, O, A, etc. used in purely descriptive grammars are *coarse-grained* semantic roles.
They are coarse-grained so that they can immediately influence syntax, but they themselves do not directly 
indicate any surface syntactic structure. O may behave like SpecTP in an ergative language (disagreement between syntax and semantics, and maybe morphology and semantics as well), or just morphologically marked like S (disagreement between semantics and morphology).
The definition of these labels, however, are related to the syntactic derivation of a sentence. (See the discussion around Sec. 3.3 (6-7) in [Dixon's book](./basic-linguistic-theory.md))

So we'd better think of these labels as phenomenological concepts. In active sentences: A means something with a closer meaning to "agent", while O means something with a closer meaning to "theme". In passive sentences, TODO

If we believe ergativity only comes from a different strategy to promote an argument to SpecTP and the inner light verb shell is the same, then the S, O, A labels are just aliases of specifiers of light verbs.

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

# "Verb phrases"

Here the term *verb phrase* means something like *could have been planning*. In the context of generative syntax, this is the VP shell minus all arguments. The VP shell is usually one or more complete phases and in this sense may be considered as a syntactic phrase.

# Verb morphology

# Noun phrases

A noun phrase can be made up by 
- a head [noun](#nouns), or 
- a pronoun or a demonstrative
and zero, one or more [modifiers](#modifier), which may be
  - [adjectives](#adjective), which may be in comparative or superlative form, or participles TODO: infinite, participles, norminalization
  - a cardinal or ordinal number, and/or a [quantifier](#pro-forms), and/or a [demonstrative](#pro-forms) (which may be analyzed as a subclass of adjectives in some languages, for example in English)
    - Note that a demonstrative seemingly as a modifier may actually be an apposition, like *[that one]* in
      > I like [that one], [the read dress]
  - one or more nouns, the type of which is usually limited, specifying sex, composition, purpose, etc.
  - a [possessive phrase](#possessive-phrases)
  - a [relative clause](#relative-clauses)
  - an NP or PP for time, location, intended purpose, etc.

## Possessive phrases

## Relative clauses

## Demonstratives as modifiers

# Noun morphology

# Pro-forms

Here the word *pro-forms* takes the meaning [here](https://en.wikipedia.org/wiki/Pro-form). 

## Pronouns
