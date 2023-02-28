using Plots
include("eqp.jl")
include("2D-insulating.jl")

cd("../../examples/WTe2-monolayer/2-sigma/")

path = "eqp1.dat"
n_val = 20
mode = :gw

val_band, cond_band, unexpected_empty_state_indices, unexpected_filled_state_indices, p = 
    check_insulator_2D(path, n_val, mode)
    
savefig(p, "insulating-check-grid.pdf")

E_max = max(val_band...)
E_min = min(cond_band...)
println(E_min - E_max)