using AbstractDomains
using Base.Test
import AbstractDomains: isintersect, subsumes, ⊔
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

# isintersect
@test isintersect(t,f) == false
@test isintersect(f,t) == false
@test isintersect(t,t) == true
@test isintersect(f,f) == true
@test isintersect(tf,t) == true
@test isintersect(t,tf) == true
@test isintersect(tf,f) == true
@test isintersect(f,tf) == true
@test isintersect(tf,tf) == true

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

#ifelse
@test ifelse(tf,f,t) === tf
@test ifelse(t,f,t) === f
@test ifelse(f,f,t) === t