using AbstractDomains
using Base.Test
import AbstractDomains: overlap, subsumes, ⊔
import AbstractDomains: t, f, tf

@test t & f === f
@test tf & f === f
@test t & t === t
@test tf & tf === tf
@test !t === f
@test !tf === tf
@test !f === t
@test tf | t === t
@test tf | f === tf
@test f | t === t
@test t | tf === t

# Lifted equality tests
@test (t == t) === t
@test (t == tf) === tf
@test (tf == t) === tf
@test (f == f) === t
@test (t == f) === f
@test (f == t) === f

# Overlap
@test overlap(t,f) == false
@test overlap(f,t) == false
@test overlap(t,t) == true
@test overlap(f,f) == true
@test overlap(tf,t) == true
@test overlap(t,tf) == true
@test overlap(tf,f) == true
@test overlap(f,tf) == true
@test overlap(tf,tf) == true

# Subsumes
@test subsumes(tf,f) == true
@test subsumes(tf,t) == true
@test subsumes(tf,tf) == true
@test subsumes(f,f) == subsumes(t,t) == true
@test subsumes(f,t) == subsumes(t,f) == false
@test subsumes(f,tf) == subsumes(t,tf) == false

# Join
@test ⊔(t,f) === ⊔(f,t) === tf
@test ⊔(t,t) === t
@test ⊔(f,f) === f
@test ⊔(tf,t) === ⊔(t,tf) === tf
@test ⊔(tf,f) === ⊔(f,tf) === tf
@test ⊔(tf,tf) === tf
