"""
    Interval{T<:Real} <: Domain{T}

An Interval of type 'T' between 'a' and 'b' represents all the values of type 'T' between 'a' and 'b'.
"""
struct Interval{T<:Real} <: Domain{T}
  l::T
  u::T
  Interval{T}(l,u) where {T<:Real} = if u > l new(l, u) else new(u,l) end
end

Interval(x::Real) = Interval{typeof(x)}(x,x)
Interval(v::Vector{T}) where T <: Real = Interval(v[1],v[2])
Interval(x::T,y::T) where T <: Real = Interval{T}(x,y)
Interval(x::T1,y::T2) where {T1<:Real, T2<:Real} = Interval{promote_type(T1,T2)}(promote(x,y)...)

## Conversions and Promotion
## =========================

# A concrete number can be coerced into an interval with no width
function convert(::Type{Interval{T1}}, x::Interval{T2}) where {T1<:Real, T2<:Real}
  T = promote_type(T1,T2)
  Interval{T}(convert(T,x.l),convert(T,x.u))
end
convert(::Type{Interval}, c::Real) = Interval{typeof(c)}(c,c)
convert(::Type{Interval{T}}, c::T) where {T<:Real} = Interval{T}(c,c)
convert(::Type{Interval{T1}}, c::T2) where {T1<:Real, T2<:Real} = Interval{T1}(c,c)

promote_rule(::Type{Interval{T1}}, ::Type{T2}) where {T1<:Real, T2<:Real} = Interval{T1}
promote_rule(::Type{Interval{T1}}, ::Type{Interval{T2}}) where {T1<:Real, T2<:Real} = Interval{promote_type(T1,T2)}

## Domain operations
## =================
ndims(i::Interval) = 1
subsumes(x::Interval, y::Interval) = y.l >= x.l && y.u <= x.u
issubset(x::Interval, y::Interval) = x.l >= y.l && x.u <= y.u
⊑ = issubset

isintersect(x::Interval, y::Interval) = y.l <= x.u && x.l <= y.u
domaineq(x::Interval, y::Interval) = x.u == y.u && x.l == y.l

"""
    intersect(x::Interval{T}, y::Interval{T}) where T

Construct interval which is intersection of two intervals
"""
intersect(x::Interval{T}, y::Interval{T}) where T = Interval(max(x.l, y.l), min(x.u, y.u))
intersect(a::Interval{T}, b::Interval{S}) where {T,S} = intersect(promote(a,b)...)
⊓ = intersect

## Union/Join
union(a::Interval, b::Interval) = ⊔(a, b)
function ⊔(a::Interval, b::Interval)
  l = min(a.l,b.l)
  u = max(a.u, b.u)
  Interval(l,u)
end

⊔(a::Interval, b::Real) = ⊔(promote(a,b)...)
⊔(b::Real, a::Interval) = ⊔(promote(b,a)...)
⊔(a::Interval) = a
⊔(a::Vector{Interval}) = reduce(⊔,a)

isequal(x::Interval,y::Interval) = domaineq(x,y)
isrelational(::Type{Interval}) = false

isabstract(c::Type{T}, a::Type{Interval{T}}) where {T<:Real} = true

## Interval Arithmetic and Inequalities
## ====================================

# ==, != return values in AbstractBool
function ==(x::Interval, y::Interval)
  if x.u == y.u == x.l == y.l t
  elseif isintersect(x,y) tf
  else f end
end

!=(x::Interval,y::Interval) = !(==(x,y))

==(x::Interval,y::Real) = ==(promote(x,y)...)
==(y::Real,x::Interval) = ==(promote(y,x)...)

!=(x::Interval, y::Real) = !==(x,y)
!=(y::Real, x::Interval) = !==(y,x)

>(x::Interval, y::Interval) = if x.l > y.u t elseif x.u <= y.l f else tf end
>(x::Interval, y::Real) = if x.l > y t elseif x.u <= y f else tf end
>(y::Real, x::Interval) =  if y > x.u t elseif y <= x.l f else tf end

<(x::Interval, y::Interval) = y > x
<(x::Interval, y::Real) = y > x
<(y::Real, x::Interval) = x > y

<=(x::Interval, y::Interval) = !(x > y)
>=(x::Interval, y::Interval) = !(x < y)
<=(x::Interval, y::Real) = !(x > y)
<=(y::Real, x::Interval) = !(y > x)

>=(x::Interval, y::Real) = !(x < y)
>=(y::Real, x::Interval) = !(y < x)

+(x::Interval, y::Interval) = Interval(x.l + y.l, x.u + y.u)
-(x::Interval, y::Interval) = Interval(x.l - y.u, x.u - y.l)
+(x::Interval, y::Real) = Interval(x.l + y, x.u + y)
+(y::Real, x::Interval) = x + y
+(x::Interval) = x
-(x::Interval, y::Real) = Interval(x.l - y, x.u - y)
-(y::Real, x::Interval) = Interval(y - x.l, y - x.u)
-(x::Interval{T}) where {T} = zero{T} - x
*(x::Interval, y::Real) = Interval(x.l * y, x.u * y)
*(y::Real, x::Interval) = x * y

sqrt(x::Interval) = Interval(sqrt(x.l), sqrt(x.u))

# CODEREVIEW: Generalise to even powers
function sqr(x::Interval)
  a,b,c,d = x.l * x.l, x.l * x.u, x.u * x.l, x.u * x.u
  Interval(max(min(a,b,c,d),0),max(a,b,c,d,0))
end

function *(x::Interval, y::Interval)
  a,b,c,d = x.l * y.l, x.l * y.u, x.u * y.l, x.u * y.u
  Interval(min(a,b,c,d),max(a,b,c,d))
end

# is c inside the interval
# CODREVIEW: TESTME
in(c::Real, y::Interval) = y.l <= c <= y.u

# CODREVIEW: TESTME
inv(x::Interval) = Interval(1/x.u,1/x.l)

# Ratz Interval Division
# CODREVIEW: TESTME
function /(x::Interval, y::Interval)
  a,b,c,d = x.l,x.u,y.l,y.u
  if !(0 ∈ y)
    x * inv(y)
  elseif (0 ∈ x)
    Interval(-Inf,Inf)
  elseif b < 0 && c < d == 0
    Interval(b/c,Inf)
  elseif b < 0 && c < 0 < d
    Interval(-Inf,Inf)
  elseif b < 0 && 0 == c < d
    Interval(-Inf,b/d)
  elseif 0 < a && c < d == 0
    Interval(-Inf,a/c)
  elseif 0 < a && c < 0 < d
    Interval(-Inf,Inf)
  elseif 0 < a && 0 == c < d
    Interval(a/d, Inf)
  else
    Inf
  end
end

/(c::Real, x::Interval) = convert(Interval,c) / x
/(x::Interval, c::Real) = x / convert(Interval,c)
## Rationals
//(x::Interval, y::Interval) = x / y
//(x::Interval, c::Real) = x / c
//(c::Real, x::Interval) = c / x

## Functions on Interval type
## ==========================

unit(::Type{Interval{T}}) where T = Interval{T}(zero(T), one(T))
unit(::Interval{T}) where T = Interval{T}(zero(T), one(T))

## It's all Ones and Zeros
zero(::Type{Interval}) = Interval(0.0,0.0)
one(::Type{Interval{T}}) where T = Interval(one(T))
one(::Interval{T}) where T = Interval(one(T))
zero(::Type{Interval{T}}) where T = Interval(zero(T))
zero(::Interval{T}) where T = Interval(zero(T))

## Functions on interval abstraction itself
## =======================================
reflect(x::Interval) = Interval(-x.l,-x.u)
makepos(x::Interval) = Interval(max(x.l,0), max(x.u,0))
mid(x::Interval) = (x.u - x.l) / 2 + x.l

## Non primitive functions
## =======================
function abs(x::Interval)
  if x.l >= 0.0 && x.u >= 0.0 x
  elseif x.u >= 0.0 Interval(0,max(abs(x.l), abs(x.u)))
  else makepos(reflect(x))
  end
end

round(x::Interval) = Interval(round(x.l), round(x.u))

function isinf(x::Interval)
  if isinf(x.l) || isinf(x.u)
    x.u == x.l ? T : t
  else
    F
  end
end

function isapprox(x::Interval, y::Interval; epsilon::Real = 1E-5)
  ifelse(isinf(x) | isinf(y), x == y, abs(x - y) <= epsilon)
end

isapprox(x::Interval, y::Real) = isapprox(promote(x,y)...)
isapprox(x::Real, y::Interval) = isapprox(promote(x,y)...)

## Vector Interop
## ==============
l(v::Vector{T}) where {T<:Real} = v[1]
u(v::Vector{T}) where {T<:Real} = v[2]
l(x::Interval) = x.l
u(x::Interval) = x.u
pair(::Type{Interval{T}},low,up) where T = Interval(low,up)
pair(::Type{Vector{Float64}},low,up) = [low,up]
Pair = Union{Vector{Float64},Interval}

## Splitting
## =========
function split_box(i::P, split_point::Float64) where {P<:Pair}
  @assert l(i) <= split_point <= u(i) "Split point must be within interval"
  # @assert l(i) != u(i) "Can't split a single point interval into disjoint sets"

  if l(i) == u(i)  #Degenrate case
    P[pair(P, l(i), u(i)), pair(P, l(i), u(i))]
  elseif split_point < u(i)
    P[pair(P, l(i), split_point), pair(P, nextfloat(split_point), u(i))]
  else
    P[pair(P, l(i), prevfloat(split_point)), pair(P, split_point, u(i))]
  end
end

mid_split(i::Interval) = split_box(i,mid(i))

# Split along the middle n times
function mid_split(i::Interval, n::Int64)
  A = [i]
  for i = 1:n
    res = Interval[]
    for a in A
      splitted = mid_split(a)
      push!(res,splitted[1],splitted[2])
    end
    A = res
  end
  A
end

## Sampling
## ========
rand(x::Interval{T}) where {T<:AbstractFloat}  =  x.l + (x.u - x.l) * rand(T)
rand(x::Interval{T}) where {T<:Integer} = rand(UnitRange(x.l,x.u))
rand(x::Interval{T},n::Int) where {T<:Real} = T[rand(x) for i = 1:n]

## Print
## =====
string(x::Interval) = "[$(x.l) $(x.u)]"
print(io::IO, x::Interval) = print(io, string(x))
show(io::IO, x::Interval) = print(io, string(x))
