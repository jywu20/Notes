using LinearAlgebra
using Plots
using Statistics
using ProgressMeter
using LaTeXStrings

##

# Whether to show a progress bar when calculating
show_progress = true

C = [0 1; 0 0]
σˣ = C + C'
σʸ = (C - C') / im
σᶻ = - C' * C + C * C'
σ⁰ = C' * C + C * C'

Pee = (σ⁰ - σᶻ) / 2
Pgg = σ⁰ - Pee

Γ = 2π * 1.0
H_damping = - im * Γ * C' * C / 2

t_max = 1.0
Δt = 0.001
t = 0.0 : Δt : t_max 

n_traj = 1000
n_t = length(t)
n_x = zeros(n_t, n_traj)
n_y = zeros(n_t, n_traj)
n_z = zeros(n_t, n_traj)

# Note that both of Ω and Δ can be time dependent
Ω = ones(n_t) * 2π * 0.0
Δ = ones(n_t) * 2π * 5.0

ψ_init = [1.0, 1.0] / sqrt(2)

progress = Progress(n_traj)

for i_traj in 1 : n_traj
    ψ = ψ_init   
    
    for i in 1 : n_t

        Ω_t = Ω[i]
        Δ_t = Δ[i]

        n_x[i, i_traj] = ψ' * σˣ * ψ
        n_y[i, i_traj] = ψ' * σʸ * ψ
        n_z[i, i_traj] = ψ' * σᶻ * ψ

        H_eff = H_damping + Ω_t * σˣ / 2 + Δ_t * σᶻ / 2 
        ψ = exp(- im * Δt * H_eff) * ψ
        P_jump = abs(1 - ψ' * ψ)
        ψ = ψ / sqrt(abs(ψ' * ψ))

        if rand() < P_jump
            ψ = C * ψ
            ψ = ψ / sqrt(abs(ψ' * ψ))
        end
    end

    if show_progress
        next!(progress)
    end
end

n_x_mean = mean(n_x, dims = 2)[:, 1]
n_y_mean = mean(n_y, dims = 2)[:, 1]
n_z_mean = mean(n_z, dims = 2)[:, 1]

n_x_single = n_x[:, 1]
n_y_single = n_y[:, 1]
n_z_single = n_z[:, 1]

##
# Bloch sphere 

p = plot3d(n_x_mean, n_y_mean, n_z_mean, 
    xlims = (-1.0, 1.0), ylims = (-1.0, 1.0), zlims = (-1.0, 1.0), label = "averaged", 
    xlabel = L"\sigma_x", ylabel = L"\sigma_y", zlabel = L"\sigma_z", dpi = 500)
plot3d!(p, n_x_single, n_y_single, n_z_single, label = "single")
scatter3d!(p, [0.0], [0.0], [0.0], color = "red", label = false)

# Be cautious, do not overwrite previous figures
output_fig = false

working_path = "D:/Notes/Physics-new/quantum-optics-homework/4/"
fig_name = "start-z.png"

if output_fig
    savefig(p, working_path * fig_name)    
end

p

##
# Occupation of the excited state

pee_single = 1 / 2 .- n_z_single / 2
pee_mean = 1 / 2 .- n_z_mean / 2

p = plot(t, pee_single, label = "single", dpi = 500)
plot!(p, t, pee_mean, label = "mean")

title!(p, L"\Omega = 0, \ \ \Gamma = 2 \pi, \ \ \Delta = 10 \pi , \ \  | \psi(t=0) \rangle = (| \mathrm{g} \rangle + | \mathrm{e} \rangle) / \sqrt{2}")

# Be cautious, do not overwrite previous figures
output_fig = true

working_path = "D:/Notes/Physics-new/quantum-optics-homework/4/"
fig_name = "rwf-5.png"

if output_fig
    savefig(p, working_path * fig_name)    
end

p