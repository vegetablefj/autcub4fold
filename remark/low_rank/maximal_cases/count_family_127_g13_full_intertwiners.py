"""Count the full finite intertwiner space for one saved E6(2)+N pair.

This deliberately does not construct any rank-22 overlattice. It imports
the exact finite F2 extraction from the first-witness preflight and scans
all 2^12 simultaneous g/s intertwiners, recording invertibility and
quadratic anti-isometry. The input N action is one saved V=10 witness.
"""

import hashlib
import json

from audit_family_127_g13_n_witness import N_PATH
from run_family_127_g13_full_finite_glue import (
    bitmask, bits, e6_data, image_mask, intertwiner_basis,
    n_discriminant_data, pair, rank_masks,
)


def main():
    raw = N_PATH.read_bytes()
    saved = json.loads(raw)
    assert saved["family"] == 127
    assert saved["selected_range_complete"] is True
    assert saved["v_start"] == saved["v_end"] == 10
    witness = saved["first_witness"]
    gn, g_n, s_n = witness["gram"], witness["g"], witness["s"]
    ge, g_e, s_e, _ = e6_data()
    _basis, gn_disc, sn_disc, qn = n_discriminant_data(gn, g_n, s_n)
    linear_basis = intertwiner_basis(g_e, s_e, gn_disc, sn_disc)
    assert len(linear_basis) == 12
    qe = []
    for x in range(64):
        numerator = pair(bits(x, 6), bits(x, 6), ge)
        assert numerator % 4 == 0
        qe.append((numerator // 4) & 1)
    invertible = 0
    anti = 0
    first = None
    last = None
    current = 0
    for index in range(1 << 12):
        if index:
            toggle = (index & -index).bit_length() - 1
            current ^= linear_basis[toggle]
        rows = [(current >> (6 * i)) & 63 for i in range(6)]
        if rank_masks(rows) != 6:
            continue
        invertible += 1
        if any(qe[x] != qn[image_mask(x, rows)] for x in range(64)):
            continue
        anti += 1
        if first is None:
            first = (index + 1, rows)
        last = (index + 1, rows)
    assert first is not None
    assert first[0] == 1282
    assert first[1] == [1, 16, 60, 4, 2, 55]
    print("Family 127: fixed E6(2) and first saved N witness")
    print(f"N source sha256={hashlib.sha256(raw).hexdigest()}")
    print(f"simultaneous g/s intertwiner dimension={len(linear_basis)}")
    print(f"linear maps tested={1 << len(linear_basis)}")
    print(f"invertible maps={invertible}")
    print(f"quadratic anti-isometries={anti}")
    print(f"first anti-isometry one-based index={first[0]} rows={first[1]}")
    print(f"last anti-isometry one-based index={last[0]} rows={last[1]}")
    print("All quadratic anti-isometries form one orbit under the finite")
    print("centralizer O(q_E,g_E,s_E), by composition with the inverse of")
    print("any fixed anti-isometry; this does not classify integral glues.")
    print("COMPLETED: all 4096 finite maps counted; no rank-22 Gram built")


if __name__ == "__main__":
    main()
