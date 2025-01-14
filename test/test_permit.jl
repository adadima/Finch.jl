@testset "permit" begin

    #=
    A = Finch.Fiber(
        Dense(5,
        Element{0.0}([1, 2, 3, 4, 5])))
    B = Finch.Fiber(
        Dense(2,
        Element{0.0}([10, 20])))
    C = Finch.Fiber(Dense(Element{0.0}()))

    println(@finch_code @loop i C[i] += A[i] + coalesce(B[permit[i]], 0))
    @finch @loop i C[i] += A[i] + coalesce(B[permit[i]], 0)
    println(C)

    A = Finch.Fiber(
        Dense(5,
        Element{0.0}([1, 2, 3, 4, 5])))
    B = Finch.Fiber(
        Dense(2,
        Element{0.0}([1, 1])))
    C = Finch.Fiber(Dense(Element{0.0}()))
    =#

    A_ref = sprand(10, 0.5); B_ref = sprand(10, 0.5); C_ref = vcat(A_ref, B_ref)
    A = fiber(A_ref); B = fiber(B_ref); C = @fiber(sl(e(0.0)))
    @test diff("concat_permit_offset.jl", @finch_code @loop i C[i] = coalesce(A[permit[i]], B[permit[offset[10, i]]]))
    @finch @loop i C[i] = coalesce(A[permit[i]], B[permit[offset[10, i]]])
    
    @test diff("concat_offset_permit.jl", @finch_code @loop i C[i] = coalesce(A[permit[i]], B[offset[10, permit[i]]]))
    @finch @loop i C[i] = coalesce(A[permit[i]], B[offset[10, permit[i]]])
    @test reference_isequal(C, C_ref)

    F = fiber([1,1,1,1,1])

    @test diff("sparse_conv.jl", @finch_code @loop i j C[i] += (A[i] != 0) * coalesce(A[permit[offset[i - 3, j]]], 0) * F[j])
    @finch @loop i j C[i] += (A[i] != 0) * coalesce(A[permit[offset[i - 3, j]]], 0) * F[j]
    C_ref = zeros(10)
    for i = 1:10
        if A_ref[i] != 0
            for j = 1:5
                k = (j - (i - 3))
                if 1 <= k <= 10
                    C_ref[i] += A_ref[k]
                end
            end
        end
    end
    @test reference_isequal(C, C_ref)
    @test diff("sparse_conv_guarded.jl", @finch_code @loop i j C[i] += (A[i] != 0) * coalesce(A[permit[offset[i - 3, j]]], 0) * coalesce(F[permit[j]], 0))
    @finch @loop i j C[i] += (A[i] != 0) * coalesce(A[permit[offset[i - 3, j]]], 0) * coalesce(F[permit[j]], 0)
    @test reference_isequal(C, C_ref)

    @test diff("sparse_window.jl", @finch_code @loop i C[i] = A[window[2, 4, i]])
    @finch @loop i C[i] = A[window[2, 4, i]]
    @test reference_isequal(C, [A(2), A(3), A(4)])
end