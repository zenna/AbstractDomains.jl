@doc "Random number between `a` and `b`" ->
rand_interval(a::Float64, b::Float64) = a + (b - a) * rand()
