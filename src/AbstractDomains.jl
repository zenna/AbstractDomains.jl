module AbstractDomains

import Base: convert, promote_rule
import Base: string, print, show, showcompact, rand
import Base: abs, zero, one, in, inv, ndims, issubset, union, intersect, isequal
import StatsBase: randi

using Iterators
VERSION < v"0.4-" && using Docile

export Interval,
       AbstractBool,
       HyperBox,
       t,f,tf,
       ⊔, ⊓, subsumes, isintersect, intersect, isrelational,
       ndims,
       getindex,
       mid, mid_split,

       isrelational

include("common.jl")
include("domains.jl")

end
