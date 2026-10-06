"""Small exact-integer checks for two determinant-1024 K candidates.

No lattice-isometry search is performed. All discriminant counts use
finite groups of at most 1024 elements.
"""

from collections import deque
from fractions import Fraction
from math import gcd


def zero(n, m):
    return [[0 for _ in range(m)] for _ in range(n)]


def block(*parts):
    n = sum(len(a) for a in parts)
    out = zero(n, n)
    k = 0
    for a in parts:
        for i, row in enumerate(a):
            for j, value in enumerate(row):
                out[k + i][k + j] = value
        k += len(a)
    return out


def transpose(a):
    return [list(row) for row in zip(*a)]


def multiply(a, b):
    bt = transpose(b)
    return [[sum(x * y for x, y in zip(row, col)) for col in bt] for row in a]


def gram_of_rows(rows, gram):
    return multiply(multiply(rows, gram), transpose(rows))


def pair(x, y, gram):
    return sum(x[i] * gram[i][j] * y[j]
               for i in range(len(x)) for j in range(len(y)))


def determinant(a):
    m = [row[:] for row in a]
    n = len(m)
    prev, sign = 1, 1
    for k in range(n - 1):
        if m[k][k] == 0:
            pivot = next((i for i in range(k + 1, n) if m[i][k]), None)
            if pivot is None:
                return 0
            m[k], m[pivot] = m[pivot], m[k]
            sign = -sign
        pivot = m[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                num = m[i][j] * pivot - m[i][k] * m[k][j]
                assert num % prev == 0
                m[i][j] = num // prev
            m[i][k] = 0
        prev = pivot
    return sign * m[-1][-1]


def inverse(a):
    n = len(a)
    m = [[Fraction(a[i][j]) for j in range(n)] +
         [Fraction(i == j) for j in range(n)] for i in range(n)]
    for j in range(n):
        pivot = next(i for i in range(j, n) if m[i][j])
        m[j], m[pivot] = m[pivot], m[j]
        t = m[j][j]
        m[j] = [x / t for x in m[j]]
        for i in range(n):
            if i != j:
                t = m[i][j]
                m[i] = [x - t * y for x, y in zip(m[i], m[j])]
    return [row[n:] for row in m]


def rank_mod2(a):
    rows = [sum((x & 1) << j for j, x in enumerate(row)) for row in a]
    pivots = {}
    for row in rows:
        while row:
            k = row.bit_length() - 1
            if k in pivots:
                row ^= pivots[k]
            else:
                pivots[k] = row
                break
    return len(pivots)


def rank_bits(values):
    pivots = {}
    for value in values:
        while value:
            k = value.bit_length() - 1
            if k in pivots:
                value ^= pivots[k]
            else:
                pivots[k] = value
                break
    return len(pivots)


def bits(mask, n):
    return [(mask >> i) & 1 for i in range(n)]


def two_torsion(gram):
    n = len(gram)
    return [m for m in range(1 << n)
            if all(pair(bits(m, n), bits(1 << j, n), gram) % 2 == 0
                   for j in range(n))]


def integral_q_count(gram, elements):
    n = len(gram)
    return sum(pair(bits(m, n), bits(m, n), gram) % 4 == 0
               for m in elements)


def action_rank_on_bits(action, elements):
    n = len(action)
    rows = [sum((value & 1) << j for j, value in enumerate(row))
            for row in action]
    images = []
    for mask in elements:
        image = 0
        for i in range(n):
            if mask & (1 << i):
                image ^= rows[i]
        images.append(image ^ mask)
    return rank_bits(images)


def discriminant_elements(gram):
    inv = inverse(gram)
    n = len(gram)
    assert all((4 * entry).denominator == 1
               for row in inv for entry in row)
    generators = [tuple(int(4 * entry) % 4 for entry in row)
                  for row in inv]
    origin = (0,) * n
    seen = {origin}
    queue = deque([origin])
    while queue:
        x = queue.popleft()
        for g in generators:
            y = tuple((a + b) % 4 for a, b in zip(x, g))
            if y not in seen:
                seen.add(y)
                queue.append(y)
    return seen


def norm_mod32(z, gram):
    return pair(z, z, gram) % 32


def pair_mod16(x, y, gram):
    return pair(x, y, gram) % 16


def e8_cartan():
    a = zero(8, 8)
    for i in range(8):
        a[i][i] = 2
    for i, j in [(0, 1), (1, 2), (2, 3), (3, 4),
                 (4, 5), (5, 6), (2, 7)]:
        a[i][j] = a[j][i] = -1
    return a


def d6_data():
    roots = zero(6, 6)
    for i in range(5):
        roots[i][i] = 1
        roots[i][i + 1] = -1
    roots[5][4] = roots[5][5] = 1
    cartan = gram_of_rows(roots, [[int(i == j) for j in range(6)]
                                  for i in range(6)])
    j_euclid = zero(6, 6)
    for i in (0, 2, 4):
        j_euclid[i][i + 1] = 1
        j_euclid[i + 1][i] = -1
    j_root = zero(6, 6)
    for i in range(6):
        y = multiply([roots[i]], j_euclid)[0]
        s = sum(y[:4])
        coeffs = [y[0], y[0] + y[1], y[0] + y[1] + y[2],
                  s, (s + y[4] - y[5]) // 2, (s + y[4] + y[5]) // 2]
        assert multiply([coeffs], roots)[0] == y
        j_root[i] = coeffs
    gram = [[2 * x for x in row] for row in cartan]
    assert multiply(multiply(j_root, gram), transpose(j_root)) == gram
    assert multiply(j_root, j_root) == [[-int(i == j) for j in range(6)]
                                      for i in range(6)]
    return gram, j_root


def check_complement_in_q():
    u = [[0, 1], [1, 0]]
    qgram = block(u, [[2]], [[-2]],
                  [[2 * x for x in row] for row in e8_cartan()])
    assert determinant(e8_cartan()) == 1
    assert determinant(qgram) == 1024
    v1 = [0] * 12
    v1[4] = 1
    v2 = [2, -2, 1, 1, -1, -2, 0, 0, 0, 0, 0, 0]
    assert gram_of_rows([v1, v2], qgram) == [[4, 0], [0, 4]]
    assert [gcd(*(pair(v, bits(1 << i, 12), qgram)
                  for i in range(12))) for v in (v1, v2)] == [2, 2]
    assert rank_mod2([v1, v2]) == 2
    # The two orthogonality equations are y2=2*y1 and
    # b=a-c+d+6*y1-2*y3. These ten rows parameterize every
    # integer solution, so they are a saturated basis for K.
    basis = []
    for idx in range(10):
        a = int(idx == 0)
        c = int(idx == 1)
        d = int(idx == 2)
        y1 = int(idx == 3)
        y3 = int(idx == 4)
        ys = [0] * 8
        ys[0], ys[1], ys[2] = y1, 2 * y1, y3
        if idx >= 5:
            ys[idx - 2] = 1
        b = a - c + d + 6 * y1 - 2 * y3
        basis.append([a, b, c, d] + ys)
    assert all(pair(x, v, qgram) == 0
               for x in basis for v in (v1, v2))
    kgram = gram_of_rows(basis, qgram)
    assert all(kgram[i][i] % 2 == 0 for i in range(10))
    assert determinant(kgram) == 1024
    assert rank_mod2(kgram) == 2
    elements2 = two_torsion(kgram)
    assert len(elements2) == 256
    assert integral_q_count(kgram, elements2) == 256
    disc = discriminant_elements(kgram)
    assert len(disc) == 1024
    r = {tuple((2 * value) % 4 for value in x) for x in disc}
    assert len(r) == 4
    assert sorted(norm_mod32(x, kgram) // 16 for x in r) == [0, 0, 1, 1]
    # Find an orthogonal positive 4-block. Its complement is a
    # 6-dimensional nondegenerate, integral-valued 2-form.
    order4 = [x for x in disc if tuple((2 * z) % 4 for z in x) != (0,) * 10]
    quarter = [x for x in order4 if norm_mod32(x, kgram) % 16 == 4]
    witness = None
    for x in quarter:
        rx = tuple((2 * z) % 4 for z in x)
        for y in quarter:
            ry = tuple((2 * z) % 4 for z in y)
            if ry == rx or pair_mod16(x, y, kgram) != 0:
                continue
            complement = [z for z in disc
                          if pair_mod16(z, x, kgram) == 0
                          and pair_mod16(z, y, kgram) == 0]
            if len(complement) != 64:
                continue
            if any(tuple((2 * z) % 4 for z in z0) != (0,) * 10
                   for z0 in complement):
                continue
            qzero = sum(norm_mod32(z, kgram) == 0 for z in complement)
            witness = (x, y, qzero)
            break
        if witness:
            break
    assert witness is not None
    x, y, qzero = witness
    assert qzero == 28  # Arf invariant one: u(2)^2 + v(2).
    print("Q-complement: v1^2=v2^2=4, pairing=0, divisibilities=(2,2)")
    print("Q-complement: A primitive (independent mod 2); glue index=4")
    print("Q-complement: K rank=10, signature=(8,2), determinant=1024")
    print("Q-complement: Gram mod2 rank=2, exponent<=4, SNF=(1^2,2^6,4^2)")
    print("Q-complement: |A_K[2]|=256, integral-q count=256, delta_K=0")
    print("Q-complement: 2A_K q-values=(0,1,1); q4 has orthogonal (1/4,1/4) generators")
    print("Q-complement: q2 complement size=64, isotropic count=28, Arf=1")
    print("Q-complement: finite q_K=<1/4>^2 + u(2)^2 + v(2)")
    print("Q-complement: characteristic c_Q=[(p+n)/2]=[(v1+v2)/2]")
    return kgram


def check_k0():
    c = [[1, 1], [-1, 1]]
    r = [[0, 1], [-1, 0]]
    g4 = [[0, 0, c[0][0], c[0][1]],
          [0, 0, c[1][0], c[1][1]],
          [c[0][0], c[1][0], 0, 0],
          [c[0][1], c[1][1], 0, 0]]
    j4 = block(r, r)
    d6, j6 = d6_data()
    kgram = block(g4, d6)
    j = block(j4, j6)
    assert determinant(g4) == 4
    assert determinant(kgram) == 1024
    assert rank_mod2(kgram) == 2
    assert all((4 * entry).denominator == 1
               for row in inverse(kgram) for entry in row)
    g4_torsion = two_torsion(g4)
    assert len(g4_torsion) == 4
    assert sum(pair(bits(m, 4), bits(m, 4), g4) % 8 == 0
               for m in g4_torsion) == 3
    assert multiply(j, j) == [[-int(i == h) for h in range(10)]
                              for i in range(10)]
    assert multiply(multiply(j, kgram), transpose(j)) == kgram
    inv4 = inverse(g4)
    assert all((sum(inv4[i][k] * j4[k][h] for k in range(4))
                - inv4[i][h]).denominator == 1
               for i in range(4) for h in range(4))
    elements2 = two_torsion(kgram)
    assert len(elements2) == 256
    assert integral_q_count(kgram, elements2) == 256
    assert action_rank_on_bits(j, elements2) == 3
    print("K0: G4 even, signature=(2,2), determinant=4, A_G4=u(2), delta=0")
    print("K0: J4^2=-I, J4 is integral isometry; J4 acts trivially on A_G4")
    print("K0: rank=10, signature=(8,2), determinant=1024")
    print("K0: |A_K[2]|=256, integral-q count=256, rank(J+I on A_K[2])=3")
    a4 = [[4, 0], [0, 4]]
    qbase = block(a4, kgram)
    # On A=E^{-s}, g is the order-two negative swap, not a rotation.
    g_a = [[0, -1], [-1, 0]]
    g_base = block(g_a, j)
    h_base = block([[1, 0], [0, 1]],
                   [[-int(i == h) for h in range(10)]
                    for i in range(10)])
    assert multiply(g_base, g_base) == h_base
    rad1 = [1, 0, 1, 0, 1, 0]
    rad2 = [1, 0, 1, 0, 0, 1]
    d6_r = {tuple((2 * value) % 4 for value in x)
            for x in discriminant_elements(d6)}
    assert len(d6_r) == 4
    assert tuple((2 * value) % 4 for value in rad1) in d6_r
    assert tuple((2 * value) % 4 for value in rad2) in d6_r
    assert rad1 != rad2
    assert [x % 2 for x in multiply([rad1], j6)[0]] == rad2
    assert [x % 2 for x in multiply([rad2], j6)[0]] == rad1
    assert pair(rad1, rad1, d6) % 8 == 4
    assert pair(rad2, rad2, d6) % 8 == 4
    assert pair(rad1, rad2, d6) % 4 == 0
    for swap in (False, True):
        first, second = (rad2, rad1) if swap else (rad1, rad2)
        over = zero(12, 12)
        over[0][0] = over[1][1] = 1
        for k, v in enumerate((first, second)):
            for i, value in enumerate(v):
                over[k][6 + i] = value
        for i in range(10):
            over[i + 2][i + 2] = 2
        # Rows of over/2 are the new basis: two graph generators
        # followed by the ten original K0 basis vectors.
        raw = gram_of_rows(over, qbase)
        assert all(value % 4 == 0 for row in raw for value in row)
        qgram = [[value // 4 for value in row] for row in raw]
        assert all(qgram[i][i] % 2 == 0 for i in range(12))
        g_on_q = multiply(multiply(over, g_base), inverse(over))
        assert all(value.denominator == 1
                   for row in g_on_q for value in row)
        assert multiply(multiply(g_on_q, qgram), transpose(g_on_q)) == qgram
        assert determinant(qgram) == 1024
        q2 = two_torsion(qgram)
        assert len(q2) == 1024
        integral = integral_q_count(qgram, q2)
        assert integral == 1024
        print(f"K0 Q-glue swap={swap}: index=4, integral_g=true, det=1024, "
              f"|A_Q[2]|=1024, integral-q count={integral}, delta_Q=0")
    # The elementary diagonal N graph is a useful comparison only.
    nbase = block(d6, kgram)
    over = zero(16, 16)
    for i in range(6):
        over[i][i] = 1
        over[i][10 + i] = 1
    for i in range(10):
        over[6 + i][6 + i] = 2
    raw = gram_of_rows(over, nbase)
    assert all(value % 4 == 0 for row in raw for value in row)
    ngram = [[value // 4 for value in row] for row in raw]
    assert determinant(ngram) == 64
    n2 = two_torsion(ngram)
    assert len(n2) == 64
    integral = integral_q_count(ngram, n2)
    assert integral < 64
    print(f"K0 diagonal N-glue: index=64, det=64, "
          f"|A_N[2]|=64, integral-q count={integral}, delta_N=1")


if __name__ == "__main__":
    check_complement_in_q()
    check_k0()
    print("COMPLETED: finite and exact checks only; this script does not construct J on Q-complement")
