# Small non-abelian computation scripts

## Scope

The calculation enumerates six-dimensional strict linear groups whose
projective actions are liftable, whose projective symplectic part is one of
`C3`, `C2^2`, `C4`, or `S3`, and whose projective full group occurs in the
non-abelian part of the Yang–Yu–Zhu bound. Abelian full groups are handled
in the abelian calculations and are not repeated here.

This directory separates three steps:

1. audit the multiplier 3-parts of the distinct projective targets;
2. enumerate and deduplicate the liftable linear representations;
3. apply the generic-full-group condition, construct invariant cubic
   spaces, and apply the González-Aguilera–Liendo necessary restriction.

The even-index condition is applied to the target group lists before
extension construction. Liftable includes both the zero and nonzero
`Ext^1(G_ab,C3)` classes; F-liftability is not assumed.

Smoothness is a logically separate downstream calculation. Its scripts are stored in `../gap_smoothness` and consume the machine-readable output produced here.

## Files used by the calculation

| Path | Role |
|---|---|
| `gap_multiplier_audit.g` | Independent cohomological audit; verifies that the Ext part covers every central `C3` extension for the audited targets. |
| `gap_small_nonabelian.g` | Canonical serial entry point, ordered collection, González restriction, and archive writer. |
| `gap_small_nonabelian_functions.g` | Shared candidate lists, validation, batch traversal, metadata, and exact necessary restrictions. |
| `gap_small_nonabelian_liftable_engine.g` | Frozen audited extension and representation engine. |
| `gap_small_nonabelian_c3.g` | The two `C3` components and the generic `S3` containment data for the index-two component. |
| `gap_small_nonabelian_c2_2.g` | The unique `C2^2` component. |
| `gap_small_nonabelian_c4.g` | The unique `C4` component. |
| `gap_small_nonabelian_s3.g` | The two `S3` components, the exact `[72,27]` branch, and the direct `S3 x C24` example. |

The three generated files are:

| Path | Contents |
|---|---|
| `gap_small_nonabelian_data.g` | Machine-readable retained and rejected candidate records and the run summary. |
| `gap_small_nonabelian.log` | Numbered progress, options, package version, and runtime information. |
| `gap_small_nonabelian.out` | Complete human-readable candidate records and final counts. |

The audited engine retains its extension, representation, and internal
deduplication logic. Its internal function names are implementation names,
not mathematical labels in the output.

The independent multiplier audit writes `gap_multiplier_audit.out` and
`gap_multiplier_audit.log`, and updates only its own section in
`gap_small_nonabelian_result.md`. Reading the audit does not start the
representation enumeration; reading the enumeration does not repeat the audit.

## Input cases and order

The projective full-group lists are transcribed from the Yang–Yu–Zhu bounds
into the workflow helpers. The ordered IDs are recorded below; no external
bound-report file is read. See the [reference guide](../../REFERENCES.md)
for the mathematical source.
It processes `C3`, `C2^2`, `C4`, and `S3` in that order and preserves the
following order within each case.

| Symplectic part and component | Generic index | Ordered projective full-group IDs |
|---|---:|---|
| `C3`, Koike (3.4) | 1 | `[18,3]`, `[6,1]`, `[12,1]`, `[36,6]`, `[24,1]` |
| `C3`, Koike (3.3) | 2 | `[18,3]`, `[6,1]`, `[12,1]`, `[36,6]`, `[24,1]` |
| `C2^2` | 1 | `[12,3]`, `[8,3]`, `[16,6]`, `[24,13]`, `[24,10]` |
| `C4` | 1 | `[8,4]`, `[8,3]`, `[24,10]`, `[16,6]` |
| `S3`, Koike (3.6) | 1 | `[6,1]`, `[12,4]`, `[18,3]`, `[24,5]`, `[36,12]`, `[48,4]`, `[72,27]` |
| `S3`, corrigendum component | 2 | `[12,4]`, `[24,5]`, `[36,12]`, `[48,4]`, `[72,27]` |

The projective group `[72,12]` in the `C3` case is omitted by the separate exclusion argument in the paper. For `S3`, no `n=16` or `n=24` branch is enumerated. The case `[72,27] = S3 x C12` uses the preserved exact weight enumeration. The known Yang–Yu–Zhu `S3 x C24` action is appended as one direct case; its projective and strict linear IDs are `[144,69]` and `[432,464]`.

## Representation enumeration

For each component and listed projective full group, the frozen engine performs the following operations in the recorded order.

1. It checks the fixed symplectic lift, its normal projective image, and the abstract projective full group.
2. It enumerates the required classes in `Ext^1(G_ab,C3)`. For each class it constructs the compatible central lift and all compatible degree-six characters.
3. It retains the representations for which the determinant-one kernel is the prescribed symplectic lift.
4. It removes `GL(6)`-equivalent matrix images inside each Ext class.
5. It performs a second `GL(6)`-conjugacy deduplication across the Ext classes, using the stored automorphism-orbit character key.

Thus the generic-full-group test is applied only after the representation-level deduplication. Abstract group IDs alone are never used for this deduplication: the same abstract group can have inequivalent natural representations.

The two allowed deduplication modes are `automorphism-orbit` and `exact-character`; the standard run uses `automorphism-orbit` and shares the canonical group cache across Ext classes. Equality of finite-dimensional complex characters under an abstract group is exactly the required equivalence of the corresponding representations.

## Generic-index-two conditions

For a component of generic index two, an admissible full group must have even non-symplectic index. The program applies this divisibility condition before the strict linear containment test.

It then requires the candidate linear group to contain, up to `GL(6)` conjugacy, the full linear group acting generically on that component:

- for the second `C3` component, this group is the displayed `S3` action with strict linear ID `[18,3]`;
- for the corrigendum `S3` component, it is the displayed `S3 x C2` action with strict linear ID `[36,12]`.

In both modules, `E(3) * IdentityMat(6)` is included explicitly among the source generators. The test therefore concerns strict linear groups, not only their projective images.

For a source $H_0$ and target $H$, the strict test does the following:

1. construct faithful permutation models of both finite matrix groups;
2. apply exact order, exponent, derived-series, and literal-containment checks;
3. enumerate representatives of all target-conjugacy classes of subgroup
   images isomorphic to $H_0$, using the general isomorphic-subgroup routine
   or the complete specialized small-group branch;
4. test one representative of every coset in `Aut(H_0)/Inn(H_0)`;
5. compare the two natural degree-six characters on every conjugacy class of $H_0$.

Character agreement proves equivalence of the two complex representations and hence the required linear-conjugacy containment. An explicit conjugating matrix is not needed. A negative result is returned only after the subgroup images and all required outer-automorphism twists have been exhausted.

The optional characteristic-polynomial fingerprint filter is disabled in this enumeration. This changes only the preliminary rejection stage; it does not change the exhaustive subgroup-and-character test.

## Cubic spaces and the González restriction

Only representations surviving the preceding conditions enter the cubic calculation. For each one, the program constructs the invariant cubic basis, computes the centralizer dimension from the natural character, and records the expected family dimension. Representations with negative expected dimension are discarded: a smooth cubic has a finite linear automorphism group, so its orbit under the centralizer has the full centralizer dimension. Character or weight formulas can supply these dimensions before the basis is constructed.

After the four modules have been collected, the entry point applies the
strict-invariant González-Aguilera–Liendo prime-order restriction. Scalar
normalization and generator powers are included. In particular, the inverse
order-nine spectra `225588` and `114477` are distinct spectra, but both are
included in the admissible patterns. This does not identify their matrices
by linear conjugacy.

The source is the published Theorem 3.8, with the historical order-5
qualification in the [reference guide](../../REFERENCES.md#prime-order-restriction).
The current inputs involve only the primes 2 and 3. The abelian-only
dangerous-spectrum exclusions are not used as general smoothness
restrictions here.

This is a necessary restriction, not a smoothness test. The retained and rejected records are both written to the machine-readable data file, and their original candidate numbers are preserved.

The later smoothness calculation is kept in `../gap_smoothness`. It consumes the archived candidate data and is not part of the representation enumeration.

## Output boundary

The representation calculation ends after the González restriction. The main entry point writes the retained and rejected candidates, their ordered invariant bases, group identifiers, family dimensions, and run metadata. It deliberately does not call Singular or perform smoothness and saturation tests.

Reading `gap_small_nonabelian_data.g` loads these records without reconstructing extensions or representations. Downstream scripts should use this data file rather than parse the human-readable output.

## Running the scripts

The canonical run is serial and uses Windows GAP 4.15.1 with the `smallgrp` and `cohomolo` packages. The actual GAP version is written automatically to the log and data files. To load definitions only, use

```gap
CF_SN_AUTO_RUN := false;;
Read("gap_small_nonabelian.g");
```

Start GAP in this module directory. To repeat the enumeration and replace
the saved result files, use a fresh session or explicitly enable running:

```gap
Read("gap_small_nonabelian.g");
```

If `CF_SN_AUTO_RUN` was set to `false` earlier in the session, set it to
`true` before the preceding command. To load the saved records without
repeating the enumeration, use

```gap
Read("gap_small_nonabelian_data.g");
```

Reading the main file with automatic running enabled replaces the three
generated files. The saved run took about 2 hours 27 minutes. No parallel
scheduler or merger is used.

## Multiplier audit and extension completeness

### Task and computation order

The executable audits the small non-abelian projective targets. It does not
construct extension presentations or enumerate matrix representations.
The full-H2 search below is a supplementary mathematical specification.
It is not executed for the audited list.

`gap_multiplier_audit.g` performs the following steps:

1. Load `smallgrp`, `cohomolo`, the shared functions, and the small non-abelian functions.
2. Read the target IDs in case order `C3`, `C2^2`, `C4`, `S3`. Remove repeated IDs while retaining their first occurrence.
3. For each distinct target, construct a permutation-group model and compute the cohomology data with trivial one-dimensional `GF(3)` coefficients.
4. Audit the separate `S3 x C24` example `[144,69]`.
5. Audit the five controls without adding them to the target list.
6. Check the target count, trivial multiplier 3-parts for the targets and direct example, and the universal-coefficient dimension identity for every record.
7. Write the GAP-readable result, update the multiplier-audit tables in the shared result document, close the log, and exit GAP.

For groups of order prime to 3, the 3-primary multiplier and second
cohomology vanish; the code records zeros without constructing a cohomolo
`CHR` record. Otherwise `CHR` uses trivial action on `GF(3)`.
The helper computes the 3-primary multiplier, not the full Schur multiplier.
An empty multiplier list therefore asserts only that its 3-part is trivial.

Compact pseudocode for the executed audit:

```text
targets := first-occurrence union of the four ordered target lists
audit each target in order
audit the direct S3 x C24 example
audit the five controls separately
require 16 distinct targets
require zero multiplier 3-part for every target and the direct example
require dim H2 = dim Ext + dim Hom(multiplier,C3) for all 22 records
export records and readable tables
```

### Functions and fields

| Function | Purpose |
|---|---|
| `CF_SN_YYZNonabelianFullGroupIds` | Supply the ordered target IDs for each case. |
| `CF_SN_CohomologyDimensionAudit` | Compute abelian invariants, multiplier 3-part, H2 dimension, and the dimension check. |
| `CF_MA_AuditGroup` | Construct a group model and attach Sylow and cohomology metadata. |
| `CF_MA_AddDistinct` | Append a target only at its first occurrence. |
| `CF_MA_WriteAssignment` | Write the GAP-readable assignment `MultiplierAuditResult`. |

Each group record contains `role`, `id`, `order`, `structure`,
`abelianInvariants`, `sylow3Order`, `sylow3Structure`,
`multiplier3Invariants`, `extDimension`, `h2Dimension`, and
`universalCoefficientCheckPassed`.
The result keeps targets, the direct example, and controls in separate
fields. Controls are not candidate input.

All dimensions are over `GF(3)`. The Ext dimension is the number of
abelianization invariant factors divisible by 3. The Hom dimension is the
number of factors in `multiplier3Invariants`. The program verifies their
sum against the independently computed H2 dimension.

### Extension and liftability criterion

Write `G` for a finite projective group and `H` for its strict linear
group, with distinguished cubic scalar subgroup `Z = mu_3`. The extension
is central:

```text
1 -> Z -> H -> G -> 1
```

A faithful scalar character of `Z` extends to a character of `H`
exactly when it is trivial on `Z intersect [H,H]`. Indeed, it must factor
through the image of `Z` in the abelianization, and a character of a
subgroup of a finite abelian group extends to the whole group.
Twisting the strict representation by the inverse character then kills
`Z` and gives a linear lift of the projective action. Conversely, a
linear lift supplies this character. Thus the action is liftable exactly
when `Z intersect [H,H] = 1`.

Since `|Z| = 3`, non-liftability is equivalent to the stem condition
`Z <= [H,H]`. For trivial coefficients, the universal coefficient
sequence is:

```text
0 -> Ext^1(G_ab,C3) -> H^2(G,C3) -> Hom(M(G),C3) -> 0
```

The homology five-term sequence identifies the image of the multiplier
map `M(G) -> Z` with the kernel of `Z -> H_ab`, namely
`Z intersect [H,H]`. Therefore the embedded Ext part is precisely
the liftable part. If `M(G)_(3) = 0`, there is no non-liftable extension
to process.

This does not mean every central extension splits. The zero class is the
F-liftable case; a nonzero Ext class can be liftable without being
F-liftable. The current small non-abelian engine traverses those Ext classes.
The audit establishes the absence of an additional multiplier branch for
the audited targets, not a general theorem about all non-abelian groups.

### Supplementary full-H2 search

For a target with nontrivial multiplier 3-part, a non-liftable search would
have to retain all labelled cohomology classes outside the Ext kernel.
Let `Kplus` be the prescribed strict symplectic linear group, containing
`Z`, and put `Kbar = Kplus/Z`.

```text
for each projective target G in prescribed order:
    list all normal subgroups Q isomorphic to Kbar
    compute full H2(G,C3) and verify the dimension identity
    for each labelled nonzero cohomology vector:
        construct the distinguished central extension H -> G with kernel Z
        skip unless Z <= [H,H]
        for each Q:
            P := its inverse image in H
            skip unless P is isomorphic to Kplus
            for each scalar-compatible identification Kplus -> P:
                enumerate all degree-six characters extending its natural character
                require faithfulness and the prescribed scalar character
                require determinant kernel = P
                construct the exact matrix representation
                verify order, full scalar subgroup, restriction, and determinant kernel
                retain the representation and construction provenance

deduplicate by exact unmarked linear-group conjugacy
apply the component-specific generic-index and generic-full-group conditions
compute the full fixed space W in all 56 cubic monomials
compute the GL centralizer dimension c
discard only when dim(W) < c
apply the strict prime-order restrictions
pass the remaining groups to the common smoothness calculation
```

Vectors `v` and `-v` retain their distinct kernel labels at extension
construction. All normal copies and scalar-compatible identifications must
also be accounted for. Markings can be forgotten only after an exact
comparison of the resulting matrix groups.

For faithful complex representations of two abstract groups, their matrix
images are conjugate exactly when a group isomorphism identifies their
characters. Character values on conjugacy-class representatives suffice.
For a fixed abstract group, this is the orbit of its irreducible-character
multiplicity vector under the full automorphism group; restricting to the
stabilizer of a selected symplectic copy is not enough. If a GAP ID is
unavailable, use exact isomorphism against cached abstract representatives.

Every smooth action with the specified data supplies an extension class,
a normal symplectic subgroup, its inverse image, and a natural character
covered by these loops. Conversely, faithfulness, the scalar audit, and
the determinant-kernel check establish the required projective group and
symplectic subgroup. The fixed-space computation gives the complete
invariant system, but does not itself prove it has a smooth member.

The dimension obstruction is one-sided: a smooth cubic has finite strict
stabilizer, so its centralizer orbit in W has dimension c.
Hence `dim(W) < c` excludes smooth members. A smooth witness is a positive
certificate; singularity requires a family-wide certificate.
Failure to find a witness remains `unknown`.

The current audit has no input for this supplementary search. Its outputs
are cohomological records, not matrix representations or smoothness certificates.
See [README.md](README.md) for loading and running, and
[gap_small_nonabelian_result.md#multiplier-audit](gap_small_nonabelian_result.md#multiplier-audit)
for the saved tables and checks.

### Loading and repeating the audit

From this directory, the saved records can be loaded without computing
cohomology or enumerating representations:

```gap
Read("gap_multiplier_audit.out");
MultiplierAuditResult;
```

To repeat the audit deliberately, use GAP with `smallgrp` and `cohomolo`:

```gap
Read("gap_multiplier_audit.g");
```

This replaces only `gap_multiplier_audit.out`, `gap_multiplier_audit.log`,
and the marked multiplier-audit section of `gap_small_nonabelian_result.md`.
The enumeration statistics outside that section are preserved. The script
exits GAP after its final checks. The supplied audit log names an earlier
standalone report; the corresponding tables are now in the shared result
document.
