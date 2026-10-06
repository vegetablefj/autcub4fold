# Restrictions for Nos. 80 and 121

`restriction_pilot_80_121_cached_parents.jl` restricts two previously saved
full integral actions. No. 80 is sought inside No. 51 (OSCAR case 21,
result 3); No. 121 is sought inside No. 74 (case 29, result 1). The cached
full-group generators are in `source_51_full_lattice_group.mrdi` and
`source_74_full_lattice_group.mrdi`. The calculation does not enumerate new
integral isometry classes or compute the full stable discriminant kernel of
a new coinvariant lattice.

The companion `restriction_next_small_geometric_characters.g` reads the
frozen numbered linear groups. It checks the recorded direct strict
containments and computes the exact primitive-\(H^4\) character of the
geometric groups. The Julia script then proceeds in four stages:
`preflight` checks the sources; `groups` enumerates eligible
subgroups up to conjugacy in each saved parent group; `lattices` computes
the embedded \(S,T,P,K\) and their actions for character-matched classes;
and `verify` checks the extracted subgroup IDs and excludes the root
obstruction. The last three stages each save and reload an output. Source
and intermediate file checks link the stages.

| Child | Saved parent / class | Extracted group | Rank \(S\) | Rank \(P\) | Rank \(K\) | Index | Dimension | Root check |
| ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| 80 | 51 / 1 | `[8,3]` | 14 | 5 | 17 | 2 | 3 | passed |
| 121 | 74 / 3 | `[4,2]` | 8 | 10 | 12 | 2 | 8 | passed |
| 121 | 74 / 5 | `[4,2]` | 8 | 10 | 12 | 2 | 8 | passed |
| 121 | 74 / 6 | `[4,2]` | 8 | 10 | 12 | 2 | 8 | passed |

The root-verified output is `restriction_pilot_80_121.verified.mrdi`.
Its match counts are one for No. 80 and three for No. 121. The catalogue
retains all four complete restrictions and chooses the lowest class number
as each row's displayed representative. The independent catalogue verifier
also checked all four retained paths. The older canonical
`lattice_156.mrdi` is not changed.

The three No. 121 subgroups need not be conjugate *inside* No. 74. The
separate `restriction_no121_three_parent_classes.g` and
`restriction_no121_three_parent_classes.md` compare their full strict
six-dimensional source characters, not only the primitive-cohomology
histograms. Their strict representations are linearly conjugate to the
numbered No. 121 representation after a trace-determined abstract group
identification. The connected smooth locus of its invariant cubics then
identifies the resulting **ordinary integral group actions**. This does not
make the three saved matrices literally equal, pick a preferred embedding
inside No. 74, or identify Hodge structures of arbitrary members.

The `verify` stage checks the group ID of each *extracted subgroup* in the
saved rank-22 parent group and the root condition. It does not recompute
the group obtained by adjoining the full stable kernel of \(S\), and it
does not prove a new symplectic-saturation equality. Exact character and
period data are used for the numbered assignment; an explicit intertwiner
between the frozen geometric matrices and the saved integral parent group
is not stored.
