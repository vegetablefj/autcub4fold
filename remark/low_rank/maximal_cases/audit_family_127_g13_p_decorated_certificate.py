"""Independently reload the OSCAR decorated-P isometry certificate over Z.

This corrects a provenance-only SHA bug in the first OSCAR certificate:
Julia's String(raw::Vector{UInt8}) consumed the raw byte buffer before the
script hashed it.  The original matrix and output remain untouched; this
script creates a separately verified certificate with the actual input SHA.
"""

import hashlib
import json
from pathlib import Path

from audit_family_127_g13_n_witness import determinant, gram, multiply, transpose


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "family_127_g13_full_q_fixed_preflight.json"
ORIGINAL = HERE / "family_127_g13_p_decorated_isometry.json"
VERIFIED = HERE / "family_127_g13_p_decorated_isometry_verified.json"
REPORT = HERE / "family_127_g13_p_decorated_isometry_verified.out"


def main():
    assert SOURCE.is_file() and ORIGINAL.is_file()
    assert not VERIFIED.exists() and not REPORT.exists()
    source_bytes = SOURCE.read_bytes()
    original_bytes = ORIGINAL.read_bytes()
    source = json.loads(source_bytes)
    original = json.loads(original_bytes)
    assert source["family"] == original["family"] == 127
    assert source["stage"] == "q_fixed_integer_preflight"
    assert source["complete_equivariant_isometry_checked"] is False
    assert original["convention"] == "geometric_pushforward"
    empty_hash = hashlib.sha256(b"").hexdigest()
    assert original["source_sha256"] == empty_hash

    gw = source["witness_gram"]
    aw = source["witness_g_row_action"]
    vw = source["witness_projected_plane"]
    gg = source["geometric_gram"]
    ag = source["geometric_g_pushforward_row_action"]
    vg = source["geometric_projected_plane"]
    t = original["isometry_witness_to_geometry_row_coordinates"]
    assert len(t) == 10 and all(len(row) == 10 for row in t)
    assert all(isinstance(x, int) for row in t for x in row)
    det_t = determinant(t)
    assert abs(det_t) == 1
    assert gram(t, gg) == gw
    assert multiply(aw, t) == multiply(t, ag)
    assert multiply([vw], t)[0] == vg
    assert gram(aw, gw) == gw and gram(ag, gg) == gg
    assert multiply([vw], aw)[0] == vw
    assert multiply([vg], ag)[0] == vg

    result = {
        "family": 127,
        "stage": "independently_verified_decorated_P_isometry",
        "source_sha256": hashlib.sha256(source_bytes).hexdigest(),
        "original_certificate_sha256": hashlib.sha256(original_bytes).hexdigest(),
        "original_certificate_sha_note":
            "Original certificate records SHA256(empty) because Julia String(raw) consumed its buffer; the matrix and checked equalities are unaffected.",
        "convention": "geometric_pushforward_row_action",
        "isometry_witness_to_geometry_row_coordinates": t,
        "determinant": det_t,
        "checks": {
            "integral_unimodular": True,
            "gram_isometry": True,
            "action_intertwining": True,
            "projected_plane_preserved": True,
        },
    }
    VERIFIED.write_text(json.dumps(result, separators=(",", ":")) + "\n",
                        encoding="utf-8")
    lines = [
        "Family No. 127: independently verified decorated P isometry",
        "Input: saturated q=g^2*s fixed lattice from saved full-L witness",
        "Target: geometric Marquand plane-class P",
        "Convention: row-action geometric pushforward; inverse not needed",
        "det(T) = " + str(det_t),
        "T*G_geo*T^T = G_witness: true",
        "A_witness*T = T*A_geo_pushforward: true",
        "projected_plane_witness*T = projected_plane_geo: true",
        "Source SHA256 = " + result["source_sha256"],
        "Original certificate SHA256 = " + result["original_certificate_sha256"],
        "Original certificate metadata SHA was SHA256(empty) due to a consumed Julia byte buffer; matrix is valid.",
        "This establishes an exact integral decorated-P isometry for this saved first full-L witness; it is not a complete search of all full-L glues.",
    ]
    REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
