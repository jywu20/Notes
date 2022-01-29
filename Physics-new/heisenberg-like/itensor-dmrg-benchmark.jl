using ITensors
using Plots
using LaTeXStrings

##
# Define Hilbert space of N spin-one sites
N = 12
sites = siteinds("S=1/2",N; conserve_qns=true)

##
# Create 1d Heisenberg Hamiltonian
ampo = AutoMPO()
for j = 1:N-1
    ampo += 1/2,"S+",j,"S-",j+1
    ampo += 1/2,"S-",j,"S+",j+1
    ampo +=     "Sz",j,"Sz",j+1
end

H = MPO(ampo,sites)

##
# Choose initial wavefunction
# to be a product state
psi0 = productMPS(sites,n->isodd(n) ? "Up" : "Dn")

# Perform 5 sweeps of DMRG
sweeps = Sweeps(5)
# Specify max number of states kept each sweep
setmaxdim!(sweeps,50,50,100,100,200)

##
# Run the DMRG algorithm
energy,psi = dmrg(H,psi0,sweeps)

# Continue to analyze wavefunction afterward 
E_per_site = inner(psi,H,psi) / N

relative_err(a, b) = (a - b) / abs(a)

E_per_site_exact = 1/4 - log(2)
@show relative_err(E_per_site, E_per_site_exact)

##
# Measure "Sz" operator on every site 
sz = expect(psi, "Sz")
for j = 1 : N
    println("Sz_$j = ",sz[j])
end

# ⟨Sᶻ⟩ almost vanishes on each site. That is because Hsisenberg model has spin-flip symmetry.

##
# Measure the correlation matrix.
corr = correlation_matrix(psi, "Sz", "Sz")
scatter(corr[1, :], legend = false)

# The result is same with the result obtained by ED, demonstrating that DMRG can really achive very
# high accuracy.