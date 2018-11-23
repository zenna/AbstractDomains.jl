using AbstractDomains

using Test

@testset "all tests" begin

tests = ["bool",
         "interval",
         "hyperbox",
         "lazybox"]

println("Running tests:")

for t in tests
    test_fn = "$t.jl"
    println(" * $test_fn")
    include(test_fn)
end

end
