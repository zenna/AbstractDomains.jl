@doc doc"Abstract Boolean Types: {{true},{false}.{true,false}}" ->
immutable AbstractBool <: Domain{Bool}
  v::Uint8
  AbstractBool(v::Uint8) = (@assert v == 0x1 || v == 0x2 || v== 0x3; new(v))
end

const t = AbstractBool(0x1)
const f = AbstractBool(0x2)
const tf = AbstractBool(0x3)

promote_rule(::Type{Bool}, ::Type{AbstractBool}) = AbstractBool
convert(::Type{AbstractBool}, b::Bool) = if b t else f end


## AbstractBool Set Operations
## ===========================
subsumes(x::AbstractBool, y::AbstractBool) = x === tf || x === y
subsumes(x::AbstractBool, y::Bool) = subsumes(x,convert(AbstractBool, y))

isintersect(x::AbstractBool, y::AbstractBool) = !((x === t && y === f) || (x === f && y === t))
isintersect(x::AbstractBool, y::Bool) = isintersect(x,convert(AbstractBool, y))
isintersect(x::Bool, y::AbstractBool) = isintersect(convert(AbstractBool, x),y)

isrelational(::Type{AbstractBool}) = false
isabstract(c::Type{Bool}, a::Type{AbstractBool}) = true

isequal(x::AbstractBool, y::AbstractBool) = x.v == y.v
domaineq(x::AbstractBool, y::AbstractBool) = x.v == y.v

⊔(a::AbstractBool) = a
⊔(a::AbstractBool, b::AbstractBool) = a === b ? a : tf
⊔(a::Bool, b::AbstractBool) = ⊔(convert(AbstractBool,a),b)
⊔(a::AbstractBool, b::Bool) = ⊔(a,convert(AbstractBool,b))
⊔(a::Bool, b::Bool) = a === b ? convert(AbstractBool,a) : tf


## =========================
## Lifted Boolean Arithmetic

function !(b::AbstractBool)
  if b === t
    f
  elseif b === f
    t
  elseif b === tf
    tf
  end
end

(==)(x::AbstractBool, y::AbstractBool) =
  x === tf || y === tf ? tf : x === t && y === t || x === f && y === f

function (==)(x::AbstractBool, y::AbstractBool)
  if x === tf || y === tf tf
  elseif x === t && y === t t
  elseif x === f && y === f t
  else f
  end
end
(==)(x::AbstractBool, y::Bool) = (==)(promote(x,y)...)
(==)(y::Bool,x::AbstractBool) = (==)(promote(y,x)...)

function (|)(x::AbstractBool, y::AbstractBool)
  if x === t || y === t t
  elseif x === tf || y === tf tf
  else f
  end
end
|(x::AbstractBool, y::Bool) = |(x,convert(AbstractBool,y))
|(y::Bool, x::AbstractBool) = |(convert(AbstractBool,y), x)

function (&)(x::AbstractBool, y::AbstractBool)
  if x === f || y === f f
  elseif x === tf || y === tf tf
  else t
  end
end

(&)(x::AbstractBool, y::Bool) = x & convert(AbstractBool, y)
(&)(y::Bool, x::AbstractBool) = convert(AbstractBool, y) & x

# When condition is TF we need to evaluate both branches
# and merge with ⊔
function ifelse(c::AbstractBool, x, y)
  if c === t
    x
  elseif c === f
    y
  elseif c === tf
    ⊔(x,y)
  end
end

## Printing
## ========
string(x::AbstractBool) = ["{true}","{false}","{true,false}"][x.v]
print(io::IO, x::AbstractBool) = print(io, string(x))
show(io::IO, x::AbstractBool) = print(io, string(x))
showcompact(io::IO, x::AbstractBool) = print(io, string(x))
