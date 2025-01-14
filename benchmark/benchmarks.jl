using Pkg
tempdir = mktempdir()
Pkg.activate(tempdir)
Pkg.develop(PackageSpec(path = joinpath(@__DIR__, "..")))
Pkg.add(["BenchmarkTools", "PkgBenchmark", "MatrixDepot"])
Pkg.resolve()

using Finch
using BenchmarkTools
using RewriteTools
using Finch.IndexNotation: or_, choose
using MatrixDepot
using SparseArrays

const SUITE = BenchmarkGroup()

SUITE["compile"] = BenchmarkGroup()

code = """
using Finch
y = @fiber d(e(0.0))
A = @fiber d(sl(e(0.0)))
x = @fiber sl(e(0.0))

@finch @loop i j y[i] += A[i, j] * x[i]
"""
cmd = pipeline(`$(Base.julia_cmd()) --project=$(Base.active_project()) --eval $code`, stdout = IOBuffer())

SUITE["compile"]["time_to_first_SpMV"] = @benchmarkable run($cmd)

let
    y = @fiber d(e(0.0))
    A = @fiber d(sl(e(0.0)))
    x = @fiber sl(e(0.0))

    SUITE["compile"]["compile_SpMV"] = @benchmarkable begin
        y, A, x = ($y, $A, $x)
        Finch.execute_code(:ex, typeof(Finch.@finch_program_instance @loop i j y[i] += A[i, j] * x[i]))
    end
end

code = """
using Finch
A = @fiber d(sl(e(0.0)))
B = @fiber d(sl(e(0.0)))
C = @fiber d(sl(e(0.0)))

@finch @loop i j k C[i, j] += A[i, k] * B[j, k]
"""
cmd = pipeline(`$(Base.julia_cmd()) --project=$(Base.active_project()) --eval $code`, stdout = IOBuffer())

SUITE["compile"]["time_to_first_SpGeMM"] = @benchmarkable run(cmd)

let
    A = @fiber d(sl(e(0.0)))
    B = @fiber d(sl(e(0.0)))
    C = @fiber d(sl(e(0.0)))

    SUITE["compile"]["compile_SpGeMM"] = @benchmarkable begin   
        A, B, C = ($A, $B, $C)
        Finch.execute_code(:ex, typeof(Finch.@finch_program_instance @loop i j k C[i, j] += A[i, k] * B[j, k]))
    end
end

SUITE["embed"] = BenchmarkGroup()

libembedbenchmarks_file = joinpath(@__DIR__, "libembedbenchmarks.so")
if isfile(libembedbenchmarks_file)
    Base.Libc.Libdl.dlopen(libembedbenchmarks_file)

    ccall((:benchmarks_initialize, "libembedbenchmarks.so"), Cvoid, ())

    function sample_spmv_tiny((), params::BenchmarkTools.Parameters)
        evals = params.evals
        sample_time = ccall((:benchmark_spmv_tiny, "libembedbenchmarks.so"), Clong, (Cint,), evals)
        time = max((sample_time / evals) - params.overhead, 0.001)
        gctime = memory = allocs = return_val = 0
        return time, gctime, memory, allocs, return_val
    end

    SUITE["embed"]["spmv_tiny"] = BenchmarkTools.Benchmark(sample_spmv_tiny, (), BenchmarkTools.Parameters())

    #TODO how to call this at the right time?
    #println(ccall((:benchmarks_finalize, "libembedbenchmarks.so"), Cvoid, ()))
end

SUITE["graphs"] = BenchmarkGroup()

function pagerank(edges; nsteps=20, damp = 0.85)
    (n, m) = size(edges)
    @assert n == m
    out_degree = @fiber d(e(0))
    @finch @loop i j out_degree[j] += edges[i, j]
    scaled_edges = @fiber d(sl(e(0.0)))
    @finch @loop i j scaled_edges[i, j] = ifelse(out_degree[i] != 0, edges[i, j] / out_degree[j], 0)
    r = @fiber d(n, e(0.0))
    @finch @loop j r[j] += $(1.0/n)
    rank = @fiber d(n, e(0.0))
    beta_score = (1 - damp)/n

    for step = 1:nsteps
        @finch @loop i j rank[i] += edges[i, j] * r[j]
        @finch @loop i r[i] = $beta_score + $damp * rank[i]
    end
    return r
end

SUITE["graphs"]["pagerank"] = BenchmarkGroup()
for mtx in ["SNAP/soc-Epinions1", "SNAP/soc-LiveJournal1"]
    SUITE["graphs"]["pagerank"][mtx] = @benchmarkable pagerank($(fiber(SparseMatrixCSC(matrixdepot(mtx))))) 
end

function bfs(edges, source=5)
    (n, m) = size(edges)

    @assert n == m
    F_in = @fiber sl(n, e(0))
    F_out = @fiber sl(n, e(0))
    F_tmp = @fiber sl(n, e(0))
    @finch @loop j F_in[j] = (j == $source)

    P_in = @fiber d(n, e(0))
    P_out = @fiber d(n, e(0))
    P_tmp = @fiber d(n, e(0))
    @finch @loop j P_in[j] = (j == $source) * (0 - 2) + (j != $source) * (0 - 1)

    V = @fiber d(n, e(0))
    B = @fiber d(n, e(0))
    w = Scalar{0}()

    while !iszero(F_in.lvl.lvl.val)
        @finch @loop j V[j] = (P_in[j] == (0 - 1))
    
        @finch (@loop j @loop k (begin
            F_out[j] <<or_>>= w[]
            B[j] <<choose>>= w[] * k
        end
            where (w[] = edges[j, k] * F_in[k] * V[j]) ) )
        
            @finch @loop j P_out[j] = choose(B[j], P_in[j])
       
        P_tmp = P_in
        P_in = P_out
        P_out = P_tmp

        F_tmp = F_in
        F_in = F_out
        F_out = F_tmp
    end

    return P_in
end

SUITE["graphs"]["bfs"] = BenchmarkGroup()
for mtx in ["SNAP/soc-Epinions1", "SNAP/soc-LiveJournal1"]
    SUITE["graphs"]["bfs"][mtx] = @benchmarkable bfs($(fiber(SparseMatrixCSC(matrixdepot(mtx))))) 
end

# For sssp we should probably compress priorityQ on both dimensions, since many entires in rowptr will be equal
# ( due to many rows being zero )
function sssp(weights, source=1)
    (n, m) = size(weights)
    @assert n == m
    P = n
    val = typemax(Int64)
    
    priorityQ_in = @fiber d(P, sl(n, e(0)))
    priorityQ_out = @fiber d(P, sl(n, e(0)))
    tmp_priorityQ = @fiber d(P, sl(n, e(0)))
    @finch @loop p (@loop j priorityQ_in[p, j] = (p == 1 && j == $source) + (p == $P && j != $source))

    dist_in = @fiber d(n, e($val))
    dist_out = @fiber d(n, e($val))
    tmp_dist = @fiber d(n, e($val))
    @finch @loop j dist_in[j] = ifelse(j == $source, 0, $val)

    B = @fiber d(n, e($val))
    slice = @fiber d(n, e(0))
    priority = 1

    while !iszero(priorityQ_in.lvl.lvl.lvl.val) && priority <= P

        @finch @loop j slice[j] = priorityQ_in[$priority, j]

        while !iszero(slice.lvl.lvl.val) 
            @finch @loop j (@loop k B[j] <<min>>= ifelse(weights[j, k] * priorityQ_in[$priority, k] != 0, weights[j, k] + dist_in[k], $val))
            @finch @loop j dist_out[j] = min(B[j], dist_in[j])
            @finch @loop j (@loop k priorityQ_out[j, k] = (dist_in[k] > dist_out[k]) * (dist_out[k] == j-1) + (dist_in[k] == dist_out[k] && j != $priority) * priorityQ_in[j, k])
            @finch @loop j slice[j] = priorityQ_out[$priority, j]
            
            tmp_dist = dist_in
            dist_in = dist_out
            dist_out = tmp_dist

            tmp_priorityQ = priorityQ_in
            priorityQ_in = priorityQ_out
            priorityQ_out = tmp_priorityQ
        end

        priority += 1
    end 
    
    return dist_in
end

SUITE["graphs"]["sssp"] = BenchmarkGroup()
for mtx in ["SNAP/soc-Epinions1", "SNAP/soc-LiveJournal1"]
    SUITE["graphs"]["sssp"][mtx] = @benchmarkable sssp($(fiber(SparseMatrixCSC(matrixdepot(mtx))))) 
end

foreach(((k, v),) -> BenchmarkTools.warmup(v), SUITE)