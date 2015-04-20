# AbstractDomains.jl

This is a Julia package for representing and computing with [abstract domains](http://en.wikipedia.org/wiki/Abstract_interpretation#Examples_of_abstract_domains). 

[![Build Status](https://travis-ci.org/zenna/AbstractDomains.jl.svg?branch=master)](https://travis-ci.org/zenna/AbstractDomains.jl)

A abstract domain is used to represent a large or infinite set in a finite amount of space.  For instance we can use intervals `[a, b]` to represent all the floating point numbers between `a` and `b`.  AbstractDomains.jl then provides functions for computing with abstract values, for instance we can add or multiple two intervals.

# Domains

Currently AbstractDomains.jl supports only two abstract domains: `Interval` and `AbstractBool`.  For every primitive functions such as `+`, `-`, `&`, `ifelse`, defined on concrete values such as `Float64` or `Bool`, there is a  corresponding *lifted* method defined on its abstract counterpart: `Interval` and `AbstractBool`.

The meaning of these *lifted* functions is [*pointwise*](http://en.wikipedia.org/wiki/Pointwise).  That is, if we do `C = f(A,B)` where `A` and `B` are elements belonging to an abstract domain, then `C` should contain the result of applying `f` to __all possible combinations__ of elements in `A` and `B`.

# Example

If only using Intervals, AbstractDomains.jl is basically an interval arithmetic package, e.g.:

```julia
julia> A = Interval(0,1)
[0.0 1.0]

julia> B = Interval(1,2)
[1.0 2.0]

julia> C = A + B
[1.0 3.0]
```

`C` should be an interval which represents all the values if we took every value in the interval `A`.  The following code represents what this means (__note:__ it is not valid code):

```julia
# What C = A + B is doing (conceptually!)
c = Set(Float64)
for a in A
  for b in B
    push!(c, a + b)
  end
end
```

Functions involving intervals and normal values are also defined in AbstractDomains.jl:

```julia
julia> C * 3
[3.0 9.0]
```

## Boolean Functions and AbstractBools

If we apply boolean functions (`>` `>=` `<` `<=` `ifelse`) to intervals, we don't get back a `Bool`, we get back an `AbstractBool`.  For example:

```julia
julia> A = Interval(1,2)
[1.0 2.0]

julia> A > 0
{true}

julia> A > 3
{false}
```

This means that for all the elements in `A` (e.g., 1.0, 1.000001, 1.00002,...), *all* of them are greater than 0.  Similarly _none_ of `A` is greater than 3. But why has it returned these strange value `{true}` and `{false}` instead of `true` and `false`?  The next example should help illustrate why:

```julia
julia> A = Interval(1,2)
[1.0 2.0]julia> A / A
[0.5 2.0]

julia> A > 1.5
{true,false}
```

The result `{true,false}` means that there are some values in `A` which are greater than 1.5 and some that are not greater than 1.5.

The values `{true}`, `{false}` and `{true,false}` fully represent the `AbstractBool` domain.  These values are exported by AbstractDomains.jl as `t`, `f` and `tf` respectively, and primitive boolean operations are defined on them, e.g:

```julia
julia> t & t
{true}

julia> t & f
{false}

julia> tf & t
{true,false}

julia> tf & f
{false}

julia> tf | f
{true,false}
```

Some of these may require thinking about.  But they are all consistent with the semantics of functions on abstract operations being defined pointwise, as described above.

## Equality
Perhaps surprisingly, there are meany meaningful definitions of equality.  In AbstractDomains.jl equality `==` is, like the other functions we've seen before, defined pointwise.  This can lead to some unexpected results if you're not careful, e.g.

```julia
julia> tf == tf
{true,false}

```

The answer is `{true,false}` because `true & true` is `true`, but `false & true` is `false` (to take just two of four possible combinations).  Similarly:

```julia
julia> Interval(0,1) == Interval(0,1)
{true,false}
```

The answer is `{true,false}` because there are points in the first interval which equal to points in the second interval, but there are also points in the first interval which are not equal to point in the second interval.

# Non-pointwise functions on abstract domains
If we really want to test the identity of abstract objects we would use `===`, e.g.

```julia
julia> Interval(0,1) === Interval(0,1)
true

julia> tf === f
false
```


`=== ` is an example of a function on abstract values which is not defined pointwise.  There are many useful others.  Some of which we call *domain functions*:

```julia
julia> subsumes(Interval(0,1),Interval(0.4,0.5))
true

julia> overlap(Interval(0,1),Interval(3,6))
false

julia> overlap(t,f)
false

julia> overlap(t,tf)
true

# ⊔ (\sqcup) is a lub
julia> Interval(0,1) ⊔ Interval(10,3)
[0.0 10.0]
```

# Imprecision

Abstractions are *sound* but can be *imprecise*.  Imprecision means that the result of a function application may contain values which are not possible in reality. E.g.:

```julia
julia> A = Interval(1,2)
[1.0 2.0]

julia> A / A
[0.5 2.0]
```

The precise answer should be `[1.0, 1.0]`.  This imprecision comes because we do not recognise that the `A` in the denominator is the same `A` as in the numerator.  That is, we have ignored the dependencies.

Imprecision is undesirable.  We can take some comfort in knowing that we'll always be sound, which this example also demonstrates.  Soundness means that the true answer `[1.0, 1.0]` must be a subset of the answer AbstractDomains.jl gives us.  For instance, the following would __never__ happen

```julia
julia> A = Interval(1,2)
[1.0 2.0]

# Unsound result: this can *NEVER* happen
julia> A / A
[2.0 3.0]
```