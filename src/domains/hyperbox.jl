@doc """
  An axis aligned hyperbox - a set of intervals 
  """ ->
type HyperBox{T}
  intervals::Vector{Interval{T}}
end

HyperBox{T}(a::Array{T,2}) = HyperBox{T}([Interval(a[1,i],a[2,i]) for i=1:size(a,2)])

##
getindex(b::HyperBox, i::Int) = b.intervals[i]

## Domain operations
## =================
ndims(b::HyperBox) = length(b.intervals)
domaineq(x::HyperBox,y::HyperBox) = isequal(x,y)
isequal(x::HyperBox,y::HyperBox) = all([isequal(x[i],y[i]) for i = 1:ndims(x)]) 
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
mid{T}(b::HyperBox{T}) = T[mid(b[i]) for i = 1:ndims(b)]

# Find cartesian product of a bunch of subboxes
function prodsubboxes{T}(splits::Vector{Vector{Interval{T}}})
  boxes = HyperBox{T}[]
  for subbox in product(splits...)
    push!(boxes, HyperBox(Interval{T}[subbox...])) # product returns tuple
  end
  return boxes
end

@doc "Split box into 2^d equally sized boxes by cutting down middle of each axis" ->
function split_box(b::HyperBox, split_point::Vector{Float64})
  @assert(length(split_point) == ndims(b))
  splits = [split_box(b[i],split_point[i]) for i = 1:ndims(b)]
  prodsubboxes(splits)
end

@doc doc"""Split a box along not all dimensions.
  `split_point` maps integer dimensions to point in that dimension to split""" ->
function partial_split_box{T}(b::HyperBox{T}, split_point::Dict{Int, Float64})
  @assert(length(keys(split_point)) <= ndims(b))

  boxes = HyperBox[]
  splits = Vector{Interval{T}}[]
  for i = 1:ndims(b)
    if haskey(split_point, i)
      push!(splits, split_box(b[i],split_point[i]))
    else # Don't split along this dimension
      push!(splits, [b[i]])
    end
  end
  prodsubboxes(splits)
end

@doc "Split box into 2^d equally sized boxes by cutting down middle of each axis" ->
mid_split(b::HyperBox) = split_box(b, mid(b))

@doc "Do a partial split at the midpoints of dimensions `dims`" ->
mid_partial_split(b::HyperBox, dims::Vector{Int}) =
  @compat partial_split_box(b,Dict([i => mid(b[i]) for i in dims]))

## Sampling
## ========
rand(b::HyperBox) = [rand(b[i]) for i = 1:ndims(b)]

## Print
## =====
string(b::HyperBox) = b.intervals
print(io::IO, b::HyperBox) = print(io, string(b))
show(io::IO, b::HyperBox) = print(io, string(b))
showcompact(io::IO, b::HyperBox) = print(io, string(b))