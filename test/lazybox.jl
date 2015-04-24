using Base.Test
X = Interval(0,1)
@compat ll = LazyBox(Dict(1=>Interval(0,1)))
ll[3]
@test domaineq(ll[3],Interval(0,1))
@test ndims(ll) == 2
ll[5]
@test ndims(ll) == 3
ll[5]
@test ndims(ll) == 3

@test length(convert(Vector{Interval},ll)) == ndims(ll)
@test length(convert(Vector{Interval},ll,[1,2])) == 2
