"""Finite-orbit audit of the 384 V10 graphs for saved No. 127 K,J.

The K subgroup uses four explicit integral complex-line reflections and
Schreier generators of their V10 stabilizer. The M subgroup is the full
centralizer of the standard quarter-turn action inside signed permutations
of D6 coordinates. All computations are exact and finite. They do not
classify other global Hermitian classes or other K actions.
"""

import hashlib
import json
from pathlib import Path

from run_family_127_g13_n_finite_preflight import (
    d6_data, j_rows, linear, module_pairs, norm_operator, q_half,
)
from verify_family_127_g13_k_v_orbit import (
    HERE, K_INPUT, ROOTS, V_INPUT, basis_of_binary_span, identity,
    image_mask, pair, product, reflection, span, transpose,
)


def mod2_rows(matrix):
    return tuple(sum((entry & 1) << j for j, entry in enumerate(row))
                 for row in matrix)


def compose_rows(left, right):
    return tuple(image_mask(row, right) for row in left)


def root_coefficients(y):
    s = sum(y[:4])
    coeffs = [y[0], y[0] + y[1], y[0] + y[1] + y[2], s,
              (s + y[4] - y[5]) // 2, (s + y[4] + y[5]) // 2]
    assert all(isinstance(x, int) for x in coeffs)
    return coeffs


def m_generators(g_m, j_m):
    roots = [[0] * 6 for _ in range(6)]
    for i in range(5):
        roots[i][i] = 1
        roots[i][i + 1] = -1
    roots[5][4] = roots[5][5] = 1
    signed = []
    for pair_number in range(3):
        a = identity(6)
        i = 2 * pair_number
        a[i][i] = a[i + 1][i + 1] = 0
        a[i][i + 1] = 1
        a[i + 1][i] = -1
        signed.append(a)
    for left in (0, 1):
        a = identity(6)
        for k in (0, 1):
            i, j = 2 * left + k, 2 * (left + 1) + k
            a[i][i] = a[j][j] = 0
            a[i][j] = a[j][i] = 1
        signed.append(a)
    generators = []
    for euclidean in signed:
        root_action = [
            root_coefficients(product([root], euclidean)[0])
            for root in roots
        ]
        assert product(root_action, roots) == product(roots, euclidean)
        assert product(product(root_action, g_m), transpose(root_action)) == g_m
        assert product(root_action, j_m) == product(j_m, root_action)
        generators.append(mod2_rows(root_action))
    return generators


def finite_group(generators, n, limit=1000):
    start = tuple(1 << i for i in range(n))
    seen = {start}
    queue = [start]
    while queue:
        a = queue.pop()
        for g in generators:
            b = compose_rows(a, g)
            if b not in seen:
                seen.add(b)
                queue.append(b)
                assert len(seen) <= limit
    return seen


def q_maps(g_m, j_m, g_k, j_k, v):
    e_m, f_m = module_pairs(set(range(64)), norm_operator(j_rows(j_m)), 3)
    e_k, f_k = module_pairs(set(v), norm_operator(j_rows(j_k)), 3)
    coordinate_m = {linear(c, e_m + f_m): c for c in range(64)}
    standard = [coordinate_m[1 << i] for i in range(6)]
    q_m = {x: q_half(x, g_m) for x in range(64)}
    q_k = {x: q_half(x, g_k) for x in v}
    qb = [q_m[1 << i] for i in range(6)]
    bp = {(i, j): q_m[(1 << i) ^ (1 << j)] ^ qb[i] ^ qb[j]
          for i in range(6) for j in range(i + 1, 6)}
    maps = set()
    invertible_a = [
        rows for code in range(512)
        if len(basis_of_binary_span(rows := [(code >> (3 * i)) & 7
                                             for i in range(3)])) == 3
    ]
    assert len(invertible_a) == 168
    for a in invertible_a:
        for code in range(512):
            b = [(code >> (3 * i)) & 7 for i in range(3)]
            ek = [linear(a[i], e_k) ^ linear(b[i], f_k) for i in range(3)]
            fk = [linear(a[i], f_k) for i in range(3)]
            basis = ek + fk
            phi = tuple(linear(c, basis) for c in standard)
            if any(q_k[phi[i]] != qb[i] for i in range(6)):
                continue
            if all((q_k[phi[i] ^ phi[j]] ^ q_k[phi[i]] ^ q_k[phi[j]])
                   == bp[i, j]
                   for i in range(6) for j in range(i + 1, 6)):
                maps.add(phi)
    assert len(maps) == 384
    return maps


def k_stabilizer_generators(g_k, j_k, images):
    labels = sorted(images)
    positions = {label: i for i, label in enumerate(labels)}
    image_lookup = {tuple(values): label for label, values in images.items()}
    bases = {label: basis_of_binary_span(values)
             for label, values in images.items()}
    generators = [mod2_rows(reflection(root, g_k, j_k)) for root in ROOTS]
    permutations = [
        tuple(image_lookup[span(image_mask(x, a) for x in bases[label])]
              for label in labels)
        for a in generators
    ]
    words = {10: ()}
    queue = [10]
    while queue:
        label = queue.pop()
        for k, permutation in enumerate(permutations):
            image = permutation[positions[label]]
            if image not in words:
                words[image] = words[label] + (k,)
                queue.append(image)
    assert set(words) == set(labels)
    ident = tuple(1 << i for i in range(10))
    stabilizer = set()
    for label in labels:
        for k, permutation in enumerate(permutations):
            image = permutation[positions[label]]
            # Each reflection is an involution, so reverse the transversal.
            word = words[label] + (k,) + tuple(reversed(words[image]))
            h = ident
            for index in word:
                h = compose_rows(h, generators[index])
            assert image_lookup[span(image_mask(x, h) for x in bases[10])] == 10
            stabilizer.add(h)
    stabilizer.discard(ident)
    return sorted(stabilizer)


def components(phi_maps, m_gens, k_gens):
    unseen = set(phi_maps)
    sizes = []
    while unseen:
        start = unseen.pop()
        queue = [start]
        count = 1
        while queue:
            phi = queue.pop()
            images = [
                tuple(image_mask(row, phi) for row in a)
                for a in m_gens
            ] + [
                tuple(image_mask(row, a) for row in phi)
                for a in k_gens
            ]
            for successor in images:
                assert successor in phi_maps
                if successor in unseen:
                    unseen.remove(successor)
                    queue.append(successor)
                    count += 1
        sizes.append(count)
    return sorted(sizes, reverse=True)


def main():
    raw_k = K_INPUT.read_bytes()
    raw_v = V_INPUT.read_bytes()
    q_record = json.loads(raw_k)["records"][0]
    v_record = json.loads(raw_v)
    assert v_record["global_complete"] is True
    g_k = [row[2:] for row in q_record["gram"][2:]]
    j_k = [row[2:] for row in q_record["g"][2:]]
    images = {r["v_index"]: tuple(r["v_masks"])
              for r in v_record["records"] if r["first_witness"] is not None}
    assert len(images) == 16
    assert all((r["q_isometries"], r["exponent_two"], r["delta_zero"])
               == (384, 384, 384)
               for r in v_record["records"] if r["first_witness"] is not None)
    g_m, j_m = d6_data()
    maps = q_maps(g_m, j_m, g_k, j_k, images[10])
    m_gens = m_generators(g_m, j_m)
    m_image = finite_group(m_gens, 6)
    k_stabilizer = k_stabilizer_generators(g_k, j_k, images)
    m_orbits = components(maps, m_gens, [])
    combined_orbits = components(maps, m_gens, k_stabilizer)
    print("No. 127: 384 finite V10 graph-map orbits")
    print(f"K source sha256={hashlib.sha256(raw_k).hexdigest()}")
    print(f"V source sha256={hashlib.sha256(raw_v).hexdigest()}")
    print(f"quadratic J-equivariant graph maps={len(maps)}")
    print(f"O(M,J) generating matrices=5; mod-2 image order={len(m_image)}")
    print(f"O(M,J)-only orbit sizes={m_orbits}")
    print(f"explicit K V10-stabilizer generators={len(k_stabilizer)}")
    print(f"combined orbit sizes={combined_orbits}")
    assert combined_orbits == [384]
    print("Together with the certified 16-V K orbit, all 6144 graph")
    print("gluings are integrally equivalent as N-actions for this fixed K,J.")
    print("This concerns the first fixed K,J only; no other Hermitian classes.")
    print("COMPLETED")


if __name__ == "__main__":
    main()
