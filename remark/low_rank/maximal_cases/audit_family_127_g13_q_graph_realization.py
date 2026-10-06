"""Identify the saved full-L anti-q lattice with one saved Q-side graph.

All matrices act on rows.  The comparison is made in the *same* rational
ambient E^-s ⊕ K, so it identifies the actual index-four graph, not merely
the abstract Q genus or finite discriminant fingerprint.  Pure exact
integer/rational arithmetic; no OSCAR call.
"""

import json
from fractions import Fraction
from pathlib import Path

from audit_family_127_g13_n_witness import (
    block, determinant, eye, gram, inverse, multiply, transpose,
)
from extract_family_127_full_q_fixed import primitive_row_kernel, xgcd


HERE = Path(__file__).resolve().parent
FULL = HERE / "family_127_g13_full_finite_glue_preflight.json"
GRAPHS = HERE / "family_127_g13_q_graph_preflight.json"
OUTPUT = HERE / "family_127_g13_q_graph_realization.json"
REPORT = HERE / "family_127_g13_q_graph_realization.out"


def row_coordinates_fraction(basis, target):
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
        c = work[k][col]
        work[k] = [x / c for x in work[k]]
        for i in range(r):
            if i != k and work[i][col]:
                c = work[i][col]
                work[i] = [x - c * y for x, y in zip(work[i], work[k])]
        pivots.append(col)
    assert len(pivots) == r
    minor = [[basis[i][j] for j in pivots] for i in range(r)]
    answer = multiply([[target[j] for j in pivots]], inverse(minor))[0]
    assert multiply([answer], basis)[0] == target
    return answer


def rational_det(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    n = len(a)
    det = Fraction(1)
    for j in range(n):
        k = next((i for i in range(j, n) if a[i][j]), None)
        if k is None:
            return Fraction(0)
        if k != j:
            a[j], a[k] = a[k], a[j]
            det = -det
        pivot = a[j][j]
        det *= pivot
        for i in range(j + 1, n):
            if a[i][j]:
                c = a[i][j] / pivot
                a[i] = [x - c * y for x, y in zip(a[i], a[j])]
    return det


def row_basis_of_span(generators):
    """A unimodular row reduction of a full-rank integer generator matrix."""
    a = [row[:] for row in generators]
    n = len(a[0])
    rank = 0
    for col in range(n):
        p = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if p is None:
            continue
        a[rank], a[p] = a[p], a[rank]
        for j in range(rank + 1, len(a)):
            if not a[j][col]:
                continue
            aa, bb = a[rank][col], a[j][col]
            d, u, w = xgcd(aa, bb)
            old_p, old_j = a[rank][:], a[j][:]
            a[rank] = [u * x + w * y for x, y in zip(old_p, old_j)]
            a[j] = [-(bb // d) * x + (aa // d) * y
                    for x, y in zip(old_p, old_j)]
            assert a[j][col] == 0 and abs(a[rank][col]) == d
        rank += 1
    assert rank == n and all(not any(row) for row in a[n:])
    basis = a[:n]
    for col in range(n - 1, -1, -1):
        if basis[col][col] < 0:
            basis[col] = [-x for x in basis[col]]
        pivot = basis[col][col]
        assert pivot > 0
        for i in range(col):
            c = basis[i][col] // pivot
            basis[i] = [x - c * y for x, y in zip(basis[i], basis[col])]
            assert 0 <= basis[i][col] < pivot
    return basis


def action_mask(mask, rows):
    output = 0
    for i, row in enumerate(rows):
        if mask & (1 << i):
            output ^= row
    return output


def mask_rows(matrix):
    return [sum((x & 1) << j for j, x in enumerate(row))
            for row in matrix]


def twice_discriminant_masks(gk):
    inv4 = [[4 * x for x in row] for row in inverse(gk)]
    assert all(x.denominator == 1 for row in inv4 for x in row)
    generators = [sum((int(x) & 1) << j for j, x in enumerate(row))
                  for row in inv4]
    subgroup = {0}
    for gen in generators:
        subgroup = {x ^ y for x in subgroup for y in (0, gen)}
    assert len(subgroup) == 4
    return sorted(subgroup)


def graph_basis(a, b, swap):
    chosen = (b, a) if swap else (a, b)
    generators = [[2 * int(i == j) for j in range(12)] for i in range(12)]
    for k in range(2):
        row = [0] * 12
        row[k] = 1
        for j in range(10):
            row[j + 2] = (chosen[k] >> j) & 1
        generators.append(row)
    doubled_basis = row_basis_of_span(generators)
    assert abs(determinant(doubled_basis)) == 2**10
    return [[Fraction(x, 2) for x in row] for row in doubled_basis], chosen


def in_graph(vector, chosen):
    doubled = [2 * x for x in vector]
    assert all(x.denominator == 1 for x in doubled)
    parity = sum((int(x) & 1) << j for j, x in enumerate(doubled))
    u = 1 | (chosen[0] << 2)
    v = 2 | (chosen[1] << 2)
    return parity in (0, u, v, u ^ v)


def main():
    assert OUTPUT.exists() == REPORT.exists()
    saved = json.loads(FULL.read_text(encoding="utf-8"))
    qgraphs = json.loads(GRAPHS.read_text(encoding="utf-8"))
    w = saved["first_witness"]
    l, g, s = w["gram"], w["g"], w["s"]
    g2 = multiply(g, g)
    q = multiply(g2, s)
    assert multiply(q, q) == eye(22)
    anti = primitive_row_kernel([[q[i][j] + int(i == j)
                                  for j in range(22)] for i in range(22)])
    assert len(anti) == 12
    qgram = gram(anti, l)
    assert abs(determinant(qgram)) == 1024

    # E^-s = <root_1, root_5>, Gram 4I_2.  The K basis is literally the
    # last ten rows in the E⊕N source basis, as the N graph retained it.
    # The six-bit intertwiner_rows are discriminant coordinates; the actual
    # length-sixteen N vectors used in the full-L basis are stored separately.
    y = [[(mask >> j) & 1 for j in range(16)]
         for mask in w["n_discriminant_images"]]
    ambient = []
    for e in (0, 4):
        row = [0] * 22
        row[e] = 2
        for j in range(16):
            row[6 + j] = -y[e][j]
        ambient.append(row)
    for j in range(6, 16):
        row = [0] * 22
        row[6 + j] = 1
        ambient.append(row)
    assert len(ambient) == 12
    rec = qgraphs["records"]
    assert len(rec) == 2 and [x["swap"] for x in rec] == [False, True]
    gk = [row[2:] for row in rec[0]["gram"][2:]]
    jk = [row[2:] for row in rec[0]["g"][2:]]
    assert gk == [row[2:] for row in rec[1]["gram"][2:]]
    assert jk == [row[2:] for row in rec[1]["g"][2:]]
    g0 = block([[0, -1], [-1, 0]], jk)
    g0gram = block([[4, 0], [0, 4]], gk)
    common_gram = gram(ambient, l)
    if common_gram != g0gram:
        differences = [(i, j, common_gram[i][j], g0gram[i][j])
                       for i in range(12) for j in range(12)
                       if common_gram[i][j] != g0gram[i][j]]
        raise AssertionError(f"common ambient Gram mismatch: {differences[:12]}")
    assert multiply(ambient, g) == multiply(g0, ambient)
    assert multiply(ambient, q) == [[-x for x in row] for row in ambient]

    b_actual = [row_coordinates_fraction(ambient, x) for x in anti]
    assert abs(rational_det(b_actual)) == Fraction(1, 4)
    assert gram(b_actual, g0gram) == qgram
    aq = [row_coordinates_fraction(anti, multiply([x], g)[0]) for x in anti]
    assert all(y.denominator == 1 for row in aq for y in row)
    aq = [[int(y) for y in row] for row in aq]
    assert multiply(b_actual, g0) == multiply(aq, b_actual)

    r = twice_discriminant_masks(gk)
    nonfixed = [x for x in r if x and action_mask(x, mask_rows(jk)) != x]
    assert len(nonfixed) == 2
    a = nonfixed[0]
    b = action_mask(a, mask_rows(jk))
    assert b == nonfixed[1]
    results = []
    for saved_rec in rec:
        swap = saved_rec["swap"]
        b_graph, chosen = graph_basis(a, b, swap)
        included = all(in_graph(x, chosen) for x in b_actual)
        assert abs(rational_det(b_graph)) == Fraction(1, 4)
        g_graph = multiply(multiply(b_graph, g0), inverse(b_graph))
        g_graph_gram = gram(b_graph, g0gram)
        assert all(x.denominator == 1 for row in g_graph for x in row)
        assert all(x.denominator == 1 for row in g_graph_gram for x in row)
        exact_saved_basis = (
            g_graph_gram == saved_rec["gram"] and
            g_graph == saved_rec["g"])
        assert exact_saved_basis
        h_graph = multiply(g_graph, g_graph)
        assert h_graph == saved_rec["h"]
        assert [[-x for x in row] for row in h_graph] == saved_rec["s"]
        record = {"swap": swap, "actual_Q_in_graph": included,
                  "graph_basis_matches_saved_HNF": exact_saved_basis}
        if included:
            # Inclusion plus equal rational determinant means equality.
            t = multiply(b_actual, inverse(b_graph))
            assert all(x.denominator == 1 for row in t for x in row)
            t = [[int(x) for x in row] for row in t]
            assert abs(determinant(t)) == 1
            assert gram(t, g_graph_gram) == qgram
            assert multiply(aq, t) == multiply(t, g_graph)
            record["isometry_actual_Q_to_graph_coordinates"] = t
        results.append(record)
    matches = [r for r in results if r["actual_Q_in_graph"]]
    assert len(matches) == 1
    output = {"family": 127, "stage": "full_L_Q_exact_graph_realization",
              "q_fixed_anti_rank": 12, "q_anti_gram_determinant": determinant(qgram),
              "matched_swap": matches[0]["swap"], "records": results,
              "search_complete": False}
    if OUTPUT.exists():
        assert json.loads(OUTPUT.read_text(encoding="utf-8")) == output
    else:
        OUTPUT.write_text(json.dumps(output, separators=(",", ":")) + "\n", encoding="utf-8")
    lines = [
        "Family No. 127: exact full-L Q graph realization",
        "Q=L^-(g^2s) is saturated of rank 12 and absolute determinant 1024.",
        "Its coordinates in the common E^-s⊕K ambient lattice form an index-four overlattice.",
        f"Matched saved graph: swap={matches[0]['swap']}.",
        "The actual Q basis lies in that graph, and both lattices have absolute basis determinant 1/4.",
        "The reconstructed graph basis equals the saved HNF basis exactly.",
        "An explicit unimodular 12x12 change from actual Q to that saved basis is recorded in JSON.",
        "Gram and g/h/s-action intertwining hold exactly over Z.",
        "This identifies the graph for the saved first full-L witness only; it is not a complete finite graph search.",
    ]
    if not REPORT.exists():
        REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
