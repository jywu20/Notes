Points to consider when describing morphosyntax
===========

How to covertly talk Distributed Morphology and Cartography points while pretending to be a descriptive (or even better, "functional-typological") linguist.

# Things often ignored by typological grammar

- Hierarchical effects: scope of adverbs and their relative orders, seemingly pragmatically unmotivated order constraints (*[est non] in Latin clausal structure, *[饭吃你了] in Mandarin, how personal indexation is calculated in a agent-instrument-patient-theme argument structure in Japhug)
  - Motivates (binary) constituency tree
  - In dependency grammar, it means dependency arcs 
  - Widely attested in languages, like Gyeli
- Grammatical function, grammatical relation, etc.: SpecFP
  - Form: XP; function: whether XP is SpecYP

# Word 

- Lexicon: list of abstract formatives (features and roots) i.e. List A, list of exponents i.e. List B, encyclopedia i.e. List C
  - Semantic lexicalization != morphosyntactic listedness/specification (irregular inflection, etc.)
- Wordhood: maximal complex heads formed in post-syntactic operations 
  - Non-maximal complex heads are not words but are word-like (e.g. English geo- or -graphy)
  - No guarantee a word is a constituency in pure syntax. (Which depends on your definition of constituency: if defined as a span in generative syntax then [performed] is indeed a constituent, as in generative syntax it's a span of heads)
    - And thus we probably shouldn't say "syntax puts words together". Syntax puts roots and formatives together, which then "condense" into words, like how rain comes from a cloud.
    - So there is no bracketing paradox.
    - Ideally a word has to be described in the construction it heads.
  - Diagnostics: regular morphological processes without clear combinatorial motivation
    - English tense inflection in theory can be expressed by auxiliaries but somehow is attached to the verb stem: it's morphological and a part of the word 
  - Diagnostics: (composite) forms with non-inferrable grammatical properties 
    - Mandarin 关心: no one expects it to be transitive: must be a listed exponent
    - Problem with this diagnostics: maximality. 
      - This diagnostics tests exponents and is only applicable in languages with little morphology, where an exponent is a word 
      
- Wordhood controversies
  - Idiomatic meaning is not per se a good criterion ([kick the bucket] is not a word)
  - Low productivity: related to wordhood but not directly 
    - If a morphological process only applies to certain stems, this has to be specified by List B

- Clitics: a very broad concept. There are phonological clitics (to the fat man: to=the=fat man)
  - Morphologically a clitic attaches to a word *lately*. But may still be a part of the maximal complex head so no categorical difference with an affix.
  - e.g. English ['nt]: analyzed by CGEL as a negative suffix (as [don't] moves in V-to-C movement)

- Word formation vs. phrasal syntax: no fundamental difference. There can be modification-like processes in word formation ([ethno-music-o-logy]) too and in Sinitic languages, forms like 白大褂 violate the usual adjective order and scope hierarchy; the peculiar behavior means the forms are List B exponents, with regular internal phrasal structure.
  - The distinction ideally has to be made *after* wordhood tests are established.
- Word formation vs. inflection: no clear boundary. Is valency alternation derivational or inflectional?

- Defining wordhood in a specific language is not always easy and sometimes we have to rely on *inference of best explanation*
  - Idiomization of meanings of words is more frequent than idiomization of phrases.
  - Low productivity is correlated to lexical specification of an exponent in List B and hence wordhood.
  - Boundaries seen in phonology are often from grammatical wordhood.

- Stacked vs. template morphology. There have been arguments suggesting that there's no real template morphology and the location class is not a real linguistic entity.
  - See comparative-method.pdf

- Head. The concept of head is now very confusing. Because we don't distinguish functional heads from lexical heads. The latter being cores of big constructions like CP (clauses) or DP (noun phrases).
  - We may define the (ultimate) head of a big construction as the grammatical word that contains the categorizer head of that construction. So whatever word containing the n head or the v head is the head of the noun phrase or the clause. 

- Parts of speech. *Lexical* parts of speech i.e. form classes in the lexicon are clusters in List B: and it's possible to have more than one noun or verb classes. *Syntactical* parts of speech are more mundane (what has a n head is a noun). 
  - In theory there's no need for parts of speech tags for grammatical formatives. Such a practice is based on the lexicalist perception that syntax puts pre-formed words together. But for practical reasons (like making looking up for unfamiliar grammatical formatives easier) we can still classify grammatical formatives.
  - Similarly it makes no real sense to ask if a formative is an auxiliary or a particle.

# Clauses, peripheral system 

- Sentential clause = nucleus clause (TP) + peripheral speech force categories (basically, CP). 
- Speech force categories: evidentiality, speaker's attitude, etc., and topicalization and focalization
  - Not always available in embedded clauses
  - Exponents: sentence initial particles, sentence final particles, etc.
  - Pay attention to the linear order of the particles; often it's not random
- Topicalization and focalization: may disrupt word order
  - Constituency can still be tested by order constraints, pronoun binding, etc. See the Latin note and discussions on non-configurational languages.
  - Note: vP may have its own information structure system (TopVP, FocVP) too.

# Nucleus clause 

- Grammatical functions: deep and surface.
  - S, A, P, G, T labels: deep. Originate from the argument structure i.e. the vP. P = SpecTransP, and the like.
    - No guarantee of uniform syntactic behaviors. S may be A-like or P-like. G or T may be P like or instrument-like.
  - subject, object, etc.: surface. 
  - Mapping from S, A, P etc. to subject, etc.: alignment
- The argument/adjunct distinction: not a single parameter
  - The defining criterion: lexical specification of an argument. (Like the verb root being able to be spelt out only with Trans head, so the verb is transitive). Tested by obligatoriness, etc. 
    - But may be confused with pragmatic or semantic factors. 
    - Real morphosyntactic obligatoriness exists ([slog] in English has to have a locative argument).
  - The structural closeness to main verb: arguments tend to be closer to the main verb (but consider the structure [<sub>vP</sub> subject [<sub>InstrP</sub> instrument [<sub>TransP</sub> ...]]] where the instrument, often considered an adjunct, is structurally closer to the main verb). 
    - Testable by whether a clausal dependent can be omitted together with the main verb ([I don't want to do **this**])
    - But often no qualitative difference can be found 
  - Agreement, case marking, etc.
    - This is about the oblique/non-oblique distinction. (Oblique arguments are phases and naturally don't participate in agreement.)
    - Arguments structurally far from the main verb can also be non-oblique: indeed that's what applicative means.
    - Non-oblique arguments often limited in number. Explainable if you assume the accusative case is assigned via probe mechanism in Minimalism: a non-oblique argument may have oblique arguments below it (very internal locative ones, see the Classical Chinese note) and above it (instrument, etc.)
  - In typological literature, we also have core/peripheral distinction. 
    - Not well defined *structurally* in generative syntax. May be definable in certain flavors of functional grammar (see e.g. the grammatical framework chapter of Pinkster's Latin syntax).
    - Most of the time, definable in morphological terms (and hence is the oblique/non-oblique distinction: "applicative moves a peripheral argument to the core" and all that).

# Alignment

- Ergativity. A term now basically means property clustering of S, A, P arguments in all kinds of constructions. 
  - At the argument structure level ergativity is almost always non-existent, and we always have S=A (not really equal of course). 
    - As seen in control, reflexive pronoun binding, etc. Dixon warns in his BLT that this is not evidence for absence of ergativity.
    - Note that this can also be evidence supporting existence of hierarchical effects in argument structure, hence evidence supporting binary tree analysis
    - We may say that the pivot at the argument structure level is always S or A. (Consistent with existence of a vP projection, and the SpecvP is the argument structure pivot.) 
  - Morphological ergativity: the A argument being oblique. 
    - Explains e.g. why the verb agrees with the P argument.
    - While it's still the S and A arguments being the shared argument in clause coordination and the argument with a broad scope. (consider English [Susan hates sushi. But she (=Susan) likes ramen.]).
    - And thus in morphological ergativity, the clausal pivot is still A and S.
  - Syntactic ergativity: the P argument being the clausal pivot. 
    - So S and P are the shared argument in coordination. 
    - A'-movements, like topicalization or relativization, also target S and P in syntactic ergativity.
  - As long as we have a well-defined clausal pivot (according to coordination, wide scope interpretation, etc.) we can define a verb phrase covering the rest of the nucleus clause (and the pivot, in terminology of CGEL, is the external argument). 
    - Thus even in Latin we can define a verb phrase, see the Latin notes. 
    - But in languages with strong pro-drop it's not always easy to decide if two clauses are coordinated, sharing the pivot, or just coordinated with some of their arguments omitted. 
      - Descriptive linguists often say these languages have flat clause structures (as in the Yakkha grammar).
  - It's not truly surprising to find different ergativity behaviors in different clause types. Certain languages have relative clause types that selectively target A or P arguments and in these constructions one may notice whether there's S=A or S=P alignment.

- Two types of direct-inverse systems. See the Japhug note. 
  - Shallow inverse is just the T head probing speech participants only.
  - Deep inverse is essentially inverse-triggered voice.

# Tense, aspect, modality

- The Cinque hierarchy can be a good list of points to investigate, but is too chaotic. We can divide our scope of investigation to several parts: 
  - Top-level categories often involving speakers' attitude or evaluation (including evidentiality and epistemic modality).
  - Primary tense (present, past, future), modality of possibility
  - Point of view aspect (progressive), including inchoative and terminative, and secondary tense (perfect)
  - Lexical aspect, which, despite the name, can be syntactically changed. See the Classical Chinese note.
- Attention should be paid to the correlation between TAM adverbs and formative orders in verb morphology.
- Auxiliaries are auxiliaries in that they are embedded into the grammatical system: orders of complement clause-taking verbs can be shifted ([want to like it] vs. [like to want it]) but orders of auxiliaries cannot.

# Argument structure

- Points already listed above, like structural closeness of clausal dependents to the main verb, need to be studies. Note that locative phrases may be far or close to the main verb.
- BE, BECOME, CAUSE and DO light verbs appear to be more or less universal. We can also call them stative clauses, inchoative clauses, causative clauses and action clauses. 
  - Naturally there's causative-inchoative alternation, unaccusative and unergative verbs, and all that. 
- Certain clauses may have a small clause in its argument structure. Especially when G and T arguments appear.
  - Evidence including whether the small clause appears in coordination ([give A to B and C to D]).
  - Both the small clause analysis and the VP shell analysis do not disagree in the hierarchical order of arguments so setting them apart is often difficult in descriptive linguistics.
- Particles in argument structure may be licensed by a small clause or by the main verb. See the English note. 
  - Particles are always syntactic. Consider the correspondence between Latin preverbs and prepositions, which suggest an earlier stage when preverbs were flexible in word order. We should not make categorical distinctions between particles embedded in the verb stem and particles in syntax.
    - Especially considering there are separable verbs in various genetically unaffiliated languages.
- Passive, causative, applicative: one may say they turn a deep A argument to the surface instrument, etc. This makes sense in typological literature - and also in generative syntax.
- Argument structure alternation is linked to verb morphology.
  - There is no categorical structural difference between verb word formation and argument structure. Mandarin has forms like 吃饭 in which the object is obligatorily indefinite, and 关心 in which the object is obligatorily indefinite and the whole form selects a P argument. The latter is obviously a word in that 关心, by virtue of obligatorily having a P argument, clearly is a List B exponent. 吃饭 may or may not be a List B exponent. Note that the internal structures of 吃饭 and 关心 are identical.


# Noun phrases

- A noun phrase in a descriptive context is a CaseP or PP or DP. The "nucleus noun phrase" (cf. the nucleus clause) is something like a NumP.

- Prepositions are a heterogeneous category. They include functional heads and transitive adverbs.
  - Grammatical prepositions, like auxiliaries or particles, form a hierarchy: thus [from behind the door] but not [*behind from the door]. In Mandarin forms like [从柜子上面] and [柜子上面] are both attested, but not *[从柜子]. In this way we find the following hierarchy: [<sub>PathP</sub> [<sub>GroundP</sub> ... ]].
  - Prepositions and oblique cases can't be categorically separated. 
    - In Japhug for instance we have case particles, not attached to any word.

- What are traditionally known as determiners include quite a lot things.
  - First, note that we have something comparable to the hierarchy of sentence final particles in clause structure: [all these things] but not *[these all things].
  - In some languages, the determiner region has a "subject", literally known as the subject-determiner in CGEL.
  

# Adjectives

- Adjectives in a noun phrase can be divided into direct modification adjectives and reduced relative clauses, according to Cinque.

# Argument structure in noun phrases 

- Multiple works mention argument structures in noun phrases. Paul Rowlett. The syntax of French. Cambridge University Press, 2007 mentions it in describing noun phrase structures. CGEL also describes noun phrases argument structures.
- The argument/adjunct distinction has already been outlined above.

# Terminological and notational issues

- Extended VP, extended NP: basically just clause structure and noun phrase structure. See Powlett's work, and The development of Latin clause structure: A study of the extended verb phrase.
- Modifiers: cf. adjuncts. In some Chomsky's papers there's a distinction between Adjoin and Merge but here we consider all the alleged differences are explainable by whether a dependent is selected by the head's lexical entry.
  - There's also a tradition to call everything in the noun phrase besides the head noun a modifier.
- Complements. Another way to say arguments.
- Flat clause analysis, template-based approach: see discussions in the beginning