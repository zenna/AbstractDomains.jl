using Base.Test

X = Interval(0,1)
ll = LazyBox(Dict(1=>Interval(0,1)))
ll[3]
@test domaineq(ll[3],Interval(0,1))
@test ndims(ll) == 2
ll[5]
@test ndims(ll) == 3
ll[5]
@test ndims(ll) == 3

@test length(convert(Vector{Interval},ll)) == ndims(ll)
@test length(convert(Vector{Interval},ll,[1,2])) == 2

l1 = LazyBox(Float64)
l1[1]
l1[2] = Interval(0.0,10.0)
rand(l1)
l2 = LazyBox(Int64)
l2[1]
l2[2] = Interval(2,5)
rand(l2)

@test 0 <= mid(l1)[2] <= 10
@test 2 <= mid(l2)[2] <= 5

# Splitting
l1split = mid_split(l1)
@test length(l1split) == 4
# partial_split_box(l2,Dict(2=>3)) Need to fix splitting intervals
l1split = partial_split_box(l1,Dict(1=>0.5))
@test length(l1split) == 2
