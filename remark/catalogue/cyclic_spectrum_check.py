"""Exact six-coordinate checks for the cyclic spectrum equivalence note.

This finite combinatorial check uses no external packages or saved matrices.
It is not an integral lattice conjugacy test.
"""

from itertools import product


def compositions(total, length):
    for values in product(range(total + 1), repeat=length):
        if sum(values) == total:
            yield values


def trace_from_cube_root_multiplicities(values):
    numerator = sum((-2) ** multiplicity for multiplicity in values)
    assert numerator % 3 == 0
    return numerator // 3


def strict_order_six_traces(n):
    return (
        trace_from_cube_root_multiplicities((n[0], n[2], n[4])),
        trace_from_cube_root_multiplicities(
            (n[0] + n[3], n[1] + n[4], n[2] + n[5])
        ),
        trace_from_cube_root_multiplicities((n[0] + n[2] + n[4], 0, 0)),
    )


def scalar_shift(n, shift):
    return tuple(n[(j - shift) % 6] for j in range(6))


def inverse_spectrum(n):
    return tuple(n[(-j) % 6] for j in range(6))


def check():
    split_three_136 = {
        n for n in compositions(6, 3)
        if trace_from_cube_root_multiplicities(n) == -2
    }
    assert split_three_136 == {
        (1, 2, 3), (1, 3, 2), (2, 1, 3),
        (2, 3, 1), (3, 1, 2), (3, 2, 1),
    }

    # Trace 1 cannot arise from a strict lift of order 3.
    assert not any(
        trace_from_cube_root_multiplicities(n) == 1
        for n in compositions(6, 3)
    )

    split_six_141 = {
        n for n in compositions(6, 6)
        if strict_order_six_traces(n) == (2, -2, -10)
    }
    reference_141 = (1, 0, 2, 0, 2, 1)
    orbit_141 = {
        scalar_shift(spectrum, shift)
        for spectrum in (reference_141, inverse_spectrum(reference_141))
        for shift in (0, 2, 4)
    }
    assert len(split_six_141) == 6 and split_six_141 == orbit_141

    # A strict order-6 lift cannot produce the No. 143 fingerprint.
    assert not any(
        strict_order_six_traces(n) == (1, 1, -2)
        for n in compositions(6, 6)
    )

    # On each pure weight subspace, smoothness requires enough quadratic
    # partial derivatives in the indicated target weight class.
    smooth_140 = {
        n for n in compositions(6, 3)
        if all(n[(j + 2) % 3] >= n[j] for j in range(3))
    }
    assert smooth_140 == {(2, 2, 2)}

    smooth_143 = {
        (p, q)
        for p in compositions(3, 3)
        for q in compositions(3, 3)
        if all(
            p[(j + 1) % 3] >= p[j]
            and p[(j + 1) % 3] >= q[j]
            for j in range(3)
        )
    }
    assert smooth_143 == {((1, 1, 1), (1, 1, 1))}

    print("No. 136: six spectra, one scalar/inverse orbit")
    print("No. 141: six spectra, one scalar/inverse orbit")
    print("No. 140: smooth nonsplit spectrum (2,2,2)")
    print("No. 143: smooth nonsplit spectrum one plus and one minus per weight")


if __name__ == "__main__":
    check()
