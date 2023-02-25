# This script shows that when doing Wannier90 calculation, 
# the .eig file given by sig2wan.x after a sigma rule
# and the eqp1.dat file given by the sigma run 
# agree perfectly with each other.

using Plots 
include("eqp.jl")
include("eig.jl")

cd("../../examples/WTe2-monolayer/2-sigma/") 
prefix = "WTe2"

# This can be found in the second last line in sig2wan.inp
nbnd = 6 
# This can be found in prefix.win
nx = 10
# Note that Wannier90 doesn't have symmetric reduction: 
# a 10 10 1 kgrid has exactly 100 k-points.
nkp = nx^2
# This can be found in the band_index_min option in sigma.inp
starting_band_index_eqp = 101
# This can be found in the last line in sig2wan.inp
starting_band_index_eig = 118

wan_bands_data = read_wannier_eig(prefix * ".eig", nbnd, nkp)
bands_data = read_bgw_eqp("eqp1.dat")[:, :, 2]

nx_bgw = Int(nx / 2 + 1)
bgw_range = map(0 : nx_bgw-1) do i
    (i * nx + 1) : (i * nx + nx_bgw)
end
bgw_range = Iterators.flatten(bgw_range) |> collect

p = plot(legend = false)
ks = 1 : length(bgw_range)
for i in 1 : nbnd
    # Note that the band indices in the .eig file and in the eqp file 
    # have different starting points, 
    # and therefore we need to do a shifting here
    plot!(p, ks, bands_data[starting_band_index_eig - starting_band_index_eqp + i, :], color="orange")
    plot!(p, ks, wan_bands_data[i, bgw_range], color="blue") 
end

# The two plots should agree with each other.
savefig(p, "check-eig-eqp-agreement.pdf")