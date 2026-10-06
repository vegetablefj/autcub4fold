"""Independent exact audit of the saved full-L No. 127 witness.

Only reads JSON certificates; does not repeat any finite graph search.  This
file is deliberately independent of the searcher's helper module.
"""

from fractions import Fraction
from hashlib import sha256
from json import loads
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "family_127_g13_full_finite_glue_preflight.json"
N_SOURCE = HERE / "family_127_g13_n_finite_full_v10.json"
OUTPUT = HERE / "alternative_family_127_g13_full_l_audit.out"


def eye(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def mul(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def block(a, b):
    na, nb = len(a), len(b)
    return [row + [0] * nb for row in a] + [[0] * na + row for row in b]


def inverse(a):
    n = len(a)
    m = [[Fraction(x) for x in row] + [Fraction(int(i == j)) for j in range(n)]
         for i, row in enumerate(a)]
    for k in range(n):
        pivot = next(i for i in range(k, n) if m[i][k])
        m[k], m[pivot] = m[pivot], m[k]
        v = m[k][k]
        m[k] = [x / v for x in m[k]]
        for i in range(n):
            if i != k and m[i][k]:
                v = m[i][k]
                m[i] = [x - v * y for x, y in zip(m[i], m[k])]
    return [row[n:] for row in m]


def determinant(a):
    a = [list(map(int, row)) for row in a]
    n, last, sign = len(a), 1, 1
    for k in range(n - 1):
        p = next((i for i in range(k, n) if a[i][k]), None)
        if p is None:
            return 0
        if p != k:
            a[k], a[p] = a[p], a[k]
            sign = -sign
        pivot = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = pivot * a[i][j] - a[i][k] * a[k][j]
                assert numerator % last == 0
                a[i][j] = numerator // last
            a[i][k] = 0
        last = pivot
    return sign * a[-1][-1]


def inertia(a):
    """Exact symmetric congruence elimination, including zero diagonal pivots."""
    a = [[Fraction(x) for x in row] for row in a]
    pos = neg = 0
    while a:
        n = len(a)
        p = next((i for i in range(n) if a[i][i]), None)
        if p is None:
            pair = next(((i, j) for i in range(n) for j in range(i + 1, n)
                         if a[i][j]), None)
            assert pair is not None, "Degenerate form"
            i, j = pair
            # Congruence e_i -> e_i+e_j makes its diagonal nonzero.
            old_i = a[i][:]
            for k in range(n):
                a[i][k] = old_i[k] + a[j][k]
            for k in range(n):
                a[k][i] = a[i][k]
            a[i][i] = old_i[i] + 2 * old_i[j] + a[j][j]
            p = i
        a[0], a[p] = a[p], a[0]
        for row in a:
            row[0], row[p] = row[p], row[0]
        d = a[0][0]
        pos += d > 0
        neg += d < 0
        a = [[a[i][j] - a[i][0] * a[0][j] / d for j in range(1, n)]
             for i in range(1, n)]
    return pos, neg


def rank_mod2(rows, n):
    pivots = {}
    for row in rows:
        v = sum((int(row[j]) & 1) << j for j in range(n))
        while v:
            p = v.bit_length() - 1
            if p in pivots:
                v ^= pivots[p]
            else:
                pivots[p] = v
                break
    return len(pivots)


def pair(x, y, g):
    return mul(mul([x], g), transpose([y]))[0][0]


def e6_data():
    c = [
        [2, -1, 0, 0, 0, 0],
        [-1, 2, -1, 0, 0, 0],
        [0, -1, 2, -1, 0, -1],
        [0, 0, -1, 2, -1, 0],
        [0, 0, 0, -1, 2, 0],
        [0, 0, -1, 0, 0, 2],
    ]
    ge = [[2 * x for x in row] for row in c]
    g = [[-int(j == [4, 3, 2, 1, 0, 5][i]) for j in range(6)]
         for i in range(6)]
    refl = []
    for root in (0, 4):
        r = eye(6)
        for i in range(6):
            r[i][root] -= c[i][root]
        refl.append(r)
    return ge, g, mul(refl[0], refl[1]), [1, 2, 0, -2, -1, 0]


def check():
    raw, nraw = SOURCE.read_bytes(), N_SOURCE.read_bytes()
    data, nd = loads(raw), loads(nraw)
    assert data["family"] == 127 and data["input_sha256"] == sha256(nraw).hexdigest()
    assert not data["search_complete"]  # This is one found graph, not classification.
    w, nw = data["first_witness"], nd["first_witness"]
    gl, g, s = w["gram"], w["g"], w["s"]
    gn, ng, ns = nw["gram"], nw["g"], nw["s"]
    ge, eg, es, pe = e6_data()
    assert all(len(a) == 22 and all(len(r) == 22 for r in a) for a in (gl, g, s))
    assert determinant(ge) == 192 and determinant(gn) == 64
    assert inertia(ge) == (6, 0) and inertia(gn) == (14, 2)
    assert len(w["n_discriminant_images"]) == 6
    y = [[(v >> j) & 1 for j in range(16)] for v in w["n_discriminant_images"]]
    assert rank_mod2(y, 16) == 6
    # Rows are embeddings of E6(2) and N in the displayed L basis.
    e_embed = [[2 * int(i == j) for j in range(6)] + [-x for x in y[i]]
               for i in range(6)]
    n_embed = [[0] * 6 + row for row in eye(16)]
    c = e_embed + n_embed
    assert determinant(c) == 64
    assert mul(mul(c, gl), transpose(c)) == block(ge, gn)
    assert mul(mul(c, g), inverse(c)) == block(eg, ng)
    assert mul(mul(c, s), inverse(c)) == block(es, ns)
    assert rank_mod2(e_embed, 22) == 6  # 2-primary primitivity; odd primes clear.
    assert rank_mod2(n_embed, 22) == 16  # Direct summand, hence primitive.
    assert gl == transpose(gl) and all(gl[i][i] % 2 == 0 for i in range(22))
    assert determinant(gl) == 3 and inertia(gl) == (20, 2)
    assert mul(mul(g, gl), transpose(g)) == gl
    assert mul(mul(s, gl), transpose(s)) == gl
    ii = eye(22)
    g2 = mul(g, g)
    assert mul(g2, g2) == ii and g2 != ii
    assert mul(s, s) == ii and mul(g, s) == mul(s, g)
    assert mul(mul(c, g2), inverse(c)) == block(eye(6), [[-x for x in row] for row in eye(16)])
    invl = inverse(gl)
    for action in (g, s):
        diff = [[action[i][j] - ii[i][j] for j in range(22)] for i in range(22)]
        assert all(x.denominator == 1 for row in mul(invl, diff) for x in row)
    p = w["plane"]
    assert len(p) == 22
    assert mul([pe + [0] * 16], c) == [p]
    assert pair(p, p, gl) == 24
    assert mul([p], g) == [p] and mul([p], s) == [p]
    div = gcd(*(abs(v) for v in mul([p], gl)[0]))
    assert div == 3 and w["plane_divisibility"] == 3
    assert gcd(*(abs(v) for v in p)) == 1
    return [
        f"source_sha256={sha256(raw).hexdigest()}",
        f"n_source_sha256={sha256(nraw).hexdigest()}",
        "search_complete=false; existence witness only",
        "E6(2) and N primitive, orthogonal; joint index=64",
        "L even rank=22 signature=(20,2) determinant=3",
        "g^4=I, g^2|E=+I, g^2|N=-I, s^2=I, gs=sg; both integral isometries",
        "g and s trivial on A_L=Z/3",
        "plane primitive, g/s-fixed, norm=24, divisibility=3",
        "RESULT=PASS",
    ]


if __name__ == "__main__":
    assert not OUTPUT.exists(), f"Refusing to overwrite {OUTPUT}"
    lines = check()
    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))
