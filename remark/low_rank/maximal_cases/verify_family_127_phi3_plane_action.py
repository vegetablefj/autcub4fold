"""Finite plane-class action for the No. 127 phi_3 involution.

This uses only exact integer/rational arithmetic from the Python standard
library. It does not construct an isometry on the full cubic cohomology.
"""

from fractions import Fraction
from pathlib import Path
from collections import Counter
import json


N = 11  # eta, y, F_1, ..., F_9


def unit(i):
    return [int(j == i) for j in range(N)]


def add(*vectors):
    return [sum(v[i] for v in vectors) for i in range(N)]


def scale(c, vector):
    return [c * a for a in vector]


def matrix_from_columns(columns):
    return [list(row) for row in zip(*columns)]


def multiply(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b)))
         for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def transpose(a):
    return [list(row) for row in zip(*a)]


def determinant(a):
    """Fraction-free Bareiss determinant for a small integer matrix."""
    b = [row[:] for row in a]
    n = len(b)
    sign, previous = 1, 1
    for k in range(n - 1):
        if b[k][k] == 0:
            pivot = next((i for i in range(k + 1, n) if b[i][k]), None)
            if pivot is None:
                return 0
            b[k], b[pivot] = b[pivot], b[k]
            sign = -sign
        pivot = b[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                numerator = b[i][j] * pivot - b[i][k] * b[k][j]
                assert numerator % previous == 0
                b[i][j] = numerator // previous
        for i in range(k + 1, n):
            b[i][k] = 0
        previous = pivot
    return sign * b[n - 1][n - 1]


def coordinates(basis, target):
    """Exact coordinates in the rank-ten column basis in rank eleven."""
    augmented = [
        [Fraction(basis[i][j]) for j in range(10)]
        + [Fraction(target[i])]
        for i in range(N)
    ]
    pivot_rows = []
    row = 0
    for col in range(10):
        pivot = next((i for i in range(row, N) if augmented[i][col]), None)
        assert pivot is not None
        augmented[row], augmented[pivot] = augmented[pivot], augmented[row]
        divisor = augmented[row][col]
        augmented[row] = [x / divisor for x in augmented[row]]
        for i in range(N):
            if i != row and augmented[i][col]:
                c = augmented[i][col]
                augmented[i] = [
                    augmented[i][j] - c * augmented[row][j]
                    for j in range(11)
                ]
        pivot_rows.append(row)
        row += 1
    assert all(not any(r[:10]) and r[10] == 0 for r in augmented[10:])
    answer = [augmented[i][10] for i in pivot_rows]
    assert all(x.denominator == 1 for x in answer)
    return [int(x) for x in answer]


def rank_mod_two(a):
    b = [[x & 1 for x in row] for row in a]
    rows, cols = len(b), len(b[0])
    rank = 0
    for col in range(cols):
        pivot = next((i for i in range(rank, rows) if b[i][col]), None)
        if pivot is None:
            continue
        b[rank], b[pivot] = b[pivot], b[rank]
        for i in range(rows):
            if i != rank and b[i][col]:
                b[i] = [x ^ y for x, y in zip(b[i], b[rank])]
        rank += 1
    return rank


def finite_discriminant_profile(action, gram):
    """A-orbits on D_P[2], decorated by the finite quadratic value."""
    seen = set()
    profile = Counter()

    def image(vector):
        return tuple(
            sum(action[i][j] * vector[j] for j in range(10)) & 1
            for i in range(10)
        )

    def four_q(vector):
        return sum(
            vector[i] * gram[i][j] * vector[j]
            for i in range(10) for j in range(10)
        ) % 8

    for bits in range(2**10):
        start = tuple((bits >> i) & 1 for i in range(10))
        if start in seen:
            continue
        orbit = []
        vector = start
        while vector not in seen:
            seen.add(vector)
            orbit.append(vector)
            vector = image(vector)
        assert vector == start
        assert all(four_q(v) == four_q(start) for v in orbit)
        profile[(len(orbit), four_q(start))] += 1
    assert len(seen) == 2**10
    return profile


def main():
    eta, y = unit(0), unit(1)
    f = {i: unit(i + 1) for i in range(1, 10)}
    plane = add(scale(2, y), *[scale(-1, f[i]) for i in range(1, 10)])
    residual = add(eta, scale(-1, plane))

    # Marquand's integral rank-eleven algebraic basis: eta, y, F_1,...,F_9.
    gram = [[0] * N for _ in range(N)]
    gram[0][0], gram[1][1] = 3, 21
    gram[0][1] = gram[1][0] = 5
    for i in range(2, N):
        gram[0][i] = gram[i][0] = 1
        gram[1][i] = gram[i][1] = 5
        for j in range(2, N):
            gram[i][j] = 3 if i == j else 1
    assert determinant(gram) == 2**10

    # Generic discriminant C * x_2 * conic has three fixed line points
    # and three two-point conic orbits under A: x_2 -> -x_2.
    # On a line fiber A swaps its two planes. On a conic orbit A^2=h
    # swaps the two planes over each point, giving a four-cycle.
    af = {i: add(residual, scale(-1, f[i])) for i in (1, 2, 3)}
    for i in (4, 6, 8):
        af[i] = f[i + 1]
        af[i + 1] = add(residual, scale(-1, f[i]))
    ay_numerator = add(plane, *[af[i] for i in range(1, 10)])
    assert all(c % 2 == 0 for c in ay_numerator)
    ay = [c // 2 for c in ay_numerator]
    action = matrix_from_columns([eta, ay] + [af[i] for i in range(1, 10)])
    identity = [[int(i == j) for j in range(N)] for i in range(N)]
    assert multiply(transpose(action), multiply(gram, action)) == gram
    square = multiply(action, action)
    assert multiply(square, square) == identity
    assert multiply(action, matrix_from_columns([plane])) == matrix_from_columns([plane])

    # Primitive q-fixed lattice P = eta^perp, using Marquand's x, alpha_i.
    x = add(scale(-1, y), *[f[i] for i in (1, 3, 5, 7, 9)])
    alpha = [add(f[i], scale(-1, f[i + 1])) for i in range(1, 9)]
    alpha.append(add(plane, f[8], f[9], scale(-1, eta)))
    primitive_basis = matrix_from_columns([x] + alpha)
    primitive_gram = multiply(
        transpose(primitive_basis), multiply(gram, primitive_basis)
    )
    assert all(sum(gram[0][i] * primitive_basis[i][j] for i in range(N)) == 0
               for j in range(10))
    assert determinant(primitive_gram) == 3 * 2**10
    assert all(z % 2 == 0 for row in primitive_gram for z in row)
    transformed_basis = multiply(action, primitive_basis)
    primitive_action = matrix_from_columns([
        coordinates(primitive_basis, [transformed_basis[i][j] for i in range(N)])
        for j in range(10)
    ])
    assert multiply(primitive_basis, primitive_action) == transformed_basis
    assert multiply(
        transpose(primitive_action), multiply(primitive_gram, primitive_action)
    ) == primitive_gram
    two = multiply(primitive_action, primitive_action)
    four = multiply(two, two)
    id10 = [[int(i == j) for j in range(10)] for i in range(10)]
    assert four == id10
    trace_a = sum(primitive_action[i][i] for i in range(10))
    trace_h = sum(two[i][i] for i in range(10))
    assert (trace_a, trace_h) == (-2, -2)
    # Thus chi_A on P is Phi_1 Phi_2^3 Phi_4^3.

    # Since P has Gram divisible by two and |D_P[2]|=2^10,
    # (1/2)P/P is its entire 2-primary discriminant group.
    mod_two = [[z & 1 for z in row] for row in primitive_action]
    nilpotent = [[(mod_two[i][j] + id10[i][j]) & 1
                  for j in range(10)] for i in range(10)]
    n2 = multiply(nilpotent, nilpotent)
    n3 = multiply(n2, nilpotent)
    n4 = multiply(n3, nilpotent)
    assert all(z % 2 == 0 for row in n4 for z in row)
    ranks = [rank_mod_two(z) for z in (nilpotent, n2, n3)]
    assert ranks == [5, 2, 1]
    profile = finite_discriminant_profile(mod_two, primitive_gram)
    assert sum(length * count for (length, _), count in profile.items()) == 2**10

    lines = [
        "Family No. 127: exact finite phi_3 plane-class action",
        "Convention: A sends each plane class to its geometric image (pushforward);",
        "for cohomological pullback of the displayed coordinate A, invert this matrix.",
        "Assumption: generic smooth invariant cubic with nonzero x2*x5*x6 coefficient,",
        "three transverse points C intersect {x2=0}, and six transverse",
        "points C intersect the conic.",
        "The A-orbits of nine discriminant points are 1+1+1+2+2+2.",
        "On three line fibers A swaps each pair of residual planes;",
        "on three conic-orbit pairs A forms a four-cycle of residual planes.",
        "Choice: F1,F2,F3 are line fibers; (F4,F5),(F6,F7),(F8,F9)",
        "are paired conic fibers; components are oriented so y is integral.",
        f"det full rank-11 algebraic Gram = {determinant(gram)}",
        f"det primitive P Gram = {determinant(primitive_gram)}",
        "Exact integral 10x10 Gram matrix of primitive P in basis x,alpha_1,...,alpha_9:",
        *[" ".join(str(z) for z in row) for row in primitive_gram],
        f"A traces on P: tr(A)={trace_a}, tr(A^2)={trace_h}",
        "chi(A|P) = Phi1 * Phi2^3 * Phi4^3",
        "Exact integral 10x10 A matrix on primitive P in basis x,alpha_1,...,alpha_9:",
        *[" ".join(str(z) for z in row) for row in primitive_action],
        "D_P[2] = (1/2)P/P = (F2)^10; induced matrix is A|P modulo two.",
        "Induced 10x10 matrix on D_P[2] in basis x/2,alpha_1/2,...,alpha_9/2:",
        *[" ".join(str(z) for z in row) for row in mod_two],
        f"rank_F2(A+I)={ranks[0]}, rank_F2((A+I)^2)={ranks[1]}, "
        f"rank_F2((A+I)^3)={ranks[2]}",
        "F2 Jordan block sizes: 4+2+2+1+1.",
        "A-orbit counts on D_P[2] by (orbit length, 4*q mod 8):",
        *[f"{length} {value}: {profile[(length, value)]}"
          for length, value in sorted(profile)],
        "This gives the finite action on D_Q up to the noncanonical anti-isometry",
        "D_P[2] ~ D_Q. It does not lift A to Q or to full cubic cohomology.",
    ]
    result = "\n".join(lines) + "\n"
    print(result, end="")
    Path(__file__).with_name("family_127_phi3_plane_action.out").write_text(
        result, encoding="utf-8"
    )
    payload = {
        "basis": ["x"] + [f"alpha_{i}" for i in range(1, 10)],
        "gram": primitive_gram,
        "action_pushforward": primitive_action,
        "action_convention": "column vectors; geometric image of planes",
    }
    Path(__file__).with_name("family_127_phi3_plane_action.json").write_text(
        json.dumps(payload, indent=2) + "\n", encoding="utf-8"
    )


if __name__ == "__main__":
    main()
