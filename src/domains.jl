# Abstract domains represent sets of finite values
abstract Domain{T}

for finame in ["bool.jl",
               "interval.jl",]
    include(joinpath("domains", finame))
end
