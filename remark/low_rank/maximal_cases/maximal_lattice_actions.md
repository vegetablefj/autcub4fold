# Integral lattice actions of the six low-rank action-maximal families

This index separates exact-character enumeration, retained **labelled
generator actions**, and identification with a cubic family. An output
number is local to one run and is not a canonical class label. In particular,
several outputs related by a power coprime to the order may represent one
cyclic-group action. The equation-side characters of all six cases were
checked in `maximal_family_character_result.md`.

| Family | Exact integral search | Retained outputs | Present conclusion | Remaining comparison |
| ---: | --- | ---: | --- | --- |
| 96, `S3 × C24` | Complete: 1 action class | 1 | MRDI reloaded; primitive extension and geometric checks pass | Record the equation-to-action link in the common catalogue |
| 127, `C4 × C2` | No exhaustive direct isometry enumeration | 1 constructed witness | Smooth four-dimensional, generically full and saturated action; the completed 156-family classification identifies its family as No. 127 | Preserve the theorem-dependent identification; no explicit full-`H^4` conjugacy to the displayed equation or exhaustive embedding search |
| 152, `C16` | Complete: 24 labelled action classes | 4 | Brown result imported; MRDI reload and lattice postchecks pass; one coprime-power orbit; output 1 has the displayed generator's negative eigenvalue pair | Hodge-line orientation and direct geometric action comparison |
| 154, `C24` | Complete: 8 labelled action classes | 4 | Brown result imported; MRDI reload and lattice postchecks pass; one coprime-power orbit; output 4 has the displayed generator's negative eigenvalue pair | Hodge-line orientation and direct geometric action comparison |
| 155, `C32` | Complete: 48 labelled action classes | 8 | Local MRDI reloaded; lattice postchecks pass; one odd-power orbit; output 7 has the displayed generator's negative eigenvalue pair | Hodge-line orientation and direct geometric action comparison |
| 156, `C48` | Complete: 16 labelled action classes | 8 | Brown result imported; MRDI reload and lattice postchecks pass; one coprime-power orbit; output 2 has the displayed generator's negative eigenvalue pair | Hodge-line orientation and direct geometric action comparison |

The Brown results for 152, 154, and 156 are in `brown_results/`, with original
logs and Slurm output. Family 96 and 155 have result files in this directory.
The first full-lattice witness and its conditional orbit certificates for
family 127 are described in `family_127_progress_20260929.md`.

## Why the retained cyclic actions form one orbit

For Nos. 152, 154, 155, and 156, let `n` be respectively 16, 24, 32,
and 48, and let `g` be any retained integral isometry. The search fixes the
**exact** cyclotomic characteristic and minimal polynomials, not merely the
order. In each case the `Phi_n`-isotypic rational subspace has signature
`(14,2)`; its orthogonal complement is positive definite. Thus exactly one
primitive eigenvalue pair `{zeta_n^a,zeta_n^(-a)}` carries the negative real
two-plane. This pair is invariant under integral conjugacy.

If `k` is coprime to `n`, then `g^k` generates the same cyclic subgroup.
It has the same exact cyclotomic factors and block signatures. Its
`Phi_n`-isotypic saturated lattice `P` and positive orthogonal lattice `K`
are unchanged. Consequently the stable-discriminant, root, and stable-kernel
tests used to retain `g` also retain `g^k`. The negative eigenvalue pair
becomes `{zeta_n^(ak),zeta_n^(-ak)}`. As `k` ranges over the units modulo
`n`, these pairs attain all `phi(n)/2` possibilities. The corresponding
classes are distinct because the negative pair is a conjugacy invariant.

The completed enumerations retain exactly `4, 4, 8, 8 = phi(n)/2` labelled
isometry classes, respectively. Hence the powers of **any one** retained
class already exhaust all retained classes. In particular, each case has
one integral cyclic-subgroup action up to conjugacy. This deduction uses
the completeness of the four exact-character enumerations and the fact
that no primitive generator root was fixed at their entrance; it does not
require another expensive lattice enumeration or pairwise isometry test.

This is an unlabelled cyclic-action statement. A separate, quick exact
audit of the saved MRDI matrices, `check_maximal_negative_eigenpairs.py`,
locates the negative primitive eigenvalue pair in every retained output:

```text
python check_maximal_negative_eigenpairs.py \
  brown_results/family_152_phi16_brown_oscar18.mrdi \
  brown_results/family_154_phi24_brown_oscar18.mrdi \
  family_155_phi32_oscar18.mrdi \
  brown_results/family_156_phi48_brown_oscar18.mrdi
```

Its saved result, including source-action indices, is
`maximal_negative_eigenpairs.out`. The check uses exact rational arithmetic
and root isolation; it does not invoke OSCAR or repeat the enumeration.

| No. | `n` | Negative-pair exponent `a` by output number | Displayed Hodge exponent | Output with matching pair |
| ---: | ---: | --- | ---: | ---: |
| 152 | 16 | `7, 1, 5, 3` | 7 | 1 |
| 154 | 24 | `11, 1, 7, 5` | 19, equivalent to `-5` for the pair | 4 |
| 155 | 32 | `15, 1, 9, 7, 13, 3, 11, 5` | 11 | 7 |
| 156 | 48 | `23, 1, 13, 11, 19, 5, 17, 7` | 1 | 2 |

Here `a` denotes the unordered pair `{zeta_n^a,zeta_n^(-a)}`. The displayed
Hodge characters are calculated independently in
`maximal_family_character_result.md`. This identifies a convenient saved
class for each geometric generator **up to Hodge-line inversion**. It does
not choose the oriented complex line or exhibit a direct conjugacy between
the saved lattice matrices and the cohomology action of the displayed cubic.

## Data to preserve per case

1. **Geometric input:** numbered family, projective and strict group IDs, coordinate
   matrices, invariant cubic space, chosen generator and Hodge eigenvalue.
2. **Search scope:** lattice Gram matrix, order, exact characteristic and
   minimal polynomials, signatures, OSCAR/Julia versions, and
   whether the search is complete or only constructive.
3. **Integral outputs:** run-local action index, Gram/action matrices in MRDI,
   period and positive-orthogonal lattices, root and stable-discriminant
   checks, and the saved reload certificate.
4. **Identification:** coprime-power orbits of the retained generators,
   geometric generator matching, and a separately stated proof level for
   matching the displayed equation or its family.

The power-orbit partition is proved above, and the output-level negative
eigenvalue pairs are now recorded. `maximal_lattice_action_index.json`
provides a compact pointer to each selected saved record;
it does not duplicate the matrices. An oriented Hodge-line or full-cohomology
conjugacy certificate remains open. No
exact-character enumeration needs to be rerun.
