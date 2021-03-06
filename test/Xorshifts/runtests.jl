using RandomNumbers.Xorshifts

if !@isdefined RandomNumbers
    include("../common.jl")
end

@info "Testing Xorshifts"
stdout_ = stdout
pwd_ = pwd()
cd(dirname(@__FILE__))
rm("./actual"; force=true, recursive=true)
mkpath("./actual")

seeds = [0x1ed73cdc948901ab, 0x6d76dcf952161e22, 0x8d0eba5421bc695b, 0xa16065e26c36cce2,
         0x944867a9aacc1bfa, 0x173d478b3ac9de91, 0x97becbc60ac9c1f2, 0x1b1cfeff0505b998,
         0x815a28dc8372d7ab, 0x5c6746d45ae2c5c4, 0x17f22f9aa839c717, 0x1fd7e8194bb9c598,
         0x442ffe4a57ed7987, 0xfd686ec417788eb6, 0x1ec96940807a8749, 0x64d93a8608a988ef]

for (rng_name, seed_t) in (
        (:Xorshift64,       UInt64),
        (:Xorshift64Star,   UInt64),
        (:Xorshift128,      NTuple{2, UInt64}),
        (:Xorshift128Star,  NTuple{2, UInt64}),
        (:Xorshift128Plus,  NTuple{2, UInt64}),
        (:Xorshift1024,     NTuple{16, UInt64}),
        (:Xorshift1024Star, NTuple{16, UInt64}),
        (:Xorshift1024Plus, NTuple{16, UInt64}),
        (:Xoroshiro128,     NTuple{2, UInt64}),
        (:Xoroshiro128Star, NTuple{2, UInt64}),
        (:Xoroshiro128Plus, NTuple{2, UInt64}),
    )

    outfile = open(string(
        "./actual/check-$(lowercase("$rng_name")).out"
    ), "w")
    redirect_stdout(outfile)

    @eval x = $rng_name()
    @test_throws(
        ErrorException("0 cannot be the seed"),
        seed_t === NTuple{16, UInt64} ? seed!(x, zeros(UInt64, 16)...) : seed!(x, 0)
    )
    seed!(x)
    @test seed_type(x) == seed_t
    @test copyto!(copy(x), x) == x
    if seed_t <: Tuple
        seed = (seeds[1:length(seed_t.types)]...,)
    else
        seed = seeds[1]
    end
    @eval x = $rng_name($seed)

    for i in 1:100
        @printf "%.9f\n" rand(x)
    end

    close(outfile)
end
redirect_stdout(stdout_)


compare_dirs("expected", "actual")
cd(pwd_)
