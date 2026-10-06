"""Independent exact-integer audit of the first saved No. 127 N witness.

Reconstruct M, K and their order-four actions from the source Q JSON, then
verify the saved index-64 overlattice. No OSCAR call or enumeration is made.
"""

import hashlib
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
Q_PATH = HERE / "family_127_g13_q_graph_preflight.json"
N_PATH = HERE / "family_127_g13_n_finite_full_v10.json"
OUT_PATH = HERE / "family_127_g13_n_witness_integer_audit.out"


def eye(n, sign=1):
    return [[sign * int(i == j) for j in range(n)] for i in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def multiply(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def block(a, b):
    na, nb = len(a), len(b)
    result = [[0] * (na + nb) for _ in range(na + nb)]
    for i in range(na):
        result[i][:na] = a[i][:]
    for i in range(nb):
        result[na + i][na:] = b[i][:]
    return result


def inverse(a):
    n = len(a)
    work = [[Fraction(x) for x in row] +
            [Fraction(int(i == j)) for j in range(n)]
            for i, row in enumerate(a)]
    for j in range(n):
        p = next(i for i in range(j, n) if work[i][j] != 0)
        work[j], work[p] = work[p], work[j]
        v = work[j][j]
        work[j] = [x / v for x in work[j]]
        for i in range(n):
            if i != j:
                v = work[i][j]
                work[i] = [x - v * y for x, y in zip(work[i], work[j])]
    return [row[n:] for row in work]


def determinant(a):
    m = [row[:] for row in a]
    n = len(m)
    previous, sign = 1, 1
    for k in range(n - 1):
        if m[k][k] == 0:
            p = next((i for i in range(k + 1, n) if m[i][k]), None)
            if p is None:
                return 0
            m[k], m[p] = m[p], m[k]
            sign = -sign
        pivot = m[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                number = m[i][j] * pivot - m[i][k] * m[k][j]
                assert number % previous == 0
                m[i][j] = number // previous
            m[i][k] = 0
        previous = pivot
    return sign * m[-1][-1]


def rank_mod2(rows):
    pivots = {}
    for row in rows:
        v = sum((int(x) & 1) << i for i, x in enumerate(row))
        while v:
            j = v.bit_length() - 1
            if j in pivots:
                v ^= pivots[j]
            else:
                pivots[j] = v
                break
    return len(pivots)


def gram(rows, g):
    return multiply(multiply(rows, g), transpose(rows))


def image(u, a):
    return [sum(u[i] * a[i][j] for i in range(len(u))) & 1
            for j in range(len(a[0]))]


def pair(u, v, g):
    return multiply(multiply([u], g), transpose([v]))[0][0]


def d6_matrices():
    roots = []
    for i in range(5):
        row = [0] * 6
        row[i], row[i + 1] = 1, -1
        roots.append(row)
    roots.append([0, 0, 0, 0, 1, 1])
    gm = [[2 * x for x in row] for row in gram(roots, eye(6))]
    je = [[0] * 6 for _ in range(6)]
    for i in (0, 2, 4):
        je[i][i + 1], je[i + 1][i] = 1, -1
    jm = multiply(multiply(roots, je), inverse(roots))
    assert all(x.denominator == 1 for row in jm for x in row)
    jm = [[int(x) for x in row] for row in jm]
    assert gram(jm, gm) == gm and multiply(jm, jm) == eye(6, -1)
    return gm, jm


def main():
    q_bytes = Q_PATH.read_bytes()
    q = json.loads(q_bytes)
    data = json.loads(N_PATH.read_text(encoding="utf-8"))
    assert data["family"] == 127 and data["first_witness"] is not None
    assert data["input_sha256"] == hashlib.sha256(q_bytes).hexdigest()
    assert data["v_start"] == data["v_end"] == 10
    witness = data["first_witness"]
    assert witness["v_index"] == 10
    gm, jm = d6_matrices()
    gk = [row[2:] for row in q["records"][0]["gram"][2:]]
    jk = [row[2:] for row in q["records"][0]["g"][2:]]
    assert gk == [row[2:] for row in q["records"][1]["gram"][2:]]
    assert jk == [row[2:] for row in q["records"][1]["g"][2:]]
    assert determinant(gm) == 256 and determinant(gk) == 1024
    assert gram(jk, gk) == gk and multiply(jk, jk) == eye(10, -1)

    phi = [[(mask >> j) & 1 for j in range(10)]
           for mask in witness["phi_basis_masks"]]
    assert len(phi) == 6 and rank_mod2(phi) == 6
    source = block(gm, gk)
    g_source = block(jm, jk)
    s_source = block(eye(6, -1), eye(10))
    b = [[Fraction(0) for _ in range(16)] for _ in range(16)]
    for i in range(6):
        b[i][i] = Fraction(1, 2)
        for j in range(10):
            b[i][6 + j] = Fraction(phi[i][j], 2)
    for i in range(10):
        b[6 + i][6 + i] = Fraction(1)
    b_inv = inverse(b)
    assert all(x.denominator == 1 for row in b_inv for x in row)
    assert all(b_inv[i][j] == (2 * int(i == j) if j < 6 else -phi[i][j - 6])
               for i in range(6) for j in range(16))
    assert all(b_inv[6 + i][j] == int(j == 6 + i)
               for i in range(10) for j in range(16))
    gn = gram(b, source)
    gn = [[int(x) for x in row] for row in gn]
    g = multiply(multiply(b, g_source), b_inv)
    s = multiply(multiply(b, s_source), b_inv)
    assert all(x.denominator == 1 for row in g + s for x in row)
    g = [[int(x) for x in row] for row in g]
    s = [[int(x) for x in row] for row in s]
    assert gn == witness["gram"] and g == witness["g"] and s == witness["s"]
    assert gn == transpose(gn) and all(gn[i][i] % 2 == 0 for i in range(16))
    assert determinant(gn) == 64
    assert gram(g, gn) == gn and gram(s, gn) == gn
    assert multiply(g, g) == eye(16, -1)
    assert multiply(s, s) == eye(16)
    assert multiply(g, s) == multiply(s, g)

    # The graph is injective, J-equivariant and isotropic on all 64 elements.
    isotropic = 0
    for mask in range(64):
        u = [(mask >> i) & 1 for i in range(6)]
        v = image(u, phi)
        assert image(image(u, jm), phi) == image(v, jk)
        if (pair(u, u, gm) + pair(v, v, gk)) % 8 == 0:
            isotropic += 1
    assert isotropic == 64

    # Embed the original M and K in N, then check restriction of both maps.
    em = [[int(x) for x in row] for row in b_inv[:6]]
    ek = [[int(x) for x in row] for row in b_inv[6:]]
    assert gram(em, gn) == gm and gram(ek, gn) == gk
    assert multiply(multiply(em, gn), transpose(ek)) == [[0] * 10 for _ in range(6)]
    assert rank_mod2(em) == 6 and rank_mod2(ek) == 10
    assert multiply(em, g) == multiply(jm, em)
    assert multiply(ek, g) == multiply(jk, ek)
    assert multiply(em, s) == [[-x for x in row] for row in em]
    assert multiply(ek, s) == ek

    dual = inverse(gn)
    assert all((2 * x).denominator == 1 for row in dual for x in row)
    assert all(dual[i][i].denominator == 1 for i in range(16))
    assert rank_mod2(gn) == 10
    lines = [
        "No. 127 genus-13 first N witness: independent exact-integer audit",
        f"Input SHA256 matches the saved Q JSON: {data['input_sha256']}",
        "Both Q graphs have identical lower-right K Gram and J blocks.",
        "D6(2) M: rank 6, determinant 256, J^2=-I.",
        "K: rank 10, determinant 1024, J^2=-I.",
        "Graph map: rank_F2(phi)=6; all 64 graph elements are J-equivariant and q-isotropic.",
        "Overlattice index [N:M+K]=64; N Gram even integral, determinant 64.",
        "Saved N Gram, g and s match independently reconstructed matrices exactly.",
        "g^2=-I=h; s^2=I; gs=sg; both are integral N-isometries.",
        "Embedded M and K are orthogonal, primitive, and are exactly the -/+ s eigensublattices.",
        "A_N has order 64, exponent 2, delta 0 (2*G_N^-1 integral; diagonal G_N^-1 integral).",
        "No abstract N isometry, full E+N gluing, or cubic geometry is claimed here.",
    ]
    content = "\n".join(lines) + "\n"
    if OUT_PATH.exists() and OUT_PATH.read_text(encoding="utf-8") != content:
        raise FileExistsError(f"Refusing to replace changed output: {OUT_PATH}")
    OUT_PATH.write_text(content, encoding="utf-8")
    print(content, end="")


if __name__ == "__main__":
    main()
