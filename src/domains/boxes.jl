@doc """
  An axis aligned hyperbox - a set of intervals
  """ ->
type HyperBox{T}
  intervals::Vector{Interval{T}}
end

@doc doc"""A LazyBox is a hyperbox whose dimensions can be
  created dynamically and do not have to be contiguous""" ->
immutable LazyBox{T} <: Domain{T}
  intervals::Dict{Int64,Interval{T}}
end

typealias Boxes{T} Union(LazyBox{T},HyperBox{T})

include("boxes/hyperbox.jl")
include("boxes/lazybox.jl")