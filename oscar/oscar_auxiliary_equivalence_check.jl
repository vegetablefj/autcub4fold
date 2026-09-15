# Audit the M_9 and A_{3,3} search cases with number_of_data > 1.
#
# Usage when the tested OSCAR installation is in the default environment:
#   julia oscar_auxiliary_equivalence_check.jl [search_data] [audit_data]
# For a separate existing environment, add --project=/path/to/environment.
# See README.md for the recorded dependencies; no local project is supplied.
#
# The default input is oscar_script_data.mrdi.  The computed auxiliary
# extension classes and the assertions used to interpret them are saved in
# oscar_auxiliary_equivalence_data.mrdi.

include(joinpath(@__DIR__, "oscar_script.jl"))

data_file = isempty(ARGS) ?
    joinpath(@__DIR__, "oscar_script_data.mrdi") :
    abspath(ARGS[1])

audit_file = length(ARGS) < 2 ?
    joinpath(@__DIR__, "oscar_auxiliary_equivalence_data.mrdi") :
    abspath(ARGS[2])

isfile(data_file) || error("Result file not found: $data_file")

println("Loading saved OSCAR results from: $data_file")
data = load(data_file)

@assert data.format_version == 3
@assert data.completed_cases == 29
@assert length(data.cases) == 29

case_results(i) = begin
    c = data.cases[i]
    @assert c.number_of_results == length(c.results)
    c.results
end

action_trace(Lf) = begin
    M = isometry(Lf)
    sum(M[i, i] for i in 1:nrows(M))
end

# Recompute the primitive extensions of the fixed pair (K, (P, f_P)).
# The same primitive-extension, root, and stable-fitting routines are used as
# in the main search.  Here the equal-rank branch makes the saturatedness check
# automatic.  The returned objects are saved for later inspection.
function auxiliary_classes(r; label::String)
    K = r.K_in_Lambda0
    Pf = r.P_action

    println("$label: recomputing auxiliary primitive extensions...")
    flush(stdout)
    classes = lattice_data_for_T_action(K, Pf, r.order)
    println("$label: auxiliary class count = $(length(classes))")
    return classes
end

println()
println("Case 6: M_9")
m9 = case_results(6)
@assert length(m9) == 2
m9a, m9b = m9

@assert m9a.number_of_data == m9b.number_of_data == 2
@assert m9a.order == m9b.order == 3
@assert m9a.dimension == m9b.dimension == 0
@assert m9a.group_gap_id == m9b.group_gap_id == (216, 153)

@assert gram_matrix(m9a.K_in_Lambda0) != gram_matrix(m9b.K_in_Lambda0)
@assert is_isometric(m9a.K_in_Lambda0, m9b.K_in_Lambda0)
@assert gram_matrix(m9a.P_in_Lambda0) == gram_matrix(m9b.P_in_Lambda0)
@assert isometry(m9a.P_action) == isometry(m9b.P_action)
@assert isometry(m9a.T_action) == isometry(m9b.T_action)

m9_classes = auxiliary_classes(m9a; label="M_9")
m9_auxiliary_count = length(m9_classes)
@assert m9_auxiliary_count == 1
println("M_9: the two stored outputs represent one auxiliary class.")

println()
println("Case 23: A_{3,3}")
a33 = case_results(23)
@assert length(a33) == 2
a33a, a33b = a33

@assert a33a.number_of_data == a33b.number_of_data == 2
@assert a33a.order == a33b.order == 6
@assert a33a.dimension == a33b.dimension == 2
@assert a33a.group_gap_id == a33b.group_gap_id == (108, 38)

@assert gram_matrix(a33a.K_in_Lambda0) == gram_matrix(a33b.K_in_Lambda0)
@assert is_isometric(a33a.K_in_Lambda0, a33b.K_in_Lambda0)
@assert gram_matrix(a33a.P_in_Lambda0) == gram_matrix(a33b.P_in_Lambda0)
@assert isometry(a33a.P_action) == isometry(a33b.P_action)
@assert isometry(a33a.T_action) == isometry(a33b.T_action)
a33_traces = (
    action_trace(a33a.S_in_Lambda0),
    action_trace(a33b.S_in_Lambda0),
)
@assert a33_traces == (-4, -1)

a33_classes = auxiliary_classes(a33a; label="A_{3,3}")
a33_auxiliary_count = length(a33_classes)
@assert a33_auxiliary_count == 2
println("A_{3,3}: the distinct traces place the two outputs in the two auxiliary classes.")

audit_data = (
    format_version=1,
    source_data_file=basename(data_file),
    source_format_version=data.format_version,
    source_completed_cases=data.completed_cases,
    cases=(
        M_9=(
            source_case=6,
            source_result_records=length(m9),
            source_number_of_data=m9a.number_of_data,
            group_gap_id=m9a.group_gap_id,
            K_isometric=true,
            P_gram_equal=true,
            P_action_equal=true,
            T_action_equal=true,
            source_S_action_traces=(
                action_trace(m9a.S_in_Lambda0),
                action_trace(m9b.S_in_Lambda0),
            ),
            auxiliary_classes=Tuple(m9_classes),
            auxiliary_class_count=m9_auxiliary_count,
            conclusion="one lattice-theoretic equivalence class",
        ),
        A_3_3=(
            source_case=23,
            source_result_records=length(a33),
            source_number_of_data=a33a.number_of_data,
            group_gap_id=a33a.group_gap_id,
            K_isometric=true,
            P_gram_equal=true,
            P_action_equal=true,
            T_action_equal=true,
            source_S_action_traces=a33_traces,
            auxiliary_classes=Tuple(a33_classes),
            auxiliary_class_count=a33_auxiliary_count,
            conclusion="two lattice-theoretic equivalence classes",
        ),
    ),
    status="passed",
)

save(audit_file, audit_data)

# Confirm that the archived object can be read back and retains the decisive
# counts and traces.
saved_audit = load(audit_file)
@assert saved_audit.format_version == 1
@assert saved_audit.status == "passed"
@assert saved_audit.cases.M_9.auxiliary_class_count == 1
@assert length(saved_audit.cases.M_9.auxiliary_classes) == 1
@assert saved_audit.cases.A_3_3.auxiliary_class_count == 2
@assert length(saved_audit.cases.A_3_3.auxiliary_classes) == 2
@assert saved_audit.cases.A_3_3.source_S_action_traces == (-4, -1)

println()
println("All auxiliary-equivalence checks passed.")
println("Audit data written to: $audit_file")
