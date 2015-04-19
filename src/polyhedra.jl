## Convex Polyhedra
## ================
convert( ::Type{Ptr{Ptr{UInt8}}}, s::Array{ASCIIString,1} ) = map(pointer ,s)

pplisinitailsed = false

function isppl_initialzied()
  global pplisinitailsed
  pplisinitailsed
end

function ppl_initialize()
  @assert !isppl_initialzied()
  ccall( (:ppl_initialize, "libppl_c"), Int32, ())
  global pplisinitailsed = true
end

function ppl_finalize()
  @assert isppl_initialzied()
  ccall( (:ppl_finalize, "libppl_c"), Int32, ())
  global pplisinitailsed = false
end

function ppl_version_vec()
  @assert isppl_initialzied()
  Int[ccall((:ppl_version_major, "libppl_c"), Int32, ()),
      ccall((:ppl_version_minor, "libppl_c"), Int32, ()),
      ccall((:ppl_version_revision, "libppl_c"), Int32, ()),
      ccall((:ppl_version_beta, "libppl_c"), Int32, ())]
end

function ppl_version()
  @assert isppl_initialzied()
#   versionnum = Array(UInt8, 20)
  versionnum = convert(Ptr{Ptr{Uint8}},["H", "E","L","L","O"])
  res = ccall((:ppl_version, "libppl_c"), Int, (Ptr{Ptr{Uint8}},), versionnum)
  bytestring(convert(Ptr{Uint8}, versionnum[1]))
end
