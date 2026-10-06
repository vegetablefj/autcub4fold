"""Exact integer extraction of the q=g^2*s fixed lattice from the saved full-L witness.

The witness matrices act on row vectors.  This uses unimodular column
operations on (q-I)^T, so the resulting kernel basis is saturated by
construction.  No OSCAR search or isometry claim is made here.
"""

import json
from fractions import Fraction
from pathlib import Path

from audit_family_127_g13_n_witness import (
    determinant, eye, gram, inverse, multiply, transpose,
)


HERE = Path(__file__).resolve().parent
INPUT = HERE / "family_127_g13_full_finite_glue_preflight.json"
GEOMETRY = HERE / "family_127_phi3_plane_action.json"
OUTPUT = HERE / "family_127_g13_full_q_fixed_preflight.json"


def xgcd(a, b):
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t
    if old_r < 0:
        return -old_r, -old_s, -old_t
    return old_r, old_s, old_t


def primitive_row_kernel(matrix):
    """Return a Z-basis of x*matrix=0 using only unimodular operations."""
    a = transpose(matrix)
    m, n = len(a), len(a[0])
    v = eye(n)
    rank = 0
    for row in range(m):
        pivot = next((j for j in range(rank, n) if a[row][j]), None)
        if pivot is None:
            continue
        for b in (a, v):
            for r in b:
                r[rank], r[pivot] = r[pivot], r[rank]
        for j in range(rank + 1, n):
            if not a[row][j]:
                continue
            aa, bb = a[row][rank], a[row][j]
            d, u, w = xgcd(aa, bb)
            assert d and u * aa + w * bb == d
            for b in (a, v):
                for r in b:
                    p, q = r[rank], r[j]
                    r[rank] = u * p + w * q
                    r[j] = -(bb // d) * p + (aa // d) * q
            assert a[row][j] == 0 and abs(a[row][rank]) == d
        rank += 1
    assert all(a[i][j] == 0 for i in range(m) for j in range(rank, n))
    assert abs(determinant(v)) == 1
    kernel = transpose([row[rank:] for row in v])
    assert multiply(kernel, matrix) == [[0] * n for _ in kernel]
    return kernel


def row_coordinates(basis, target):
    """Express an ambient row in a full-rank row basis, exactly."""
    r, n = len(basis), len(basis[0])
    work = [[Fraction(x) for x in row] for row in basis]
    pivots = []
    for col in range(n):
        if len(pivots) == r:
            break
        k = len(pivots)
        p = next((i for i in range(k, r) if work[i][col]), None)
        if p is None:
            continue
        work[k], work[p] = work[p], work[k]
        scalar = work[k][col]
        work[k] = [x / scalar for x in work[k]]
        for i in range(r):
            if i != k and work[i][col]:
                scalar = work[i][col]
                work[i] = [x - scalar * y for x, y in zip(work[i], work[k])]
        pivots.append(col)
    assert len(pivots) == r
    minor = [[basis[i][j] for j in pivots] for i in range(r)]
    answer = multiply([[target[j] for j in pivots]], inverse(minor))[0]
    assert multiply([answer], basis)[0] == target
    assert all(x.denominator == 1 for x in answer)
    return [int(x) for x in answer]


def scalar(v, g, w):
    return multiply(multiply([v], g), transpose([w]))[0][0]


def mod2_rank(rows):
    pivots = {}
    for row in rows:
        mask = sum((int(x) & 1) << i for i, x in enumerate(row))
        while mask:
            k = mask.bit_length() - 1
            if k in pivots:
                mask ^= pivots[k]
            else:
                pivots[k] = mask
                break
    return len(pivots)


def mod2_jordan(g):
    n = len(g)
    a = [[(g[i][j] + int(i == j)) & 1 for j in range(n)] for i in range(n)]
    ranks = []
    power = eye(n)
    for _ in range(4):
        power = multiply(power, a)
        ranks.append(mod2_rank(power))
    return ranks


def geometric_plane_coordinates():
    """Coordinates of 3*[plane]-eta in Marquand's P basis."""
    def unit(i):
        return [int(j == i) for j in range(11)]
    eta, y = unit(0), unit(1)
    f = {i: unit(i + 1) for i in range(1, 10)}
    plane = [2 * y[j] - sum(f[i][j] for i in range(1, 10))
             for j in range(11)]
    x = [-y[j] + sum(f[i][j] for i in (1, 3, 5, 7, 9))
         for j in range(11)]
    alpha = [[f[i][j] - f[i + 1][j] for j in range(11)]
             for i in range(1, 9)]
    alpha.append([plane[j] + f[8][j] + f[9][j] - eta[j]
                  for j in range(11)])
    projected = [3 * plane[j] - eta[j] for j in range(11)]
    return row_coordinates([x] + alpha, projected)


def main():
    data = json.loads(INPUT.read_text(encoding="utf-8"))
    witness = data["first_witness"]
    geometry = json.loads(GEOMETRY.read_text(encoding="utf-8"))
    g, s, l = witness["g"], witness["s"], witness["gram"]
    assert len(l) == 22 and determinant(l) == 3
    assert gram(g, l) == l and gram(s, l) == l
    assert multiply(g, s) == multiply(s, g)
    g2 = multiply(g, g)
    assert multiply(g2, g2) == eye(22)
    assert sum(g2[i][i] for i in range(22)) == -10  # +6 and -16.
    assert sum(g[i][i] for i in range(22)) == -2  # Phi1^2 Phi2^4 Phi4^8.
    q = multiply(g2, s)
    assert multiply(q, q) == eye(22)
    basis = primitive_row_kernel([[q[i][j] - int(i == j)
                                   for j in range(22)] for i in range(22)])
    assert len(basis) == 10
    pgram = gram(basis, l)
    assert determinant(pgram) == 3072
    paction = [row_coordinates(basis, multiply([row], g)[0]) for row in basis]
    assert gram(paction, pgram) == pgram
    assert multiply(multiply(paction, paction), multiply(paction, paction)) == eye(10)
    plane = row_coordinates(basis, witness["plane"])
    assert scalar(plane, pgram, plane) == 24
    assert multiply([plane], paction)[0] == plane
    geometric_plane = geometric_plane_coordinates()
    geo_gram = geometry["gram"]
    geo_action = transpose(geometry["action_pushforward"])
    assert scalar(geometric_plane, geo_gram, geometric_plane) == 24
    assert multiply([geometric_plane], geo_action)[0] == geometric_plane
    invariants = {
        "det": determinant(pgram),
        "trace_g": sum(paction[i][i] for i in range(10)),
        "trace_g2": sum(multiply(paction, paction)[i][i] for i in range(10)),
        "mod2_jordan_ranks": mod2_jordan(paction),
        "plane_divisibility_in_P": abs(__import__("math").gcd(*multiply([plane], pgram)[0])),
    }
    geometric_invariants = {
        "det": determinant(geo_gram),
        "trace_g": sum(geo_action[i][i] for i in range(10)),
        "trace_g2": sum(multiply(geo_action, geo_action)[i][i] for i in range(10)),
        "mod2_jordan_ranks": mod2_jordan(geo_action),
        "plane_divisibility_in_P": abs(__import__("math").gcd(*multiply([geometric_plane], geo_gram)[0])),
    }
    assert invariants == geometric_invariants
    result = {
        "family": 127,
        "stage": "q_fixed_integer_preflight",
        "complete_equivariant_isometry_checked": False,
        "witness_basis_rows_in_full_L": basis,
        "witness_gram": pgram,
        "witness_g_row_action": paction,
        "witness_projected_plane": plane,
        "geometric_gram": geo_gram,
        "geometric_g_pushforward_row_action": geo_action,
        "geometric_projected_plane": geometric_plane,
        "witness_invariants": invariants,
        "geometric_invariants": geometric_invariants,
    }
    assert not OUTPUT.exists()
    OUTPUT.write_text(json.dumps(result, separators=(",", ":")) + "\n", encoding="utf-8")
    print("P=L^(g^2*s) primitive rank=10, determinant=3072")
    print("Witness P and geometric P basic invariants agree:", invariants)
    print("Exact decorated isometry NOT YET CHECKED")
    print("Output:", OUTPUT)


if __name__ == "__main__":
    main()
