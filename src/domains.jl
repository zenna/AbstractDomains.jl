# Abstract domains represent sets of finite values
abstract Domain{T}

for finame in ["bool.jl",
               "interval.jl",
               "hyperbox.jl"]
    include(joinpath("domains", finame))
end

## Domain General Doc
## ==================
@doc doc"Can an abstract domain represent relationships between variables?" -> isrelational
@doc doc"Is domain `y` a subset of domain `x`" -> subsumes
@doc doc"Is the intersection of two domains non-empty"  -> isintersect
@doc doc"Does domain `x` and domain `y` represent the same set of points" -> domaineq