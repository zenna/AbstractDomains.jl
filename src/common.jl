"""
    all_domains()

All the abstract domains.
"""
all_domains() = Set(Interval,AbstractBool,HyperBox)

"""
    abstractdomains(CT::DataType)

Return a type Union of all the abstract domains which can abstract a type T.
"""
abstractdomains(CT::DataType) = Union{filter(AT->isabstract(CT,AT),all_domains())...}

## Random Number Generation
## =========================
"""
    rand_interval(a::Float64, b::Float64)

Random number between `a` and `b`.
"""
rand_interval(a::Float64, b::Float64) = a + (b - a) * rand()
