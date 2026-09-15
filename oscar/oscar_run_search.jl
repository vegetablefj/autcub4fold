# Run the 29 OSCAR search cases in their recorded order and save each completed
# case.  The lattice algorithms are defined in oscar_script.jl; this file only
# manages execution and serialization.
#
# Usage when the tested OSCAR installation is in the default environment:
#   julia oscar_run_search.jl [data_file]
# For a separate existing environment, add --project=/path/to/environment.
# See README.md for the recorded dependencies; no local project is supplied.
#
# The default data file is oscar_script_data.mrdi.  If it already contains a
# compatible partial run, execution resumes at the next case.  A complete file
# is loaded and checked without repeating the search.  To start a separate run,
# supply a new output path.

include(joinpath(@__DIR__, "oscar_script.jl"))
include(joinpath(@__DIR__, "input.jl"))

using Dates

data_file = isempty(ARGS) ?
    joinpath(@__DIR__, "oscar_script_data.mrdi") :
    abspath(ARGS[1])

case_names = (
    "3^{1+4}:2.2 — generic index 2",
    "A_6 — generic index 1",
    "L_2(7) — generic index 1",
    "S_5 — generic index 1",
    "S_5 — generic index 2",
    "M_9 — generic index 1",
    "N_{72} — generic index 2",
    "3^{1+4}:2 — generic index 2",
    "A_{4,3} — generic index 1",
    "A_{4,3} — generic index 2",
    "A_5 — generic index 1",
    "A_5 — generic index 2",
    "3^2.4 — generic index 1",
    "3^2.4 — generic index 2",
    "S_{3,3} — generic index 2",
    "F_{21} — generic index 1",
    "Hol(5) — generic index 1",
    "QD_{16} — generic index 1",
    "S_4 — generic index 1",
    "S_4 — generic index 2",
    "Q_8 — generic index 1",
    "A_{3,3} — generic index 1",
    "A_{3,3} — generic index 2",
    "D_{12} — generic index 1",
    "D_{12} — generic index 2",
    "A_4 — generic index 1",
    "A_4 — generic index 2",
    "D_{10} — generic index 1",
    "D_8 — generic index 1",
)

@assert length(cases) == length(case_names) == 29

timestamp() = string(Dates.now())

function search_snapshot(started_at, records)
    return (
        format_version=3,
        description="OSCAR cubic-fourfold lattice search: complete retained result objects by input case",
        script="oscar_script.jl",
        input_file="input.jl",
        started_at=started_at,
        last_saved_at=timestamp(),
        completed_cases=length(records),
        cases=Tuple(records),
    )
end

function checked_saved_records(saved)
    @assert saved.format_version == 3
    @assert saved.script == "oscar_script.jl"
    @assert saved.input_file == "input.jl"
    @assert 0 <= saved.completed_cases <= length(cases)
    @assert saved.completed_cases == length(saved.cases)

    for i in 1:saved.completed_cases
        record = saved.cases[i]
        @assert record.case_index == i
        @assert record.case_name == case_names[i]
        @assert record.candidate_orders == Tuple(cases[i][3])
        @assert record.number_of_results >= 0
        if record.number_of_results > 0
            @assert hasproperty(record, :results)
            @assert length(record.results) == record.number_of_results
        else
            @assert !hasproperty(record, :results)
        end
    end

    return Any[saved.cases...]
end

if isfile(data_file)
    println("Loading saved search data from: $data_file")
    saved = load(data_file)
    started_at = saved.started_at
    records = checked_saved_records(saved)
else
    started_at = timestamp()
    records = Any[]
end

for i in (length(records) + 1):length(cases)
    println()
    println("Case $i/$(length(cases)): $(case_names[i])")
    flush(stdout)

    t0 = time()
    results = cubic_fourfold_search(cases[i])
    elapsed_seconds = time() - t0
    candidate_orders = Tuple(cases[i][3])

    record = if isempty(results)
        (
            case_index=i,
            case_name=case_names[i],
            candidate_orders=candidate_orders,
            elapsed_seconds=elapsed_seconds,
            number_of_results=0,
        )
    else
        (
            case_index=i,
            case_name=case_names[i],
            candidate_orders=candidate_orders,
            elapsed_seconds=elapsed_seconds,
            number_of_results=length(results),
            results=Tuple(results),
        )
    end

    push!(records, record)
    save(data_file, search_snapshot(started_at, records))
    println("Completed case $i; retained $(length(results)) result(s); data saved.")
end

final_data = load(data_file)
checked_saved_records(final_data)
@assert final_data.completed_cases == length(cases)

println()
println("All search cases are complete and the saved data passed validation.")
println("Search data: $data_file")
