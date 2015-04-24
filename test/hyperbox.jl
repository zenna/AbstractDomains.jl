using AbstractDomains
using Base.Test

a = HyperBox([0.0 0.0 0.0
              1.0 1.0 1.0])
b = HyperBox([0.0 0.0 0.0 0.0
              1.0 1.0 1.0 1.0])
@test mid(a) == [0.5,0.5,0.5]
@test ndims(a) == 3
@test a != b
@test isrelational(HyperBox) == false

# Mid
c = HyperBox([0.0 0.0
              1.0 1.0])
prev = prevfloat(0.5)
next = nextfloat(0.5)
c1 = HyperBox([0.0 0.0
              0.5 0.5])
c2 = HyperBox([next 0.0
              1.0 0.5])
c3 = HyperBox([0.0 next
               0.5 1.0])
c4 = HyperBox([next next
               1.0  1.0])
q = mid_split(c)

@test isequal(q[1],c1)
@test isequal(q[2],c2)
@test isequal(q[3],c3)
@test isequal(q[4],c4)

@test all([0 <= rb <= 1 for rb in rand(b)])