@doc "Abstract domains represent sets of finite values
  They are paramaterise by T which determines the type of values it represents" ->
abstract Domain{T}

# # Does the abstract domain represent a single variable or a set of variables
# abstract VariateForm
# type Univariate    <: VariateForm end
# type Multivariate  <: VariateForm end

# # Is it disjunctive or not
# # Is it relational or not

# abstract ValueSupport
# type Discrete   <: ValueSupport end
# type Continuous <: ValueSupport end



for finame in ["bool.jl",
               "interval.jl",
               "boxes.jl"]
  include(joinpath("domains", finame))
end

## Domain General Doc
## ==================
@doc doc"Can an abstract domain represent relationships between variables?" -> isrelational
@doc doc"Is domain `y` a subset of domain `x`" -> subsumes
@doc doc"Is the intersection of two domains non-empty"  -> isintersect
@doc doc"Does domain `x` and domain `y` represent the same set of points" -> domaineq
@doc doc"Unit interval [0,1]" -> unit
@doc doc"Find midpoint of numerical domain " -> mid
