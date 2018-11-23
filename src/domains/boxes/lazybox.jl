LazyBox(T2::Type{T}) where {T<:Real} = LazyBox{T2}(Dict())

"""
    getindex(o::LazyBox{D}, key::Int) where D

Gets nth dim of box, creates it as unit-interval if it doesn't exist
"""
function getindex(o::LazyBox{D}, key::Int) where D
  if haskey(o.intervals,key)
    o.intervals[key]
  else
    o.intervals[key] = unit(Interval{D})
  end
end

setindex!(b::LazyBox{T}, val::Interval{T}, key::Int) where T = b.intervals[key] = val
ndims(b::LazyBox) = length(keys(b.intervals))
dims(b::LazyBox) = keys(b.intervals)
hasdim(b::LazyBox, i::Int) = haskey(b.intervals,i)

## Conversion
## ==========
convert(::Type{Vector{Interval{T}}}, b::LazyBox{T}) where T = collect(values(b.intervals))
convert(::Type{Vector{Interval}}, b::LazyBox{T}) where T = collect(values(b.intervals))
convert(::Type{Vector{Interval{T}}}, b::LazyBox{T}, dims::Vector) where T = Interval{T}[b[d] for d in dims]
convert(::Type{Vector{Interval}}, b::LazyBox{T}, dims::Vector) where T = Interval{T}[b[d] for d in dims]
convert(::Type{HyperBox}, l::LazyBox) = HyperBox(convert(Vector{Interval},l))

# ## Splitting
# ## =========
mid(b::LazyBox{T}) where T =
  Dict(dim => mid(interval) for (dim,interval) in b.intervals)

function split_box(b::LazyBox{T}, split_point::Dict{Int,T}) where T
  ks = collect(keys(b.intervals))
  intervals_set = product_boxes(b,split_point)
  [LazyBox(Dict{Int,Interval{T}}(zip(ks,intervals))) for intervals in intervals_set]
end

partial_split_box(b::LazyBox{T}, split_point::Dict{Int,T}) where T =
  split_box(b,split_point)

## Rand
"""
    struct LazyRandomVector{T<:Real}

A Vector of whose values are sampled uniformly from [0,1], but are not created until accessed (hence Lazy).
"""
struct LazyRandomVector{T<:Real}
  samples::Dict{Int64,T}
end
LazyRandomVector(T1::Type{T}) where {T<:Real} = LazyRandomVector(Dict{Int64,T1}())

function getindex(o::LazyRandomVector{T}, key::Int) where T
  if haskey(o.samples,key)
    o.samples[key]
  else
    i = rand(T)
    o.samples[key] = i
    i
  end
end

function setindex!(o::LazyRandomVector{T}, val::T, key::Int) where T
  o.samples[key] = val
end

function rand(b::LazyBox{T}) where T <: Real
  l = LazyRandomVector(T)
  for (dim,interval) in b.intervals
    l[dim] = rand(interval)
  end
  l
end

## Print
## =====
string(b::LazyBox) = b.intervals
print(io::IO, b::LazyBox) = print(io, string(b))
show(io::IO, b::LazyBox) = print(io, string(b))
showcompact(io::IO, b::LazyBox) = print(io, string(b))
