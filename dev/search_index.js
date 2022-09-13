var documenterSearchIndex = {"docs":
[{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"CurrentModule = Finch","category":"page"},{"location":"getting_started/#Finch","page":"Getting Started","title":"Finch","text":"","category":"section"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"Finch is an adaptable compiler for loop nests over structured arrays. Finch can specialize to tensors with runs of repeated values, or to tensors which are sparse (mostly zero). Finch supports general sparsity as well as many specialized sparsity patterns, like clustered nonzeros, diagonals, or triangles.  In addition to zero, Finch supports optimizations over arbitrary fill values and operators.","category":"page"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"At it's heart, Finch is powered by a domain specific language for coiteration, breaking structured iterators into units we call Looplets. The Looplets are lowered progressively, leaving several opportunities to rewrite and simplify intermediate expressions.","category":"page"},{"location":"getting_started/#Installation:","page":"Getting Started","title":"Installation:","text":"","category":"section"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"julia> using Pkg; Pkg.add(\"Finch\")","category":"page"},{"location":"getting_started/#Quick-start-guide","page":"Getting Started","title":"Quick start guide","text":"","category":"section"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"You can convert an AbstractArray to a Finch Fiber with the fiber function:","category":"page"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"julia> using Finch, SparseArrays\n\njulia> A = fiber(sprand(5, 6, 0.5))\nDense [1:5]\n│ \n├─[1]:\n│ SparseList (0.0) [1:6]\n│ │ \n│ └─[1]      [3]    \n│   0.758513 0.65606\n│ \n├─[2]:\n│ SparseList (0.0) [1:6]\n│ │ \n│ └─[2]      [5]     \n│   0.103387 0.103223\n│ \n├─[3]:\n│ SparseList (0.0) [1:6]\n│ │ \n│ └─[1]      [2]     \n│   0.653705 0.225958\n│ \n├─[4]:\n│ SparseList (0.0) [1:6]\n│ │ \n│ └─[1]      [2]      [4]      [5]     \n│   0.918955 0.898256 0.444113 0.843331\n│ \n├─[5]:\n│ SparseList (0.0) [1:6]\n│ │ \n│ └─[4]      \n│   0.0701716\n\n\njulia> A(1, 3)\n0.65605977333406\n\njulia> A(1, 2)\n0.0","category":"page"},{"location":"getting_started/","page":"Getting Started","title":"Getting Started","text":"Arrays in finch are stored using a recursive tree-based approach. ","category":"page"},{"location":"embed/","page":"Embedding","title":"Embedding","text":"CurrentModule = Finch","category":"page"},{"location":"embed/#Public-Functions","page":"Embedding","title":"Public Functions","text":"","category":"section"},{"location":"embed/","page":"Embedding","title":"Embedding","text":"Finch.h.FINCH_SCOPE\nFinch.h.finch_escape\nFinch.h.finch_eval\nFinch.h.finch_consume_vector\nFinch.h.finch_free\nFinch.h.finch_mirror_vector\nFinch.h.finch_initialize\nFinch.h.finch_root\nFinch.h.finch_exec\nFinch.h.finch_T\nFinch.h.finch_call\nFinch.h.finch_finalize","category":"page"},{"location":"embed/#Finch.h.FINCH_SCOPE","page":"Embedding","title":"Finch.h.FINCH_SCOPE","text":"FINCH_SCOPE([stmt])\n\nExecute the statement stmt in a new finch scope. All finch objects allocated within this scope will be freed when the scope is closed, unless passed to finch_escape to pass them to the parent scope. The user must not use return or break to leave stmt.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_escape","page":"Embedding","title":"Finch.h.finch_escape","text":"jl_value_t* finch_escape(jl_value_t* var)\n\nRemoves var from the current scope and registers it with the parent scope. This meansvar will not be freed when the current scope is closed.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_eval","page":"Embedding","title":"Finch.h.finch_eval","text":"jl_value_t* finch_eval(const char* proc)\n\nEvaluate the Julia code represented by the string proc at global scope in the Main module.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_consume_vector","page":"Embedding","title":"Finch.h.finch_consume_vector","text":"jl_value_t* finch_consume_vector(jl_datatype_t* type, void* ptr, int len);\n\nCreate a Julia array with elements of datatype type from the pointer ptr. The array will be of length len, no copying will be performed, and Finch may call free(ptr).\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_free","page":"Embedding","title":"Finch.h.finch_free","text":"void finch_free(jl_value_t* var)\n\nUnregister the Finch-tracked object var within the current scope to allow the garbage collector to free memory. This method should be avoided in favor of using FINCH_SCOPE to limit the lifetime of objects.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_mirror_vector","page":"Embedding","title":"Finch.h.finch_mirror_vector","text":"jl_value_t* finch_mirror_vector(jl_datatype_t* type, void* ptr, int len);\n\nCreate a Julia array with elements of datatype type from the pointer ptr. The array will be of length len, no copying will be performed, and Finch may not call free(ptr).\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_initialize","page":"Embedding","title":"Finch.h.finch_initialize","text":"void finch_initialize()\n\nInitialize Finch. Should be called only once before any other finch calls, from the executable.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_root","page":"Embedding","title":"Finch.h.finch_root","text":"jl_value_t* finch_root(jl_value_t* var)\n\nRegister the Julia-allocated object var with Finch on the current scope to avoid garbage collecting it.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_exec","page":"Embedding","title":"Finch.h.finch_exec","text":"jl_value_t* finch_exec(const char* proc, jl_value_t* args...)\n\nEvaluate the Julia code represented by the string proc at local scope in the Main module.  proc can optionally contain format specifiers to interpolate julia arguments.  Format specifiers should be either %s for a julia input or %% for a literal % character. For example,\n\n    finch_exec(\"%s + %s\", x, y)\n\nshould evaluate to x + y\n\nfinch_exec caches inputs by their string to avoid repeated compilation.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_T","page":"Embedding","title":"Finch.h.finch_T","text":"void finch_[T](S x);\n\nCreate a Julia object of type T from corresponding C object x of type S.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_call","page":"Embedding","title":"Finch.h.finch_call","text":"jl_value_t* finch_call(jl_value_t* f, jl_value_t* args...)\n\nCall the Julia function f on the arguments args and return the result. This is a macro that counts the number of arguments.\n\n\n\n\n\n","category":"function"},{"location":"embed/#Finch.h.finch_finalize","page":"Embedding","title":"Finch.h.finch_finalize","text":"void finch_finalize()\n\nFinalize Finch. Should be called at the end of the program to allow Finch to cleanup.\n\n\n\n\n\n","category":"function"},{"location":"listing/","page":"The Deets","title":"The Deets","text":"CurrentModule = Finch","category":"page"},{"location":"listing/#Public-Functions","page":"The Deets","title":"Public Functions","text":"","category":"section"},{"location":"listing/","page":"The Deets","title":"The Deets","text":"Modules = [Finch]","category":"page"},{"location":"listing/#Finch.Environment","page":"The Deets","title":"Finch.Environment","text":"Environment([parent]; kwargs...)\n\nAn environment can be thought of as the argument to a level that yeilds a fiber. Environments also allow parents levels to pass attributes to their children.\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.Fiber","page":"The Deets","title":"Finch.Fiber","text":"Fiber(lvl, env=Environment())\n\nA fiber is a combination of a (possibly nested) level lvl and an environment env. The environment is often used to refer to a particular fiber within the level. Fibers are arrays, of sorts. The function refindex(fbr, i...) is used as a reference implementation of getindex for the fiber. Accessing an N-dimensional fiber with less than N indices will return another fiber.\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.Finalize","page":"The Deets","title":"Finch.Finalize","text":"Finalize(ctx)\n\nA transformation to finalize output tensors before they leave scope and are returned to the caller.\n\nSee also: finalize!\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.Initialize","page":"The Deets","title":"Finch.Initialize","text":"Initialize(ctx)\n\nA transformation to initialize tensors that have just entered into scope.\n\nSee also: initialize!\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.LowerJulia-Tuple{Any, Finch.DimensionalizeStyle}","page":"The Deets","title":"Finch.LowerJulia","text":"TODO out of date     dimensionalize!(prgm, ctx)\n\nA program traversal which gathers dimensions of tensors based on shared indices. Index sharing is transitive, so A[i] = B[i] and B[j] = C[j] will induce a gathering of the dimensions of A, B, and C into one. The resulting dimensions are gathered into a Dimensions object, which can be accesed with an index name or a (tensor_name, mode_name) tuple.\n\nThe program is assumed to be in SSA form.\n\nSee also: getsize, getsites, combinedim, TransformSSA\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.TransformSSA","page":"The Deets","title":"Finch.TransformSSA","text":"TransformSSA(freshen)\n\nA transformation of a program to SSA form. Fresh names will be generated with freshen(name).\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.VirtualEnvironment","page":"The Deets","title":"Finch.VirtualEnvironment","text":"VirtualEnvironment([parent]; kwargs...)\n\nIn addition to holding information about the environment instance itself, virtual environments may also hold information about the scope that this fiber lives in.\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.VirtualFiber","page":"The Deets","title":"Finch.VirtualFiber","text":"VirtualFiber(lvl, env)\n\nA virtual fiber is the avatar of a fiber for the purposes of compilation. Two fibers should share a name only if they hold the same data. lvl is a virtual object representing the level nest and env is a virtual object representing the environment.\n\n\n\n\n\n","category":"type"},{"location":"listing/#Finch.combinedim-Tuple{Any, Any}","page":"The Deets","title":"Finch.combinedim","text":"combinedim(a, b)\n\nCombine the two dimensions a and b.  To avoid ambiguity, only define one of\n\ncombinedim(::A, ::B)\ncombinedim(::B, ::A)\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.default","page":"The Deets","title":"Finch.default","text":"default(fbr)\n\nThe default for a fiber is the value that each element of the fiber will have after initialization. This value is most often zero, and defaults to nothing.\n\nSee also: initialize!\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.envcoordinate-Tuple{Union{Finch.VirtualEnvironment, Finch.Environment}}","page":"The Deets","title":"Finch.envcoordinate","text":"envcoordinate(env)\n\nGet the coordinate (index) in the previous environment.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envdefaultcheck-Tuple{Any}","page":"The Deets","title":"Finch.envdefaultcheck","text":"envdefaultcheck(env)\n\nReturn a variable which should be set to false if the subfiber is not entirely default.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envdepth-Tuple{Any}","page":"The Deets","title":"Finch.envdepth","text":"envdepth()\n\nReturn the number of accesses (coordinates) unfurled so far in this environment.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envexternal-Tuple{Union{Finch.VirtualEnvironment, Finch.Environment}}","page":"The Deets","title":"Finch.envexternal","text":"envexternal(env)\n\nStrip environments which are internal to the level, leaving the parent environment of the level.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envname-Tuple{Any}","page":"The Deets","title":"Finch.envname","text":"envname()\n\nThe name of the tensor when it was last named.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envposition-Tuple{Any}","page":"The Deets","title":"Finch.envposition","text":"envposition(env)\n\nGet the position in the environment. The position is an integer identifying which fiber to access in a level.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.envreinitialized-Tuple{Any}","page":"The Deets","title":"Finch.envreinitialized","text":"envreinitialized(env)\n\ndid the previous level selectively initialize this one?\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:d}}","page":"The Deets","title":"Finch.f_code","text":"f_code(d) = DenseLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:e}}","page":"The Deets","title":"Finch.f_code","text":"f_code(e) = ElementLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:p}}","page":"The Deets","title":"Finch.f_code","text":"f_code(p) = PatternLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:rl}}","page":"The Deets","title":"Finch.f_code","text":"f_code(rl) = RepeatRLELevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:sc}}","page":"The Deets","title":"Finch.f_code","text":"f_code(sc) = SparseCooLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:sh}}","page":"The Deets","title":"Finch.f_code","text":"f_code(sh) = SparseHashLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:sl}}","page":"The Deets","title":"Finch.f_code","text":"f_code(l) = SparseListLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:sm}}","page":"The Deets","title":"Finch.f_code","text":"f_code(sm) = SparseBytemapLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.f_code-Tuple{Val{:sv}}","page":"The Deets","title":"Finch.f_code","text":"f_code(sv) = SparseVBLLevel.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.ffindnz-Tuple{Any}","page":"The Deets","title":"Finch.ffindnz","text":"ffindnz(arr)\n\nReturn the nonzero elements of arr, as Finch understands arr. Returns (I, V), where I is a tuple of coordinate vectors, one for each mode of arr, and V is a vector of corresponding nonzero values, which can be passed to fsparse.\n\nSee also: (findnz)(https://docs.julialang.org/en/v1/stdlib/SparseArrays/#SparseArrays.findnz)\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.fiber","page":"The Deets","title":"Finch.fiber","text":"fiber(arr, default = zero(eltype(arr)))\n\nCopies an array-like object arr into a corresponding, similar Fiber datastructure. default is the default value to use for initialization and sparse compression.\n\nSee also: fiber!\n\nExamples\n\njulia> println(summary(fiber(sparse([1 0; 0 1]))))\n2×2 @fiber(d(sl(e(0))))\n\njulia> println(summary(fiber(ones(3, 2, 4))))\n3×2×4 @fiber(d(d(d(e(0.0)))))\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.fiber!","page":"The Deets","title":"Finch.fiber!","text":"fiber!(arr, default = zero(eltype(arr)))\n\nLike fiber, copies an array-like object arr into a corresponding, similar Fiber datastructure. However, fiber! reuses memory whenever possible, meaning arr may be rendered unusable.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.finalize!-Tuple{Finch.VirtualFiber, Finch.LowerJulia, Any, Vararg{Any}}","page":"The Deets","title":"Finch.finalize!","text":"finalize!(fbr, ctx, mode, idxs...)\n\nFinalize the virtual fiber in the context ctx with access mode mode. Return the new fiber object.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.finalize_level!","page":"The Deets","title":"Finch.finalize_level!","text":"finalize_level!(fbr, ctx, mode)\n\nFinalize the level within the virtual fiber. These are the bulk cleanup steps.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.fsparse","page":"The Deets","title":"Finch.fsparse","text":"fsparse(I::Tuple, V,[ M::Tuple, combine])\n\nCreate a sparse COO fiber S such that size(S) == M and S[(i[q] for i = I)...] = V[q]. The combine function is used to combine duplicates. If M is not specified, it is set to map(maximum, I). If the combine function is not supplied, combine defaults to + unless the elements of V are Booleans in which case combine defaults to |. All elements of I must satisfy 1 <= I[n][q] <= M[n].  Numerical zeros are retained as structural nonzeros; to drop numerical zeros, use dropzeros!.\n\nSee also: sparse\n\nExamples\n\njulia> I = (     [1, 2, 3],     [1, 2, 3],     [1, 2, 3]);\n\njulia> V = [1.0; 2.0; 3.0];\n\njulia> fsparse(I, V) SparseCoo (0.0) [1:3×1:3×1:3] │ │ │  └─└─└─[1, 1, 1] [2, 2, 2] [3, 3, 3]       1.0       2.0       3.0    \n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.fsparse!","page":"The Deets","title":"Finch.fsparse!","text":"fsparse!(I::Tuple, V,[ M::Tuple])\n\nLike fsparse, but the coordinates must be sorted and unique, and memory is reused.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.fsprand-Tuple{Tuple, Vararg{Any}}","page":"The Deets","title":"Finch.fsprand","text":"fsprand([rng],[type], m::Tuple,p::AbstractFloat,[rfn])\n\nCreate a random sparse tensor of size m in COO format, in which the probability of any element being nonzero is independently given by p (and hence the mean density of nonzeros is also exactly p). Nonzero values are sampled from the distribution specified by rfn and have the type type. The uniform distribution is used in case rfn is not specified. The optional rng argument specifies a random number generator.\n\nSee also: (sprand)(https://docs.julialang.org/en/v1/stdlib/SparseArrays/#SparseArrays.sprand)\n\nExamples\n\njulia> fsprand(Bool, (3, 3), 0.5)\nSparseCoo (false) [1:3×1:3]\n│ │\n└─└─[1, 1] [1, 3] [2, 2] [2, 3] [3, 3]\n    true   true   true   true   true  \n\njulia> fsprand(Float64, (2, 2, 2), 0.5)\nSparseCoo (0.0) [1:2×1:2×1:2]\n│ │ │\n└─└─└─[1, 2, 2] [2, 1, 1] [2, 1, 2]\n      0.647855  0.996665  0.749194 \n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.fspzeros-Tuple{Any}","page":"The Deets","title":"Finch.fspzeros","text":"fspzeros([type], shape::Tuple)\n\nCreate a random zero tensor of size m, with elements of type type. The tensor is in COO format.\n\nSee also: (spzeros)(https://docs.julialang.org/en/v1/stdlib/SparseArrays/#SparseArrays.spzeros)\n\nExamples\n\njulia> fspzeros(Bool, (3, 3))\nSparseCoo (false) [1:3×1:3]\n│ │\n└─└─\n    \njulia> fspzeros(Float64, (2, 2, 2))\nSparseCoo (0.0) [1:2×1:2×1:2]\n│ │ │\n└─└─└─\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.getdefaultcheck-Tuple{Any}","page":"The Deets","title":"Finch.getdefaultcheck","text":"getdefaultcheck(env)\n\nReturn a variable which should be set to false if the subfiber is not entirely default.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.getname","page":"The Deets","title":"Finch.getname","text":"getname(ex)\n\nReturn the name of the index expression ex. The name serves as a unique identifier and often corresponds to the variable name which holds a tensor. Tensors can have the same name only if they are === to each other. The names of indices are used to distinguish the loops they reference.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.getresults","page":"The Deets","title":"Finch.getresults","text":"getresults(stmt)\n\nReturn an iterator over the result tensors of an index expression. For example, where statements return the results of the consumer, not the producer, and assignments return their left hand sides.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.getsites","page":"The Deets","title":"Finch.getsites","text":"getsites(tns)\n\nReturn an iterable over the identities of the modes of tns. If tns_2 is a transpose of tns, then getsites(tns_2) should be a permutation of getsites(tns) corresponding to the order in which modes have been permuted.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.getsize","page":"The Deets","title":"Finch.getsize","text":"getsize(tns, ctx, mode)\n\nReturn an iterable over the dimensions of tns in the context ctx with access mode mode. This is a function similar in spirit to Base.axes.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.getunbound-Tuple{Any}","page":"The Deets","title":"Finch.getunbound","text":"getunbound(stmt)\n\nReturn an iterator over the names in an index expression that have yet to be bound.\n\njulia> getunbound(@finch_program @loop i :a[i, j] += 2)\n[j]\njulia> getunbound(@finch_program i + j * 2 * i)\n[i, j]\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.getvalue-Tuple{Any}","page":"The Deets","title":"Finch.getvalue","text":"getvalue(ex)\n\nIf isliteral(ex) is true, return the value of ex. Defaults to the identity.\n\nSee also: isliteral\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.hasdefaultcheck-Tuple{Any}","page":"The Deets","title":"Finch.hasdefaultcheck","text":"hasdefaultcheck(lvl)\n\nCan the level check whether it is entirely default?\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.initialize!-Tuple{Finch.VirtualFiber, Finch.LowerJulia, Any, Vararg{Any}}","page":"The Deets","title":"Finch.initialize!","text":"initialize!(fbr, ctx, mode)\n\nInitialize the virtual fiber to it's default value in the context ctx with access mode mode. Return the new fiber object.\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.initialize_level!","page":"The Deets","title":"Finch.initialize_level!","text":"initialize_level!(fbr, ctx, mode)\n\nInitialize the level within the virtual fiber to it's default value in the context ctx with access mode mode. Return the new level.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.interval_assembly_depth-Tuple{Any}","page":"The Deets","title":"Finch.interval_assembly_depth","text":"interval_assembly_depth(lvl)\n\nto what depth will the level tolerate interval environment properties for assembly?\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.isliteral-Tuple{Any}","page":"The Deets","title":"Finch.isliteral","text":"isliteral(ex)\n\nReturn a boolean indicating whether the expression is a literal. If an expression is a literal, getvalue(ex) should return the literal value it corresponds to. getvalue defaults to the identity.\n\nSee also: getvalue\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.pattern!-Tuple{Fiber}","page":"The Deets","title":"Finch.pattern!","text":"pattern!(fbr)\n\nReturn the pattern of fbr. That is, return a fiber which is true wherever fbr is structurally unequal to it's default. May reuse memory and render the original fiber unusable when modified.\n\njulia> A = Finch.Fiber(SparseList(10, [1, 6], [1, 3, 5, 7, 9], Element{0.0}([2.0, 3.0, 4.0, 5.0, 6.0])))\nSparseList (0.0) [1:10]\n│ \n└─[1] [3] [5] [7] [9]\n  2.0 3.0 4.0 5.0 6.0\n\njulia> pattern!(A)\nSparseList (false) [1:10]\n│ \n└─[1]  [3]  [5]  [7]  [9] \n  true true true true true\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.reinitializeable-Tuple{Any}","page":"The Deets","title":"Finch.reinitializeable","text":"reinitializeable(lvl)\n\nDoes the level support selective initialization through assembly?\n\n\n\n\n\n","category":"method"},{"location":"listing/#Finch.setname","page":"The Deets","title":"Finch.setname","text":"setname(ex, name)\n\nReturn a new expression, identical to ex, with the name name.\n\n\n\n\n\n","category":"function"},{"location":"listing/#Finch.@fiber-Tuple{Any}","page":"The Deets","title":"Finch.@fiber","text":"@fiber ctr\n\nConstruct a fiber using abbreviated fiber constructor codes. All function names in ctr must be format codes, but expressions may be interpolated with $. As an example, a csr matrix which might be constructed as Fiber(DenseLevel(SparseListLevel(Element{0.0}(...)))) can also be constructed as @fiber(sl(d(e(0.0)))). Consult the documentation for the helper function f_code for a full listing of format codes.\n\n\n\n\n\n","category":"macro"},{"location":"level/","page":"Level Formats","title":"Level Formats","text":"CurrentModule = Finch","category":"page"},{"location":"level/#Public-Functions","page":"Level Formats","title":"Public Functions","text":"","category":"section"},{"location":"level/","page":"Level Formats","title":"Level Formats","text":"fiber\nfiber!\nsparse\nsparse!","category":"page"},{"location":"level/#Finch.fiber","page":"Level Formats","title":"Finch.fiber","text":"fiber(arr, default = zero(eltype(arr)))\n\nCopies an array-like object arr into a corresponding, similar Fiber datastructure. default is the default value to use for initialization and sparse compression.\n\nSee also: fiber!\n\nExamples\n\njulia> println(summary(fiber(sparse([1 0; 0 1]))))\n2×2 @fiber(d(sl(e(0))))\n\njulia> println(summary(fiber(ones(3, 2, 4))))\n3×2×4 @fiber(d(d(d(e(0.0)))))\n\n\n\n\n\n","category":"function"},{"location":"level/#Finch.fiber!","page":"Level Formats","title":"Finch.fiber!","text":"fiber!(arr, default = zero(eltype(arr)))\n\nLike fiber, copies an array-like object arr into a corresponding, similar Fiber datastructure. However, fiber! reuses memory whenever possible, meaning arr may be rendered unusable.\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = Finch","category":"page"},{"location":"#Finch","page":"Home","title":"Finch","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Finch is an adaptable compiler for loop nests over structured arrays. Finch can specialize to tensors with runs of repeated values, or to tensors which are sparse (mostly zero). Finch supports general sparsity as well as many specialized sparsity patterns, like clustered nonzeros, diagonals, or triangles.  In addition to zero, Finch supports optimizations over arbitrary fill values and operators.","category":"page"},{"location":"","page":"Home","title":"Home","text":"At it's heart, Finch is powered by a domain specific language for coiteration, breaking structured iterators into units we call Looplets. The Looplets are lowered progressively, leaving several opportunities to rewrite and simplify intermediate expressions.","category":"page"},{"location":"#Installation:","page":"Home","title":"Installation:","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg; Pkg.add(\"Finch\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"Here's a few examples","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"}]
}