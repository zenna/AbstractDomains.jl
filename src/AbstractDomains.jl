module AbstractDomains

import Base: convert, promote_rule
import Base: string, print, show, showcompact, rand
import Base: abs, zero, one, in, inv, ndims, issubset, union, intersect, isequal, ifelse
import Base: ==, !=, !, |, &, <, >, >=, <=, +, -, *, /, //
import Base: getindex, setindex!

using Iterators
using Compat
VERSION < v"0.4-" && using Docile

export Interval,
       Domain,
       AbstractBool,
       Boxes, HyperBox,LazyBox,
       LazyRandomVector,
       t,f,tf,
       ⊔, ⊓, subsumes, isintersect, intersect, isrelational, domaineq,
       ndims,
       getindex,
       mid, mid_split, partial_split_box, mid_partial_split,
       unit,
       dims,
       hasdim,
       isrelational

include("common.jl")
include("domains.jl")

end
