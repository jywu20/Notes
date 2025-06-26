Foundational concepts of algorithms
===============

# Algorithms in procedural programming

In [this note](../HPC/overview.md) we have seen that a piece of software 
usually can be theoretically conceived as a random access machine (RAM),
as modern CPUs' user interface works in this way
and the operation system gives a hosted program the illusion of this.
Most software is developed using (structured) procedural programming.
When talking about the theory of algorithm,
most of the time we're talking about the analysis of 
structured procedural algorithms on RAM.
That's to say, how Python is taught to first-year students.

# Proving correctness of an algorithm

The main non-trivial aspect of analysis of algorithms is
the behavior of loops.
The standard approach is called the approach of loop invariants:
the analyst is to conceive a property $P(i)$ (where $i$ is the loop counter) on their own,
using their intelligence, such that 
- $P(0)$ is correct: it is consistent with the situation before the loop starts 
- $P(i) \Rightarrow P(i+1)$
- $P(n)$ (where $n$ indicates when the loop ends) is a property we want to prove 

For instance, to prove that a sorting algorithm works,
$P(i)$ may be defined as "elements at 1 to $i$ have been sorted".
And $n$ is the total length of the array to be sorted.

