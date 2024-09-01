How to read Landau's Course
==========

Landau's Course is known for its deep physical intuitions
and the hard-core mathematical skills it employs.
This is a rather diplomatic way to present the unique traits of Course.
For readers not familiar with Landau's style,
these features mean they'll constantly be confused by questions like this:
Why I'm formulating the problem in this way?
Why I'm taking these mathematical approximations?
And, finally, what does my results mean experimentally?

# (Lack of) uniformity and uniform formalism

The contents of Course may seem a little outdated,
but this is the strength of the series:
none of today's textbooks would treat topics like elasticity or fluid dynamics 
as topics integrated into the uniform system of theoretical physics.

Rather strangely, in the treatment of many other topics,
*lack* of uniformity turns out to be one of the greatest obstacles
an unexperienced reader may encounter when reading Course.

To name a few:
- Navier-Stokes equation is seen almost as given, and not as a natural fixed point for a non-equilibrium system.
- In the chapters about Fermi liquid theory, discussions about "when Fermi liquid theory fails" are rather misleading. A modern reader tends to consider the phrase "breakdown of Fermi liquid theory" as emergence of strongly correlated phases, while what is actually meant in Course here is "when a Fermi liquid stops to show quantum features and can be handled by a classical kinetic theory".
- On the other hand, the kinetic equation of Fermi liquid is always valid regardless of the temperature. Here the problem of lack of a bigger theoretical framework strikes again: the Boltzmann-like kinetic equation is taken for granted, and not as an approximation of a truncated Green function equation of motion.
- Another problem in the treatment of Fermi liquid theory is $\epsilon$ which contains the $f \var{n}$ correction is directly placed into the Fermi-Dirac distribution function to force a self-consistent equation for quasiparticle distributions. You need to know Matsubara field theory to understand why this is valid: we are essentially doing self-energy correction to finite-$T$ Green functions. But Course treats this in a completely phenomenological way.
- Fluctuations in medium are important because they are needed in building a Langevin-like effective theory of the medium. This is particularly important in laser physics. 

It can be seen that although we can base everything in Course on Keldysh field theory
(not every modern physics topic can be based on it:
quantum information and related formalisms, like entanglement-based wave function ansatzs e.g. DMRG,
are notable exceptions),
the authors reject to do so and rely on physical intuitions instead.
This is rather challenging for students without much physical intuitions!

# What does my results mean experimentally?

A part of the question has already been answered by my discussion of lack of explicit uniformity (with strong implicit uniformity) in Course.
For example, if we know calculating the fluctuation correlation function is useful for building an effective theory, ultimately we will try to think of a case where the appropriate effective theory does need to consider fluctuation, and it turns out that a theory about laser noise is an instance.
This specific example is further related to a more generic question:
is the theory of effective dielectric function enough?
We know when the noise is strong, the answer is no.

Another part of the question is deeply rooted in how many theoretical physicists - not just Landau - deal with equations they get.
They're like mathematicians who only care about existence and uniqueness in this regard:
what they care about are discovery and classification of mechanisms,
and what quantitatively will happen is often ignored.
This is particularly true in condensed matter physics.
If you really want to calculate the exact value of the Feynman diagrams,
you should do first-principles calculations,
not "pure" theory.