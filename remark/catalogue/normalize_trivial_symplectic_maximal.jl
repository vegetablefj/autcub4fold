# Repackage the four selected maximal searches with trivial symplectic part.
# This file only defines functions. It neither loads MRDI files nor searches
# for further lattice actions. The original saved result should remain stored
# separately, as it is in each catalogue row's `saved_result` field.

using Oscar

function trivial_symplectic_maximal_source(number::Integer)
    number == 152 && return (
        order=16, dimension=1, source_result_index=1, source_action_index=1,
        source_file="remark/low_rank/maximal_cases/brown_results/family_152_phi16_brown_oscar18.mrdi",
        geometric_projective_group_id=(16, 1),
    )
    number == 154 && return (
        order=24, dimension=1, source_result_index=4, source_action_index=4,
        source_file="remark/low_rank/maximal_cases/brown_results/family_154_phi24_brown_oscar18.mrdi",
        geometric_projective_group_id=(24, 2),
    )
    number == 155 && return (
        order=32, dimension=0, source_result_index=7, source_action_index=13,
        source_file="remark/low_rank/maximal_cases/family_155_phi32_oscar18.mrdi",
        geometric_projective_group_id=(32, 1),
    )
    number == 156 && return (
        order=48, dimension=0, source_result_index=2, source_action_index=2,
        source_file="remark/low_rank/maximal_cases/brown_results/family_156_phi48_brown_oscar18.mrdi",
        geometric_projective_group_id=(48, 2),
    )
    throw(ArgumentError("Expected one of the trivial-symplectic maximal Nos. 152, 154, 155, 156"))
end

"""
    normalize_trivial_symplectic_maximal(result, number)

Convert the selected saved exact-character result for No. `number` (152,
154, 155, or 156) to `(data=NamedTuple, provenance=NamedTuple)`, where
`data` uses the ambient-lattice catalogue's core ambient-lattice field names.
The source result is not modified. Its `Lambda0` is the complete rank-22
action, `S` is zero, and `T` is all of `Lambda0`. Saved `P`, `K`, and
`P_action` objects are reused after consistency checks.

`group_gap_id` in the ambient-lattice catalogue identifies the group acting on `S` through
the stable discriminant kernel. It is left `nothing` here; the geometric
projective group ID from the numbered table is recorded separately.
`number_of_data` is omitted because these four source runs count labelled
full actions, not primitive extensions for one fixed `T` action.
OSCAR represents the zero-rank `S_in_Lambda0` isometry with a sentinel order;
use `rank(lattice(data.S_in_Lambda0)) == 0` when checking this field.

The original search output and its checks remain in the source MRDI file;
this normalized view records its path and selected output index. The
separate 156-row catalogue also retains the original selected result.
"""
function normalize_trivial_symplectic_maximal(result, number::Integer)
    source = trivial_symplectic_maximal_source(number)
    m = source.order
    Lf = result.Lambda0
    L = lattice(Lf)
    P = result.P
    K = result.K
    Pf = result.P_action

    result.source_action_index == source.source_action_index ||
        throw(ArgumentError("No. $number has the wrong saved action index"))
    result.dimension == source.dimension ||
        throw(ArgumentError("No. $number has the wrong saved period dimension"))
    result.stable_kernel_order == 1 ||
        throw(ArgumentError("No. $number is not certified to have trivial symplectic kernel"))
    all(values(result.checks)) ||
        throw(ArgumentError("No. $number has a failed source-search check"))

    rank(L) == 22 || throw(ArgumentError("Expected a rank-22 ambient lattice"))
    signature_tuple(L) == (20, 0, 2) ||
        throw(ArgumentError("Expected ambient signature (20, 2)"))
    abs(det(gram_matrix(L))) == 3 ||
        throw(ArgumentError("Expected ambient discriminant of absolute value 3"))
    Int(order_of_isometry(Lf)) == m ||
        throw(ArgumentError("No. $number has the wrong ambient action order"))

    rank(P) == 16 && signature_tuple(P) == (14, 0, 2) ||
        throw(ArgumentError("No. $number has unexpected period lattice P"))
    rank(K) == 6 && signature_tuple(K) == (6, 0, 0) ||
        throw(ArgumentError("No. $number has unexpected complement lattice K"))
    basis_matrix(lattice(Pf)) == basis_matrix(P) ||
        throw(ArgumentError("The saved P action is not on the saved embedded P"))
    Int(order_of_isometry(Pf)) == m ||
        throw(ArgumentError("No. $number has the wrong period action order"))
    basis_matrix(P) * gram_matrix(ambient_space(L)) * transpose(basis_matrix(K)) ==
        zero_matrix(QQ, rank(P), rank(K)) ||
        throw(ArgumentError("The saved P and K are not orthogonal"))
    div(rank(P), Int(euler_phi(m))) - 1 == source.dimension ||
        throw(ArgumentError("No. $number has inconsistent period dimension"))

    # The zero coinvariant lattice is formed in the same ambient quadratic
    # space as L, following the convention of restrict_cyclic_power.jl.
    S = orthogonal_submodule(L, basis_matrix(L))
    rank(S) == 0 || throw(ArgumentError("Could not construct the zero S lattice"))
    Sf = integer_lattice_with_isometry(
        S, identity_matrix(QQ, 0); ambient_representation=false, check=true,
    )

    return (
        data=(
            order=m,
            dimension=source.dimension,
            S_in_Lambda0=Sf,
            T_in_Lambda0=Lf,
            T_action=Lf,
            K_in_Lambda0=K,
            P_in_Lambda0=P,
            P_action=Pf,
            Lambda0=Lf,
            group_gap_id=nothing,
        ),
        provenance=(
            family_number=Int(number),
            construction="selected result of complete exact-character search",
            source_file=source.source_file,
            source_result_index=source.source_result_index,
            source_action_index=source.source_action_index,
            source_stable_kernel_order=result.stable_kernel_order,
            source_checks_passed=true,
            group_gap_id_status="not computed for rank-zero S",
            geometric_projective_group_id=source.geometric_projective_group_id,
            number_of_data_status="not applicable to this exact-character search",
        ),
    )
end
