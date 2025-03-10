# Auxliaries for band plotting with `PGFPlotsX` 
# TODO: if there is any

using PGFPlotsX
using LaTeXStrings
using Colors

color_to_tuple(c::RGB) = (
    c.r * 255 |> Int,
    c.g * 255 |> Int,
    c.b * 255 |> Int
)

"""
Create a PGFPlotsX band plot withoutcolormap on each band.
`nkp` is the number of k-points in the k-path. 
"""
function pgf_band_plot(nkp, kpoint_positions, 
    kpoint_labels, ε_min, ε_max; 
    background_fill = colorant"white",
    ylabel = L"$\xi_{\mathbf{k}}$ / eV",
    show_vertical_lines = true)

    band_axis = @pgf Axis({
        ylabel = ylabel,
        xmin = kpoint_positions[1],
        xmax = kpoint_positions[end],
        ymin = ε_min,
        ymax = ε_max,
        fill = colorant"white", 
        fill_opacity = 0.8, 
        draw_opacity = 1,
        text_opacity = 1,
        legend_style = "draw=none",
        xtick = kpoint_positions,
        xticklabels = kpoint_labels,
        "axis background/.style" = { fill = background_fill }
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
        if show_vertical_lines
            push!(band_axis, vertical_line)
        end
    end
    
    band_axis 
end

"""
Create a PGFPlotsX band plot with colormap on each band.
`nkp` is the number of k-points in the k-path. 
"""
function pgf_band_plot_colormap(nkp, kpoint_positions, 
    kpoint_labels, ε_min, ε_max, min_Sz, max_Sz, spin_colors; 
    background_fill = colorant"white")
    band_axis = @pgf Axis({
        # Set the color bar
        colormap = "{}{$(join(map(c -> "rgb255=$(color_to_tuple(c))", spin_colors), ", "))}",
        colorbar,
        colorbar_style = {
            ytick= [1, nkp], 
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
        "axis background/.style" = { fill = background_fill }
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
    
    band_axis 
end

function pgf_plot_band!(band_axis, ε_k; 
    color = colorant"grey", 
    k_path = 1 : length(ε_k), 
    legend = false,
    options = nothing)
    curve = @pgf Plot(
        {
            thick,
            color = color,
            no_marks,
            point_meta = "x", # Ensure that the color map is applied from teh left to the right 
        },
        Coordinates(k_path, ε_k)
    )
    
    if !legend
        curve["forget plot"] = nothing
    end
    
    if options !== nothing
        merge!(curve, options)
    end

    push!(band_axis, curve)
end

function pgf_plot_band_with_color!(band_axis, ε_k, band_spin_colors)
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
        Coordinates(1 : length(ε_k), ε_k)
    )

    push!(band_axis, curve)
end

function linear_colormap(spin_colors, spin_z_at_n, min_Sz, max_Sz)
    Sz_to_color(sz) = spin_colors[Int(round((sz - min_Sz) / (max_Sz - min_Sz) * (length(spin_colors) - 1))) + 1]
    map(Sz_to_color, spin_z_at_n)
end

function zero_energy_line!(band_axis, nkp::Integer)
    push!(band_axis, @pgf Plot(
        {
            color = colorant"grey",
            no_marks,
            dotted,
            forget_plot
        },
        Coordinates(
            [1, nkp], 
            [0, 0]
        ) 
    ))
end

function zero_energy_line!(band_axis, path::AbstractArray)
    push!(band_axis, @pgf Plot(
        {
            color = colorant"grey",
            no_marks,
            dotted,
            forget_plot
        },
        Coordinates(
            [path[firstindex(path)], path[lastindex(path)]], 
            [0, 0]
        ) 
    ))
end