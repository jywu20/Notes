# 2021.12.12

Ying, S. C. Hydrodynamic response of inhomogeneous metallic systems. Nuovo Cimento B Serie 23, 270 (1974).

Question: what does the $G[\rho]$ term in Eq. (2) mean? 

It can be interpreted as something like the Hamiltonian of Luttinger liquid, and in this case $\rho$ is an operator.
It can also be seen as the density functional as is in DFT, but why does the author use a Lagrangian to derive EOMs?

Now roughly we have three kinds of quantum hydrodynamics:
- Bohmian
- based on the expectation of density and/or velocity, as is the case in dynamic DFT
    - based on Green functions, i.e. quantum kinetic theories
    - based a generalized form of density functional theory
- something like Luttinger liquid, involving density and velocity *operators*

- "quantum correction" in the second meaning of quantum hydrodynamics may be assigned field theoretical meaning

Question: possible unification?

In the classical limit these approaches unify automatically (for example, when we evaluate $T_{\mu\nu}$ for a cosmological calculation, which "quantum hydrodynamics" we use should not affect the final result). 
But in a quantum system:
- A formulation that contains intuitive information about the system (i.e. field theoretical approaches, Feynman diagrams, etc.) is not about directly measurable quantities.
- A formulation that is about directly measurable quantities is not the most concise formulation (though a certain amount of intuitive information, i.e. hydrodynamics, may be kept).
- Some frameworks work both for these two kind of formulations (i.e. hydrodynamics), and therefore are frequently seen.

These quantum theories about directly measurable quantities can also be seen as effective theories of a quantum 
effective action, where quantum fluctuations have been resummed.

Note that for a degree of freedom to be integrated out, which formulation we choose in principle has nothing to do
with the effective theory. For example, $\epsilon_\text{r}$ evaluated using Green functions or using DFT should 
be the same. 
The former approach is like, we know
$$
\ee^{- S_\text{eff}[J]} = \int \mathcal{D}\phi \ee^{- S_J[J] - S_\text{coupling}[J, \phi] - S_\phi[\phi]},
$$
and we integrate out $\phi$ using standard field theoretical methods. The latter approach is like, we obtain
an explicit super-duper quantum effective action
$$
\ee^{-S_\text{quantum-eff}[J]} = \int \mathcal{D}\phi \ee^{- S_J[J] - S_\text{coupling}[J, \phi] - S_\phi[\phi]}
$$
in advance (and no one knows how the shapes of $S_\text{coupling}$ and $S_\phi$ are reflected in it), and then we have 
$$
\ee^{- S_\text{eff}[J]} = \ee^{- S_J{J}} \ee^{-S_\text{quantum-eff}[J]}.
$$
That is why some article just put the energy functional in DFT into a Lagrangian.

It can be expected that we may have a DFT for photons. Indeed we have. See https://arxiv.org/abs/1403.5541.
A major difference is that in the standard model, fermionic fields themselves are not observable, and they
are actually square roots of particle densities (bubble Feynman diagrams with inner structures reveal the fact 
that fermions can not be simply represented by their densities). Therefore, a many-body theory that is about 
directly measurable quantities of fermions must be about *densities*. On the other hand, gauge fields in the 
standard model themselves are observables, and a many-body theory that is about directly 
measurable quantities of gauge bosons can be about *the expectation of gauge fields*.
So in the end, the formulation of something like "DFT for QED" looks just like classical electrodynamics,
where the electromagnetic field interacts with electron density (instead of electronic fields).

Expectation-based hydrodynamics can be further divided into several approaches. If we are talking about 
the flavor of thermodynamics that we usually encounter in fluid dynamics courses, then there must be frequent
collisions in the system to establish thermal equilibrium. When there are few collisions, however, formally we 
may still have hydrodynamics, because bosonization may work.