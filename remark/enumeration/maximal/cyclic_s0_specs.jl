# Exact integral-search inputs for the four cyclic families with S = 0.
# Each block is (cyclotomic index, multiplicity, positive rank, negative rank).
# The polynomial and OSCAR block constraints are derived from these entries.

const cyclic_s0_specs = Dict(
    152 => (
        number=152, name="family_152_phi16", order=16, group_id=(16, 1),
        determinant_exponent=7, dimension=1,
        blocks=((1, 2, 2, 0), (2, 2, 2, 0), (4, 1, 2, 0), (16, 2, 14, 2)),
    ),
    154 => (
        number=154, name="family_154_phi24", order=24, group_id=(24, 2),
        determinant_exponent=19, dimension=1,
        blocks=((3, 1, 2, 0), (12, 1, 4, 0), (24, 2, 14, 2)),
    ),
    155 => (
        number=155, name="family_155_phi32", order=32, group_id=(32, 1),
        determinant_exponent=11, dimension=0,
        blocks=((1, 1, 1, 0), (2, 1, 1, 0), (8, 1, 4, 0), (32, 1, 14, 2)),
    ),
    156 => (
        number=156, name="family_156_phi48", order=48, group_id=(48, 2),
        determinant_exponent=1, dimension=0,
        blocks=((3, 1, 2, 0), (12, 1, 4, 0), (48, 1, 14, 2)),
    ),
)
