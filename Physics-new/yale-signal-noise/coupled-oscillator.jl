using QuantumOptics
using LaTeXStrings
using Plots 
using ProgressMeter

cutoff_dim = 50
a1_space = FockBasis(cutoff_dim)
a2_space = FockBasis(cutoff_dim)
whole_space = a1_space ⊗ a2_space

a1 = destroy(a1_space) ⊗ identityoperator(a2_space)
at1 = create(a1_space) ⊗ identityoperator(a2_space)
a2 = identityoperator(a1_space) ⊗ destroy(a2_space)
at2 = identityoperator(a1_space) ⊗ create(a2_space)

H1 = at1 * a1 + 1/2 * identityoperator(a1) 
H2 = at2 * a2 + 1/2 * identityoperator(a1)
Hint = - 1/2 * (at1 * a2 + at2 * a1)
H = H1 + H2 + Hint

ψ0 = fockstate(a1_space, 3) ⊗ fockstate(a2_space, 0)
t_points = LinRange(0, 10, 1000)
purities = zeros(length(t_points))
# Due to particle number conservation,
# there are at most three particles 
# in the a1 mode,
# and therefore, 
# the non-zero block of the effective density matrix of a2 
# is a 3×3 matrix. 
# The projectors of this subspace is given below.
# Note that the index is n_a1 + 1
a1_space_projectors = [
    projector(fockstate(a1_space, j - 1), fockstate(a1_space, i - 1)') for i in 1 : 4, j in 1 : 4]
dms = zeros(4, 4, length(t_points))

let 
    current_t_idx = 1

    progress = Progress(length(t_points))
    function retrieve_density_matrix(t, ψ)
        dm = ptrace(normalize(ψ), 2)
        purity = tr(dm^2)
        purities[current_t_idx] = purity
        @views dms[:, :, current_t_idx] = map(a1_space_projectors) do p
            tr(p * dm)
        end
        current_t_idx += 1
        next!(progress)
    end
    
    timeevolution.schroedinger(t_points, ψ0, H; fout = retrieve_density_matrix)
end

# Plotting all the data
p = let 
    p = plot(t_points, purities, label="purity")
    #plot!(p, t_points, dms[1, 1, :], label=L"\rho_{00}")
    #plot!(p, t_points, dms[2, 2, :], label=L"\rho_{11}")
    #plot!(p, t_points, dms[3, 3, :], label=L"\rho_{22}")
    plot!(p, t_points, dms[4, 4, :], label=L"\rho_{33}")
    
    # Markovian approximation
    damped_ρ_33(t) = exp(- 2π * (1/2)^2 * t)
    # This seems to work badly ... why?
    plot!(p, t_points, map(damped_ρ_33, t_points), label="Markovian approx.")
    p
end