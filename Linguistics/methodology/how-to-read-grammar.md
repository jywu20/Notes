Modern descriptive grammars are based on two intertwined types of building blocks:
**dependency relations** and **constructions**.
In principle, one can describe something purely in terms of dependency relations 
or purely in terms of constructions (or in other words constituency),
but in practice this is not quite feasible.
Dependency relations in different constructions with the same name (e.g. direct object)
often have subtle differences,
and eliminating the notion of construction as a preliminary
means these subtleties have to be numerated, 
and each variety of, say, direct object, needs a distinct name,
and lots of rules specifying what dependency relations may coexist are required,
making the whole grammar writing project tedious.
On the other hand, it is usually easy to define somehow non-canonical constructions 
by transformational rules applied on canonical ones,
and if the notion of dependency relations (e.g. the subject-verb relation) is canceled,
transformational rules will be hard to write.

It is therefore a wise idea to write a grammar 
by successively invoking concepts of dependency relations and constructions.
A construction may be analyzed as the composition of several "slots", 
and there are conditions about how these slots ("functions")
are filled by smaller constructions ("forms").
Now selectional rules, agreement rules, etc. can be imposed,
which are all ways to show dependency relations.
A slot, with relevant dependency relations, is called a **grammatical relation** (e.g. subject, object, predicator).
A feature that is used in dependency relations is a **grammatical category** (e.g. number, case, tense).
A type of constructions, i.e. packages of grammatical relations and grammatical categories,
is a lexical category, e.g. nouns, verbs, noun phrases, clauses, etc.
The grammatical categories of a lexical category, therefore,
can be viewed as dependency relations with one end in the lexical category and one end out of it 
(e.g. the number category of an NP can be seen as "half of" the number agreement dependency relation),
and the grammatical relations of a lexical category can be viewed as dependency relations purely internal to it
(e.g. the subject slot is defined by the subject-verb dependency relation).
The other half of dependency relations defining grammatical categories of a construction
defines the syntactic context or syntactic function of the construction.
A package of possible values of a grammatical category and related grammatical relations 
is called a **grammatical system**.
For example, the possible values of the case category 
together with their respective connection with argument positions 
form a **case system**.
The possible values of the verbal agreement affixes together with 
the possible values of NP person category
and the matching condition between the two categories
form a **number system**.
Several systems concerning the reflection of argument properties on the verb or the verbal complex
form a **argument indexation system**.

The logic is quite clear.
Then, what makes grammars hard to read?

# How grammatical systems are represented

## The bottom-up approach

Since descriptive grammars are usually more "surface-oriented",
a common practice is to classify dependency relations 
according to how they are morphologically or syntactically marked.
This makes it easier to write a grammar,
because the author doesn't need to take time to enumerate all grammatical systems in a construction,
say, a clause.
All he or she needs to do is to write down grammatical categories 
manifested by morphology or constituent order in each construction filling clausal slots.
For example, the author may write about how case and number are morphologically marked on NPs
in the chapter concerning NPs,
and how the verb selects its complements and agrees with the subject in the chapter concerning verbs.

This bottom-up approach, however, makes it hard to search for all grammatical systems in the larger construction,
in this case the clause, 
since relevant discussions are scattered over various chapters.
It is therefore quite hard to have a comprehensive classification 
of, say verbs, based on, say, complementation pattern, 
because verbs taking complement clauses are introduced in the chapter about complement clauses,
while verbs taking NP-like objects are discussed in chapters about argument indexation and clausal structure.

A consequence of the problem above is it becomes hard 
to *justify* definition of grammatical relations in the larger construction.
For example, when describing the verb,
only argument positions are uncontroversial grammatical relations:
the notion of subject hints something more than agentiveness: 
the "obligatory topic" properties,
while the notion of object also hints something more than patientiveness:
for example, the ability to be promoted to the subject position in passivization.

A third problem, also related to the fact that grammatical relations are hard to enumerate,
is the overall constituency order (and constituency structure) is hard to find.
There may be some discussion about "subject precedes the verb, while the object follows the verb".
OK, so where are the adjuncts?
The reader has to then turn to chapters about adjuncts,
and try to find some information about constituency order 
between long, long sections on the semantics and pragmatics.

The second and third problems also give rise to the fourth problem:
transformational rules are hard to use.
A topicalization rule may be "place the topic to the front of the clause".
Alright, *how* front should it be? 
Can certain adjuncts appear before the topic? 
After topicalization, should the case marking change?
No answer.

## The top-down approach

An alternative way to write a grammar is to first introduce large constructions, 
and then introduce the smaller constructions as the grammatical relations are shown.
Again, in the case of clauses,
several prototypical clause structures may be introduced first,
and then NPs are discussed as the arguments.

This approach also face several problems.

The first problem is a top-down grammar is always less surface-oriented for obvious reasons 
and can never be achieved with first-hand fieldwork data only.
The second problem is related to the first problem: 
it is hard to write a top-down grammar.

Another problem is the order of chapters. 
NPs can be both core arguments and peripheral arguments,
so where should they be placed?
After the chapter on clause structure, or after the chapters on clause structure and PPs?

# Linear order and binary-branching

BLT criticize

# Transformations

Transformational rules are useful to derive non-canonical constructions from canonical ones,
but they themselves have problems.

## When there is no grammatical canonical counterpart

## How transformation rules are organized

Transformational rules are useful to diagnose syntactic properties of lexical categories.
For example, reduplication is an important criterion to distinguish verbs and adjectives in Chinese.
So suppose the reader wants to learn more about the syntactic context of reduplication 
after finishing chapters about adjectives and verbs.
Where should he or she start?
Since reduplication happens in several constructions,
it can be expected that there is no hub that assembles all constructions in which reduplication appears.
A similar problem is English subject-auxiliary inversion.
It happens here and there, 
and often diagnoses using this transformation are never cross linked to a hub summarizing possible places 
where this transformation occurs.

# Misleading chapter names

Chapter names may mislead readers, making it hard to find grammar points of interest.
The structure of canonical clauses may be hidden in a chapter about verbs,
and the chapter about clauses is merely a review of all grammatical relations involved,
often without enough cross references.
A chapter about simple clauses may have subordinate clauses in the examples given,
because the subordinate clauses are just like NPs.
A chapter about case system 
(or even adpositions, in a language where case clitics has no difference with adposition) 
may talk a lot about complement types 
(and hence verb classification according to the complementation pattern).
Discussion on constituent order may not appear in chapters about NPs or clauses:
it may appear in a chapter about information structure,
since information structure may be marked in constituent order.

# References

Jacques, Guillaume. 2021. A grammar of Japhug. (Comprehensive Grammar Library 1). Berlin: Language Science Press. DOI: 10.5281/zenodo.4548232