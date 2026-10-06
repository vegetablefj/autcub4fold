"""Compare the finite discriminant actions of the 16 saved No. 127 N witnesses.

This is an exact, small F_2 computation for the first saved global
Hermitian genus-#13 representative. An E-side anti-isometric graph for V10
can be transported through any resulting finite-module isometry. This does
not test conjugacy of the integral rank-16 N-actions, other Hermitian
classes, or all maps for each V.
"""

import hashlib
import json
from pathlib import Path

from run_family_127_g13_full_finite_glue import (
    image_mask, intertwiner_basis, n_discriminant_data, rank_masks,
)


HERE = Path(__file__).resolve().parent
INPUT = HERE / "family_127_g13_n_finite_full_v1-35.json"


def action_data(witness):
    # For exponent-two A_N, a class is v/2 with G_N v even. The quadratic
    # value is v G_N v / 4 modulo 2; n_discriminant_data checks integrality.
    _basis, g_rows, s_rows, q_values = n_discriminant_data(
        witness["gram"], witness["g"], witness["s"]
    )
    return g_rows, s_rows, q_values


def bit_matrix(rows):
    return [[(row >> j) & 1 for j in range(6)] for row in rows]


def count_isometries(source, target):
    g_source, s_source, q_source = source
    g_target, s_target, q_target = target
    basis = intertwiner_basis(
        bit_matrix(g_source), bit_matrix(s_source), g_target, s_target
    )
    assert len(basis) == 12
    invertible = quadratic_isometries = 0
    current = 0
    # Gray-code enumeration toggles exactly one basis vector at each step.
    for index in range(1 << len(basis)):
        if index:
            current ^= basis[(index & -index).bit_length() - 1]
        rows = tuple((current >> (6 * i)) & 63 for i in range(6))
        if rank_masks(rows) != 6:
            continue
        invertible += 1
        if all(q_source[x] == q_target[image_mask(x, rows)]
               for x in range(64)):
            quadratic_isometries += 1
    return len(basis), invertible, quadratic_isometries


def main():
    raw = INPUT.read_bytes()
    data = json.loads(raw)
    assert data["global_complete"] is True
    witnesses = [
        (record["v_index"], record["first_witness"])
        for record in data["records"] if record["first_witness"] is not None
    ]
    assert [index for index, _ in witnesses] == [
        10, 11, 12, 13, 16, 17, 18, 19,
        28, 29, 30, 31, 32, 33, 34, 35,
    ]
    source = action_data(witnesses[0][1])
    print("No. 127: finite discriminant (g,s)-action comparison")
    print(f"source={INPUT.name}")
    print(f"source_sha256={hashlib.sha256(raw).hexdigest()}")
    print("reference=V10; each A_N has order 64 and exponent two")
    print("V  equivariant_dimension  equivariant_maps  invertible  q_isometries")
    for index, witness in witnesses:
        dimension, invertible, quadratic_isometries = count_isometries(
            source, action_data(witness)
        )
        assert (dimension, invertible, quadratic_isometries) == (12, 768, 96)
        print(f"{index:2d} {dimension:21d} {1 << dimension:17d} "
              f"{invertible:11d} {quadratic_isometries:13d}")
    print("All 16 finite quadratic discriminant modules with g,s action")
    print("are isomorphic to the V10 one.")
    print("The V10 E-side anti-isometric graph therefore transports to")
    print("each saved N witness at the finite discriminant-module level.")
    print("This does NOT prove integral equivalence of the 16 N-actions")
    print("or L-actions, root/saturation conditions, or completeness across")
    print("other global Hermitian classes. COMPLETED")


if __name__ == "__main__":
    main()
