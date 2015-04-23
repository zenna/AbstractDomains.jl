# AbstractDomains

## Exported
---

### isintersect
Is the intersection of two domains non-empty

*source:*
[AbstractDomains/src/domains.jl:14](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains.jl)

---

### isrelational
Can an abstract domain represent relationships between variables?

*source:*
[AbstractDomains/src/domains.jl:12](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains.jl)

---

### subsumes
Is domain `y` a subset of domain `x`

*source:*
[AbstractDomains/src/domains.jl:13](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains.jl)

---

### intersect{T}(x::Interval{T}, y::Interval{T})
Construct interval which is intersection of two intervals

*source:*
[AbstractDomains/src/domains/interval.jl:48](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/interval.jl)

---

### HyperBox{T}
An axis aligned hyperbox - a set of intervals 


*source:*
[AbstractDomains/src/domains/hyperbox.jl:3](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/hyperbox.jl)

---

### Interval{T<:Real}
An Interval of type 'T' between 'a' and 'b' represents all the values
  of type 'T' between 'a' and 'b'.


*source:*
[AbstractDomains/src/domains/interval.jl:3](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/interval.jl)

## Internal
---

### domaineq
Does domain `x` and domain `y` represent the same set of points

*source:*
[AbstractDomains/src/domains.jl:15](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains.jl)

---

### findproduct(splits::Array{Array{Array{Float64, 1}, 1}, 1}, b::HyperBox{T})
Splits a box at a split-point along all its dimensions into n^d boxes

*source:*
[AbstractDomains/src/domains/hyperbox.jl:37](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/hyperbox.jl)

---

### mid_partial_split(b::HyperBox{T}, dims::Array{Int64, 1})
Do a partial split at the midpoints of dimensions `dims`

*source:*
[AbstractDomains/src/domains/hyperbox.jl:76](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/hyperbox.jl)

---

### mid_split(b::HyperBox{T})
Split box into 2^d equally sized boxes by cutting down middle of each axis

*source:*
[AbstractDomains/src/domains/hyperbox.jl:73](file:///home/zenna/.julia/v0.3/AbstractDomains/src/domains/hyperbox.jl)

---

### rand_interval(a::Float64, b::Float64)
Random number between `a` and `b`

*source:*
[AbstractDomains/src/common.jl:1](file:///home/zenna/.julia/v0.3/AbstractDomains/src/common.jl)

