# Ambient lattice completion

The complete side-by-side 156-row catalogue is
[`lattice_156_standard_ambient_20261004.mrdi`](lattice_156_standard_ambient_20261004.mrdi).
All 156 rows have a saved ambient action in the common nine-field scheme.
The preceding `lattice_156_complete_ambient_20261004.mrdi` imported the
seven independently verified final constructions and preserved the other
149 rows. The final normalization fills omitted aliases in 12 older
rank-zero records using the same saved generator at exponent one, checks
all existing `T/P/K` data by integral basis transport, and retains the
legacy records. Its reload comparison confirms that the other 144 rows
are unchanged. Original OSCAR data and earlier catalogue versions remain
intact.

See `sources/family_156_sources_current.md` for one provenance row per family,
including the geometric record, lattice source, ambient evidence, and
qualifications. This table is generated from the explicitly selected
catalogue; its opening paragraph identifies that file. Older
135-record and 149-record catalogues are intermediate checkpoints, not
the current coverage.

The `rank20_19/` and `rank18_16/` directories preserve selected
stage-specific records and historical notes, not every development-stage
script. The runnable final structural check is in `sources/`. In
particular, Nos. 13/14 are assigned by the real-structure criterion
and their distinct integral negative eigenlattices; both complete case-3
candidates remain retained. No. 127 is the constructed action identified
by the stable root-free action and generic-period criterion, not an exhaustive integral search.

`sources/verify_complete_156_ambient.jl` provides a final structural audit.
Its `.txt` and `.mrdi` receipts record the pass count and
scope; `sources/complete_156_ambient_structural_v3_20261004.txt` and `.mrdi`
record `complete=true`, 156 passing rows, and an unchanged input. The
audit checks primitive embeddings, actual action restrictions, stability,
cyclotomic periods, and dimensions. It does not repeat family
identification, root tests, saturation, or orthogonal-group enumeration.

A power restriction uses the ambient isometry and hence its compatible
actions on both `S` and `T`; an abstract `T` matrix alone does not supply
such a restriction. The standard record does not assert that rank-22
matrices for every symplectic group generator are stored.
