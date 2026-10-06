"""Exact finite orbit audit for the first saved E6(2)+N glue.

Enumerates the 1152-element folded E6 Weyl centralizer from the four
generators in verify_family_127_e6_involution.jl, then its stabilizer
of the chosen plane and s_E. Reduces that integral subgroup mod 2
and compares its orbit of the first glue with ALL equivariant
quadratic anti-isometries for one fixed N witness. No rank-22 Gram
is built or other N classes searched.
"""

import hashlib
import json
from pathlib import Path

from audit_family_127_g13_n_witness import HERE, N_PATH, eye, multiply, pair
from run_family_127_g13_full_finite_glue import (
    bits, e6_data, image_mask, intertwiner_basis, n_discriminant_data,
    rank_masks,
)


FULL_PATH = HERE / "family_127_g13_full_finite_glue_preflight.json"


def mat_key(a):
    return tuple(tuple(int(x) for x in row) for row in a)


def simple_reflection(c, i):
    r = eye(6)
    for j in range(6):
        r[j][i] -= c[j][i]
    return r


def closure(generators):
    identity = eye(6)
    found = {mat_key(identity)}
    queue = [identity]
    for current in queue:
        for generator in generators:
            successor = multiply(current, generator)
            key = mat_key(successor)
            if key not in found:
                found.add(key)
                queue.append(successor)
    assert len(found) == len(queue)
    return queue


def mod2_rows(matrix):
    return tuple(
        sum((value & 1) << j for j, value in enumerate(row))
        for row in matrix
    )


def compose_rows(left, right):
    return tuple(image_mask(row, right) for row in left)


def is_isometry(matrix, gram):
    return all(
        pair(matrix[i], matrix[j], gram) == gram[i][j]
        for i in range(6) for j in range(6)
    )


def all_finite_antimaps(ge, g_e, s_e, gn, g_n, s_n):
    _nbasis, gn_disc, sn_disc, qn = n_discriminant_data(gn, g_n, s_n)
    linear_basis = intertwiner_basis(g_e, s_e, gn_disc, sn_disc)
    assert len(linear_basis) == 12
    qe = []
    for x in range(64):
        numerator = pair(bits(x, 6), bits(x, 6), ge)
        assert numerator % 4 == 0
        qe.append((numerator // 4) & 1)
    anti = set()
    invertible = 0
    current = 0
    for index in range(4096):
        if index:
            toggle = (index & -index).bit_length() - 1
            current ^= linear_basis[toggle]
        rows = tuple((current >> (6 * i)) & 63 for i in range(6))
        if rank_masks(rows) != 6:
            continue
        invertible += 1
        if all(qe[x] == qn[image_mask(x, rows)] for x in range(64)):
            anti.add(rows)
    assert invertible == 768 and len(anti) == 96
    return anti


def main():
    raw_n = N_PATH.read_bytes()
    raw_full = FULL_PATH.read_bytes()
    n_record = json.loads(raw_n)
    full_record = json.loads(raw_full)
    assert n_record["v_start"] == n_record["v_end"] == 10
    assert full_record["input_sha256"] == hashlib.sha256(raw_n).hexdigest()
    first = tuple(full_record["first_witness"]["intertwiner_rows"])
    assert first == (1, 16, 60, 4, 2, 55)
    n = n_record["first_witness"]
    ge, g_e, s_e, plane = e6_data()
    c = [[value // 2 for value in row] for row in ge]
    reflections = [simple_reflection(c, i) for i in range(6)]
    folded_generators = [
        reflections[2],
        reflections[5],
        multiply(reflections[1], reflections[3]),
        multiply(reflections[0], reflections[4]),
    ]
    assert all(is_isometry(w, ge) for w in folded_generators)
    folded = closure(folded_generators)
    assert len(folded) == 1152
    assert all(multiply(w, g_e) == multiply(g_e, w) for w in folded)
    plane_stabilizer = [
        w for w in folded if multiply([plane], w) == [plane]
    ]
    assert len(plane_stabilizer) == 384
    pair_stabilizer = [
        w for w in plane_stabilizer
        if multiply(w, s_e) == multiply(s_e, w)
    ]
    assert len(pair_stabilizer) == 96
    assert all(is_isometry(w, ge) for w in pair_stabilizer)
    reductions = {mod2_rows(w) for w in pair_stabilizer}
    assert len(reductions) == 96
    orbit = {compose_rows(w, first) for w in reductions}
    assert len(orbit) == 96
    anti = all_finite_antimaps(
        ge, g_e, s_e, n["gram"], n["g"], n["s"]
    )
    assert first in anti and orbit == anti
    print("Family 127: E6(2) plane/g/s stabilizer orbit on fixed V10 N glue")
    print(f"N source sha256={hashlib.sha256(raw_n).hexdigest()}")
    print(f"full first-glue sha256={hashlib.sha256(raw_full).hexdigest()}")
    print("folded Weyl centralizer order=1152")
    print("plane stabilizer order=384")
    print("plane and s_E stabilizer order=96")
    print("distinct mod-2 reductions of that stabilizer=96 (faithful)")
    print("all simultaneous g/s quadratic anti-isometries=96")
    print("orbit of first anti-isometry under integral E stabilizer=96")
    print("orbit equals complete finite anti-isometry set=true")
    print("For this fixed E,N action and plane, all 96 graph overlattices")
    print("are conjugate by w+I_N with w in the integral E6 Weyl stabilizer.")
    print("No claim about other N witnesses, K actions, or geometric No. 127.")
    print("COMPLETED: exact finite enumeration; no rank-22 Gram rebuilt")


if __name__ == "__main__":
    main()
