@doc """
  An axis aligned hyperbox - a set of intervals
  """ ->
type HyperBox{T} <: Domain{T}
  intervals::Vector{Interval{T}}
end

@doc doc"""A LazyBox is a hyperbox whose dimensions can be
  created dynamically and do not have to be contiguous""" ->
immutable LazyBox{T} <: Domain{T}
  intervals::Dict{Int64,Interval{T}}
end

@doc "Boxes are abstractions of Vector{T<:Real}" ->
typealias Boxes{T} Union(LazyBox{T},HyperBox{T})

## Domain Operations
## =================
isrelational{T<:Boxes}(::Type{T}) = false
domaineq(x::Boxes,y::Boxes) = isequal(x,y)
function isequal(x::Boxes,y::Boxes)
  for dim in union(dims(x),dims(y))
    if !(hasdim(x,dim) && hasdim(y,dim) && isequal(x[dim],y[dim]))
      return false
    end
  end
  true
end

## Box Domain General functions
## ============================
function product_boxes{T}(b::Boxes, split_point::Dict{Int, T})
  @assert(length(keys(split_point)) <= ndims(b))

  splits = Vector{Interval{T}}[]
  for dim in dims(b)
    if haskey(split_point, dim)
      push!(splits, split_box(b[dim],split_point[dim]))
    else # Don't split along this dimension
      push!(splits, [b[dim]])
    end
  end
  prodsubboxes(splits)
end

# Find cartesian product of a bunch of subboxes (vector of intervals)
function prodsubboxes{T}(splits::Vector{Vector{Interval{T}}})
  @compat boxes = Tuple{Vararg{Interval}}[]
  for subbox in product(splits...)
    push!(boxes, subbox) # product returns tuple
  end
  return boxes
end

mid{T}(b::Boxes{T}) = T[mid(b[dim]) for dim in dims(b)]

@doc "Split box into 2^d equally sized boxes by cutting down middle of each axis" ->
mid_split(b::Boxes) = split_box(b, mid(b))

@doc "Do a partial split at the midpoints of dimensions `dims`" ->
mid_partial_split(b::Boxes, partial_dims::Vector{Int}) =
  @compat partial_split_box(b,Dict([dim => mid(b[dim]) for dim in partial_dims]))

## Sampling
## ========
rand(b::Boxes) = [rand(b[dim]) for dim in dims(b)]

include("boxes/hyperbox.jl")
include("boxes/lazybox.jl")
