# Prescribed extra actions for the ten high-rank cases using the same
# primitive-extension search. No. 42 uses a different finite gluing search.
# The rank-two Gram/action entries below are rows 1,3,4,7,8 of the original
# build_lattice_156.jl, copied in row-vector convention. S is read afresh
# from oscar/list_S.txt; cases 1,5,7,14 are read from oscar/input.jl.
# No. 11 uses list_S.txt #8 and the ternary T Gram from the original
# run_rank19_generic_index_two.jl / verify_rank19_easy_sources.jl.

const hr_project = normpath(joinpath(@__DIR__, "..", "..", ".."))

const hr_specs = Dict{Int,Any}(
    1  => (source=:reference, source_index=1, rank_S=20, rank_T=2,
           T_gram=[-6,-3,-3,-6], T_action=[0,1,-1,1],
           index=6, dimension=0, symplectic_order=29160,
           group_id=nothing, gluing_index=nothing),
    3  => (source=:reference, source_index=2, rank_S=20, rank_T=2,
           T_gram=[-2,-1,-1,-18], T_action=[-1,0,0,-1],
           index=2, dimension=0, symplectic_order=2520,
           group_id=nothing, gluing_index=nothing),
    4  => (source=:reference, source_index=3, rank_S=20, rank_T=2,
           T_gram=[-6,0,0,-6], T_action=[0,1,-1,0],
           index=4, dimension=0, symplectic_order=1944,
           group_id=nothing, gluing_index=nothing),
    7  => (source=:reference, source_index=5, rank_S=20, rank_T=2,
           T_gram=[-22,-11,-11,-22], T_action=[-1,1,-1,0],
           index=3, dimension=0, symplectic_order=660,
           group_id=(1980,57), gluing_index=nothing),
    8  => (source=:reference, source_index=6, rank_S=20, rank_T=2,
           T_gram=[-10,-5,-5,-10], T_action=[0,1,-1,1],
           index=6, dimension=0, symplectic_order=360,
           group_id=nothing, gluing_index=nothing),
    9  => (source=:case, source_index=1, rank_S=19, rank_T=3,
           T_gram=nothing, T_action=nothing,
           index=2, dimension=1, symplectic_order=972,
           group_id=(1944,3536), gluing_index=54),
    11 => (source=:reference, source_index=8, rank_S=19, rank_T=3,
           T_gram=[20,0,0,0,-2,-1,0,-1,-2], T_action=nothing,
           index=2, dimension=1, symplectic_order=360,
           group_id=(720,763), gluing_index=60),
    16 => (source=:case, source_index=5, rank_S=19, rank_T=3,
           T_gram=nothing, T_action=nothing,
           index=2, dimension=1, symplectic_order=120,
           group_id=(240,189), gluing_index=100),
    19 => (source=:case, source_index=7, rank_S=19, rank_T=3,
           T_gram=nothing, T_action=nothing,
           index=2, dimension=1, symplectic_order=72,
           group_id=(144,186), gluing_index=108),
    34 => (source=:case, source_index=14, rank_S=18, rank_T=4,
           T_gram=nothing, T_action=nothing,
           index=2, dimension=2, symplectic_order=36,
           group_id=(72,40), gluing_index=nothing),
)

function hr_source_path(spec)
    name = spec.source == :reference ? "list_S.txt" : "input.jl"
    return joinpath(hr_project, "oscar", name)
end

function hr_check_numbering(n,spec)
    path = joinpath(hr_project,"remark","input","family_numbering.md")
    rows = filter(line->startswith(line,"| $n |"),readlines(path))
    length(rows) == 1 || error("Numbered family row is missing or ambiguous")
    cells = strip.(split(only(rows),'|';keepempty=false))
    length(cells) == 8 || error("Numbering table format changed")
    parse(Int,cells[2]) == spec.rank_S || error("Numbered rank differs")
    parse(Int,cells[4]) == spec.index || error("Numbered generic index differs")
    parse(Int,cells[5]) == spec.index || error("Numbered index differs")
    parse(Int,cells[6]) == spec.dimension || error("Numbered dimension differs")
    if spec.group_id !== nothing
        cells[7] == "`[$(spec.group_id[1]),$(spec.group_id[2])]`" ||
            error("Numbered projective group ID differs")
    end
    return nothing
end

# Parse only the selected expression, as in the original runners. Loading
# the complete 29-case expression would evaluate unrelated large inputs.
function hr_source_expression(spec)
    path = hr_source_path(spec)
    if spec.source == :reference
        lines = readlines(path)
        markers = findall(==("#$(spec.source_index)"), strip.(lines))
        length(markers) == 1 || error("Reference S marker is not unique")
        return Meta.parse(strip(lines[only(markers)+1]))
    end
    spec.source == :case || error("Unknown input source")
    parsed = Meta.parseall(read(path, String))
    assignments = [ex for ex in parsed.args if ex isa Expr &&
        ex.head == :(=) && ex.args[1] == :cases]
    length(assignments) == 1 || error("Input cases assignment is not unique")
    tuples = only(assignments).args[2]
    tuples isa Expr && tuples.head == :tuple && length(tuples.args) == 29 ||
        error("Original 29-case input order changed")
    return tuples.args[spec.source_index]
end

# Called only after OSCAR and oscar_script.jl have been loaded.
function hr_inputs(spec)
    selected = Core.eval(@__MODULE__, hr_source_expression(spec))
    if spec.source == :reference
        S = integer_lattice(; gram=selected)
        T = integer_lattice(; gram=matrix(ZZ,spec.rank_T,spec.rank_T,spec.T_gram))
        fT = spec.T_action === nothing ? -identity_matrix(QQ,spec.rank_T) :
            matrix(QQ,spec.rank_T,spec.rank_T,spec.T_action)
    else
        S,T = selected[1],selected[2]
        fT = -identity_matrix(QQ,spec.rank_T)
    end
    rank(S) == spec.rank_S && signature_tuple(S) == (spec.rank_S,0,0) ||
        error("Unexpected S input")
    rank(T) == spec.rank_T && signature_tuple(T) == (spec.rank_T-2,0,2) ||
        error("Unexpected T input")
    Tf = integer_lattice_with_isometry(T,fT;
        ambient_representation=false, check=true)
    Int(order_of_isometry(Tf)) == spec.index || error("Unexpected T-action order")
    period_dimension(T,spec.index) == spec.dimension ||
        error("Unexpected period dimension")
    if spec.gluing_index !== nothing
        glue_order_to_disc3(S,T) == spec.gluing_index ||
            error("Unexpected gluing index")
    end
    return S,T,Tf
end
