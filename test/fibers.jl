@testset "fibers" begin
    println("fiber(s) = fiber(s) + fiber(s)")
    A = Finch.Fiber{Float64}((
        HollowListLevel{0.0, Float64}(10, [1, 6], [1, 3, 5, 7, 9]),
        ElementLevel{0.0, Float64}([2.0, 3.0, 4.0, 5.0, 6.0]),
    ))
    B = Finch.Fiber{Float64}((
        HollowListLevel{0.0, Float64}(10, [1, 4], [2, 5, 8]),
        ElementLevel{0.0, Float64}([1.0, 1.0, 1.0]),
    ))
    C = Finch.Fiber{Float64}((
        HollowListLevel{0.0, Float64}(10, [1, 1], Int[]),
        ElementLevel{0.0, Float64}([]),
    ))
    ex = @I @loop i C[i] += A[i] + B[i]

    display(execute_code_lowered(:ex, typeof(ex)))
    println()
    execute(ex)

    println(A)
    println(B)
    println(C)

    @test C == [2.0, 1.0, 3.0, 0.0, 5.0, 0.0, 5.0, 1.0, 6.0, 0.0]
    println()

    A = Finch.Fiber{Float64}((
        SolidLevel(3),
        HollowListLevel{0.0, Float64}(5, [1, 4, 6, 8], [1, 2, 5, 2, 4, 3, 5]),
        ElementLevel{0.0, Float64}([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
    ))
    @test A == [
        1.0  1.0  0.0  0.0  1.0;
        0.0  1.0  0.0  1.0  0.0;
        0.0  0.0  1.0  0.0  1.0;
    ]

    println("dense = fiber(s) + fiber(s)")
    A = Finch.Fiber{Float64}((
        HollowListLevel{0.0, Float64}(10, [1, 6], [1, 3, 5, 7, 9]),
        ElementLevel{0.0, Float64}([2.0, 3.0, 4.0, 5.0, 6.0]),
    ))
    B = Finch.Fiber{Float64}((
        HollowListLevel{0.0, Float64}(10, [1, 4], [2, 5, 8]),
        ElementLevel{0.0, Float64}([1.0, 1.0, 1.0]),
    ))
    C = zeros(10)
    ex = @I @loop i C[i] += A[i] + B[i]

    display(execute_code_lowered(:ex, typeof(ex)))
    println()
    execute(ex)

    println(A)
    println(B)
    println(C)

    @test C == [2.0, 1.0, 3.0, 0.0, 5.0, 0.0, 5.0, 1.0, 6.0, 0.0]
    println()

    println("dense[i] = fiber(d, s)[j, i]")
    A = Finch.Fiber{Float64}((
        SolidLevel(2),
        HollowListLevel{0.0, Float64}(10, [1, 6, 9], [1, 3, 5, 7, 9, 2, 5, 8]),
        ElementLevel{0.0, Float64}([2.0, 3.0, 4.0, 5.0, 6.0, 1.0, 1.0, 1.0]),
    ))
    B = zeros(10)
    ex = @I @loop j i B[i] += A[j, i]

    display(execute_code_lowered(:ex, typeof(ex)))
    println()
    execute(ex)

    println(A)
    println(B)

    @test B == [2.0, 1.0, 3.0, 0.0, 5.0, 0.0, 5.0, 1.0, 6.0, 0.0]
    println()
end