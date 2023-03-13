using Plots
include("eqp.jl")

"""
Check whether the band structure given by `path`
is indeed insulating.
The current version only checks the supposed highest valence band 
the the lowest conduction band.
It's also expected that the data in the `eqp` file given by `path`
comes from a complete irreducible Brillouin zone, 
so electron filling can be done on top of that.
"""
function check_insulator_2D(path::AbstractString, n_val::Integer, mode::Symbol)
    k_points = read_bgw_eqp_kpoints(path)
    band_data = read_bgw_eqp(path)
    
    nkp = size(k_points)[2]
    
    if mode == :gw
        band_data = band_data[:, :, 2]
    elseif mode == :dft 
        band_data = band_data[:, :, 1]
    else
        error("The mode has to be :dft or :gw.")
    end
    
    val_band  = band_data[n_val, :]
    cond_band = band_data[n_val + 1, :]
    
    #region Electron filling
    
    band_to_be_filled = vcat(val_band, cond_band)
    sort_perm_indices = sortperm(band_to_be_filled)
    filled_state_indices = sort_perm_indices[1 : nkp]
    empty_state_indices = sort_perm_indices[nkp + 1 : end]
    unexpected_filled_state_indices = filter(x -> x > nkp, filled_state_indices) .- nkp
    unexpected_empty_state_indices = filter(x -> x <= nkp, empty_state_indices)
    
    #endregion
    
    #region Plotting 
    
    p = plot(legend = false, framestyle = :box, aspect_ratio = :equal)
    xlims!(p, (-0.6, 0.6))
    ylims!(p, (-0.6, 0.6))
    
    for n_k in 1 : nkp
        k_x, k_y = k_points[1:2, n_k]
        
        # Hole Fermi pocket identified
        if n_k in unexpected_empty_state_indices
            scatter!(p, [k_x], [k_y], color = "red", markerstrokewidth = 0)
            continue
        end
        
        # Electron Fermi pocket identified
        if n_k in unexpected_filled_state_indices
            scatter!(p, [k_x], [k_y], color = "blue", markerstrokewidth = 0)
            continue
        end
        
        scatter!(p, [k_x], [k_y], color = "grey", markerstrokewidth = 0)
    end
    
    #endregion
    
    val_band, cond_band, unexpected_empty_state_indices, unexpected_filled_state_indices, p
end