Gauge problem in quantum transportation
======

The quantum Boltzmann equation (QBE) can be derived 
from the (generalized) quantum master equation 
about the reduced electron (or other particle-like degrees of freedom)
$$
\begin{equation}
    \dv{\rho}{t} = \frac{1}{\ii \hbar} \comm{H}{\rho} + \text{quantum jump},
\end{equation}
$$
where $H$ contains the band Hamiltonian 
plus the self-energy $\Sigma$, 
which in turn contains $G^<$ that should be reconstructed from $\rho$.

In free space, the momentum basis is clear: 
$$
\begin{equation}
    \psi_{n \vb{k}} = \frac{1}{\sqrt{V}} \ee^{\ii \vb{k} \cdot \vb{r}},
\end{equation}
$$
and we have the correct normalization relation
$$
\begin{equation}
    \int \dd^3 \vb{r} \psi_{n \vb{k}}^*(\vb{r}) \psi_{n' \vb{k}'} (\vb{r})
    = \delta_{n n'} \delta_{\vb{k} \vb{k}'}, 
\end{equation}
$$
and to get $f_{\vb{k}}(\vb{r})$ we just need to do 
Wigner transform to $\mel{\vb{r}}{\rho}{\vb{r}'}$.

In a crystal, however, according to Bloch theorem we have 
$$
\begin{equation}
\psi_{n \vb{k}} = \ee^{\ii \vb{k} \cdot \vb{r}} u_{n \vb{k}},
\end{equation}
$$
where $u_{n \vb{k}}$ may have a rather complicated structure. 
So now comparing this with the free space case, 
we find it's possible that  
a $\vb{k}$-dependent phase factor
is added to the basis. 
This of course causes major change to the QBE.

Toy model: still free space (so no 1BZ boundary)
but $\psi_{n \vb{k}}$ contains $\ee^{\ii \theta_{n \vb{k}}}$.