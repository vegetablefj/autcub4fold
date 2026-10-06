# Repackage the selected exact-character output for family No. 96.
# The source MRDI remains unchanged; this file performs no enumeration.

module Maximal096Normalization

using Oscar

function normalize_maximal_096(snapshot; selected_output::Int=1)
    @assert snapshot.family_number == 96
    @assert snapshot.tested_order == 24
    @assert snapshot.characteristic_polynomial == "Phi24"
    @assert snapshot.structural_checks_passed
    @assert snapshot.expected_family_found
    @assert snapshot.number_of_results == length(snapshot.results)
    @assert 1 <= selected_output <= length(snapshot.results)

    result = snapshot.results[selected_output]
    @assert result.matches_expected_group
    @assert Tuple(result.group_gap_id) == (144, 69)
    @assert result.order == 24 && result.dimension == 0
    @assert rank(lattice(result.S_in_Lambda0)) == 14
    @assert rank(lattice(result.T_in_Lambda0)) == 8
    @assert order_of_isometry(result.T_action) == 24
    @assert all(values(result.checks))

    # The old script records the source T-action index but not the count of
    # surviving extensions for that particular action. Reconstruct precisely
    # that count from the complete saved output, matching the ambient-lattice catalogue's
    # meaning of number_of_data.
    action_index = result.source_T_action_index
    number_of_data = count(r -> r.source_T_action_index == action_index,
        snapshot.results)
    @assert number_of_data >= 1

    data = (
        order=result.order,
        dimension=result.dimension,
        number_of_data=number_of_data,
        S_in_Lambda0=result.S_in_Lambda0,
        T_in_Lambda0=result.T_in_Lambda0,
        T_action=result.T_action,
        K_in_Lambda0=result.K_in_Lambda0,
        P_in_Lambda0=result.P_in_Lambda0,
        P_action=result.P_action,
        Lambda0=result.Lambda0,
        group_gap_id=result.group_gap_id,
    )
    provenance = (
        family_number=96,
        source_file="remark/low_rank/maximal_cases/family_096_phi24_oscar18.mrdi",
        source_kind="completed_exact_character_enumeration",
        selected_output=selected_output,
        source_T_action_index=action_index,
        source_number_of_T_actions=snapshot.number_of_T_actions,
        source_number_of_results=snapshot.number_of_results,
        all_source_structural_checks_passed=snapshot.structural_checks_passed,
    )
    return (data=data, provenance=provenance)
end

end # module
