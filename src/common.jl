@doc "All the abstract domains" ->
all_domains() = Set(Interval,AbstractBool,HyperBox)

@doc "Return a type Union of all the abstract domains which can abstract a type T" ->
abstractdomains(CT::DataType) = Union(filter(AT->isabstract(CT,AT),all_domains())...)

## Random Number Generation
## =========================
@doc "Random number between `a` and `b`" ->
rand_interval(a::Float64, b::Float64) = a + (b - a) * rand()

## Copy/paste from StatsBase to avoid importing
# Internal facilities for fast random number generation
immutable RandIntSampler  # for generating Int samples in [0, K-1]
    a::Int
    Ku::UInt
    U::UInt

    @compat RandIntSampler(K::Int) = (Ku = UInt(K); new(1, Ku, div(typemax(UInt), Ku) * Ku))
    @compat RandIntSampler(a::Int, b::Int) = (Ku = UInt(b-a+1); new(a, Ku, div(typemax(UInt), Ku) * Ku))
end

# algo http://stackoverflow.com/questions/2509679/how-to-generate-a-random-number-from-within-a-range/6852396#6852396
function rand(s::RandIntSampler)
    x = rand(UInt)
    while x >= s.U
  x = rand(UInt)
    end
    @compat s.a + Int(rem(x, s.Ku))
end

randi(K::Int) = rand(RandIntSampler(K))
randi(a::Int, b::Int) = rand(RandIntSampler(a, b))