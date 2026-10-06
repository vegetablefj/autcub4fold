"""Exact Q(sqrt(2)) model for the outer action in HLWZ, Section 3.4.

This is an exploratory diagnostic, not a proof of the period-to-equation match.
The seven-dimensional permutation module restricts to the sum-zero space used
for the cubic equations. All group and eigenspace arithmetic is exact.
"""

from fractions import Fraction


class K:
    __slots__ = ("a", "b")

    def __init__(self, a=0, b=0):
        self.a = Fraction(a)
        self.b = Fraction(b)

    def __add__(self, other):
        other = coerce(other)
        return K(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return K(-self.a, -self.b)

    def __sub__(self, other):
        return self + -coerce(other)

    def __rsub__(self, other):
        return coerce(other) - self

    def __mul__(self, other):
        other = coerce(other)
        return K(self.a * other.a + 2 * self.b * other.b,
                 self.a * other.b + self.b * other.a)

    __rmul__ = __mul__

    def __truediv__(self, other):
        other = coerce(other)
        d = other.a * other.a - 2 * other.b * other.b
        if not d:
            raise ZeroDivisionError
        return K((self.a * other.a - 2 * self.b * other.b) / d,
                 (self.b * other.a - self.a * other.b) / d)

    def __eq__(self, other):
        other = coerce(other)
        return self.a == other.a and self.b == other.b

    def __repr__(self):
        if not self.b:
            return str(self.a)
        return f"({self.a}+{self.b}*sqrt(2))"

    def __bool__(self):
        return bool(self.a or self.b)


def coerce(x):
    return x if isinstance(x, K) else K(x)


N = 7
ZERO = K()
ONE = K(1)


def ident():
    return [[ONE if i == j else ZERO for j in range(N)] for i in range(N)]


def mul(A, B):
    return [[sum((A[i][k] * B[k][j] for k in range(N)), ZERO)
             for j in range(N)] for i in range(N)]


def add(A, B):
    return [[A[i][j] + B[i][j] for j in range(N)] for i in range(N)]


def scale(c, A):
    return [[c * A[i][j] for j in range(N)] for i in range(N)]


def compose(p, q):
    return tuple(p[q[i]] for i in range(N))


def cycle(*cycles):
    p = list(range(N))
    for c in cycles:
        c = [i - 1 for i in c]
        for a, b in zip(c, c[1:] + c[:1]):
            p[a] = b
    return tuple(p)


def pmatrix(p):
    A = [[ZERO for _ in range(N)] for _ in range(N)]
    for j, i in enumerate(p):
        A[i][j] = ONE
    return A


def power(A, e):
    result = ident()
    for _ in range(e):
        result = mul(result, A)
    return result


def group(generators):
    unit = tuple(range(N))
    found = {unit}
    queue = [unit]
    for g in queue:
        for h in generators:
            q = compose(g, h)
            if q not in found:
                found.add(q)
                queue.append(q)
    return queue


def kernel(A):
    """Nullspace basis over Q(sqrt(2)), with vectors stored as columns."""
    A = [[coerce(x) for x in row] for row in A]
    rows, cols = len(A), len(A[0])
    pivots = []
    r = 0
    for j in range(cols):
        k = next((i for i in range(r, rows) if A[i][j]), None)
        if k is None:
            continue
        A[r], A[k] = A[k], A[r]
        c = A[r][j]
        A[r] = [x / c for x in A[r]]
        for i in range(rows):
            if i != r and A[i][j]:
                c = A[i][j]
                A[i] = [A[i][m] - c * A[r][m] for m in range(cols)]
        pivots.append(j)
        r += 1
        if r == rows:
            break
    free = [j for j in range(cols) if j not in pivots]
    result = []
    for j in free:
        v = [ZERO for _ in range(cols)]
        v[j] = ONE
        for i, p in enumerate(pivots):
            v[p] = -A[i][j]
        result.append(v)
    return result


def rank(A):
    return len(A[0]) - len(kernel(A))


def eigenspace_sum_zero(M, eigenvalue):
    rows = [[M[j][i] - (eigenvalue if i == j else ZERO)
             for j in range(N)] for i in range(N)]
    rows.append([ONE] * N)
    basis = kernel(rows)
    assert len(basis) == 3
    return basis


def monomial(nvars, *indices):
    exponents = [0] * nvars
    for i in indices:
        exponents[i] += 1
    return tuple(exponents)


def form_polynomial(B, sign):
    """Substitute x_i=sum_j B[j][i] y_j in HLWZ F_+ or F_-."""
    nvars = len(B)
    result = {}

    def add_term(coef, *indices):
        if not coef:
            return
        e = monomial(nvars, *indices)
        result[e] = result.get(e, ZERO) + coef

    for i in range(7):
        for j in range(nvars):
            for k in range(nvars):
                for l in range(nvars):
                    add_term(B[j][i] * B[k][i] * B[l][i], j, k, l)
    fano_lines = ((0, 1, 3), (1, 2, 4), (2, 3, 5), (0, 4, 5),
                  (0, 2, 6), (3, 4, 6), (1, 5, 6))
    c = K(0, Fraction(3, 2) * sign)
    for i, j, k in fano_lines:
        for p in range(nvars):
            for q in range(nvars):
                for r in range(nvars):
                    add_term(c * B[p][i] * B[q][j] * B[r][k], p, q, r)
    return {e: v for e, v in result.items() if v}


def poly_mul(A, B):
    out = {}
    for e, a in A.items():
        for f, b in B.items():
            g = tuple(x + y for x, y in zip(e, f))
            out[g] = out.get(g, ZERO) + a * b
    return {e: a for e, a in out.items() if a}


def poly_add(A, B, sign=1):
    out = A.copy()
    for e, a in B.items():
        out[e] = out.get(e, ZERO) + sign * a
    return {e: a for e, a in out.items() if a}


def branch_cubics(M, sign):
    noncontained = eigenspace_sum_zero(M, K(sign))
    contained = eigenspace_sum_zero(M, K(-sign))
    F = form_polynomial(noncontained + contained, sign)
    C = {}
    A = [[{} for _ in range(3)] for _ in range(3)]
    for e, coef in F.items():
        y, z = e[:3], e[3:]
        dz = sum(z)
        if dz == 0:
            C[y] = coef
        elif dz == 2 and sum(y) == 1:
            indices = [i for i in range(3) for _ in range(z[i])]
            i, j = indices
            fac = K(1) if i == j else K(2)
            A[i][j][y] = coef / fac
            A[j][i][y] = coef / fac
        else:
            raise AssertionError(("forbidden monomial", e, coef))
    D = {}
    for p in ((0, 1, 2), (0, 2, 1), (1, 0, 2),
              (1, 2, 0), (2, 0, 1), (2, 1, 0)):
        parity = (-1) ** sum(p[i] > p[j] for i in range(3) for j in range(i + 1, 3))
        piece = poly_mul(poly_mul(A[0][p[0]], A[1][p[1]]), A[2][p[2]])
        D = poly_add(D, piece, parity)
    return noncontained, contained, C, D


def poly_repr(P):
    terms = []
    for e, c in sorted(P.items(), reverse=True):
        var = "*".join(f"y{i+1}^{n}" for i, n in enumerate(e) if n)
        terms.append(f"{c}*{var}")
    return " + ".join(terms)


def reduce_mod_p(P, p, root_two):
    return {e: (int(c.a.numerator) * pow(c.a.denominator, -1, p)
                + root_two * int(c.b.numerator) * pow(c.b.denominator, -1, p)) % p
            for e, c in P.items()}


def projective_points(p):
    for a in range(p):
        for b in range(p):
            yield 1, a, b
    for a in range(p):
        yield 0, 1, a
    yield 0, 0, 1


def gradient_mod_p(P, y, p):
    out = [0, 0, 0]
    for e, c in P.items():
        for i in range(3):
            if e[i]:
                v = c * e[i]
                for j in range(3):
                    v *= pow(y[j], e[j] - (i == j), p)
                out[i] = (out[i] + v) % p
    return out


def singular_pencil_parameters_mod_p(C, D, p, root_two):
    assert root_two * root_two % p == 2
    C, D = reduce_mod_p(C, p, root_two), reduce_mod_p(D, p, root_two)
    singular = {}
    for y in projective_points(p):
        c = gradient_mod_p(C, y, p)
        d = gradient_mod_p(D, y, p)
        if any(d):
            i = next(i for i in range(3) if d[i])
            t = -c[i] * pow(d[i], -1, p) % p
            if all((c[j] + t * d[j]) % p == 0 for j in range(3)):
                singular.setdefault(t, []).append(y)
        elif not any(c):
            raise AssertionError(("all pencil members singular at", y))
    return singular


g2 = cycle((1, 2), (3, 6))
g7 = cycle((1, 2, 3, 4, 5, 6, 7))
P = cycle((2, 4, 3, 7, 5, 6))
G7 = pmatrix(g7)
a = K(Fraction(1, 7), Fraction(2, 7))
b = K(Fraction(1, 7), Fraction(-3, 14))
Q = scale(a, add(add(ident(), power(G7, 4)), power(G7, 6)))
for i in (1, 2, 3, 5):
    Q = add(Q, scale(b, power(G7, i)))
E = mul(pmatrix(P), Q)


def main():
    L = group((g2, g7))
    print("|L2(7)| =", len(L))
    print("E^2 = (162)(457):", power(E, 2) == pmatrix(cycle((1, 6, 2), (4, 5, 7))))
    outer2 = []
    for g in L:
        M = mul(pmatrix(g), E)
        if power(M, 2) == ident():
            tr = sum((M[i][i] for i in range(N)), ZERO)
            outer2.append((g, M, tr))
    print("Outer involutions:", len(outer2))
    print("7D trace counts:", {repr(t): sum(1 for _, _, z in outer2 if z == t)
                               for t in (K(-5), K(-1), K(1), K(5))})
    for i, (g, _, tr) in enumerate(outer2[:5]):
        print("sample", i, "g=", g, "trace7=", tr)
    g, M, _ = outer2[0]
    for sign in (1, -1):
        noncontained, contained, C, D = branch_cubics(M, sign)
        print("branch sign", sign)
        print("noncontained basis:", noncontained)
        print("contained basis:", contained)
        print("C=", poly_repr(C))
        print("D=", poly_repr(D))
        planes = [eigenspace_sum_zero(matrix, K(-sign)) for _, matrix, _ in outer2]
        intersections = {}
        first_disjoint = None
        for i in range(len(planes)):
            for j in range(i + 1, len(planes)):
                dim = 6 - rank(planes[i] + planes[j])
                intersections[dim] = intersections.get(dim, 0) + 1
                if dim == 0 and first_disjoint is None:
                    first_disjoint = (i, j)
        print("fixed-plane vector intersection dimensions:", intersections)
        print("first disjoint plane pair (zero-based):", first_disjoint)
        assert all(form_polynomial(P, sign) == {} for P in planes)
        for p in (17, 23, 31, 41):
            roots = [x for x in range(p) if x * x % p == 2]
            if roots:
                singular = singular_pencil_parameters_mod_p(C, D, p, roots[0])
                print("pencil singular values mod", p, "=",
                      {t: len(points) for t, points in singular.items()})


if __name__ == "__main__":
    main()
