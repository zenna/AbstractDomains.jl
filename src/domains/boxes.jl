"""
    struct HyperBox{T} <: Domain{T}

An axis aligned hyperbox - a set of intervals.
"""
struct HyperBox{T} <: Domain{T}
  intervals::Vector{Interval{T}}
end

"""
    struct LazyBox{T} <: Domain{T}

A LazyBox is a hyperbox whose dimensions can be
created dynamically and do not have to be contiguous
"""
struct LazyBox{T} <: Domain{T}
  intervals::Dict{Int64,Interval{T}}
end

"""
    Boxes{T}

Boxes are abstractions of Vector{T<:Real}
"""
const Boxes{T} = Union{LazyBox{T},HyperBox{T}}

## Domain Operations
## =================
isrelational(::Type{T}) where {T<:Boxes} = false
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
function product_boxes(b::Boxes, split_point::Dict{Int, T}) where T
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
function prodsubboxes(splits::Vector{Vector{Interval{T}}}) where T
  boxes = Tuple{Vararg{Interval}}[]
  for subbox in Iterators.product(splits...)
    push!(boxes, subbox) # product returns tuple
  end
  return boxes
end

mid(b::Boxes{T}) where T = T[mid(b[dim]) for dim in dims(b)]

"""
    mid_split(b::Boxes)
Split box into 2^d equally sized boxes by cutting down middle of each axis
"""
mid_split(b::Boxes) = split_box(b, mid(b))


"""
    mid_partial_split(b::Boxes, partial_dims::Vector{Int})

Do a partial split at the midpoints of dimensions `dims`
"""
mid_partial_split(b::Boxes, partial_dims::Vector{Int}) =
    partial_split_box(b,Dict(dim => mid(b[dim]) for dim in partial_dims))

## Sampling
## ========
rand(b::Boxes) = [rand(b[dim]) for dim in dims(b)]

include("boxes/hyperbox.jl")
include("boxes/lazybox.jl")
