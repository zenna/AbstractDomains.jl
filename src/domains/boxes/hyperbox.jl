HyperBox(a::Array{T,2}) where T = HyperBox{T}([Interval(a[1,i],a[2,i]) for i=1:size(a,2)])

## Access
## ======
getindex(b::HyperBox, i::Int) = b.intervals[i]
setindex!(b::HyperBox{T}, i::Int, v::Interval{T}) where T = b.intervals[i] = v
ndims(b::HyperBox) = length(b.intervals)
dims(b::HyperBox) = collect(1:ndims(b)) # make this iterable?
hasdim(b::HyperBox, i::Int) = i <= ndims(b)

## Splitting
## =========
mid(b::HyperBox{T}) where T = T[mid(b[dim]) for dim in dims(b)]

"""
    split_box(b::HyperBox{T}, split_point::Vector{T}) where T

Split box into 2^d equally sized boxes by cutting down middle of each axis.
"""
function split_box(b::HyperBox{T}, split_point::Vector{T}) where T
  @assert(length(split_point) == ndims(b))
  splits = [split_box(b[i],split_point[i]) for i = 1:ndims(b)] # Split intervals
  intervals_set = prodsubboxes(splits)
  HyperBox[HyperBox([intervals...]) for intervals in intervals_set]
end

"""
    partial_split_box(b::HyperBox{T}, split_point::Dict{Int, T}) where T

Split a box along not all dimensions. `split_point` maps integer dimensions to point in that dimension to split.
"""
function partial_split_box(b::HyperBox{T}, split_point::Dict{Int, T}) where T
  @assert(length(keys(split_point)) <= ndims(b))
  intervals_set = product_boxes(b, split_point)
  HyperBox[HyperBox([intervals...]) for intervals in intervals_set]
end

## Print
## =====
string(b::HyperBox) = b.intervals
print(io::IO, b::HyperBox) = print(io, string(b))
show(io::IO, b::HyperBox) = print(io, string(b))
showcompact(io::IO, b::HyperBox) = print(io, string(b))
