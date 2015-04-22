## Relational Disjunctive Domain A1 ∨ A2 ∨ A3 ∨ ... ∨ An
## =================================================================

# This is a simple non-relational domain of disjunctive domains (paramaterised by T)
immutable Relational{T} <: Domain{T}
  values::Set{T}
end

# This domain is relational, duh
isrelational(::Union(Relational, Type{Relational})) = true

## Set Operations
## ==============
issubset(x::SimpleDisjunctive, y::SimpleDisjunctive) = issubset(x.values, y.values)
isintersect(x::SimpleDisjunctive, y::SimpleDisjunctive) = intersect(x.values, y.values)
domaineq(x::SimpleDisjunctive, y::SimpleDisjunctive) = x.values == y.values
⊔{T}(x::SimpleDisjunctive{T},y::T) = push!(x.values, y)

# Apply f to every abstract element in disjunction
function setmap{T}(f::Function, s::Set{T})
  out = Set{T}()
  for x in s
    push!(out,f(x))
  end
  out
end
