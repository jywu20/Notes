using Plots 

directory = "../archives/qian/2-sigma-10/"
prefix = "WTe2"

nbnd = 6 
nx = 10
nkp = nx^2 

ΔE = 0.

################################################

function parse_sig2wan_lines(bands_data, nbnd, nkp)
    bands_data = map(bands_data) do line
        parse(Float64, split(line)[3]) 
    end
    bands_data = reshape(bands_data, (nbnd, nkp))
end

function parse_eqp_lines(data)
    nbnd = parse(Int, split(data[1])[4])
    nkp = Int(length(data) / (nbnd + 1))
    
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
    cat(dft_bands, gw_bands, dims = 3)
end

################################################

wan_bands_data = readlines(directory * prefix * ".eig")
wan_bands_data = parse_sig2wan_lines(wan_bands_data, nbnd, nkp)

bands_data = readlines(directory * "eqp1.dat")
bands_data = parse_eqp_lines(bands_data)[:, :, 2]

nx_bgw = Int(nx / 2 + 1)
bgw_range = map(0 : nx_bgw-1) do i
    (i * nx + 1) : (i * nx + nx_bgw)
end
bgw_range = Iterators.flatten(bgw_range) |> collect

p = plot(legend = false)
ks = 1 : length(bgw_range)
for i in 1 : nbnd
    plot!(p, ks, bands_data[17 + i, :], color="orange")
    plot!(p, ks, wan_bands_data[i, bgw_range] .+ ΔE, color="blue") 
end
p