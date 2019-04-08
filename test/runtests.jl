import WebFuncs
import UUIDs
using Test

f = d -> sqrt(d["a"])
f1 = d -> d["a"] * d["a"]
fadd = d -> d["a"] + d["a"]

input_f = Dict("a" => 0.42)
test_input = Dict("a" => 4)

@test length(WebFuncs.Mapping()) == 0

m = WebFuncs.Mapping()
u = WebFuncs.expose!(m, f, Dict{String,Number})
@test UUIDs.uuid_version(u) == 4
@test length(m) == 1

multi_func_map = WebFuncs.Mapping()
ids = WebFuncs.expose!(multi_func_map, [f, f1], Dict{String,Number})
@test length(ids) == 2
@test length(multi_func_map) == 2
## expose preserves order, first func should be sqrt
@test multi_func_map[ids[1]].func(test_input) ≈ 2
@test multi_func_map[ids[2]].func(test_input) ≈ 16		

multi_func_types = WebFuncs.Mapping()
ids2 = WebFuncs.expose!(
	multi_func_types, 
	[fadd, fadd]::Vector{<:Function},
	[Dict{String,Int}, Dict{String,Real}],
)


@test multi_func_types[ids2[1]].func(test_input) == 8
@test multi_func_types[ids2[2]].func(input_f) ≈ 0.84
