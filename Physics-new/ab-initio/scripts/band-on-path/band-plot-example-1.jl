# In this minimal example, 
# we show how to plot bands of WTe2 monolayer using `Plots.jl`

using Plots 
include("qe-bands.jl")

#region Configurations

# Go to the directory containing 
# the band calculation; 
# this makes the directory the default place 
# to store plots.
cd("../../examples/WTe2-monolayer/4-path/") 

# Selecting bands around the Fermi surface
band_range = 116:124

# This value has to be read from QuantumESPRESSO output files, 
# like `scf.out`
ε_F = 2.7317

suffix = "WTe2"

#endregion

#region Reading bands

nkp, nbnd = read_qe_bands_x_size("$(suffix)_bands.dat")
ε_kn = read_qe_bands_x_energy("$(suffix)_bands.dat.gnu", nkp, nbnd)
ε_kn = ε_kn[:, band_range]
ε_kn .-= ε_F

#endregion

#region Plotting

p = plot(legend = false)
for n in 1 : length(band_range) 
    plot!(p, ε_kn[:, n])
end
savefig(p, "example-plot-1.pdf")

#endregion