using LsqFit
using PGFPlotsX
using LaTeXStrings
using Colors

T_data = [310, 321, 339, 360, 383, 405, 434]
R_data = [13.5, 9.1, 4.95, 2.41, 1.22, 0.74, 0.37]

plot_axis = @pgf Axis({
    xlabel = L"$T$ / K",
    ylabel = L"$R$ / $\Omega$",
    fill = colorant"white", 
    fill_opacity = 0.8, 
    draw_opacity = 1,
    text_opacity = 1,
    legend_style = {
        draw = "none"
    }
})

push!(plot_axis, @pgf Plot(
    {
        "only marks",
        color = colorant"steelblue",
    },
    Coordinates(T_data, R_data)
))

@. T_to_R(T, p) = p[1] * T^(- 3/2) * exp(p[2] / T)

fit = curve_fit(T_to_R, T_data, R_data, [1.0, 1.0])
Ts = LinRange(300, 440, 100)
Rs = T_to_R(Ts, fit.param) 

push!(plot_axis, @pgf Plot(
    {
        "no marks",
        color = colorant"blue",
    },
    Coordinates(Ts, Rs)
))

pgfsave("./plots/resistance-fitting-2.pdf", plot_axis)