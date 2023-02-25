# Plotting the spin texture 
# Before running, please modify the constants in the Configuration block 
# according to the comments. 

using PGFPlotsX
using LaTeXStrings
using Colors
using DelimitedFiles
include("qe-bands.jl")

#region Configuration

spin_colors = range(colorant"deepskyblue1", stop=colorant"orange", length=100) 

# Go to the directory containing 
# the band calculation; 
# this makes the directory the default place 
# to store plots.
cd("../../examples/WTe2-monolayer/4-path/") 
band_dat_path = "WTe2_bands.dat"
band_dat_gnu_path = "WTe2_bands.dat.gnu"
spin_dat_path = "WTe2_bands.dat.3"

# I strongly recommend you leaving the band plots in the 
# same directory with the input and output files. 
# Again, always check the working directory before running the program.
output_file = "example-plot-2.pdf"

# If you are sure the material is an insulator, then use the following definition of ϵ_F
# ϵ_F = max(energies[:, n_valence]...)
# Otherwise, read the Fermi energy from, say, scf.out:
ε_F = 2.7317

# Though we can use the number of plotted bands to control the size of the diagram,
# hard cutoff is needed to avoid displaying a too dispersive band 
# and to show the vertical lines corresponding to 
# high symmetry points
ε_min = -1
ε_max = 1 

kpoint_labels =  [L"-X", L"\Gamma", L"X"]
kpoint_numbers = [60,    60]

# Indices of bands to be shown;
# To be decided by looking at what bands are near the Fermi surface 
# in the output file
band_index_range = 110 : 130

#endregion

#region Reading band data 

nkp, nbnd = read_qe_bands_x_size(band_dat_path)
ε_kn = read_qe_bands_x_energy(band_dat_gnu_path, nkp, nbnd)
ε_kn .-= ε_F

Sz_kn = read_qe_bands_x_spin(spin_dat_path, nkp, nbnd)

#endregion

#region Preparing the axis of the diagram

# Convert colors in Colors.jl into RGB format 
color_to_tuple(c::RGB) = (
    c.r * 255 |> Int,
    c.g * 255 |> Int,
    c.b * 255 |> Int
)

kpoint_positions = let 
    kpoint_positions = zeros(size(kpoint_labels))
    current_pos = 1
    kpoint_positions[1] = 1

    for i in eachindex(kpoint_numbers)
        current_pos += kpoint_numbers[i]
        kpoint_positions[i + 1] = current_pos
    end
    
    kpoint_positions
end

min_Sz = min(Sz_kn...)
max_Sz = max(Sz_kn...)
# Convert spin value to color
Sz_to_color(sz) = spin_colors[Int(round((sz - min_Sz) / (max_Sz - min_Sz) * (length(spin_colors) - 1))) + 1]

band_axis = @pgf Axis({
    # Set the color bar
    colormap = "{}{$(join(map(c -> "rgb255=$(color_to_tuple(c))", spin_colors), ", "))}",
    colorbar,
    colorbar_style = {
        ytick= [1, 120], # TODO: where does this 120 come from?? Possibly it's just length(kpoint_numbers),
        # because the color bar maps x coordinate to color
        yticklabels= [min_Sz, max_Sz],
    },
    ylabel = L"$\xi_{\mathbf{k}}$ / eV",
    xmin = 1,
    xmax = nkp,
    ymin = ε_min,
    ymax = ε_max,
    fill = colorant"white", 
    fill_opacity = 0.8, 
    draw_opacity = 1,
    text_opacity = 1,
    legend_style = "draw=none",
    xtick = kpoint_positions,
    xticklabels = kpoint_labels,
})

for kpt_idx in eachindex(kpoint_positions)
    vertical_line = @pgf Plot(
        {
            color = colorant"grey",
            no_marks,
            forget_plot
        },
        Coordinates(
            [kpoint_positions[kpt_idx], kpoint_positions[kpt_idx]], 
            [ε_min, ε_max]
        )
    )
    push!(band_axis, vertical_line)
end

#endregion 

#region Plot the band

k = 1 : nkp 

map(band_index_range) do n
    spin_z_at_n = Sz_kn[:, n]
    band_spin_colors = map(Sz_to_color, spin_z_at_n)

    curve = @pgf Plot(
        {
            thick,
            #color = band_colors,
            no_marks,
            forget_plot,
            point_meta = "x", # Ensure that the color map is applied from teh left to the right 
            mesh,
            colormap = "{}{$(join(map(c -> "rgb255=$(color_to_tuple(c))", band_spin_colors), ", "))}"
        },
        Coordinates(k, ε_kn[:, n])
    )

    push!(band_axis, curve)
end

#endregion

#region Plot the Fermi surface 

push!(band_axis, @pgf Plot(
    {
        color = colorant"grey",
        no_marks,
        forget_plot
    },
    Coordinates(
        [1, nkp], 
        [0, 0]
    ) 
))

#endregion

pgfsave(output_file, band_axis)

