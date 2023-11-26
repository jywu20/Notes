using Plots
using LaTeXStrings

struct TwoLevelMasterEq{A <: AbstractVector{ComplexF64}, R <: AbstractRange{Float64}}
    Ω   :: Float64
    Δ   :: Float64
    Γ   :: Float64
    γ_⊥ :: Float64

    t_list :: R

    ρ_ee_t :: A 
    ρ_gg_t :: A 
    ρ_eg_t :: A 
end

function Base.step(eq::TwoLevelMasterEq)
    step(eq.t_list)
end

function Base.length(eq::TwoLevelMasterEq)
    length(eq.t_list)
end

function TwoLevelMasterEq(
    params::NamedTuple, time_steps::AbstractRange
)::TwoLevelMasterEq{Vector{ComplexF64}}

    Ω   = params.Ω
    Δ   = params.Δ
    Γ   = params.Γ
    γ_⊥ = params.γ_⊥

    num_t = length(time_steps)
    ρ_ee_t = zeros(ComplexF64, num_t)
    ρ_gg_t = zeros(ComplexF64, num_t)
    ρ_eg_t = zeros(ComplexF64, num_t)   

    TwoLevelMasterEq(
        Ω, Δ, Γ, γ_⊥,
        time_steps, 
        ρ_ee_t, ρ_gg_t, ρ_eg_t)
end

function run!(
    sys::TwoLevelMasterEq; 
    ρ_ee_0 = 0.0, ρ_gg_0 = 1.0, ρ_eg_0 = 0.0)
    
    Ω   = sys.Ω
    Δ   = sys.Δ
    Γ   = sys.Γ
    γ_⊥ = sys.γ_⊥

    Δt = step(sys.t_list)
    
    ρ_ee_t = sys.ρ_ee_t
    ρ_gg_t = sys.ρ_gg_t
    ρ_eg_t = sys.ρ_eg_t

    first_idx = firstindex(ρ_ee_t)
    last_idx = lastindex(ρ_ee_t)
    
    ρ_ee_t[first_idx] = ρ_ee_0
    ρ_gg_t[first_idx] = ρ_gg_0
    ρ_eg_t[first_idx] = ρ_eg_0

    for t_idx in first_idx + 1 : last_idx
        ρ_eg_last = ρ_eg_t[t_idx - 1]
        ρ_ee_last = ρ_ee_t[t_idx - 1]
        ρ_gg_last = ρ_gg_t[t_idx - 1]

        ρ_ee_t[t_idx] = ρ_ee_last + Δt * (- Ω * imag(ρ_eg_last) - Γ * ρ_ee_last)
        ρ_gg_t[t_idx] = ρ_gg_last + Δt * (  Ω * imag(ρ_eg_last) + Γ * ρ_ee_last)
        ρ_eg_t[t_idx] = ρ_eg_last + Δt * (
            - (γ_⊥ - im * Δ) * ρ_eg_last 
            + im * Ω / 2 * (ρ_ee_last - ρ_gg_last))
    end
end

####################################
##

Ω = 1.0 
Γ = 0.0 
γ_⊥ = 0.0
Δ = 0.0 
sys = TwoLevelMasterEq(
    (Ω = Ω, Δ = Δ, Γ = Γ, γ_⊥ = γ_⊥), 
    LinRange(0, 10, 1000)
)
run!(sys, ρ_ee_0 = 0, ρ_gg_0 = 1, ρ_eg_0 = 0)
let p = plot(legend = :topright)
    plot!(p, sys.t_list / π, real.(sys.ρ_ee_t), label = "e")
    plot!(p, sys.t_list / π, real.(sys.ρ_gg_t), label = "g")
    xlabel!(p, L"t / \pi")
end

##

let p = plot(legend = :topright)
    plot!(p, sys.t_list / π, real(sys.ρ_eg_t), label = "Re eg")
    plot!(p, sys.t_list / π, imag(sys.ρ_eg_t), label = "Im eg")
    xlabel!(p, L"t / \pi")
end

## 

let p = plot(legend = :topright)
    plot!(p, sys.t_list / π, imag(sys.ρ_ee_t), label = "Im ee")
    plot!(p, sys.t_list / π, imag(sys.ρ_gg_t), label = "Im gg")
    xlabel!(p, L"t / \pi")
end

