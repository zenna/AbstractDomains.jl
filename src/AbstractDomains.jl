module AbstractDomains

import Base: convert, promote_rule
import Base: string, print, show, showcompact
import Base: abs, zero, in

if VERSION.minor <= 3
  typealias UInt8 Uint8
end

export Interval,
       AbstractBool,
       t,f,tf,
       ⊔, subsumes, overlap

include("domains.jl")

end
