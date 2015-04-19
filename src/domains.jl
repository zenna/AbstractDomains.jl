# Abstract domains represent sets of finite values
abstract Domain{T}

for finame in ["bool.jl",
               "hyperbox.jl",
               "interval.jl",
               "simpledisjunctive.jl"]
    include(joinpath("domains", finame))
end
