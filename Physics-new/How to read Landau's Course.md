How to read Landau's Course
==========

Landau's Course is known for its deep physical intuitions
and the hard-core mathematical skills it employs.
This is a rather diplomatic way to present the unique traits of Course.
For readers not familiar with Landau's style,
these features mean they'll constantly be confused by questions like the follows:
- Why I'm formulating the problem in this way?
- Why I'm taking these mathematical approximations?
- And, finally, what does my results mean experimentally?

People doing theoretical physics first formulate a problem within a formalism, and then do some mathematical manipulations, and then identify the calculation results with real world measurements.
Landau's course is hard in all the three aspects.

# (Lack of) uniformity and uniform formalism

The contents of Course may seem a little outdated,
but this is the strength of the series:
none of today's textbooks would treat topics like elasticity or fluid dynamics 
as topics integrated into the uniform system of theoretical physics:
they are derived from thermodynamic principles of condensed matter systems.

Rather strangely, in the treatment of many other topics,
*lack* of uniformity turns out to be one of the greatest obstacles
an unexperienced reader may encounter when reading Course.

- if we think about the issue for a while, we will find that even elasticity and fluid dynamics are not treated in a quite "uniform" way. How do we know that we can assume local equilibrium and keep only the very, very long-range degrees of freedom as dynamic degrees of freedom? The way Navier-Stokes equation is derived is not too much different from taking it as given, and not as a natural fixed point for a non-equilibrium system.
  In fact, there *is* non-trivial physics in fluid dynamics.
  We can argue that gapless bosonic excitations - which are *not* necessarily the same as "sound", i.e. hydrodynamic waves (cf. zero sound in Fermi liquid) - tend to be thermalized when the temperature is high enough,
  and therefore the only degrees of freedom that are not thermalized are the usual hydrodynamic degrees of freedom. See e.g. arXiv 1805.09331.
- In the chapters about Fermi liquid theory, discussions about "when Fermi liquid theory fails" are rather misleading. A modern reader tends to consider the phrase "breakdown of Fermi liquid theory" as emergence of strongly correlated phases, while what is actually meant in Course here is "when a Fermi liquid stops to show quantum features and can be handled by a classical kinetic theory".
- On the other hand, the kinetic equation of Fermi liquid is always valid regardless of the temperature. Here the problem of lack of a bigger theoretical framework strikes again: the Boltzmann-like kinetic equation is taken for granted, and not as an approximation of a truncated Green function equation of motion.

  Here we can see a terminological problem:
  for modern readers, "Fermi liquid" means a *phase*:
  thus it *never* breaks down when the temperature goes higher,
  and the full theory describing it is a non-equilibrium Green's function EOM,
  which in the long wave length limit is the Boltzmann-like equation given by Landau,
  and in general is something like time-dependent adiabatic GW.
  For Landau, "Fermi liquid" means the low temperature limit of modern readers' Fermi liquid, which is essentially a *equilibrium* self-energy correction but is framed using energy functional etc. in his description.
  When the temperature increases, we get a crossover from quantum fluid behaviors (beyond Navier-Stokes because of zero-sound etc. which are beyond standard hydrodynamics: see above)
  to standard hydrodynamic behaviors, but this is not a phase transition.
  See e.g. [here](yale-solid-state-2/boson-in-fermi-liquid.pdf).
  Note that Navier-Stokes equation without viscosity *can* describe many bosonic systems,
  and the resulting theory may indeed by known as "hydrodynamics" (see the discussions on Xiao-gang Wen's textbook below).
  But hydrodynamics without viscosity is hardly what is intuitionally known as hydrodynamics.
- Another problem in the treatment of Fermi liquid theory is the single quasiparticle energy $\epsilon$ which contains the $f \var{n}$ correction is directly placed into the Fermi-Dirac distribution function to force a self-consistent equation for quasiparticle distributions. You need to know Matsubara field theory to understand why this is valid: we are essentially doing self-energy correction to finite-$T$ Green functions. But Course treats this in a completely phenomenological way (and uses a lot of rather hand-wavy arguments like minimization of entropy etc. which are formally equivalent to $Z = \trace \ee^{-\beta H}$ but may leave the reader wondering why we are applying soft condensed matter methods to electrons).
- Fluctuations in medium, appearing out of no where in the volume about condensed matter physics in Course, are important because they are needed in building a Langevin-like effective theory of the medium. They are also necessary because a medium has dissipation and we would expect that excitations in the medium created by the dissipation may spontaneously decay and return the energy to the radiational field. This is particularly important in laser physics: a simplest laser device can be modeled as a mode whose EOM contains a loss channel, a gain channel (because of the presence of the pump), and a non-thermalized out-of-cavity channel, and by assuming that we have no input to the laser device and calculating the correlation function of the output mode of the out-of-cavity channel, we get the laser power spectrum. On the other hand, we may say that with the presence of a very coherent driving field whose intensity is strong enough and there is a non-thermalized outgoing channel, we always get laser, and it can be understood as a result of spontaneous emission (see the laser part in [this note](optics-and-quantum-electronics/lecture-notes.pdf)).
  
  (Note, however, that just because an exponential decay term like $- a / \tau$ appears in the EOM of a mode
  doesn't mean the mode is necessarily connected to a noisy environment:
  it just means the mode is connected to an environment that's much larger, and nothing else.
  Indeed that's how we model "laser beam coming out of the laser medium, causing energy loss":
  nothing noise happens in this process.
  We have to manually put noisiness into the environment to have noisy and Langevin behaviors.
  
  This kind of exponential decay caused by system-environment coupling is sometimes known as spontaneous decay.
  Note that it's orthogonal the fact that the transition between $\ket{\text{e}, n=0}$ and $\ket{\text{g}, n=1}$ is non-zero,
  which is also known as spontaneous decay.
  The latter kind of spontaneous decay doesn't need to be irreversible:
  consider the Jaynes-Cummings model.)
- Questions like "what hydrogen atom-like models of exciton miss" lead us to include the exchange term in BSE for excitons (see [here](ab-initio/gw-bse.pdf)), which highlights the many-body nature of the problem.
  In the volume about single-electron quantum mechanics not a single word is given to this issue.
- The question how indistinguishability is reflected in Feynman diagrams about interactions between a particle and a compound state made of the same kind of particles leads us to include "exchange" terms in electron-exciton interactions (useful when investigating trion formation).
- When should we consider interaction as "scattering" (led by, say, Fermi golden rule), and when should we consider interaction to be a correction to the single-particle energy? Turns out the two ways to see interaction correspond to two types of self-energy corrections, namely the retarded self-energy and the lesser self-energy, which, in the near-equilibrium case, reduce to the real and imaginary parts of the self-energy. See e.g. [here](ab-initio/tdagw-preview.pdf).
- Why sometimes we calculate various material properties using a microscopic quantum theory,
  and then insert them into a theory that disregards any quantum coherence
  (e.g. scattering rates from Fermi golden rule being used in a rate equation,
  or $U/I$ curve of diode derived from Fermi golden rule)?
  The reason of course is that in these systems we have a lot of dephasing effects
  that "observe" the system and destroy quantum coherence.
  But that's not a trivial topic at all,
  because when dephasing effects are too strong, we have quantum zeno effects.
  Ideally the quantum zeno effect regime and the rate equation regime should be derived from the same quantum master equation, but Landau never goes in details about it.

The problem, by the way, is not confined to Landau's Courses.
Xiao-gang Wen's textbook about quantum field theory in many-body systems suffers from similar problems:

- Can we somehow "quantize" the Boltzmann equation? Turns out we *can*: in some senses:
  the Boltzmann equation is the quantum master equation after gradient expansion,
  and we know time-dependent quantum master equation about a single-particle quantity 
  gives us information about higher-order correlation functions 
  (for example, linear response of dynamic GW = BSE).
  Therefore the oscillation modes of the Boltzmann equation gives us bosonic excitations made of electron-hole pairs,
  and formally, these excitations can be read from Boltzmann equation understood as a quantum EOM of operators.
  Of course, the full Boltzmann equation has collision terms,
  and "quantization" of it involves things like input-output formalism and the picture becomes less neat.
  We can actually see that the "quantization of Boltzmann equation" in Wen's book
  has nothing different from deriving BSE from GW:
  see Eq. (5.3.12), the first line is actually BSE:
  the $v_{\text{F}}$ term clearly comes from $\epsilon_{\vb{k} + \vb{q}} - \epsilon_{\vb{k}}$,
  and the appearance of $f$ in the second term comes from the fact that 
  the BSE kernel is $K = \frac{\delta \Sigma}{\delta G}$.
- Similarly we can ask whether hydrodynamics works for electrons.
  It works, in some sense: if we're only interested in, say, the absorption spectrum or electromagnetic properties,
  we're essentially only interested in the response of electron density to a perturbation coupled to the electron density,
  and the resulting effective theory is essentially generalized hydrodynamics
  and its long-range behavior is governed by (collision-less) Boltzmann equation.
  This is a naive form of bosonization:
  it's not of much theoretical importance because this bosonization is done 
  *after* we deal with the system in the basis of electrons
  and conclude that it's a Fermi liquid,
  and because this bosonization contains infinite bosonic modes,
  which is unlike the case in Luttinger liquid where there are only two modes.
  (The relevant discussions can be found in Xiao-gang Wen's textbook.)

  This "hydrodynamics" (also mentioned [here](intro.pdf)) is quite different from ordinary hydrodynamics 
  in that the latter has viscosity:
  indeed the word "hydrodynamic behaviors" usually refers to systems in which electron-hole degrees of freedom are predominant *and* dissipation exists for these degrees of freedom.


It can be seen that although we can base everything in Course on Keldysh field theory
(not every modern physics topic can be based on it:
quantum information and related formalisms, like entanglement-based wave function ansatzs e.g. DMRG,
are notable exceptions),
the authors reject to do so and rely on physical intuitions instead.
This is rather challenging for students without much physical intuitions!

And sometimes, reckoning on the formalism does lead you to interesting topics.
- The examples given above all lead to high non-trivial research-level problems.
- Here is yet another example: if you just say "crystal momentum is just like real momentum"
and proceed to write $\dot{\vb{r}} = \pdv{\epsilon_{\vb{k}}}{\vb{k}}$,
$\dot{\vb{k}} = q \vb{E}$,
it's very likely that you'll not realize that we have an additional Berry curvature term in the equation of motion.
But if you try to derive the EOM of $\vb{r}$ and $\vb{k}$,
the necessity of a Berry curvature term becomes obvious. 
- Reckoning on formalisms also helps to avoid mistakes,
like incorrectly including the long-range exchange term in a BSE calculation 
in preparation of exciton energies and wave functions for the calculation of the macroscopic dielectric function:
if we reflect on the Feynman diagrams involved,
we soon realize that this leads to double counting.
And if we consider "how to write down an effective theory for long wavelength electromagnetic modes only" for a while,
we will never forget to do local field approximation.
- Yet another kind of sloppiness observed in some physics textbooks is that, say,
some properties of an interactive system can be derived from an "effective Hamiltonian" or something like this by pretending that the system is non-interactive;
a serious reader will immediately raise the issue that just because we can calculate some properties from the effective Hamiltonian doesn't mean we can calculate others.
An effective Hamiltonian, for example,
might actually be $H - \ii \Gamma C^\dagger C$ in a quantum master equation,
from which we expect to see non-Hermitian band structures,
but the stronger the non-Hermitian effects are,
the stronger the quantum noises are,
so the dynamics of the system at least is not completely determined by the "effective Hamiltonian".

The problem with obsessing with formalisms of course is it prevents you from doing more concrete works.
And sometimes it tempts you to try problems that are too hard
(especially in strongly correlated systems).
But Landau's Course is definitely far from that danger - probably too far from it.
The way physics (especially condensed matter physics) is practiced in our time is system-wise.
So we should expect Landau's Course has a lot to teach about how to do case studies.
It does - but not without caveats. See the next section.

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
A lecture given by a pure theorist about electron structure likely will cover
Kohn-Sham DFT and the inappropriateness to interpret the Kohn-Sham energies as quasiparticle energies,
and that it's a good idea to use DFT wave functions as a starting point
of many-body perturbative approaches,
Hartree-Fock approximation and its inconsistencies in the treatment of screening,
diagrammatic resummation beyond HF and probably some model calculations.
It's very likely that even Hedin's equation is not touched,
let alone the transition matrices that originate from the quasiparticle wave functions
and come with the Coulomb interaction vertex 
(when there is no band topology,
it's often assumed that we can faithfully represent band electrons as plane waves).
So if you really want to calculate the exact value of the Feynman diagrams,
you should read what people doing first-principles calculations say,
not "pure" theory.
(This in turn means that the most *theoretical* works sometimes ignore formalisms more than *computational* works do.)

Although Landau's Course is much more "quantitative" compared with the practice of modern condensed matter physics,
which is filled with hand-waving arguments,
it still strongly leans to the "theoretical"  side and not the first-principles calculation side,
and the result is that unexperienced readers often find it hard to know whether a calculation presented by Course 
should be regarded as an order of magnitude estimation
or a result to be directed compared with experiments.

This, again, is not restricted to Course:
many other otherwise good textbooks, like Philip Phillips's Solid State Theory,
have the same problem.
This is most obvious in BCS theory:
how much the mathematical treatment of the self-consistent equation changes the numeric prefactor of the transition temperature
is almost never clearly stated.

But there are problems unique to Course.
Course doesn't pay attention to formalisms, but it sometimes acts as if it is working under a given formalism and is merely applying different assumptions to derive different results.
If Landau were our contemporary, he would probably add a section to his Statistical Physics II after Sec. 67 about how SOC influences the band structure:
he would probably enumerate several cases, in one of which
the spin and the orbital degrees of freedom are locked, 
and when the inversion symmetry is broken, different bands get unambiguous different spin polarizations.
Modern physicists however will give this phenomenon a simple, easy to remember name: valleytronics.
In Course it's hard to find such concise names for things.
Landau knew of the Berry curvature in light-matter interaction,
and yet he never talks in detail about it in Statistical Physics II.
