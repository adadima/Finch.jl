using Finch
using Finch.IndexNotation
using Finch: execute_code_lowered
using RewriteTools
using BenchmarkTools
using SparseArrays
using LinearAlgebra

or(x,y) = x == 1|| y == 1

function choose(x, y)
    if x != 0
        return x
    else
        return y
    end
end

@slots a b c d e i j Finch.add_rules!([
    (@rule @i(@chunk $i a (b[j...] <<min>>= $d)) => if Finch.isliteral(d) && i ∉ j
        @i (b[j...] <<min>>= $d)
    end),

    (@rule @i(@chunk $i a @multi b... (c[j...] <<min>>= $d) e...) => begin
        if Finch.isliteral(d) && i ∉ j
            @i @multi (c[j...] <<min>>= $d) @chunk $i a @i(@multi b... e...)
        end
    end),

    (@rule @i(@chunk $i a (b[j...] <<$or>>= $d)) => if Finch.isliteral(d) && i ∉ j
        @i (b[j...] <<$or>>= $d)
    end),

    (@rule @i(@chunk $i a @multi b... (c[j...] <<$or>>= $d) e...) => begin
        if Finch.isliteral(d) && i ∉ j
            @i @multi (c[j...] <<$or>>= $d) @chunk $i a @i(@multi b... e...)
        end
    end),
])

Finch.register()

function F_init(F, source)
    @index @loop j F[j] = (j == $source)
end

function P_init(P, source)
    @index @loop j P[j] = (j == $source) * (0 - 2) + (j != $source) * (0 - 1)
end

function V_func(V_out, P_in)
    @index @loop j V_out[j] = (P_in[j] == (0 - 1))
end

# initial value for or is 0; tensor is by default initialized to 0
function F_out_func(F_out, edges, F_in, V_out)
    @index @loop j k F_out[j] <<$or>>= edges[j, k] * F_in[k] * V_out[j]
end

# initial value for choose is P_in[j]
function P_out_func(P_out, edges, F_in, V_out, P_in, N)
    B = Finch.Fiber(
        Solid(N,
            Element{0, Cint}([])
        )
    )
    @index @loop j k B[j] <<$choose>>= edges[j, k] * F_in[k] * V_out[j] * k
    println("B: ")
    println(B.lvl.lvl.val)
    @index @loop j P_out[j] = $choose(B[j], P_in[j])
end

function main()
    N = 5
    source = 5
    F = Finch.Fiber(
        Solid(N,
        Element{0, Cint}([]))
    );
    
    F_init(F, source);
    println("F_in:")
    println(F.lvl.lvl.val)

    P = Finch.Fiber(
        Solid(N,
        Element{0, Cint}([]))
    );
    P_init(P, source);
    println("P_in:")
    println(P.lvl.lvl.val)

    V_out = Finch.Fiber(
        Solid(N,
        Element{0, Cint}([]))
    );
    V_func(V_out, P);
    println("V_out:")
    println(V_out.lvl.lvl.val)

    edge_vector = Cint[0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    edges = Finch.Fiber(
        Solid(N,
                Solid(N,
                    Element{0, Cint}(edge_vector)
                )
            )
    )
    println("Edges:")
    println(edges.lvl.lvl.lvl.val)

    F_out = Finch.Fiber(
        Solid(N,
        Element{0, Cint}([]))
    );
    F_out_func(F_out, edges, F, V_out);
    println("F_out:")
    println(F_out.lvl.lvl.val)

    P_out = Finch.Fiber(
        Solid(N,
        Element{0, Cint}([]))
    );
    P_out_func(P_out, edges, F, V_out, P, N)
    println("P_out:")
    println(P_out.lvl.lvl.val)
end

main()