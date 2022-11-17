using PGFPlotsX
using Colors
using LaTeXStrings

ms = LinRange(-1, 1, 500)
H(α) = 1 / (1 - α) * log2.(( (1 .- ms) / 2).^α + ((1 .+ ms) / 2).^α)

plot_axis = @pgf Axis({
    xlabel = L"$m = \langle X \rangle$",
    ylabel = L"$H_\alpha(X)$",
    xmin = -1, 
    xmax = 1,
    ymin = 0,
    ymax = 1.2,
    fill = colorant"white", 
    fill_opacity = 0.8, 
    draw_opacity = 1,
    text_opacity = 1,
    legend_style = {
        draw = "none"
    }
})

αs = [0, 0.5, 1.001, 2, 3]
α_labels = [L"0", L"0.5", L"1^+", L"2", L"3"]
α_colors = range(colorant"paleturquoise1", stop = colorant"steelblue3", length = length(α_labels) + 1)

for i in eachindex(αs)
    push!(plot_axis, @pgf Plot(
        {
            color = α_colors[i],
            no_marks,
        },
        Coordinates(ms, H(αs[i]))
    ))

    push!(plot_axis, LegendEntry(α_labels[i]))
end

H_∞ = - log2.(map(ms) do m
    max((1 - m) / 2, (1 + m) / 2)    
end) 

push!(plot_axis, @pgf Plot(
    {
        color = α_colors[end],
        no_marks,
    },
    Coordinates(ms, H_∞)
))
push!(plot_axis, LegendEntry(L"\infty"))

pgfsave("./plots/ising-entroy-alpha.pdf", plot_axis)