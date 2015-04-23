using AbstractDomains
using Base.Test

a = HyperBox([0.0 0.0 0.0
              1.0 1.0 1.0])
@test mid(a) == [0.5,0.5,0.5]
