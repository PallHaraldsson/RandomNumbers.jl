for (i, testfile) in enumerate((
    "generic.jl",
    "wrapped_rng.jl",
    "PCG/runtests.jl",
    "MersenneTwisters/runtests.jl",
    "Xorshifts/runtests.jl",
    "Random123/runtests.jl"))
    @eval module $(Symbol("T$i"))
        include("common.jl")
        include($testfile)
    end
end
