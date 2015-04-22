module AbstractDomains

import Base: convert, promote_rule
import Base: string, print, show, showcompact
import Base: abs, zero, one, in, inv, ndims, issubset, union, intersect

VERSION < v"0.4-" && using Docile

export Interval,
       AbstractBool,
       HyperBox,
       t,f,tf,
       ⊔, ⊓, subsumes, isintersect, intersect, isrelational,
       ndims,

       isrelational

include("common.jl")
include("domains.jl")

end
