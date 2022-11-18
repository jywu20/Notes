using CurveFit
using PGFPlotsX
using Colors

T = [310, 321, 339, 360, 383, 405, 434]
R = [13.5, 9.1, 4.95, 2.41, 1.22, 0.74, 0.37]

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
    Coordinates(T, R)
))

(C, k) = exp_fit(1 ./ T, R)
Ts = LinRange(300, 440, 100)
Rs = C * exp.(k ./ Ts)

push!(plot_axis, @pgf Plot(
    {
        "no marks",
        color = colorant"blue",
    },
    Coordinates(Ts, Rs)
))

pgfsave("./plots/resistance-fitting-1.pdf", plot_axis)