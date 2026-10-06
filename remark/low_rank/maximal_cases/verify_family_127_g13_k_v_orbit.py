"""Exact integral K-isometry certificate for the 16 saved No. 127 images.

Four complex-line reflections commute with the fixed order-four J on K.
Their induced permutations are transitive on the 16 eligible six-spaces V.
This does not classify the 384 graph maps within each V or other K actions.
"""

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
K_INPUT = HERE / "family_127_g13_q_graph_preflight.json"
V_INPUT = HERE / "family_127_g13_n_finite_full_v1-35.json"
ROOTS = [
    (0, 0, 0, 0, 0, 1, -1, 0, 0, -1),
    (0, 0, 0, 0, 0, 1, 0, 0, -1, 0),
    (0, 0, 0, 0, 0, 1, 0, 0, 0, -1),
    (0, 0, 0, 1, -1, 1, -1, 0, 0, 0),
]


def product(a, b):
    return [[sum(x * y for x, y in zip(row, col)) for col in zip(*b)]
            for row in a]


def transpose(a):
    return [list(col) for col in zip(*a)]


def row_product(v, a):
    return product([v], a)[0]


def pair(v, w, gram):
    return sum(x * y for x, y in zip(row_product(v, gram), w))


def identity(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def basis_of_binary_span(values):
    pivots = {}
    basis = []
    for value in values:
        reduced = value
        while reduced:
            k = reduced.bit_length() - 1
            if k not in pivots:
                pivots[k] = reduced
                basis.append(value)
                break
            reduced ^= pivots[k]
    return basis


def span(values):
    result = {0}
    for value in values:
        result |= {x ^ value for x in tuple(result)}
    return tuple(sorted(result))


def image_mask(value, rows):
    result = 0
    for i, row in enumerate(rows):
        if value & (1 << i):
            result ^= row
    return result


def reflection(v, gram, j):
    u = row_product(v, j)
    n = pair(v, v, gram)
    assert n == pair(u, u, gram) == 4 and pair(v, u, gram) == 0
    gv = row_product(v, gram)
    gu = row_product(u, gram)
    assert all((2 * x) % n == 0 for x in gv + gu)
    r = [
        [int(i == k) - (2 * gv[i] * v[k] + 2 * gu[i] * u[k]) // n
         for k in range(10)] for i in range(10)
    ]
    assert product(product(r, gram), transpose(r)) == gram
    assert product(r, j) == product(j, r)
    assert product(r, r) == identity(10)
    return r


def orbit(seed, permutations, labels):
    positions = {label: i for i, label in enumerate(labels)}
    seen = {seed}
    queue = [seed]
    while queue:
        current = queue.pop()
        for permutation in permutations:
            image = permutation[positions[current]]
            if image not in seen:
                seen.add(image)
                queue.append(image)
    return seen


def main():
    raw_k = K_INPUT.read_bytes()
    raw_v = V_INPUT.read_bytes()
    k_data = json.loads(raw_k)
    v_data = json.loads(raw_v)
    assert k_data["family"] == v_data["family"] == 127
    assert v_data["global_complete"] is True
    q_record = k_data["records"][0]
    gram = [row[2:] for row in q_record["gram"][2:]]
    j = [row[2:] for row in q_record["g"][2:]]
    assert len(gram) == len(j) == 10
    assert product(j, j) == [[-int(i == k) for k in range(10)]
                              for i in range(10)]
    assert product(product(j, gram), transpose(j)) == gram
    images = {
        record["v_index"]: tuple(record["v_masks"])
        for record in v_data["records"]
        if record["first_witness"] is not None
    }
    labels = sorted(images)
    assert labels == [10, 11, 12, 13, 16, 17, 18, 19,
                      28, 29, 30, 31, 32, 33, 34, 35]
    assert all(len(v) == 64 and span(basis_of_binary_span(v)) == v
               for v in images.values())
    image_lookup = {v: label for label, v in images.items()}
    bases = {label: basis_of_binary_span(v) for label, v in images.items()}
    assert all(len(basis) == 6 for basis in bases.values())
    print("No. 127: integral O(K,J) orbit on 16 eligible V")
    print(f"K source={K_INPUT.name} sha256={hashlib.sha256(raw_k).hexdigest()}")
    print(f"V source={V_INPUT.name} sha256={hashlib.sha256(raw_v).hexdigest()}")
    permutations = []
    for number, root in enumerate(ROOTS, 1):
        r = reflection(root, gram, j)
        rows = [sum((entry & 1) << k for k, entry in enumerate(row))
                for row in r]
        permutation = tuple(
            image_lookup[span(image_mask(x, rows) for x in bases[label])]
            for label in labels
        )
        assert len(set(permutation)) == len(labels)
        permutations.append(permutation)
        print(f"root {number}={root}; norm=4; permutation={permutation}")
        print(f"orbit after root {number}={len(orbit(10, permutations, labels))}")
    assert orbit(10, permutations, labels) == set(labels)
    print("The 16 eligible image subspaces form one orbit under these four")
    print("explicit integral K-isometries commuting with J. COMPLETED")
    print("This does NOT identify the 384 maps within each V, prove all")
    print("integral N/L actions equivalent, or exhaust other K actions.")


if __name__ == "__main__":
    main()
