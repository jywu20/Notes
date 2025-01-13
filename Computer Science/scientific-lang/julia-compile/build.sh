DEFAULT_PATH=$($(which julia) -e "unsafe_string(Base.JLOptions().image_file) |> println")
echo $DEFAULT_PATH
$(which julia) --startup-file=no --output-o mat_mut_naive.o -J$DEFAULT_PATH mat_mut_naive.jl