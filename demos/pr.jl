using Finch
using Finch.IndexNotation
using RewriteTools
using BenchmarkTools
using SparseArrays
using LinearAlgebra
using SparseArrays
using MatrixMarket

function def_5_pagerank(out_d, edges)
    #= /Users/adadima/mit/commit/Finch.jl/demos/pr.jl:141 =#
    #= /Users/adadima/mit/commit/Finch.jl/demos/pr.jl:142 =#
    w_0 = Scalar{0}()
    #= /Users/adadima/mit/commit/Finch.jl/demos/pr.jl:143 =#
    begin
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/denselevels.jl:67 =#
            tns_lvl = out_d.lvl
        end
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:57 =#
            tns_lvl_2 = tns_lvl.lvl
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:58 =#
            tns_lvl_2_val_alloc = length(tns_lvl.lvl.val)
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:59 =#
            tns_lvl_2_val = 0
        end
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/denselevels.jl:67 =#
            tns_2_lvl = edges.lvl
        end
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/sparselistlevels.jl:87 =#
            tns_2_lvl_2 = tns_2_lvl.lvl
            #= /Users/adadima/mit/commit/Finch.jl/src/sparselistlevels.jl:88 =#
            tns_2_lvl_2_pos_alloc = length(tns_2_lvl_2.pos)
            #= /Users/adadima/mit/commit/Finch.jl/src/sparselistlevels.jl:89 =#
            tns_2_lvl_2_idx_alloc = length(tns_2_lvl_2.idx)
        end
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:57 =#
            tns_2_lvl_3 = tns_2_lvl_2.lvl
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:58 =#
            tns_2_lvl_3_val_alloc = length(tns_2_lvl_2.lvl.val)
            #= /Users/adadima/mit/commit/Finch.jl/src/elementlevels.jl:59 =#
            tns_2_lvl_3_val = 0
        end
        begin
            #= /Users/adadima/mit/commit/Finch.jl/src/scalars.jl:31 =#
            w_0 = w_0
            #= /Users/adadima/mit/commit/Finch.jl/src/scalars.jl:32 =#
            w_0_val = w_0.val
        end
        @inbounds begin
                j_stop = tns_2_lvl_2.I
                i_stop = tns_2_lvl.I
                tns_lvl_2_val_alloc = (Finch).refill!(tns_lvl_2.val, 0, 0, 4)
                tns_lvl_2_val_alloc < (*)(1, tns_2_lvl_2.I) && (tns_lvl_2_val_alloc = (Finch).refill!(tns_lvl_2.val, 0, tns_lvl_2_val_alloc, (*)(1, tns_2_lvl_2.I)))
                for i = 1:i_stop
                    tns_2_lvl_q = (1 - 1) * tns_2_lvl.I + i
                    tns_2_lvl_2_q = tns_2_lvl_2.pos[tns_2_lvl_q]
                    tns_2_lvl_2_q_stop = tns_2_lvl_2.pos[tns_2_lvl_q + 1]
                    if tns_2_lvl_2_q < tns_2_lvl_2_q_stop
                        tns_2_lvl_2_i = tns_2_lvl_2.idx[tns_2_lvl_2_q]
                        tns_2_lvl_2_i1 = tns_2_lvl_2.idx[tns_2_lvl_2_q_stop - 1]
                    else
                        tns_2_lvl_2_i = 1
                        tns_2_lvl_2_i1 = 0
                    end
                    j = 1
                    j_start = j
                    phase_start = j_start
                    phase_stop = (min)(tns_2_lvl_2_i1, j_stop)
                    if phase_stop >= phase_start
                        j = j
                        j = phase_start
                        while tns_2_lvl_2_q < tns_2_lvl_2_q_stop && tns_2_lvl_2.idx[tns_2_lvl_2_q] < phase_start
                            tns_2_lvl_2_q += 1
                        end
                        while j <= phase_stop
                            j_start_2 = j
                            tns_2_lvl_2_i = tns_2_lvl_2.idx[tns_2_lvl_2_q]
                            phase_stop_2 = (min)(tns_2_lvl_2_i, phase_stop)
                            j_2 = j
                            if tns_2_lvl_2_i == phase_stop_2
                                tns_2_lvl_3_val = tns_2_lvl_3.val[tns_2_lvl_2_q]
                                j_3 = phase_stop_2
                                tns_lvl_q = (1 - 1) * tns_2_lvl_2.I + j_3
                                tns_lvl_2_val = tns_lvl_2.val[tns_lvl_q]
                                w_0_val = 0
                                w_0_val = (+)(tns_2_lvl_3_val, w_0_val)
                                tns_lvl_2_val = w_0_val
                                tns_lvl_2.val[tns_lvl_q] = tns_lvl_2_val
                                tns_2_lvl_2_q += 1
                            else
                            end
                            j = phase_stop_2 + 1
                        end
                        j = phase_stop + 1
                    end
                    j_start = j
                    phase_start_3 = j_start
                    phase_stop_3 = j_stop
                    if phase_stop_3 >= phase_start_3
                        j_4 = j
                        j = phase_stop_3 + 1
                    end
                end
                (tns = Fiber((Finch.DenseLevel){Int64}(tns_2_lvl_2.I, tns_lvl_2), (Finch.Environment)(; name = :tns)),)
            end
    end
end

function main()
    matrix = copy(transpose(MatrixMarket.mmread("graphs/dag7.mtx")))
    (n, m) = size(matrix)
    @assert n == m
    nzval = ones(size(matrix.nzval, 1))
    edges = Finch.Fiber(
                Dense(n,
                SparseList(n, matrix.colptr, matrix.rowval,
                Element{0}(nzval))))
    out_d = Finch.Fiber(Dense(n, Element{0, Int64}()))
    
    def_5_pagerank(out_d, edges);
    ctx = Finch.LowerJulia()
    code = Finch.contain(ctx) do ctx_2
        t_out_d = typeof(@fiber d(e(0)))
        out_d = Finch.virtualize(:out_d, t_out_d, ctx_2)
        t_edges = typeof(@fiber d(sl(e(0))))
        edges = Finch.virtualize(:edges, t_edges, ctx_2)
        w_0 = Finch.virtualize(:w_0, typeof(Scalar{0, Int64}()), ctx_2, :w_0)
        kernel = @finch_program (
            @loop i (
                @loop j (
                    (out_d[j] = w_0[]) where (w_0[] += edges[i,j])
                )
            )
        )
        
        kernel_code = Finch.execute_code_virtualized(kernel, ctx_2)
    end
    f = quote
                function def_5_pagerank(out_d, edges)
                    w_0 = Scalar{0}()
                    $code
                end
            end
    
    func = last(f.args)
    println(func)

    # function wa()
    #     g = eval(func)
    #     Base.invokelatest(g, out_d, edges)
    # end

    # wa()

    println(out_d.lvl.lvl.val)
end

main()