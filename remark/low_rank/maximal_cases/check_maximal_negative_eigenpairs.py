"""Exact, bounded negative-eigenvalue-pair audit of saved OSCAR MRDI files.

This reads the JSON representation of the already completed OSCAR snapshots.
It neither loads OSCAR nor repeats any lattice enumeration.  In these four
families the Phi_n lattice has rank 16 and signature (14, 2).  Put
T=f+f^-1 and p(T)=0, where p is the minimal polynomial of
t=zeta_n+zeta_n^-1.  The projector to t_a=2*cos(2*pi*a/n) is exactly
(p(T)/(T-t_a))/p'(t_a).  Its quadratic value is a polynomial in t_a over
Q, divided by p'(t_a).  Rational intervals isolate all roots of p; rational
interval arithmetic determines its sign.  Primitive a is chosen in
1 <= a < n/2, so the label denotes the unordered pair {a, -a} mod n.

Each real pair has even negative index because f gives it a compatible
complex structure.  Therefore a negative projected vector, together with
signature (14, 2), uniquely identifies the negative primitive-root pair.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from math import comb, gcd
from pathlib import Path


# Minimal polynomial of t = zeta_n + zeta_n^(-1), constant term first.
REAL_CYCLO = {
    16: (2, 0, -4, 0, 1),
    24: (1, 0, -4, 0, 1),
    32: (2, 0, -16, 0, 20, 0, -8, 0, 1),
    48: (1, 0, -16, 0, 20, 0, -8, 0, 1),
}


def number(s):
    return int(s) if "//" not in s else Fraction(s.replace("//", "/"))


def matrix(raw):
    return [[number(s) for s in row] for row in raw]


def multiply_rows_by_matrix(rows, m):
    columns = list(zip(*m))
    return [[sum(a * b for a, b in zip(row, col)) for col in columns]
            for row in rows]


def pairings(left, gram, right):
    left_gram = multiply_rows_by_matrix(left, gram)
    return [[sum(a * b for a, b in zip(row, v)) for v in right]
            for row in left_gram]


def scalar_form(m, x):
    return sum(x[i] * m[i][j] * x[j]
               for i in range(len(x)) for j in range(len(x))
               if x[i] and x[j])


def inertia(symmetric):
    """Sylvester inertia by exact congruence, including zero-diagonal pivots."""
    m = [[Fraction(x) for x in row] for row in symmetric]
    positive = negative = zero = 0
    while m:
        n = len(m)
        pivot = next((i for i in range(n) if m[i][i] != 0), None)
        if pivot is None:
            pair = next(((i, j) for i in range(n) for j in range(i + 1, n)
                         if m[i][j] != 0), None)
            if pair is None:
                zero += n
                break
            i, j = pair
            # Replace e_i by e_i+e_j, preserving the lattice's real inertia.
            row_i = [m[i][k] + m[j][k] for k in range(n)]
            for k in range(n):
                m[i][k] = m[k][i] = row_i[k]
            m[i][i] = row_i[i] + m[j][i]
            pivot = i
        if pivot:
            m[0], m[pivot] = m[pivot], m[0]
            for row in m:
                row[0], row[pivot] = row[pivot], row[0]
        diagonal = m[0][0]
        positive += diagonal > 0
        negative += diagonal < 0
        m = [[m[i][j] - m[i][0] * m[0][j] / diagonal
              for j in range(1, n)] for i in range(1, n)]
    return positive, negative, zero


def poly_at_scaled_integer(poly, numerator, denominator):
    # denominator^degree * p(numerator / denominator), with integer arithmetic.
    degree = len(poly) - 1
    return sum(c * numerator**j * denominator**(degree - j)
               for j, c in enumerate(poly))


def isolate_all_real_roots(poly):
    degree = len(poly) - 1
    denominator = 128
    values = [(k, poly_at_scaled_integer(poly, k, denominator))
              for k in range(-2 * denominator, 2 * denominator + 1)]
    assert all(v != 0 for _, v in values), "A grid endpoint is a root"
    intervals = []
    for (k0, v0), (k1, v1) in zip(values, values[1:]):
        if (v0 < 0) != (v1 < 0):
            intervals.append([Fraction(k0, denominator),
                              Fraction(k1, denominator)])
    assert len(intervals) == degree, "Grid did not isolate every real root"
    return intervals[::-1]  # decreasing root order = increasing primitive a


def interval_multiply(left, right):
    products = [a * b for a in left for b in right]
    return min(products), max(products)


def polynomial_interval(poly, interval):
    acc = (Fraction(0), Fraction(0))
    for coefficient in reversed(poly):
        lo, hi = interval_multiply(acc, interval)
        acc = lo + coefficient, hi + coefficient
    return acc


def sign_at_root(poly, minimal, interval):
    if all(c == 0 for c in poly):
        return 0
    for _ in range(200):
        low, high = polynomial_interval(poly, interval)
        if low > 0:
            return 1
        if high < 0:
            return -1
        left, right = interval
        midpoint = (left + right) / 2
        value = sum(c * midpoint**j for j, c in enumerate(minimal))
        assert value != 0
        left_value = sum(c * left**j for j, c in enumerate(minimal))
        if (left_value < 0) != (value < 0):
            interval[1] = midpoint
        else:
            interval[0] = midpoint
    raise ArithmeticError("Exact root sign did not resolve in 200 bisections")


def projection_numerator(moment, minimal):
    # (p(X)-p(t))/(X-t) = sum_j h_j(t) X^j, with p(t)=0.
    degree = len(minimal) - 1
    answer = [0] * degree
    for j, value in enumerate(moment):
        for r in range(j + 1, degree + 1):
            answer[r - 1 - j] += value * minimal[r]
    return answer


def candidates(rank):
    for i in range(rank):
        v = [0] * rank
        v[i] = 1
        yield (i + 1,), v
    for i in range(rank):
        for j in range(i + 1, rank):
            for sign in (-1, 1):
                v = [0] * rank
                v[i] = 1
                v[j] = sign
                yield (i + 1, sign * (j + 1)), v


def audit(path):
    raw = path.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    saved = json.loads(raw)
    fields = saved["_type"]["params"]["names"]
    values = dict(zip(fields, saved["data"]))
    family = int(values["family_number"])
    order = int(values["order"])
    minimal = REAL_CYCLO[order]
    degree = len(minimal) - 1
    exponents = [a for a in range(1, order // 2) if gcd(a, order) == 1]
    assert len(exponents) == degree
    assert int(values["number_of_results"]) == len(values["results"])
    print(f"{family}: MRDI SHA256 {digest}")
    record_types = saved["_type"]["params"]["tuple_params"][-1]["params"]
    assert len(record_types) == len(values["results"])
    seen = {}
    for output, (record_type, record) in enumerate(
            zip(record_types, values["results"]), 1):
        names = record_type["params"]["names"]
        record_fields = dict(zip(names, record))
        action_type = record_type["params"]["tuple_params"][names.index("P_action")]
        ambient = action_type["params"]["ambient_space"]
        action = matrix(ambient["data"]["isom"])
        quad_id = ambient["_type"]["params"]["quad_space"]
        gram = matrix(saved["_refs"][quad_id]["data"])
        basis = matrix(record_fields["P_action"])
        assert len(basis) == 16 and len(action) == len(gram) == 22
        assert int(ambient["data"]["order"]) == order
        assert all(record_fields["checks"])
        assert pairings(action, gram, action) == gram
        assert inertia(pairings(basis, gram, basis)) == (14, 2, 0)

        # M_k[i,j] = <basis_i, f^k basis_j>, for k=0,...,degree-1.
        moments_f = []
        powered_basis = basis
        needed_power = order // 2 if order in (16, 32) else order // 3
        powers = {}
        for k in range(needed_power + 1):
            if k < degree:
                moments_f.append(pairings(basis, gram, powered_basis))
            if k in (0, needed_power, needed_power // 2):
                powers[k] = powered_basis
            powered_basis = multiply_rows_by_matrix(powered_basis, action)
        if order in (16, 32):
            assert all(all(x + y == 0 for x, y in zip(left, right))
                       for left, right in zip(powers[needed_power], basis))
        else:
            assert all(all(x - y + z == 0 for x, y, z in zip(left, middle, right))
                       for left, middle, right in zip(
                           powers[needed_power], powers[needed_power // 2], basis))

        # T=f+f^-1.  In a scalar pairing <v,f^-k v>=<v,f^k v>.
        root_intervals = isolate_all_real_roots(minimal)
        derivative = [j * minimal[j] for j in range(1, degree + 1)]
        negative = []
        for exponent, interval in zip(exponents, root_intervals):
            derivative_sign = sign_at_root(derivative, minimal, interval)
            witness = None
            for label, vector in candidates(16):
                c = [scalar_form(m, vector) for m in moments_f]
                t_moments = [sum(comb(j, r) * c[abs(j - 2*r)]
                                 for r in range(j + 1))
                             for j in range(degree)]
                numerator = projection_numerator(t_moments, minimal)
                sign = sign_at_root(numerator, minimal, interval)
                if sign * derivative_sign < 0:
                    witness = label
                    break
            if witness is not None:
                negative.append((exponent, witness))
        assert len(negative) == 1, (family, output, negative)
        exponent, witness = negative[0]
        assert exponent not in seen, (family, seen, output, exponent)
        seen[exponent] = output
        source = int(record_fields["source_action_index"])
        print(f"{family} output {output} (raw action {source}): "
              f"negative pair +/-{exponent}; witness {witness}")
    assert set(seen) == set(exponents), (family, seen, exponents)
    print(f"{family}: all {degree} primitive root pairs occur exactly once")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mrdi", nargs="+", type=Path)
    args = parser.parse_args()
    for path in args.mrdi:
        audit(path)


if __name__ == "__main__":
    main()
