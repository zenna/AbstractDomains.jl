@doc """
  An axis aligned hyperbox - a set of intervals 
  """ ->
type HyperBox{T} <: Domain{T}
  intervals::Array{T,2}
end

## Domain operations
## =================
ndims(b::HyperBox) = size(b.intervals,2)
isequal(x::HyperBox,y::HyperBox) = domaineq(x,y)
isrelational(::Type{HyperBox}) = false

# function ⊔(x::HyperBox, y::HyperBox) 
#   # Need this mess to take into account x and y may have different ndim
#   local dims; local smaller; local bigger
#   if ndims(x) > ndims(y)
#     smaller = y
#     bigger = x
#     dims = ndims(x)
#   else
#     smaller = x
#     bigger = y
#     dims = ndims(y)
#   end
#   joined = Array(Float64, 2, ndims)
#   for i = 1:dims
#     joined[i,1],joined[i,1] = 

#   HyperBox([])

## Splitting
## =========
mid{T<:Real}(i::Vector{T}) = i[1] + (i[2] - i[1]) / 2
mid(b::HyperBox) = Float64[mid(b.intervals[:,i]) for i = 1:ndims(b)]

@doc "Splits a box at a split-point along all its dimensions into n^d boxes" ->
function findproduct(splits::Vector{Vector{Vector{Float64}}}, b::HyperBox)
  boxes = HyperBox[]
  for subbox in product(splits...)
    z = Array(Float64,2,ndims(b))
    for i = 1:size(z,2)
      z[:,i] = subbox[i]
    end
    push!(boxes, HyperBox(z))
  end
  return boxes
end

function split_box(b::HyperBox, split_points::Vector{Float64})
  @assert(length(split_points) == ndims(b))
  boxes = HyperBox[]
  splits = [split_box(b.intervals[:, i],split_points[i]) for i = 1:ndims(b)]
  findproduct(splits, b)
end

# A partial split does not split along all dimensions
function partial_split_box(b::HyperBox, split_points::Dict{Int, Float64})
  @assert(length(keys(split_points)) <= ndims(b))

  boxes = HyperBox[]
  splits = Vector{Vector{Float64}}[]
  for i = 1:ndims(b)
    if haskey(split_points, i)
      push!(splits, split_box(b.intervals[:, i],split_points[i]))
    else # Don't split along this dimension
      push!(splits, Vector[b.intervals[:, i]])
    end
  end
  findproduct(splits, b)
end

@doc "Split box into 2^d equally sized boxes by cutting down middle of each axis" ->
mid_split(b::HyperBox) = split_box(b, mid(b))

@doc "Do a partial split at the midpoints of dimensions `dims`" ->
mid_partial_split(b::HyperBox, dims::Vector{Int}) =
  partial_split_box(b,[i => mid(b.intervals[:,i]) for i in dims])

## Sampling
## ========
rand(b::HyperBox) = [rand_interval(b.intervals[:,i]...) for i = 1:ndims(b)]
