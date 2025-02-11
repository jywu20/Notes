# Organization of grammar and terminology

Here is the organization of the following discussion:
- we have domains and subdomains (in the sense of "vP-TP-CP domain or layer", or "NumP projection"), 
  which may also be called as **constructions** or **grammatical systems**

  Words in one layer (for example, the so-called "predicate", or things in the clause except the arguments, or an NP) 
  are often said to be "unbranchable", because too many things happen in a single layer:
  there may be movements like Cinque 2005, there may be prosody segmentation (which is so strong that it 
  strongly affects native speakers' intuition of phrase segmentation), etc. 
- A word can also be seen as a construction, since it's formed by several functional heads and/or lexical roots,
  and can be seen as the "crystallized" phonetic realization of a domain.
- in each domain, we have **grammatical relations**, which arises from constituent relations or c-command relations 
  in the *derivational tree* (for details see [here](语言学中什么样的概念并不科学.md))
- Constructions that are generated in a similar way may have uniform **transformational rules** between them; 
  roughly we start from a **canonical** form, but there is no well-defined criterion to distinguish a 
  canonical form. Chinese 把-constructions are often seen as non-canonical, but sentences like 他把城市管理得很好 can't be transformed to a "canonical" SVO one.
- Multiple analysis of the same construction are possible, and sometimes it's just a matter of notation. 
  Let's consider the simplest example: English SVO clauses, both active and passive. We can describe them using 
  the following one-step production rules:
  > An active clause consists of a subject, a predicate complex, which includes auxiliary verbs and the main verb,
  > and an object, and adjuncts; adjuncts typically appear at the end of the clause, but it's also possible for
  > them to appear in front of the predicate complex. There is subject-verb agreement ...
  > 
  > A passive clause consists of a subject, which is the patient of the main verb, a predicate complex the 
  > main verb of which is *be* ...

  Now as is shown [here](语言学中什么样的概念并不科学.md), the predicate complex is just the TP layer minus all
  DP layers in it (or in other words, the "pure" TP layer), we can decompose the predicate by binary branching.
  This can also be seen as breaking a large construction into smaller ones: here, we break the clause construction
  into the argument structure, the aspect marking, the tense marking, the adjunct modifying construction, 
  and the concept of subject, which involves subject-verb agreement.

  We can also treat the passive clause as transformed from the active one. By introducing a transformation
  rule, we can relate two constructions with related derivation processes.

  We can even treat the optional adjuncts as something added by a transformation process. Embedding a construction
  into another may cause transformation into the former. When the transformation is not severe, it can be 
  described by a production rule, and when it's severe, it would better be analyzed as transformation.
  When describing the SVO clause, we can first describe the simplest clause with S, V and O only, and 
  describe a clause with adjuncts by a specific "manner-adjoining" transformation.
  Here we are simply rephrasing 
  > Clause → S V O
  > Clause → S V O Adjunct

  into 
  > Clause → S V O
  > Clause → adding adjuncts to a clause

  An adjunct position in a clause template, a manner-adjoining transformation rule, and a manner-modifying 
  construction are all about the same thing.

  Similarly, auxiliary verbs can also be introduced by transformation rules.

  Besides relating two correlated structures and the operation of embedding one construction into another, 
  another usage of transformation rules is to introduce local operations, like agreement.

  These roles of transformation rules are interrelated. If the derivation processes of two structures involve
  similar stages, they are related by a transformation rule.
  On the other hand, if construction C2 is made by embedding construction C1 into another construction ΔC,
  we may regard C2 and C1 to undergo the same stages of derivation that create C1, and then undergo 
  ΔC and a "null" version of ΔC, respectively. So we can also say that C2 and C1 are two structures with 
  similar derivation stages at some time steps.
  So the transformation rules invoked when embedding one construction into another can also be seen as 
  the transformation rules used to related a canonical construction and its non-canonical peers.
  As for the morphological transformation rules, they are frequently invoked in the above two kinds of 
  transformation rules.

- Existence and non-existence of certain type of constructions are called **typological parameters**. 
  A language has SVO clauses but not unmarked SOV clauses, so the *word order parameter* (which actually is clause 
  constituent order parameter) is well-defined for it and we say it's a SVO language. 
  A language with free clause constituent order doesn't have a well-defined word order parameter, but 
  the *free word order parameter* is well-defined for it and we say it has free word order.
  Correlations between logically independent typological parameters are called **typological universals**.
- It's often the case that two elements with a certain grammatical relation are of limited choice. 
  In this case we say there are dependencies between grammatical systems.
  Usually only nouns can fill argument slots; some aspects and tensors may not be available under negation;
  in some languages, no evidentiality specifications are not available in future tense.
- The descriptive framework presented here involves multiple mechanisms, which can be reduced to the standard 
  Merge-based Minimalist syntax without losing its explanatory scope (Adger 2021). The reason we introduce 
  so many notations is to simply the *descriptive* burden: derivational syntax proves to be non handy when 
  doing a sketch of a language (but once a derivational syntax is established, it can lead us to investigate 
  aspects of syntax we have never thought of). Some linguists like Croft call this descriptive framework
  construction grammar. For perspectives on this issue, see Trotzke 2020.

It should be noted that BLT (and many other typological works) are functionalist, which means syntactic devices
are often sorted and classified according to how they serve the semantics, and this can create some barrier to 
generative linguistics. It should also be noted that the approach of BLT is also drastically different from the 
approach of *theoretical* functionalists. (see Descriptive theories, explanatory theories, and Basic Linguistic Theory by Matthew S. Dryer) BLT further will also be unfamiliar to typologists who are more interested in finding
language universals rather than describing a language in details (for the relation between typology and generative
syntax, see A note on linguistic theory and typology by GUGLIELMO CINQUE)

Here we briefly list some of possible confusions.

## Abbreviation

| abbreviation | meaning |
| :---- | :---- |
| BLT | [Basic Linguistic Theory](basic-linguistic-theory.md) | 
| DM | distributed morphology |

## "Heads"

The term *head*, in a more descriptive context, means something that somehow "dominates" a phrase. 
For example, the head of an NP is the central noun, because it means the NP must have case, gender, number, etc.
The head of a PP is also the noun, because the preposition may be viewed as an additional marker of the case of the noun. 
Actually Dixon rejects the term PP: in Sec. 3.9 of BLT he questions: "If the head of an NP marked by a preposition is the preposition, then should we say the head of *viro obeso* in Latin is the case". 
But this is exactly what happens in generative linguistics. Here we again see the disagreement between generative and functional approaches.

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

With this notion in mind, we can see that some theoretical disputations are merely differences in notation.
Since in purely descriptive works concepts like TP are not acknowledged, we may say "the verb mark its A argument
with the nominative case", while in generative grammar we say it's T that does the task. The two accounts can be 
reconciled if we think of the term "verb" here as verb phrase in the sense in BLT or in other words "the predicate
complex", which includes all functional projections governing the whole clause. Similarly, Dixon may say 
"the verb marks the subject by the SVO order", which again makes sense even in the generative context because 
here the term "verb" concludes the TP projection, and therefore includes the EPP feature.

## "Phrase" and "verb phrase"

Here the term *verb phrase* means something like *could have been planning*. In the context of generative syntax, this is the VP shell *minus* all arguments. It is NOT the VP in S → NP VP: the latter *contains* all arguments (beside the subject). The VP shell is usually one or more complete phases and in this sense may be considered as a syntactic phrase.

So we can see that the meaning of "phrase" is closer to "phase" or to be more exact, "domain" 
(as in "vP domain" or "CP domain") in generative syntax. A *phrase* is made of several smaller constructions,
since a CP domain is made of several functional projections. A flat phrase structure tree preferred by functionalists
merely displays the hierarchy relation between *domains*.

## "Subject", "topic" and "pivot"

- SpecTP
- A and S argument
- the argument with nominative case

In more descriptive terms, "topic" is a pragmatic category, while "pivot" is a grammatical category. Note that the latter is called as "topic" in generative works.

# Topics in morphosyntax (and *informal* semantics)

For a more theoretically motivated list, see [here](phenomenon.md). Aspects mentioned in this file also apply
to sign languages, but they may have some [distinct properties](sign-language.md).

## Grammatical relations and transformation relations between them

Below are topics  inside a CP, or in other words, concerning the structure of clauses
- [Classification of possible CPs](#structure-and-function-of-sentences-and-clauses)
- The CP layer(s)
  - [Basic notion of CPs](#structure-and-function-of-sentences-and-clauses)
- The TP layer(s)
  - [Non-spatial information: TAME categories](#non-spatial-settings)
- The vP layer(s)
  - [Canonical argument structure](#typical-verb-clauses-the-corresponding-verb-types-and-the-core-arguments)
  - [Change in verb valency: passivization and more](#verb-valence-change)
  - [Many verbs but no embedded clauses: serial verb constructions](#serial-verb-constructions)
  - The influence of arguments to the verb
    - [Noun incorporation](#noun-incorporation)
    - [Argument indexation](#argument-indexation)
- Topics that are not clearly about TP or CP

Inside a DP

## Recursion involving CP

CP embedded into 
- [a subordinate clause of a sentence](#linked-clause) TODO: "that he is mad since he got so stimulated in that event" is a clause, yet it has one linking clause attached to it. What category will Dixon put it into? A sentence, or a clause?

## Semantic roles, grammatical statuses and morphological marks

Generally speaking, sematic information is mapped into grammatical relations in a *lossy* way, and the morphology just roughly reflects the syntactic structure. 
Examples include:
- [the case of argument labels](#a-note-about-argument-labels-used-here)

## Constituent order

Constituent order is also called *word order*, though the latter term is misleading because what we are discussing is about constituents with possible modifiers, not single words.

## Distinguish constructions and word classes

Working procedure:
1. Sketchy fragmentation
2. Identify some expressions with shared *inner* constructions
3. Check whether they can be in grammatical relations introduced in the following discussion
4. Identify "typical" constructions and word classes
5. Compare words the categories of which are not clear with the behavior of typical nouns and verbs.
   (It may seem "scientific" to list all grammatical relations in a language and then check the distribution of 
   each words in them, but this is too time-consuming - organizing grammatical relations around typical
  constructions is much more efficient)

  For example, we can compare how "noun-like" the adjectives are or how "noun-like" or "verb-like" the participles
  are.
6. Give detailed cartography of large constructions, like NP or the clause structure

# Prototypical lexical word classes

## Nouns

Despite some morphological and syntactic varieties, all languages have nouns. A noun is typically a head of a phrase filling an argument slot - this distribution feature [in clauses](#inner-structure-of-clauses) is the *prototype* role of nouns, and also an important criteria to recognize a noun class.

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

- countable noun
- mass noun: *coffee*, *bread*
- collective noun: *committee*
- abstract noun (countable and uncountable both are OK)

A list of frequent roles of nouns:
- *prototypical*: [head an NP](#general-structure-of-noun-phrases)
- be a [modifier](#general-structure-of-noun-phrases) of an NP about its sex, purpose, etc.
- be [marked](#marking-strategies-of-arguments) as arguments
- involve in [noun classification](#noun-classification)

How a noun (or another construction, like a participle relative clause) behaves in these grammatical relations
is the main criterion of subcategorization of the noun class.

## Verbs

Similar to the case of [nouns](#nouns), all languages have verbs, which typically appear in the head of a predicate - this distribution feature [in clauses](#inner-structure-of-clauses) is the *prototype role* of verbs, and also an important criteria to recognize a verb class.

Note that the verb category may be a closed category, sometimes only a few dozen, but in this case, they can usually be enriched with certain affixes.

Verbs may be classified according to the [argument structure](#typical-verb-clauses-the-corresponding-verb-types-and-the-core-arguments).

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

## Distinguishing nouns and verbs

See BLT Chap. 11

We know that in many languages, nouns can take the prototypical role of verbs and be the predicate, while verbs can take the prototypical role of nouns and head an NP. (see [here](#inner-structure-of-clauses))
These languages are claimed to lack the distinction between nouns and verbs. 
However, it's often the case that one of the following criteria can still distinguish nouns and verbs:
- Verbs in argument slots show meaning different from their meaning when being the predicate
  - Example: in English, the meaning of the verb is not predictable from the meaning of the noun.
  *Father* v. means "to be sb's father", while *baby* v. does *not* means to be sb's baby.
- Noun-to-verb and verb-to-noun derivation mechanisms exist, and show similar semantic behavior of so-called "noun used as verb" or "verb used as noun" mechanisms:
  - Example: in English, we have 
  > *witness* v. -> *witness* n. "someone who witness"
  > 
  > *observe* v. -> *observer* n. "someone who observe"

  The semantic relation from the verb to the noun is the same for the two verb-noun pairs, so we conclude that the first pair carries a zero allomorph of *-er*.
- Nouns acting as predicates are almost always intransitive, especially when there are many, many normal transitive verbs. This can be easily explained by assuming the nouns undergo a zero derivation and the derivation affix is intransitive.
- An NP headed by a verb often has more restricted structures (this is also one criterion that defined pronouns). 
  - NP headed by a verb is possible to reject possessive affixes.
  - NP headed by a verb may obligatorily take an "article" - a nominalizer, actually.
  - Verbs in argument slots show signs that they are actually clauses or have undergone zero realization: clauses usually can't be modified by adjectives, for example
- A predicate headed by a noun is possibly unable to be modified by certain adverbs, like "almost"
- Nouns as predicates may have uncanonical behaviors in serial verb constructions
- It's also possible that nominal predicates don't take [TAME features](#non-spatial-setting-of-clauses) and mood
- Nominal predicates may undergo fewer [valence changing](#verb-valence-change)
- Typical nouns may have a noun class or gender system (which can be reflected by a classifier), number feature, definiteness, and/or case. NPs headed by a verb often lack one or more systems. 
- Verb and noun may undergo different morphological process: word-class-changing derivations, reduplication, etc.

Above are all morphosyntactic criteria. Note that semantics should *not* be the key point when classifying words.
*After* word classes are established, it's then necessary to find the semantics of each class.

## Adjectives

See BLT Chap. 12. 

The prototypical function of adjectives is [to modify an NP](#general-structure-of-noun-phrases).
But whether it's really necessary to introduce a single adjective class is often disputed.
To describe a single language, any terms may be used, and it's alright to merge adjectival classes
into the verb class or the noun class. However, for unified description and role in typology (to "provide 
feedback into the basic linguistic theory"), we need to recognize a separate adjective class, 
because what can be said as adjectives have robust cross-linguistic functional properties and semantic 
content. If we don't set an adjective class, then typical adjectives (those in English) have to be 
compared with a subclass of a language lacking prototypical adjectives, creating unnecessary 
obstacles.

Adjectives can't be distinguished using a single criterion. Latin grammarians use the existence of a gender 
feature to distinguish adjectives, which fails for the genderless language Finnish. However, in Finnish,
some words take possessive suffixes but not comparative and superlative suffixes, but another class of 
words is the opposite, so we can name them as nouns and adjectives. 

When analyzing languages where adjectives are like verbs, linguists often use the term "stative verb",
but if so, in order to be consistent, they have to admit that in Spanish, adjectives are "stative nouns".
Here we see the effort to remind people that something in a language is different from European languages
unfortunately makes them to ignore important language universals.

Adjective is a highly heterogeneous category. It may have the following roles:
- It may (but not necessarily) make a statement that something has a certain property, either
  - by a copula clause 
  - with the main part of the predicate being the adjective, just like an intransitive verb
- It may (but not necessarily) modify an NP (and sometimes a verb)
- It may be in a comparative construction (which may not exist for certain languages)

According to its behavior in these constructions, we can classify adjectives into
- type 1: verb-like
  - in that it can be head a predicate
  - which may be slightly different from typical verbs in 
    - how it is modified when acting as a predicate (less adverbial constituents are available, for example) 
    - that it can be a modifier (usually only possible via a relative clause for adjectives like verbs; 
    if this can be achieved without a relative construction, then the adjective is not likely to undergo 
    similar morphological processes with the noun)
    - that it can appear in comparative constructions
    - that it can form adverbs
- type 2: noun like
  - in that 
    - it may be an NP modifier
    - it may head an NP
    - it has similar morphological properties like a noun
    - it may fill the copula complement position
  - which may be slightly different from typical nouns in
    - that fewer modification possibilities exist for it than for nouns
    - that it can appear in comparative constructions
    - that it can form adverbs
- type 3: sharing properties with both verbs and nouns
  - in that it can both
    - appear in the head of a predicate, and
    - inflect like a noun when in an NP, and
    - sometimes also act as a copula complement
- type 4: different from nouns and verbs
  - different from nouns in that
    - it don't undergo similar morphological process with the noun
    - its behavior in the copula complement position differs with a typical noun (for example a noun may require an article but an adjective doesn't) 
  - different from verbs in that 
    - it can't appear in the head of a predicate 

A language may have two adjective classes, and the adjective class in a language can be closed and highly restricted.

The size of the adjective category is often related to the semantics of adjectives.
When the number of adjectives is just a dozen or so, there are likely to be adjectives about
- dimension: big, small, long, short
- age: old, young
- color: black, white, red
- value: good, bad

When there are more members:
- physical property: raw, hard, heavy

larger classes:
- human propensity: clever, rude

# Pro-forms

Here the word *pro-forms* takes the meaning [here](https://en.wikipedia.org/wiki/Pro-form). 
The term *pronoun* is used differently in Basic Linguistic Theory and in this Wikipedia page.
In Basic Linguistic Theory, the term *pronoun* is used to denote *personal pronouns*, while in the Wikipedia page personal pronouns are not discussed, and the term *pronoun* is used to denote any pro-form referring to a noun.

Generally speaking, pro-forms are more limited in possible modifiers. For example, in English, pronouns cannot be modified by [temporal or spacial phrases](#space-and-time).

## Personal pronouns

All languages have 1st and 2nd person pronouns. There is almost always a number distinction in a pronoun system, while it is possible that some numbers share one pronoun form (i.e. in English).

The 1st person pronoun may have a distinction between inclusive and exclusive when in the plural form.
Soe languages have a "me and you" pronoun.

It is possible that a language both have free pronouns, which are single words, and bound pronouns, which are clitics or affixes [attached to the verb](#person-and-number-marking-on-a-verb) or the end of the first constituent of the clause.

## Demonstratives

A few languages have just one nominal demonstrative: "this".
All languages seem to have at least two adverbial demonstratives, "here" and "there".

## Interrogatives

Note that words belonging to "interrogatives" may have different word classes, but somehow they have shared properties (for example inducing an interrogative affix on the verb).

# General notion of morphology

BLT Sec. 3.13 and 3.14, 5.2, 5.3, 5.4

Here we introduce different morphological operations and how they are labeled in the Lepzig Glossing Rules.
The rules can be found [here](https://www.eva.mpg.de/lingua/pdf/Glossing-Rules.pdf).

A list of morphological processes can be found [here](https://en.wikipedia.org/wiki/Transfix).
The terminology is slightly different from Dixon's, as the latter insists only morphological units in 
concatenative morphology can be said as *morphemes*.

- Concatenative morphology (*prefix* and *suffix*, *interfix*)
  - affixation and compounding; an interfix is something that must appear to link other morphemes but doesn't have any semantic meaning
  - almost universal, with exceptions of perhaps several totally isolating languages
  - affixes (as well as compounding) are labeled as
  > they-OBL-GEN
  - a clitic is something not that closely attached to one word (for example, in-word phonological rules like assimilation doesn't apply), yet cannot stand solely by itself, like the Latin -que, which may be attached to the head of an NP as well as the first word) are labeled as
  > priest=and shopkeeper=and
  
  If the major morphological process is affixation, then we can distinguish "free" and "bound" morphemes. This doesn't work when there is tone change, however.

  A grammatical system (like tense) may be realized as affix, clitic or separate grammatical word. The latter two are unlikely to be associated with every word of a phrase, but an affix may be (for example, Latin case).
  A case marker at the end of an NP is often a clitic.
  Note, however, that there are no necessary restrictions. Whether something is an affix or a clitic should be decided according to phonological criteria, not syntax. Syntax only defines the feature structure. 
  It's possible that a dialect of a language place the case marker to the end of the NP, while another dialect place the case marker after the head of the NP. 
  The phonological-morphological process involved is the same between the two dialects, but if we claim that a case marker after an NP *must* be a clitic, then we have to make the strange claim that the same morphological process results in a clitic in one dialect and an affix in another.

  Compounding may have following functions
  - [noun compound as a mean of derivation](#noun-compounding)
  - [serial verb construction](#serial-verb-constructions) 
  - [noun incorporation](#noun-incorporation)

- Non-concatenative morphology with easy-to-recognize morphemes (infix, circumfix, transfix)
  - infix is annotated as morpheme\<infix\>morpheme 
  - circumfix is annotated as cirfumfix.meaning<sub>1</sub>-morpheme-circumfix.meaning<sub>1</sub>
  - transfix: template morphology as seen in Semitic languages, where the root is a template and the affix is a discontinuous one inserted into the root. In [this wiki](https://wikis.hu-berlin.de/interlinear_glossing/Glossing_Rules#Affixes_and_clitics), it is glossed as morpheme\affix
- Internal change (*suprafix*, *simulfix*)
  - a suprafix is a suprasegmental change, including tone, prosody, stress, or nasalization
  - a simulfix changes one sound in an existing morpheme (a transfix can be seen as a generalized simulfix):
   foot -> feet, and may also apply to consonants
- Reduplication (*duplifix*)
  - annotated as main.morpheme~the.function.of.duplication
  - Things repeated may be initial syllable, first two syllables, last syllable, and the whole word; each of them may have a distinct function
  - For nouns: plural, diminutive, selection ("long" -> "things that are long")
  - For verbs: repeating, intensive, continuous
  - But generally this operation can mean anything
  - When annotated, reduplication is treated similar to affixation, but with a tilde: yerak-rak in Hebrew means "greenish" and is tagged as green~ATT
- Subtraction (*disfix*)
  - for example Somoan: silaf -> sila

It's sometimes useful to distinguish between derivation and inflection. 
Distinction between derivation and inflection is useful in some languages, but not others. 
In the former case, we can define *stem* easily: it's something that may or may not undergo some derivation, but not inflection, and after proper inflection it becomes a full word.
For some other languages the distinction between derivation and inflection doesn't make sense.
Some people claim that inflection is always subject to agreement and derivation not. This is not the case in Dyirbal.
In Dyirbal, the comitative case can stack with another case marking the argument role, so it may be seen as derivation suffix. 
However, it shows agreement between the adjective and the head noun.

Zero inflection marker is a convenient term when similar features are marked. 

The method to show morphology in a table is called the word-and-paradigm model, while we can also show morphology in an item-and-arrangement method, which lists all morphemes and how they are arranged together.
A morpheme mau have several alternative forms, called "allomorphs".
Again, for languages in which non-affixation processes are frequent and/or fusion is strong (as is the case in Latin: a noun inflection suffix should be analyzed as one or three morphemes?), we can't use these terms and should work with a more general "item-and-process" approach.

# Derivations 

# Structure and function of sentences and clauses

See BLT Sec. 3.1, 3.11

## Sentences and clauses

A sentence is made by
- a main clause
- zero, one more more linked clauses

The syntactic role of a clause may be
- The **main clause** in a sentence, a clause which on its own makes up a sentence. Categories about a sentence, if grammatically marked, is usually marked on the main clause. 
- Embedded clause which looks like adjectives or nouns in some aspects
  - [**Relative clause**](#relative-clause) can be seen as 
  - [**Complement clause**](#complement-clause)
- Linked clause which are after conjunctions like ", and ..." in English.
  - [Temporal clause](#temporal-clause)
    - Likely a universal construction.
    - Note that conditional constructions are usually similar to a temporal one, but the semantics of a conditional construction may be not directly temporal, as is the case in *If Shanghai is bigger than London, then it must be a huge conurbation*
  - **Contrast clause**
    - Not that universal 
  - [**Consequence clause**](#consequence-clause)
  - Addition
    - A universal type of linkage, often simply by apposition of clauses
  - **Disjunction**
    - closed disjunction "either ... or ..." is rarer 

## Mood of a sentence

A sentence has one of the following pragmatic function-related *mood*:
- a statement, with **declarative mood**
- a command, with **imperative mood**
- a question, with **interrogative mood**
  - a content question
  - a polar question, or in other words, a yes/no question (some languages lack "yes" and "no")

Note that the same meaning may be expressed by different *syntactic* moods. For example, *Would you mind ...* is interrogative but it actually is a command.

---
**Note** In generative linguistics, these *moods* are usually called *Force* to distinguish them from the indicative/subjunctive *Mood* (which is called *modality* in a more descriptive context).

---

Declarative mood is typically unmarked.

Imperative mood is often shown by a verbal suffix.

An interrogative sentence may be marked by one or more features in the following:
- intonation
- word order change
- interrogative affix or particle

## What's really a sentence or a clause?

Note that it's often hard to distinguish what is really a sentence. There are several approaches:
- ask a literate speaker to edit the transcription. This, however, may be influenced by the actual stylistic preference. For example, people may begin a sentence with a conjunction.
- The final syllable of a sentence may undergo certain phonology process.
- There is a grammatical marker signaling the end of the sentence.
- SOV language

But these criterions may be in conflict with each other. Intonation may suggest two sentences, while the syntax of linkers points to one.

Sentences may also undergo ellipsis and parenthesis.

## Inner structure of clauses

A clause's inner structure may be
- a "complete" one, consisting of 
  - a predicate or [none](#verbless-clause), typically a verb or including a verb or something like a verb
  - zero, one or more arguments
    - core arguments, which are either stated or easily inferred from the context 
    - peripheral arguments
- not "complete", with only some NPs

There is generally no clear distinction between "core" arguments and peripheral arguments.
Different languages may have different obliged arguments for verbs with the same meaning.
Some obliged arguments are about time and space, which surely are not traditionally conceived core arguments.
The term *adjunct* is best avoided, both for theoretical reasons (only one Merge operation in MP) and for empirical reasons. See the end of Sec. 3.2 of BLT. 
However, the term *core argument* is still handy because there are often arguments that
- are obliged to appear, and
- cannot undergo many movements (for peripheral arguments, we have [In the forest], I was caught ~in the forest~), and
- are selected by the predicate verb (for example, the complement clause of *want* must be infinite and the complement clause of *suggest* must be subjunctive), and
- often leave marks on the predicate verb when the language has complicated morphology 

Arguments may be filled by 
- a phrase with a [noun](#nouns) head (which is attested in all languages); this is the *prototype* function of nouns
- a phrase with a [verb](#verbs) head
- a [complement clause](#complement-clause)

These constituents may be considered as *nominal*.

The predicate may be 
- a [verb](#verbs) (which is attested in all languages); this is the *prototype* function of verbs
  - Note that in Dixon's term, a copula is also a predicate, while the adjective after the copula is the CC argument
- a [noun](#nouns) (where morphological markers, if any, will be added to the predicate noun)
  - attested in Nenets (see [Basic Linguistic Theory](basic-linguistic-theory.md) Sec. 3.5 (7-8))
  Note that this is different from the verbless clause.
- an [adjective](#adjectives)

- [verbal clauses](#typical-verb-clauses-the-corresponding-verb-types-and-the-core-arguments), the prototypical clause structure
- [copula clause](#copula-clause)
- [verbless clause](#verbless-clause)

From the perspective of generative (morpho)syntax, the core arguments can be seen as specifiers of inner vP layers.
They are obliged to appear, because otherwise the verb cannot get spelt out (we can reasonably assume that due to some general cognitive reasons, in the lexicon we can only find entries like [Do [Trans √V]] for transitive verbs).
This also explains why they are strongly selected by the predicate verb and why they leave marks on the predicate verb, both of which can be introduced in the spellout process.
They cannot undergo certain movements, because there is a phase layer between them and the peripheral arguments (which may in the TP layer), or because there is some constraints prohibiting long-range movements.

## Transitive argument marking

# Typical verb clauses, the corresponding verb types and the core arguments

This section is about the "default" argument configuration of verbs, i.e. without any change on valence, like passivization, and typical verb clauses the predicates of which are (ordinary) verbs.
We discuss the vP layer in this section.

## Argument label, S, O and A

The labels S, O, A, etc. used here are defined in a "prototypical way" according to *semantics* (but they are syntactic categories), 
as coarse-grained concepts that captures a set of grammatical features that occur together.  
The definition of these labels in active sentences is 
- A means something with a closer meaning to "agent", 
- while O means something with a closer meaning to "theme". 
 
If we believe ergativity (and other non-accusative alignments) only comes from a different construction of the TP and CP layers and the inner light 
verb shell is the same, then the S, O, A labels are just aliases of specifiers of light verbs, with A being the
"external" argument (SpecvP) when there are two core argument being present and O being the internal one, 
and S marking the argument when there is only one. But this doesn't hold for passive sentences and other valence changing constructions. In passive 
sentences, it is convenient to talk about the "surface S" which is the underlying O. No one would think 
of the surface S as the agent in any sense. Similar to the [case in ergativity](../argument-structure/配列.md#混合中枢), it may be a good idea to distinguish "deep" and "surface" S, A and O:
- S, A and O may be defined according to "deeper" dependency relations in the vP layer, which are connected to
  properties like binding. This definition also works for core arguments in the clause with valence changing, 
  but it doesn't work for peripheral arguments in the clause. For example, with this definition, we know the 
  subject in a passive clause is the *deep* O, but under this definition there is *no* deep A here. 
- Another way to define deep S, A, and O may be transformation relations: the deep S, O and A arguments 
  of a clause is the S, O and A arguments in the *canonical form* of the clause.

  For example, in English passivization construction *he was arrested*, the deep A is not specified and the 
  deep O is *he*. The canonical form of this clause is *Someone arrested him*, where *him* (i.e. *he*) is 
  O, so in the passive clause, the deep argument position of *he* should be O as well.
- Contrary to the *deep* definition, the *surface* S, A and O are defined by there similarity to "deep" S, A 
  and O in a "canonical" clause. By definition, surface and deep S, A and O coincide. Valence changing  
  doesn't change the deep S, A and O, but it changes the surface ones. Again, consider the example of 
  *he was arrested*. Here *he* is the *deep* O, but since in the passive clause it's marked similar to the 
  active S, we say its *surface* role is S.

  Note that we don't specify *what* grammatical relations are involved in the definition of surface argument
  slots. What we just say is "what overt marking strategies that define the surface S, A and O in a canonical
  construction also define the same argument slots in a non-canonical construction". The question about 
  what defines a surface S, A or O relation should be answered in the language's own term.

  Let's consider an example. O may be promoted to SpecTP in an ergative language,
  which creates syntactic and probably morphological marking of ergativity, or it may be just morphologically 
  marked like S, but since the case assignment is about the whole TP domain, this morphological ergativity
  is also done in the TP layer. So,
  - in the former case, being the surface A means being unable to be promoted to SpecTP, 
  - while in the latter case, being the surface A only means being morphologically assign a case

A single term like "S" or "A" without the context being specified is value and is not a simple alias of generative
concepts, though in any contexts the definition of these label can be related to certain steps of the syntactic
derivation process. (See the discussion around Sec. 3.3 (6-7) of BLT)
So we'd better think of these labels as phenomenological concepts. 

Neither the deep definition nor the surface definition says anything deterministic about how the arguments 
interact with external constructions. So we have the following logically independent (macro)parameters:
- allowed types of valence change, i.e. how deep and surface S, A and O are interconnected
- in-clause grammatical relations marking the surface S, A and O, which define parameters like morphological/syntactic ergativity
- how surface S, A and O interact with external constructions, e.g. which one can be relativized, which one 
  can have coreference with external pronouns, etc. In other words, among S, A, and O, which one is the *subject*, etc.

Deep S, A and O are solely defined with vP-level grammatical relations. The notions of subject and clause 
constituent order are TP-level or even CP-level grammatical relations.
A word order typology with parameters defined according to the *relative order* (a feature influenced strongly 
by the TP layer, though also reflecting something about the vP layer) of clause constituents and *deep* 
(or even worse, purely semantic and not syntactic) definition of 
argument slots (a feature about the vP layer) is likely to fail for ergative languages, 
where even in the canonical clause, the mapping from vP grammatical relations 
to TP ones is complicated (Haider 2021).

We should also remark that though the deep definitions of S, A and O are largely independent on the definition 
of clause-level grammatical relations, this is not the case for the surface definitions. 
There is no intermediate level between the vP grammatical relations that define the deep S, A and O and the 
TP grammatical relations that define what's the clause subject, so the notion of *surface* S, A and O 
is based on the *same* set of grammatical relations that define the clause subject, clause constituent order, etc.
What can be easily identified is the deep S, A and O (by binding, serial verb construction, etc., and also largely
by semantic intuition - though without knowing the cultural background, mistakes can be done here - consider the 
example of English Jack marries Marry and Marry marries Jack and the Chinese *她爸妈*把她嫁给了他, where an 
asymmetry arises between 娶 and 嫁 and for 嫁 the family of the bride is the agent) and the clause-level 
argument slots like the subject (by checking the interpretation scope, distribution in non-finite clauses, etc.)
So what we are actually doing here is to *first* investigate deep S, A and O, and clause-level constructions, 
and then to *define* surface S, A and O, and finally to determine whether a seemingly non-canonical construction 
is *really* a valence changing construction or something else.

## Argument number and transitivity

A clause with a verb as its predicate has some possible structures (here we only list the core arguments):
- transitive, in which there is 
  - a **transitive** predicate
  - a transitive subject labeled as A
  - a transitive object labeled as O
- intransitive, where there is 
  - an **intransitive** predicate
  - an intransitive subject labeled as S
- extended transitive, sometimes called [**ditransitive**](https://en.wikipedia.org/wiki/Ditransitive_verb), where there is 
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

A verb may both be transitive and intransitive, where its intransitive subject takes the same function as its transitive subject. An English example is *knit*, as in *She knits* and *She knits socks*.
This is called **ambitransitives of type S = A**.

**Ambitransitives of type S = O** are similar to ambitransitives of type S = A but the intransitive subject functions as the transitive object.
An English example is melt, as in *The butter melted* and *She melted the butter*.

## "Ergativity" of verbs

TODO: microparameter of unaccusativity and macroparameter of ergativity

It should be noted that ergativity terms used for verbs may be misleading, especially for those not familiar with generative 
jargons. An unergative verb has vP structure [ A Do [ O Trans V ] ], with O being optional, while an 
unaccusative verb has [ A Cause [ O Undergo V ] ], with A being optional. If the marking of arguments
faithfully reflects their semantic roles, then unergative verbs are indeed marked as accusative and vice versa.
However, we know this is almost impossible. Constructions like *Simon walks* involves a single A argument, and we 
can't expect this construction to be always absent in ergative languages. A possible solution which enable us 
to explain ergativity solely by argument structure is to give up
any semantic indication of light verb structure, but this seems rather strange. Besides, ergativity is actually
a highly diverse concept, with syntactic ergativity, morphological ergativity, mixture between ergativity and 
accusativity, and so on, so it really doesn't make any sense to insist a verb argument structure explanation.

# Marking of core and peripheral arguments

See BLT Sec. 3.9.

## Prototypical marking strategies of S, A and O

Marking strategies of S, A and O is also called **alignment**. See [the Wikipedia page about alignment](https://en.wikipedia.org/wiki/Morphosyntactic_alignment).
There are several prototypical marking of core arguments based on the SAO notation. 
Note that since there is no clear distinction between core and peripheral arguments (see the discussion 
[here](#inner-structure-of-clauses)), what we are really doing here is classification of marking of 
S, A and O arguments. The list is
- [**Accusative marking**](#accusative-marking): S=A, O
- [**Ergative marking**](#ergative-marking): S=O, A
- [**Tripartite**](#tripartite-marking): S, A, O are all different
- [**Direct**](#direct-marking): no difference between S, A and O
- [**Transitive**](#transitive-argument-marking): A=O, S, i.e. the arguments of a transitive clause are marked the same, and different from the argument of an intransitive clause

It's also possible that S is split into several subcategories:
- [**Split S**](#active–stative-alignment): For some verbs, S and A are marked in the same way (so we call the S Sa 
  in this case), while for others, S and O are marked in the same way (and S is now called So). Sa is often 
  called as **active**, while So is often called as **stative**.
- [Fluid S]: for some verbs, we have a system similar to a split S system, while for other verbs, 
  S can be marked as either A or O, to convey active or stative meanings.

The distribution can be found in [WALS](https://wals.info/chapter/100).

## Mixture of accusative and ergative marking and the nominal hierarchy

Note that it's possible that some nouns are marked in the accusative way, while some nouns are marked in the ergative way.
This can be explained by the following nominal hierarchy:
1. 1st pronouns
2. 2nd pronouns
3. demonstratives, 3rd pronouns
4. proper nouns
5. common nouns: human
6. common nouns: animate
7. common nouns: inanimate

The higher a noun's position in the list is, the more possible it will be A. Therefore, for a noun with a high
position in the list, if it functions as O, then the fact deserves a special marking. Therefore, nouns 
with a high position in the list tend to be marked in the accusative way. On the other hand, a noun
with a low position tends to be O and therefore if it functions as A, it deserves a special marking, 
so it tends to be marked in the ergative way.

## Marking of peripheral arguments

- [space and time](#space-and-time)
  - allative
  - locative
- instraument
- accompaniment: *he walked with his wife*
- recipient: *he showed his license to the policeman*
- beneficiary: *she wrote the letter for her cousin*
- aversive: *In case of thunderstorm*

## Marking strategies of arguments 

- Marking on the NP
  - by [case affixes or clitics](#argument-marking-on-the-noun), 
    - on the last word of an NP, or
    - on the first word, or
    - on the head, or 
    - on all words, or
    - on all words of a certain type
  - and/or by adposition
- Marking by a bound pronominal 
  - usually attached to the verb or a verbal auxiliary
  - or sometimes cliticized on the first contituent of the clause
  - Actually, this is one way to distinguish "core arguments", since verb morphology about arguments is usually highly limited.
- Constituent order, like AOV (i.e. SOV)

The first strategy is usually called **case**, which is a closed system, and each NP of a certain type must make only one choice from the system.
Note, however, this doesn't mean a noun can only have one case marker. Consider a language in which the case of an NP is marked on each member of the NP, with no exception, and in this case a genitive NP within a larger nominative NP has both a genitive and a nominative marker.

Peripheral arguments are usually marked, with some exceptions like *go home*. 

It's possible some arguments are marked in the same way:
- ergative and instrumental (ergative argument = Causer? If so, maybe this means in ergative languages the prototypical verb argument structure is the same as the so-called ergative verbs, i.e. [ A Cause [ O Undergo V ] ], where A is optional)
- instrumental and locative
- dative and allative (give ... to = go to)
- locative and allative ("arrive at")

## Accusative marking

## Ergative marking

## Tripartite marking

## Direct marking

## Active–stative alignment


# Verb valence change

BLT 3.20



# Verb morphology

## Person and number marking on a verb

There may be person and number marking on the verb which contains information about 
[the core arguments](#marking-strategies-of-arguments). This is sometimes called [argument indexing](#argument-indexation).

See 
- The rise and preservation of argument indexing systems by Sebastian Collin

# Serial verb constructions

# Argument indexation

# Direct-inverse system

Empathy hierarchy

# Noun incorporation

Sometimes an argument in the underlying argument structure becomes incorporated into the verbal word.
Possible situations include:
- O argument incorporated into the verb, and the clause becomes intransitive
- the head of an O argument is incorporated, and a modifier in the [NP]<sub>O</sub> becomes the new O: "I'm house-making Subih"

# Non spatial settings

See BLT 3.15

TODO
- The relation between Reichenbach's  theory and completion and composition in BLT 3.15
- The contrast between completion and composition
- Whether BLT 3.15 is about lexical or grammatical aspect

# Copula clause

A copula clause contains 
- a copula verb
- a copula subject labeled as CS
- a copula complement labeled as CC, which may be an identity of the subject, an attribution, or a location

CS can be realized like an S, but in some case (e.g. Ainu), it can be realized as similar to A and different from S.
The behavior of CC generally is different from other arguments (for example, no bound pronouns can be an CC 
in known languages).

Sometimes the copula can be omitted. 

# Verbless clause

Some languages support a clause made up solely by two NPs, which are 
- verbless clause subject (VCS) and
- verbless clause complement (VCC) argument

# Negation of clause

See BLT Sec. 3.12

The only universal mechanism is negation of a main clause. Other languages may be able to negate subordinate clause, predicate, and argument.
Negation may be represented by an interjection (which can be the full reply to a polar question).

Clausal negation can be shown by a separate word or a verbal affix or clitic, or by a negative verb.

The scope of negation is also a critical issue:
- Negation with scope over predicate:
  > He could not write the review because he could decline the invitation to review the book to avoid offending the author.
- Negation with scope over clause
  > He could not write the review because he is too busy.
  > I don't beat my dog, because I love her. Yeah, I never, ever beat my dog. I love her so much.
- Negation over sentence
  > I don't beat my dog because I love her. I do beat her sometimes, but of course not for the reason I love her.

The contrast between positive and negative is referred to as polarity.

# Non-spatial setting of clauses

See BLT 3.15

In this section we discuss features that may appear in the TP layer, also called **TAME categories** (tense, aspect, modality, evidentiality). 
In Dixon's terms, features appearing in the TP layer are called "categories associated with the clause", 
while features appearing in the CP layer (for example, Mood, or generative syntax's Force) are called "categories associated with the sentence".
His definition of clause, then, seems to be identical to a routinized TP, and he extracts embedded CP layers 
out and names them "clause connecting devices".

The notion of **completion** is identical to the definition of aspect [here](../Chinese/古汉语句式.md#功能范畴).
Note that Dixon's definition of completion is in the present tense; we need to replace "present" in his definition
by "reference time". In this way, a **perfect** clause denotes to an action that happened before the reference 
time (but still has relevance at the reference time - by the definition of "reference time"), while an
**imperfect** clause denotes to an action that was the case at the reference time.

TODO: when the reference time is before the event time

**Extent** is about an event's actual temporal organization. A more or less instant event is **punctual**, while 
an event that last for some time is **durative** (or **continuous** or **progressive**).

**Composition** is about whether an event is *regarded* as a whole. A durative event can still be regarded as 
somehow "punctual". A **perfective** event is regarded as a whole, while an **imperfective** event is regarded 
as having temporal make-up. Consider, for example:
> [John baked the cake] (perfective, a event as a whole) while [Mary was sleeping] (imperfective, because Mary was sleeping before, during and after John's baking the cake, so it is regarded as having temporal make-up).

The category of composition is different from the category of completion, for quite obvious reasons.

TODO: phase of activity, boundedness

It should be noted that features mentioned above are semantic features that are frequently coded grammatically.
The terms can be used in the following ways:
- as purely functional or semantic terms, e.g. "Evidentiality in English" (though English doesn't have systematic
  syntactic way to code evidentiality)
- as inherent features to the verb, i.e. "lexical aspect", which may include morphological phenomena
- as grammatical terms, including syntactic and morphological marking (not the inherent one!) of the verb

# Finite and non-finite clauses

BLT 2.5 warns about the ambiguity of the term *finite* and *infinite*. 

# General structure of noun phrases

A noun phrase can be made up by 
- a head [noun](#nouns), or 
- a pronoun or a demonstrative,
- an adjective or a free relative clause
  
and zero, one or more NP modifiers. We classify these modifiers according to the grammatical relation between 
the head the the modifier and the inner structure of the modifier:
  - attributive modifiers, including
    - [adjectives](#adjectives), which may be in comparative or superlative form, or participles TODO: infinite, participles, norminalization
    - a [relative clause](#relative-clause)
  - modifiers about the range of the NP, including
    -  a cardinal or ordinal number, and/or 
    -  a [quantifier](#pro-forms), 
    -  and/or a [demonstrative](#pro-forms) (which may be analyzed as a subclass of adjectives in some languages, for example in English)
    - Note that a demonstrative seemingly as a modifier may actually be an apposition, like *[that one]* in
      > I like [that one], [the read dress]
  - one or more nouns, the type of which is usually limited, specifying sex, composition, purpose, etc.
  - a [possessive phrase](#possessive-constructions)
  - an NP or PP for [time or location](#space-and-time), intended purpose, etc.

It should be noted that the above grammatical relations are not necessarily compositional. 
It's possible that an NP headed by an adjective can't be further modified, for example.
It should also be noted that the above classification of grammatical relations are *functional* and for each 
function there is by no means only one construction. Attributive constituents in a NP in English may appear
in front of the head noun or behind the head noun. Only adjectives may fill the former position, and there can 
be several adjectives, while certain adjectives (often those with prepositional phrase complements) and 
relative clauses may fill the latter position. 

# Noun morphology

See BLT Sec. 3.13.

Noun morphology may record the grammatical relation within the NP (example: possessive prefix on the head noun in
some languages), between the NP and an external construction (for example, case marking), and derivation to nouns.
The last can also be seen as a grammatical relation within the NP, from a DM aspect.

## Noun compounding in noun-to-noun derivation

- gunman, gunpowder: one root modifying another
- cry-baby: metaphoric
- cut-throat: indicating someone doing certain action (i.e. a person who cuts other's throats)

## Argument marking on the noun

Morphological marking of nouns may be about
- it's [argument role](#marking-of-core-and-peripheral-arguments), usually named as [case](#marking-strategies-of-arguments)
- 

## Genders and classes

# Noun classification

# Possessive constructions

# Relative clause

A relative clause is a modifier in an NP. 

# NP without noun head

## Free relative clause

> I want [what I want]
> 
> I am [who I am]

# Demonstratives as modifiers

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

# Complement clause

BLT Sec. 3.10

Roughly speaking, a complement clause is an argument in another clause.
Some people call it both an NP and a sentence, though not all arguments are NPs and clauses themselves 
are not sentences. We *don't* name a clause describing a place or a time as a complement clause - 
a complement clause always represents a fact or an event. We should also note that the complement 
clause is NOT verb nominalization, though it's common that they involve similar morphological operations.
For example, in English, we have a -ing complement clause variety:
> John's playing the national anthem

and we also have a -ing nominalization construction:

> John's playing of the national anthem

The -ing complement clause can only be modified by an adverb and can have auxiliaries like *have* and *be*, 
and the -ing nominalization can only be modified by an adjective and can't have auxiliaries.
This is an example of the difference between a complement clause and a genuine NP.

Complement clauses should be distinguished from [*free relative clauses*](#free-relative-clause), which may also fill argument slots.

In many languages, complement clauses and content clauses in non-argument positions have exactly the same 
construction, and therefore it's tempting to analyze them as [the same type of clause](http://itre.cis.upenn.edu/~myl/languagelog/archives/001317.html).

# References

Adger, D. (2021). On doing theoretical linguistics. Theoretical Linguistics, 47(1-2), 33-45.

Cinque, G. (2005). Deriving Greenberg's Universal 20 and its exceptions. Linguistic inquiry, 36(3), 315-332.

Haider, H. 2021 "OVS"–A misnomer for SVO languages with ergative alignment. https://ling.auf.net/lingbuzz/005680

Trotzke, A. (2020). Constructions in Minimalism: A Functional Perspective on Cyclicity. Frontiers in Psychology, 2152.