"""Bounded exact finite preflight for No. 127, M + genus-13 K -> N.

Input: the saved Q-side JSON, whose last ten basis vectors span the
primitive K and whose lower-right g-block is its integral J. This
identification is checked below. Uses standard Python only.

Default is a short smoke: all candidate images, at most 256 equivariant
maps per image. --full removes that limit. --v-start/--v-end partition a
full run by candidate image; one JSON checkpoint is saved after each V.
The finite search is exhaustive only when all V and all 86,016 maps per
eligible V have been examined. No abstract N isometry or cubic-lattice
extension is asserted by the finite screen.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import time

from verify_family_127_q_complement_integer import (
    block, determinant, d6_data, discriminant_elements, gram_of_rows,
    inverse, multiply, pair, rank_bits, rank_mod2, transpose, two_torsion,
)


HERE = Path(__file__).resolve().parent
INPUT = HERE / "family_127_g13_q_graph_preflight.json"


def note(message):
    print(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} | {message}", flush=True)


def vector(mask, n):
    return [(mask >> i) & 1 for i in range(n)]


def linear(mask, basis):
    result = 0
    for i, value in enumerate(basis):
        if mask & (1 << i):
            result ^= value
    return result


def span(values):
    result = {0}
    for v in values:
        result |= {x ^ v for x in tuple(result)}
    return result


def j_rows(j):
    return [sum((value & 1) << k for k, value in enumerate(row))
            for row in j]


def norm_operator(jrows):
    return lambda x: linear(x, jrows) ^ x


def q_half(x, gram):
    numerator = pair(vector(x, len(gram)), vector(x, len(gram)), gram)
    assert numerator % 4 == 0
    return (numerator // 4) & 1


def q_numerator(z, gram):
    return pair(z, z, gram) % 16


def pairing_bit(z, x, gram):
    numerator = pair(z, vector(x, len(gram)), gram)
    assert numerator % 4 == 0
    return (numerator // 4) & 1


def twice_mask(z):
    return sum((value & 1) << i for i, value in enumerate(z))


def add4(x, y):
    return tuple((a + b) & 3 for a, b in zip(x, y))


def module_pairs(members, norm, rank):
    e, f = [], []
    for x in sorted(members):
        y = norm(x)
        if y and rank_bits(e + f + [x, y]) == 2 * (len(e) + 1):
            e.append(x)
            f.append(y)
        if len(e) == rank:
            break
    assert len(e) == rank
    assert span(e + f) == set(members)
    return e, f


def quotient_representatives(disc, v_members, n):
    v_classes = [tuple(2 * ((x >> i) & 1) for i in range(n))
                 for x in sorted(v_members)]
    v_set = set(v_classes)
    assert len(v_set) == 64
    assert all(tuple((2 * a) & 3 for a in z) in v_set for z in disc)

    def key(z):
        return min(add4(z, v) for v in v_classes)

    zero = (0,) * n
    generated = {key(zero)}
    reps = []
    for z in sorted(disc):
        if key(z) in generated:
            continue
        reps.append(z)
        generated |= {key(add4(x, z)) for x in tuple(generated)}
        if len(reps) == 4:
            break
    assert len(reps) == 4 and len(generated) == 16
    return reps


def candidate_images(t_members, norm, radical):
    u = span(norm(x) for x in t_members)
    assert len(u) == 8
    assert len(radical) == 4 and len(u & radical) == 2
    base = span(u | radical)
    assert len(base) == 16
    cosets = {}
    for x in sorted(t_members):
        key = min(x ^ b for b in base)
        cosets.setdefault(key, x)
    assert len(cosets) == 16
    outside = [cosets[key] for key in sorted(cosets) if key != 0]
    candidates = {}
    for i, x in enumerate(outside):
        for y in outside[i + 1:]:
            first = base | {b ^ x for b in base}
            v = first | {b ^ y for b in first}
            if len(v) == 64:
                candidates[tuple(sorted(v))] = v
    assert len(candidates) == 35
    return u, base, [candidates[key] for key in sorted(candidates)]


def load_input():
    raw = INPUT.read_bytes()
    data = json.loads(raw)
    assert data["family"] == 127
    assert data["stage"] == "g13_Q_side_two_graphs"
    assert len(data["records"]) == 2
    record = data["records"][0]
    qg = record["gram"]
    qj = record["g"]
    qh = record["h"]
    qs = record["s"]
    assert len(qg) == len(qj) == len(qh) == len(qs) == 12
    assert all(qh[i][j] == -int(i == j) and qs[i][j] == int(i == j)
               for i in range(2, 12) for j in range(2, 12))
    assert all(qh[i][j] == qs[i][j] == qj[i][j] == 0
               for i in range(2, 12) for j in range(2))
    gram = [row[2:] for row in qg[2:]]
    action = [row[2:] for row in qj[2:]]
    assert determinant(gram) == 1024
    assert rank_mod2(gram) == 2
    assert multiply(action, action) == [
        [-int(i == j) for j in range(10)] for i in range(10)
    ]
    assert gram_of_rows(action, gram) == gram
    assert all(gram[i][i] % 2 == 0 for i in range(10))
    return gram, action, hashlib.sha256(raw).hexdigest()


def matrix_witness(phi_basis, gm, jm, gk, jk):
    base = block(gm, gk)
    over = [[0] * 16 for _ in range(16)]
    for i, image in enumerate(phi_basis):
        over[i][i] = 1
        for j in range(10):
            over[i][6 + j] = (image >> j) & 1
    for i in range(10):
        over[6 + i][6 + i] = 2
    raw = gram_of_rows(over, base)
    assert all(value % 4 == 0 for row in raw for value in row)
    gram = [[value // 4 for value in row] for row in raw]
    assert all(gram[i][i] % 2 == 0 for i in range(16))
    assert determinant(gram) == 64
    gbase = block(jm, jk)
    sbase = block(
        [[-int(i == j) for j in range(6)] for i in range(6)],
        [[int(i == j) for j in range(10)] for i in range(10)],
    )
    over_inv = inverse(over)
    g = multiply(multiply(over, gbase), over_inv)
    s = multiply(multiply(over, sbase), over_inv)
    assert all(x.denominator == 1 for row in g + s for x in row)
    assert gram_of_rows(g, gram) == gram
    assert gram_of_rows(s, gram) == gram
    assert multiply(g, g) == [
        [-int(i == j) for j in range(16)] for i in range(16)
    ]
    assert multiply(s, s) == [
        [int(i == j) for j in range(16)] for i in range(16)
    ]
    assert multiply(g, s) == multiply(s, g)
    dual = inverse(gram)
    assert all((2 * x).denominator == 1 for row in dual for x in row)
    assert all(dual[i][i].denominator == 1 for i in range(16))
    return {
        "gram": gram,
        "g": [[int(x) for x in row] for row in g],
        "s": [[int(x) for x in row] for row in s],
        "phi_basis_masks": phi_basis,
        "target_2_elementary": True,
        "target_delta_zero": True,
    }


def atomic_checkpoint(path, state):
    temp = path.with_name(path.name + f".{os.getpid()}.partial")
    with temp.open("x", encoding="utf-8") as out:
        json.dump(state, out, sort_keys=True, separators=(",", ":"))
        out.write("\n")
    os.replace(temp, path)


def scan():
    parser = argparse.ArgumentParser()
    parser.add_argument("--full", action="store_true")
    parser.add_argument("--v-start", type=int, default=1)
    parser.add_argument("--v-end", type=int)
    parser.add_argument("--max-maps-per-v", type=int)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    gm, jm = d6_data()
    gk, jk, input_hash = load_input()
    tm = set(two_torsion(gm))
    tk = set(two_torsion(gk))
    assert tm == set(range(64)) and len(tk) == 256
    disc_m = discriminant_elements(gm)
    disc_k = discriminant_elements(gk)
    assert len(disc_m) == 256 and len(disc_k) == 1024
    rm = {twice_mask(z) for z in disc_m}
    rk = {twice_mask(z) for z in disc_k}
    assert len(rm) == len(rk) == 4
    nm = norm_operator(j_rows(jm))
    nk = norm_operator(j_rows(jk))
    assert len(span(nm(x) for x in tm)) == 8
    assert len(span(nk(x) for x in tk)) == 8
    assert all(q_half(x, gm) in (0, 1) for x in tm)
    assert all(q_half(x, gk) in (0, 1) for x in tk)
    qm = {x: q_half(x, gm) for x in tm}
    qk = {x: q_half(x, gk) for x in tk}
    um, _base, images = candidate_images(tk, nk, rk)
    assert len(um) == 8 and len(images) == 35
    em, fm = module_pairs(tm, nm, 3)
    coordinate_m = {
        linear(c, em + fm): c for c in range(64)
    }
    assert len(coordinate_m) == 64
    standard_coordinates = [coordinate_m[1 << i] for i in range(6)]
    m_by_function = {}
    for z in sorted(disc_m):
        code = sum(pairing_bit(z, 1 << i, gm) << i for i in range(6))
        m_by_function.setdefault(code, z)
    assert len(m_by_function) == 64
    qnum_m = {z: q_numerator(z, gm) for z in m_by_function.values()}
    assert set(rm).issubset(tm) and set(rk).issubset(tk)
    assert [qm[x] for x in sorted(rm)] == [0, 1, 1, 0] or sorted(
        qm[x] for x in rm
    ) == [0, 0, 1, 1]
    assert sorted(qk[x] for x in rk) == [0, 0, 1, 1]

    start = args.v_start
    end = len(images) if args.v_end is None else args.v_end
    assert 1 <= start <= end <= 35
    limit = args.max_maps_per_v
    if limit is None:
        limit = None if args.full else 256
    assert limit is None or limit > 0
    mode = "full" if limit is None else f"sample_{limit}"
    output = args.output or HERE / (
        f"family_127_g13_n_finite_{mode}_v{start}-{end}.json"
    )
    assert not output.exists(), f"Refusing to overwrite {output}"
    note(f"INPUT_OK sha256={input_hash} M_torsion=64 K_torsion=256 "
         f"candidate_V=35 range={start}-{end} maps_per_V={limit or 86016}")
    state = {
        "family": 127,
        "stage": "g13_N_finite_preflight",
        "input_sha256": input_hash,
        "candidate_V_count": 35,
        "v_start": start,
        "v_end": end,
        "map_limit_per_V": limit,
        "records": [],
        "first_witness": None,
        "selected_range_complete": False,
        "global_complete": False,
    }
    atomic_checkpoint(output, state)
    invertible_a = [
        rows for code in range(512)
        if rank_bits(rows := [(code >> (3 * i)) & 7 for i in range(3)]) == 3
    ]
    assert len(invertible_a) == 168
    source_q_basis = [qm[1 << i] for i in range(6)]
    source_polar = {
        (i, j): qm[(1 << i) ^ (1 << j)]
                ^ source_q_basis[i] ^ source_q_basis[j]
        for i in range(6) for j in range(i + 1, 6)
    }
    for v_index in range(start, end + 1):
        v = images[v_index - 1]
        row = {
            "v_index": v_index,
            "v_masks": sorted(v),
            "j_stable": all(linear(x, j_rows(jk)) in v for x in v),
            "n_rank": rank_bits(nk(x) for x in v),
            "q_zero_count": sum(qk[x] == 0 for x in v),
            "maps_tested": 0,
            "q_isometries": 0,
            "exponent_two": 0,
            "delta_zero": 0,
            "first_witness": None,
            "sample_complete": False,
        }
        note(f"V={v_index}/35 J_stable={row['j_stable']} "
             f"N_rank={row['n_rank']} q_zero={row['q_zero_count']}")
        if (row["j_stable"] and row["n_rank"] == 3
                and row["q_zero_count"] == sum(qm[x] == 0 for x in tm)):
            ek, fk = module_pairs(v, nk, 3)
            quotient_reps = quotient_representatives(disc_k, v, 10)
            pair_tables = [
                {x: pairing_bit(z, x, gk) for x in tk}
                for z in quotient_reps
            ]
            qnum_k = [q_numerator(z, gk) for z in quotient_reps]
            for a_rows in invertible_a:
                for b_code in range(512):
                    b_rows = [(b_code >> (3 * i)) & 7 for i in range(3)]
                    image_e = [
                        linear(a_rows[i], ek) ^ linear(b_rows[i], fk)
                        for i in range(3)
                    ]
                    image_f = [linear(a_rows[i], fk) for i in range(3)]
                    target_basis = image_e + image_f
                    phi_std = [
                        linear(c, target_basis)
                        for c in standard_coordinates
                    ]
                    row["maps_tested"] += 1
                    if row["maps_tested"] % 10000 == 0:
                        note(f"V={v_index} progress maps={row['maps_tested']} "
                             f"q_iso={row['q_isometries']} "
                             f"exp2={row['exponent_two']} "
                             f"delta0={row['delta_zero']}")
                    if any(qk[phi_std[i]] != source_q_basis[i]
                           for i in range(6)):
                        pass
                    elif all(
                        (qk[phi_std[i] ^ phi_std[j]]
                         ^ qk[phi_std[i]] ^ qk[phi_std[j]])
                        == source_polar[i, j]
                        for i in range(6) for j in range(i + 1, 6)
                    ):
                        row["q_isometries"] += 1
                        exponent_ok = True
                        delta_ok = True
                        for z, ptab, knum in zip(
                            quotient_reps, pair_tables, qnum_k
                        ):
                            functional = sum(
                                ptab[phi_std[i]] << i for i in range(6)
                            )
                            m = m_by_function[functional]
                            twice_m = linear(
                                coordinate_m[twice_mask(m)], target_basis
                            )
                            if twice_m != twice_mask(z):
                                exponent_ok = False
                                break
                            if (qnum_m[m] + knum) % 16 != 0:
                                delta_ok = False
                        if exponent_ok:
                            row["exponent_two"] += 1
                            if delta_ok:
                                row["delta_zero"] += 1
                                if row["first_witness"] is None:
                                    row["first_witness"] = {
                                        "v_index": v_index,
                                        "a_rows": a_rows,
                                        "b_rows": b_rows,
                                        **matrix_witness(
                                            phi_std, gm, jm, gk, jk
                                        ),
                                    }
                                    if state["first_witness"] is None:
                                        state["first_witness"] = row["first_witness"]
                                    state["active_record"] = row
                                    atomic_checkpoint(output, state)
                                    note(f"V_WITNESS_SAVED V={v_index} "
                                         f"maps={row['maps_tested']} "
                                         f"file={output}")
                    if limit is not None and row["maps_tested"] >= limit:
                        break
                if limit is not None and row["maps_tested"] >= limit:
                    break
        row["sample_complete"] = (
            row["maps_tested"] == 86016
            or not row["j_stable"]
            or row["n_rank"] != 3
            or row["q_zero_count"] != sum(qm[x] == 0 for x in tm)
        )
        state.pop("active_record", None)
        state["records"].append(row)
        atomic_checkpoint(output, state)
        note(f"V={v_index} done maps={row['maps_tested']} "
             f"q_iso={row['q_isometries']} exp2={row['exponent_two']} "
             f"delta0={row['delta_zero']}")
    state["selected_range_complete"] = all(
        row["sample_complete"] for row in state["records"]
    )
    state["global_complete"] = (
        start == 1 and end == 35 and state["selected_range_complete"]
    )
    atomic_checkpoint(output, state)
    note(f"COMPLETED searched_V={len(state['records'])} "
         f"selected_range_complete={state['selected_range_complete']} "
         f"global_complete={state['global_complete']} "
         f"first_witness={state['first_witness'] is not None} file={output}")


if __name__ == "__main__":
    scan()
