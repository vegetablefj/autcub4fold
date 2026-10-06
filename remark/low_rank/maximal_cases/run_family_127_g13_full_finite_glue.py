"""Finite E6(2) + N graph preflight for No. 127; standard Python only.

The input is the first saved N witness. Search all F2-linear maps between the
2-primary discriminant groups that intertwine both g and s and reverse the
quadratic form. A bounded default never asserts exhaustiveness. The first
passing map, if any, is tested by exact integer Gram and action calculations.
This does not test the full-lattice isometry class or coinvariant lattice.
"""

import argparse
import hashlib
import json
from fractions import Fraction
from math import gcd
from pathlib import Path

from audit_family_127_g13_n_witness import (
    HERE, N_PATH, OUT_PATH as N_AUDIT, block, determinant, eye, gram, inverse,
    multiply, pair, rank_mod2, transpose,
)


DEFAULT_OUTPUT = HERE / "family_127_g13_full_finite_glue_preflight.json"


def bitmask(row):
    return sum((int(v) & 1) << i for i, v in enumerate(row))


def bits(value, n):
    return [(value >> i) & 1 for i in range(n)]


def image_mask(value, row_masks):
    out = 0
    for i, row in enumerate(row_masks):
        if value & (1 << i):
            out ^= row
    return out


def rank_masks(values):
    pivots = {}
    for v in values:
        while v:
            j = v.bit_length() - 1
            if j in pivots:
                v ^= pivots[j]
            else:
                pivots[j] = v
                break
    return len(pivots)


def nullspace_basis(equations, variables):
    pivots = {}
    for v in equations:
        while v:
            j = v.bit_length() - 1
            if j in pivots:
                v ^= pivots[j]
            else:
                pivots[j] = v
                break
    free = [j for j in range(variables) if j not in pivots]
    basis = []
    for j in free:
        x = 1 << j
        for k in sorted(pivots):
            if (pivots[k] & x).bit_count() & 1:
                x |= 1 << k
        assert all((eq & x).bit_count() % 2 == 0 for eq in equations)
        basis.append(x)
    return basis


def e6_data():
    c = [
        [2, -1, 0, 0, 0, 0],
        [-1, 2, -1, 0, 0, 0],
        [0, -1, 2, -1, 0, -1],
        [0, 0, -1, 2, -1, 0],
        [0, 0, 0, -1, 2, 0],
        [0, 0, -1, 0, 0, 2],
    ]
    ge = [[2 * v for v in row] for row in c]
    d = [4, 3, 2, 1, 0, 5]
    g = [[-int(j == d[i]) for j in range(6)] for i in range(6)]
    reflections = []
    for root in (0, 4):
        r = eye(6)
        for i in range(6):
            r[i][root] -= c[i][root]
        reflections.append(r)
    s = multiply(reflections[0], reflections[1])
    plane = [1, 2, 0, -2, -1, 0]
    assert determinant(c) == 3 and determinant(ge) == 192
    assert gram(g, ge) == ge and gram(s, ge) == ge
    assert multiply(g, g) == eye(6) and multiply(s, s) == eye(6)
    assert multiply(g, s) == multiply(s, g)
    assert multiply([plane], g) == [plane]
    assert multiply([plane], s) == [plane]
    assert pair(plane, plane, ge) == 24
    return ge, g, s, plane


def n_discriminant_data(gn, g, s):
    # For exponent-two A_N, its 64 classes are v/2 with G_N*v=0 mod 2.
    parity_rows = [bitmask(row) for row in gn]
    members = [v for v in range(1 << 16)
               if all(((row & v).bit_count() & 1) == 0 for row in parity_rows)]
    assert len(members) == 64
    basis = []
    for value in members:
        if rank_masks(basis + [value]) > len(basis):
            basis.append(value)
    assert len(basis) == 6
    coordinates = {image_mask(x, basis): x for x in range(64)}
    assert len(coordinates) == 64 and set(coordinates) == set(members)
    g_rows = [bitmask(row) for row in g]
    s_rows = [bitmask(row) for row in s]
    g_discr = [coordinates[image_mask(x, g_rows)] for x in basis]
    s_discr = [coordinates[image_mask(x, s_rows)] for x in basis]
    q_values = []
    for x in range(64):
        v = bits(image_mask(x, basis), 16)
        n = pair(v, v, gn)
        assert n % 4 == 0
        q_values.append((n // 4) & 1)
    return basis, g_discr, s_discr, q_values


def intertwiner_basis(g_e, s_e, g_n_rows, s_n_rows):
    equations = []
    for left, right in ((g_e, g_n_rows), (s_e, s_n_rows)):
        for i in range(6):
            for j in range(6):
                eq = 0
                for k in range(6):
                    if left[i][k] & 1:
                        eq ^= 1 << (6 * k + j)
                    if right[k] & (1 << j):
                        eq ^= 1 << (6 * i + k)
                equations.append(eq)
    basis = nullspace_basis(equations, 36)
    assert all((eq & x).bit_count() % 2 == 0
               for x in basis for eq in equations)
    return basis


def first_glue_candidate(ge, gn, g_e, g_n, s_e, s_n, image_rows):
    # The first six rows adjoin half-sums (e_i + image_i)/2.
    assert multiply(g_e, g_e) == eye(6)
    assert multiply(g_n, g_n) == [[-int(i == j) for j in range(16)]
                                  for i in range(16)]
    y = [bits(x, 16) for x in image_rows]
    b = [[Fraction(0) for _ in range(22)] for _ in range(22)]
    for i in range(6):
        b[i][i] = Fraction(1, 2)
        for j in range(16):
            b[i][6 + j] = Fraction(y[i][j], 2)
    for i in range(16):
        b[6 + i][6 + i] = Fraction(1)
    b_inv = inverse(b)
    lattice_gram = gram(b, block(ge, gn))
    assert all(x.denominator == 1 for row in lattice_gram for x in row)
    lattice_gram = [[int(x) for x in row] for row in lattice_gram]
    assert all(lattice_gram[i][i] % 2 == 0 for i in range(22))
    assert determinant(lattice_gram) == 3
    g = multiply(multiply(b, block(g_e, g_n)), b_inv)
    s = multiply(multiply(b, block(s_e, s_n)), b_inv)
    assert all(x.denominator == 1 for row in g + s for x in row)
    g = [[int(x) for x in row] for row in g]
    s = [[int(x) for x in row] for row in s]
    assert gram(g, lattice_gram) == lattice_gram
    assert gram(s, lattice_gram) == lattice_gram
    g_squared = multiply(g, g)
    assert g_squared != eye(22)
    assert multiply(g_squared, g_squared) == eye(22)
    assert multiply(s, s) == eye(22)
    assert multiply(g, s) == multiply(s, g)
    # Both automorphisms must act trivially on the order-three discriminant.
    dual = inverse(lattice_gram)
    g_disc_difference = multiply(
        dual, [[g[i][j] - int(i == j) for j in range(22)]
               for i in range(22)]
    )
    s_disc_difference = multiply(
        dual, [[s[i][j] - int(i == j) for j in range(22)]
               for i in range(22)]
    )
    assert all(x.denominator == 1 for row in g_disc_difference for x in row)
    assert all(x.denominator == 1 for row in s_disc_difference for x in row)
    plane_e = [1, 2, 0, -2, -1, 0] + [0] * 16
    plane_l = multiply([plane_e], b_inv)[0]
    assert all(x.denominator == 1 for x in plane_l)
    plane_l = [int(x) for x in plane_l]
    assert pair(plane_l, plane_l, lattice_gram) == 24
    assert multiply([plane_l], g) == [plane_l]
    assert multiply([plane_l], s) == [plane_l]
    divisibility = gcd(*(abs(x) for x in multiply([plane_l], lattice_gram)[0]))
    return {
        "gram": lattice_gram,
        "g": g,
        "s": s,
        "plane": plane_l,
        "plane_divisibility": divisibility,
        "stable_on_discriminant": True,
        "rank_s_anti_expected": 8,
        "rank_q_fixed_expected": 10,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dimension-only", action="store_true")
    parser.add_argument("--max-maps", type=int, default=100000,
                        help="Maximum intertwining matrices to test")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    assert N_AUDIT.is_file(), "Run the independent N witness audit first"
    raw = N_PATH.read_bytes()
    data = json.loads(raw)
    witness = data["first_witness"]
    gn, g_n, s_n = witness["gram"], witness["g"], witness["s"]
    ge, g_e, s_e, _plane = e6_data()
    n_basis, gn_disc, sn_disc, qn = n_discriminant_data(gn, g_n, s_n)
    linear_basis = intertwiner_basis(g_e, s_e, gn_disc, sn_disc)
    dimension = len(linear_basis)
    print(f"Finite intertwiner dimension={dimension}; total={1 << dimension}; "
          f"N discriminant basis={n_basis}", flush=True)
    if args.dimension_only:
        return
    assert args.max_maps > 0
    if args.output.exists():
        raise FileExistsError(f"Refusing to overwrite {args.output}")
    qe = []
    for x in range(64):
        n = pair(bits(x, 6), bits(x, 6), ge)
        assert n % 4 == 0
        qe.append((n // 4) & 1)
    tested = 0
    invertible = 0
    q_isometric = 0
    witness_out = None
    limit = min(1 << dimension, args.max_maps)
    current = 0
    for index in range(limit):
        if index:
            toggle = (index & -index).bit_length() - 1
            current ^= linear_basis[toggle]
        tested += 1
        rows = [(current >> (6 * i)) & 63 for i in range(6)]
        if rank_masks(rows) != 6:
            continue
        invertible += 1
        if any(qe[x] != qn[image_mask(x, rows)] for x in range(64)):
            continue
        q_isometric += 1
        n_images = [image_mask(row, n_basis) for row in rows]
        candidate = first_glue_candidate(
            ge, gn, g_e, g_n, s_e, s_n, n_images
        )
        if candidate["plane_divisibility"] != 3:
            continue
        witness_out = {"intertwiner_rows": rows,
                       "n_discriminant_images": n_images,
                       **candidate}
        break
    result = {
        "family": 127,
        "stage": "g13_full_finite_glue_preflight",
        "input_sha256": hashlib.sha256(raw).hexdigest(),
        "intertwiner_dimension": dimension,
        "intertwiners_total": 1 << dimension,
        "maps_tested": tested,
        "maps_invertible": invertible,
        "maps_quadratic_anti_isometric": q_isometric,
        "search_complete": tested == (1 << dimension),
        "first_witness": witness_out,
    }
    args.output.write_text(json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n",
                           encoding="utf-8")
    print("Finished: tested=", tested, " invertible=", invertible,
          " q-anti=", q_isometric, " witness=", witness_out is not None,
          " complete=", result["search_complete"], " output=", args.output,
          sep="", flush=True)


if __name__ == "__main__":
    main()
