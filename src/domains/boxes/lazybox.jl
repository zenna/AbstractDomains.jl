@doc "Gets nth dim of box, creates it as unit-interval if it doesn't exist" ->
function getindex{D}(o::LazyBox{D}, key::Int)
  if haskey(o.intervals,key)
    o.intervals[key]
  else
    i = unit(Interval{D})
    o.intervals[key] = i
    i
  end
end

setindex!{T}(b::LazyBox{T}, val::Interval{T}, key::Int) = o.intervals[key] = val
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

# ## Split
# ## =====
function split_box{T}(b::LazyBox{T}, split_point::Dict{Int,T})
  ks = collect(keys(o.intervals))
  intervals_set = partial_split_box(b,split_point)

  # For each HyperBox in resulting split, convert to set of Intervals
  # Then recreate Omega using keys from parent.
  @compat [LazyBox(Dict(zip(ks,intervals))) for intervals in intervals_set]
end

# ## Sampling
# ## ========
# function rand(o::LazyBox)
#   s = Dict{Int64,Float64}()
#   for interval in o.intervals
#     s[interval[1]] = rand_interval(interval[2].l,interval[2].u)
#   end
#   SampleOmega(s)
# end

# ## Sample Omega
# ## ============
# immutable SampleOmega
#   samples::Dict{Int64,Float64}
# end
# SampleOmega() = SampleOmega(Dict{Int64,Float64}())

# function getindex(o::SampleOmega, key::Int64)
#   if haskey(o.samples,key)
#     o.samples[key]
#   else
#     i = rand()
#     o.samples[key] = i
#     i
#   end
# end
