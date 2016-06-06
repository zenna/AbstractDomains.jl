@doc "All the abstract domains" ->
all_domains() = Set(Interval,AbstractBool,HyperBox)

@doc "Return a type Union of all the abstract domains which can abstract a type T" ->
abstractdomains(CT::DataType) = Union{filter(AT->isabstract(CT,AT),all_domains())...}

## Random Number Generation
## =========================
@doc "Random number between `a` and `b`" ->
rand_interval(a::Float64, b::Float64) = a + (b - a) * rand()
