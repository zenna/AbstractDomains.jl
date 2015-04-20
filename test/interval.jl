using AbstractDomains
import AbstractDomains: subsumes, overlap, ⊔, sqr, makepos
using Base.Test

# Concrete Arithmetic Examples
@test Interval(3,4) + Interval(9,10) === Interval(12,14)
@test Interval(3,4) * Interval(1,2) === Interval(3,8)


@test subsumes(Interval(-5,5), Interval(-3,3))
@test subsumes(Interval(-5,5), Interval(-5,5))
@test !subsumes(Interval(-5,5), Interval(-3,10))
@test !subsumes(Interval(-5,5), Interval(10,20))

@test overlap(Interval(-5,5), Interval(-3,3))
@test overlap(Interval(-5,5), Interval(-3,10))
@test overlap(Interval(0,5), Interval(5,10))
@test !overlap(Interval(-5,5), Interval(10,20))
@test !overlap(Interval(10,20), Interval(5,-5))

@test (Interval(5,5) > Interval(5,5)) === f
@test (Interval(0,5) > Interval(5,5)) === f
@test (Interval(5,5) > Interval(0,5)) === tf

@test (Interval(0,1) > Interval(-2,-1)) === t
@test (Interval(0,1) > Interval(1,2)) === f
@test (Interval(0,1) > Interval(-1,0)) === tf
@test (Interval(0,1) > Interval(1.5,2.5)) === f

@test (Interval(-9,-3) < Interval(0,3)) === t
@test (Interval(0,1) < Interval(1,2)) === tf
@test (Interval(0,1) < Interval(-1,0)) === f
@test (Interval(1.5,2.5) < Interval(0,1)) === f

@test (Interval(0,1) >= Interval(0,0)) === t
@test (Interval(0,1) <= Interval(1,1)) === t

@test (Interval(0,1) == Interval(0,1)) === tf

#abs
@test abs(Interval(-3,-1)) === Interval(1,3)
@test abs(Interval(-9,0)) === Interval(0,9)
@test abs(Interval(-10,5)) === Interval(0,10)
@test abs(Interval(0,7)) === Interval(0,7)
@test abs(Interval(0,0)) === Interval(0,0)
@test abs(Interval(2,5)) === Interval(2,5)
@test sqr(Interval(-4,4)) === Interval(0,16)

# Division
@test Interval(9,18) / Interval(2,3) === Interval(3.0,9.0)
@test makepos(Interval(-2,5)) === Interval(0,5)

# ⊔
@test ⊔(Interval(-3,2), Interval(10,12)) === Interval(-3,12)
@test Interval(0,0) ⊔ 1 === Interval(0,1)