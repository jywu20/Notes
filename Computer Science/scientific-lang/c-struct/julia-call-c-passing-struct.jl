first_element = @ccall "./c-function-accepting-struct-example.so".first((25, 30)::Tuple{Int, Int})::Int
println(first_element)
# So it seems (25, 30) is passed to the C function by value, 
# as the C function accepts it by value and 
# the above code works well.