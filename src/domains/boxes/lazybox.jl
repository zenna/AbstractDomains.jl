@compat LazyBox{T<:Real}(T2::Type{T}) = LazyBox{T2}(Dict())

@doc "Gets nth dim of box, creates it as unit-interval if it doesn't exist" ->
function getindex{D}(o::LazyBox{D}, key::Int)
  if haskey(o.intervals,key)
    o.intervals[key]
  else
    o.intervals[key] = unit(Interval{D})
  end
end

setindex!{T}(b::LazyBox{T}, val::Interval{T}, key::Int) = b.intervals[key] = val
ndims(b::LazyBox) = length(keys(b.intervals))
dims(b::LazyBox) = keys(b.intervals)
hasdim(b::LazyBox, i::Int) = haskey(b.intervals,i)

## Conversion
## ==========
convert{T}(::Type{Vector{Interval{T}}}, b::LazyBox{T}) = collect(values(b.intervals))
convert{T}(::Type{Vector{Interval}}, b::LazyBox{T}) = collect(values(b.intervals))
convert{T}(::Type{Vector{Interval{T}}}, b::LazyBox{T}, dims::Vector) = Interval{T}[b[d] for d in dims]
convert{T}(::Type{Vector{Interval}}, b::LazyBox{T}, dims::Vector) = Interval{T}[b[d] for d in dims]
convert(::Type{HyperBox}, l::LazyBox) = HyperBox(convert(Vector{Interval},l))

# ## Splitting
# ## =========
mid{T}(b::LazyBox{T}) = 
  Dict([dim => mid(interval) for (dim,interval) in b.intervals])

function split_box{T}(b::LazyBox{T}, split_point::Dict{Int,T})
  ks = collect(keys(b.intervals))
  intervals_set = product_boxes(b,split_point)
  @compat [LazyBox(Dict{Int,Interval{T}}(zip(ks,intervals))) for intervals in intervals_set]
end

partial_split_box{T}(b::LazyBox{T}, split_point::Dict{Int,T}) =
  split_box(b,split_point)

## Rand
@doc doc"""A Vector of whose values are sampled uniformly from [0,1], but are not
  created until accessed (hence Lazy).""" ->
immutable LazyRandomVector{T<:Real}
  samples::Dict{Int64,T}
end
LazyRandomVector{T<:Real}(T1::Type{T}) = LazyRandomVector(Dict{Int64,T1}())

function getindex{T}(o::LazyRandomVector{T}, key::Int)
  if haskey(o.samples,key)
    o.samples[key]
  else
    i = rand(T)
    o.samples[key] = i
    i
  end
end

function setindex!{T}(o::LazyRandomVector{T}, val::T, key::Int)
  o.samples[key] = val
end

function rand{T<:Real}(b::LazyBox{T})
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