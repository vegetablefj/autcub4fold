"""Exact integer checks for the two L_2(7):2 real-structure branches.

This checks the small-lattice calculations only.  The geometric inputs are
the Clebsch cubic's transcendental lattice (Laza--Zheng, Thm. 1.8(2)) and
the real smooth path and normalizer (He--Li--Wang--Zheng, Table 1 and Sec. 4).
No OSCAR installation is needed.
"""

from fractions import Fraction as Q
from math import gcd


def matmul(a, b):
    return tuple(
        tuple(sum(a[i][k] * b[k][j] for k in range(len(b)))
              for j in range(len(b[0])))
        for i in range(len(a))
    )


def transpose(a):
    return tuple(zip(*a))


def rowmul(v, a):
    return tuple(sum(v[k] * a[k][j] for k in range(len(v)))
                 for j in range(len(a[0])))


def determinant(a):
    return (a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
            - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
            + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0]))


def inverse(a):
    aug = [[Q(a[i][j]) for j in range(3)]
           + [Q(i == j) for j in range(3)] for i in range(3)]
    for j in range(3):
        pivot = next(i for i in range(j, 3) if aug[i][j])
        aug[j], aug[pivot] = aug[pivot], aug[j]
        scale = aug[j][j]
        aug[j] = [x / scale for x in aug[j]]
        for i in range(3):
            if i != j:
                scale = aug[i][j]
                aug[i] = [aug[i][k] - scale * aug[j][k]
                          for k in range(6)]
    return tuple(tuple(row[3:]) for row in aug)


def pairing(v, w):
    return sum(rowmul(v, GRAM)[j] * w[j] for j in range(3))


def integral(v):
    return all(Q(x).denominator == 1 for x in v)


def integral_matrix(a):
    return all(integral(row) for row in a)


def scalar_mul(a, scalar):
    return tuple(tuple(scalar * x for x in row) for row in a)


GRAM = ((Q(-2), Q(1), Q(0)),
        (Q(1), Q(10), Q(0)),
        (Q(0), Q(0), Q(-28)))
IDENTITY = ((Q(1), Q(0), Q(0)),
            (Q(0), Q(1), Q(0)),
            (Q(0), Q(0), Q(1)))
assert determinant(GRAM) == 588

# The Clebsch/S_7 point: u0^perp has Gram [[-2, 1], [1, -18]].
u0 = (Q(4), Q(8), Q(3))
root = (Q(1), Q(0), Q(0))
other = (Q(0), Q(1), Q(1))
assert pairing(u0, u0) == 420
assert pairing(u0, root) == pairing(u0, other) == 0
assert (pairing(root, root), pairing(root, other),
        pairing(other, other)) == (-2, 1, -18)
assert gcd(*(abs(int(x)) for x in rowmul(u0, GRAM))) == 84
P = (u0, root, other)
assert abs(determinant(P)) == 5

# In the basis (u0, root, other), the two orientation-reversing
# possibilities on u0^perp are r_root and -r_root.  Only matched signs
# on the 5-glued positive line and negative plane extend integrally.
extensions = {}
for sign_u in (1, -1):
    for sign_k in (1, -1):
        # sign_k=+1 means r_root: root -> -root, other -> root+other.
        action = ((Q(sign_u), Q(0), Q(0)),
                  (Q(0), Q(-sign_k), Q(0)),
                  (Q(0), Q(sign_k), Q(sign_k)))
        extension = matmul(matmul(inverse(P), action), P)
        extensions[(sign_u, sign_k)] = extension
        assert integral_matrix(extension) == (sign_u == sign_k)

c = extensions[(1, 1)]
assert c == ((-1, 0, 0), (1, 1, 0), (0, 0, 1))
assert matmul(c, c) == IDENTITY
assert matmul(matmul(c, GRAM), transpose(c)) == GRAM
assert rowmul(u0, c) == u0

# (1,2,0)/3 represents the residual A_T[3] = A_Lambda0 generator.
residual_three = (Q(1, 3), Q(2, 3), Q(0))
assert integral(rowmul(residual_three, GRAM))
assert integral(tuple(3 * x for x in residual_three))
assert not integral(residual_three)
assert integral(tuple(rowmul(residual_three, c)[i] - residual_three[i]
                      for i in range(3)))
minus_c = scalar_mul(c, -1)
assert not integral(tuple(rowmul(residual_three, minus_c)[i]
                          - residual_three[i] for i in range(3)))


def positive_line_involution(v):
    assert pairing(v, v) == 42
    assert gcd(*(abs(int(x)) for x in rowmul(v, GRAM))) == 21
    dual = rowmul(v, GRAM)
    return tuple(tuple(-IDENTITY[i][j] + dual[i] * v[j] / 21
                       for j in range(3)) for i in range(3))


models = (
    ("norm-2", (Q(1), Q(2), Q(0)), (root, (Q(0), Q(0), Q(1))),
     ((-2, 0), (0, -28))),
    ("norm-4", (Q(7), Q(-7), Q(3)),
     ((Q(-3), Q(1), Q(0)), (Q(2), Q(-2), Q(1))),
     ((-14, 0), (0, -4))),
)

for label, v, basis, expected_gram in models:
    g = positive_line_involution(v)
    assert integral_matrix(g)
    assert matmul(g, g) == IDENTITY
    assert matmul(matmul(g, GRAM), transpose(g)) == GRAM
    assert rowmul(v, g) == v
    assert all(rowmul(w, g) == tuple(-x for x in w) for w in basis)
    assert tuple(tuple(pairing(x, y) for y in basis) for x in basis) == expected_gram
    commutes_with_real_structure = matmul(c, g) == matmul(g, c)
    assert commutes_with_real_structure == (label == "norm-2")
    assert integral(tuple(rowmul(residual_three, g)[i] - residual_three[i]
                          for i in range(3)))
    print(label, "involution:", g)
    print(label, "negative Gram:", expected_gram)
    print(label, "commutes with Clebsch real structure:",
          commutes_with_real_structure)

print("Clebsch u norm/div/index: 420 / 84 / 5")
print("Real structure c = r_e1:", c)
print("c fixes residual A_T[3]; -c does not")
print("PASS: only the norm-2 branch commutes with the transported real structure")
