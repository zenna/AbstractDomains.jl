module AbstractDomains

import Base: string

if VERSION.minor <= 3
  typealias UInt8 Uint8
end

export Interval,
       t,f,tf

include("domains.jl")
include("polyhedra.jl")

end
