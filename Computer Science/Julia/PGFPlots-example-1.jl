using PGFPlots
x = [1,2,3]
y = [2,4,1]
p = Axis(Plots.Linear(x, y))

working_path = "D:\\Notes\\Computer Science\\Julia\\"
save(working_path * "three-points-simplest-plot.tex", p)
save(working_path * "three-points-simplest-plot-from-julia.pdf", p)