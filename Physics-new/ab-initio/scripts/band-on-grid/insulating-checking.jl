# Reading a eqp.dat file 
# and check whether it's a metal or an insulator

using Plots

valence_idx = 20
conduction_idx = 21
E_range = (0, 4)
working_directory = "../archives/qian-gw-conv/30-2000/2-sigma/"
data = readlines(working_directory * "eqp1.dat")
save_checking_plot = true

nbnd = parse(Int, split(data[1])[4])
nkp = Int(length(data) / (nbnd + 1))

# GW sometimes displaces all bands with a constant, 
# and to compare the difference between the two bands, 
# we may want to move the GW bands with an opposite constant
ΔE = 0.

kpoints = data[1 : nbnd + 1 : end]
kpoints = map(kpoints) do line
    map(split(line)[1:3]) do x
        parse(Float64, x)
    end
end
kpoints = hcat(kpoints...)

deleteat!(data, 1 : nbnd + 1 : length(data))
data = reshape(data, (nbnd, nkp))
dft_bands = map(data) do line
    parse(Float64, split(line)[3])
end
gw_bands = map(data) do line
    parse(Float64, split(line)[4])
end

E_max = max(gw_bands[valence_idx, :]...)
E_min = min(gw_bands[conduction_idx, :]...)
println(E_min - E_max)

gw_bands .+= ΔE
p = plot()
for i in valence_idx:conduction_idx
    plot!(p, dft_bands[i, :], color="orange", legend = false)
    plot!(p, gw_bands[i, :], color="blue", legend = false)
end
ylims!(p, E_range)
p

if save_checking_plot
    savefig(p, working_directory * "insulating-check.pdf")
end
