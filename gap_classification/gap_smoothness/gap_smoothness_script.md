# Smoothness scripts

## Scope

For a finite strict linear group `H`, let `V` be its complete invariant
space of cubics in six variables. These scripts seek either an explicit
smooth member or an exact certificate that every member is singular.
They do not establish completeness of the input groups or perform
equivalence, containment, saturation, or complex self-conjugacy tests.

A smooth member proves that the smooth subset of `V` is nonempty and
Zariski open. It does not make every member smooth. Singularity of one
tested cubic has no family-wide negative meaning.

## Files and inputs

| File | Role |
|---|---|
| `gap_smoothness_functions.g` | Common exact arithmetic, external calls, and certificate functions; no candidate input or automatic run. |
| `gap_large_abelian_smoothness.g` | Reconstruct and dimension-audit the large and abelian inputs, then seek characteristic-zero smooth witnesses. |
| `gap_small_nonabelian_smoothness.g` | Screen the saved retained small non-abelian candidates. |
| [gap_smoothness_result.md](gap_smoothness_result.md) | Statistics and interpretation of the completed runs. |

The large/abelian entry point processes the following sources in this order.

| Input, relative to this directory | Records |
|---|---:|
| `../gap_saturation/gap_large_koike_families.g` | 76 |
| `../gap_liftable_abelian/gap_liftable_abelian_data.g` | 53 |
| `../gap_nonliftable_abelian/gap_nonliftable_abelian_data.g` | 2 |
| **Total** | **131** |

The small entry point reads
`../gap_small_nonabelian/gap_small_nonabelian_data.g`. Its 182 retained
records keep the enumeration order and candidate numbers from the
202-record list before the González-Aguilera–Liendo restriction. Neither
entry point reads a result-display directory.

The large/abelian entry point also loads `../gap_functions.g` for invariant
cubics and centralizers. The small entry point uses the saved basis vectors
and dimensions; it does not reconstruct extensions or repeat the
prime-order restriction.

## Polynomial data and exact coefficients

A cubic basis is represented by coefficient vectors relative to
`cubicMonomialExponents`, the ordered 56 cubic monomials. Coefficient
vectors and witnesses must use this same order. Display strings are not
parsed to recover the basis.

The characteristic-zero Singular input uses `Q` when the coefficient
conductor is 1 and `Q(a)` with the cyclotomic minimal polynomial otherwise.
GAP's `E(n)` is converted through its exact rational coefficients in powers
of the primitive root `a`, not by numerical approximation or literal string
replacement. The prescribed witness coefficients are integers.

These helpers assume valid six-variable cubic coefficient data. A proposed
projective point must be nonzero and have exact coefficients. Candidate
validation checks the stored vector lengths, exponent degrees, dimensions,
and preceding-filter flags; it does not independently prove that a saved
basis is complete or fixed by the input matrices.

## Smoothness criteria

For a homogeneous cubic in characteristic zero, or characteristic greater
than 3, smoothness is equivalent to the absence of a common nonzero zero of
the six partial derivatives. Euler's identity makes the cubic itself
vanish at every common zero.

### Characteristic zero

For one member, the script tests the six ideals
`(partial_1 F,...,partial_6 F,x_i-1)`, in coordinate order.
A Gröbner basis certifies a chart empty precisely when reducing 1 gives 0.
All six empty charts certify smoothness over the algebraic closure.
The calculation stops early if a nonempty chart proves that the tested
member is singular.

### Good split-prime reduction

The small screening can reduce coefficients at a prime `p > 3` with
`p = 1 mod n`, where `n` is the basis coefficient conductor. Every
denominator in the chosen cyclotomic coefficient expressions must be
invertible modulo `p`. The image of the primitive root has exact order
`n`. Zero reduced members are skipped.

Unlike the characteristic-zero test, the finite-field batch uses the
dimension of the homogeneous affine Jacobian ideal. Dimension zero means
that its zero set is only the origin, so the projective Jacobian locus is
empty over the algebraic closure. It is not a search through rational
points. A successful batch witness is tested again individually.

A smooth reduction certifies characteristic-zero smoothness of the same
explicit cubic. Indeed, a nonempty generic projective Jacobian locus would
specialize to a nonempty locus at that prime. Failure at a prime proves
nothing about characteristic-zero singularity.

### Family-wide singularity

All negative certificates concern the whole invariant space.

- If the invariant-space dimension is smaller than the linear-centralizer
  dimension, the centralizer orbit of a smooth member cannot have the full
  centralizer dimension. This contradicts finiteness of its linear
  automorphism group.
- A common nonconstant monomial factor forces every nonzero member to be
  reducible or non-reduced, hence singular.
- If a variable has exponent at most one in every supported monomial, its
  coordinate point is singular for every member.
- A nonzero point where all partial derivatives of every basis element
  vanish is a common singular point for every linear combination.
- The exact common-locus test uses all basis partials and `x_i-1`, in the
  same six-chart order. A non-unit chart ideal proves the existence of a
  common point over the algebraic closure. It need not supply explicit
  point coordinates.

An empty common locus does not prove the family has a smooth member:
every member may be singular at a point depending on its coefficients.
It therefore supplies no positive status by itself. Timeouts, missing tools,
and unsuccessful bounded searches are not singularity certificates.

## Common functions

The `CF_SNS_` prefix is retained for compatibility; these functions are
shared by both entry points.

| Function | Input and purpose |
|---|---|
| `CF_SNS_LinearCombinationOfVectors` | Ordered basis and coefficient vector; form the exact member vector. |
| `CF_SNS_CoefficientVectorToPolynomialString` | Member vector and monomial exponents; produce its GAP-oriented display string. |
| `CF_SNS_FamilyConductor` | Basis record; determine the common cyclotomic conductor. |
| `CF_SNS_CyclotomicCoefficientString`, `CF_SNS_ExactRingLines` | Convert exact coefficients and define the characteristic-zero Singular coefficient field. |
| `CF_SNS_AdmissibleSplitPrimes` | Basis and bounds; list split primes where all coefficients reduce. |
| `CF_SNS_TestCandidateBatchAtPrime` | Basis, ordered coefficients, prime, tools, and timeout; seek a smooth reduction and recheck a successful witness. |
| `CF_SNS_RunExactMemberTest` | Basis, coefficients, tools, and timeout; return `exact_smooth`, `exact_singular`, or `timeout_or_error`. |
| `CF_SNS_PointIsCommonSingularPoint` | Basis and nonzero point; evaluate every basis partial exactly in GAP. |
| `CF_SNS_FindSmallCommonSingularPointBounded` | Basis and support/check limits; search sparse exact points, returning a point or `fail`. |
| `CF_SNS_RunExactCommonSingularLocusTest` | Basis, tools, and timeout; certify existence or absence of a common point, or leave the call unresolved. |
| `CF_SNS_RunBoundedSingularScript` | Generate temporary files, call external Singular under GNU `timeout`, and require successful exit, no error marker, and a completion marker. |
| `CF_SMOOTH_DeterministicCoefficientVectors` | Invariant-space dimension and maximum; build the large/abelian integer witness batch. |
| `CF_SMOOTH_FindExactSmoothMember` | Basis, tools, trial limit, and timeout; seek a characteristic-zero witness and retain its trials. |

The outer wrappers interpret these results conservatively. For example,
`exact_singular` applies only to the chosen member and never labels the
whole invariant space singular.

## Large-group and abelian verification

For each saved input, `CF_LAS_PrepareCandidate` reconstructs the complete
invariant cubic space and linear centralizer from the strict generators.
It compares the stored and computed invariant-space, centralizer, and
family dimensions. This is a dimension audit, not a recomputation of the
group IDs or a comparison with the original ordered basis.

The family-dimension expression is `dim(V) - dim(C_GL6(H))`. When a smooth
member exists, this is also the projective invariant-space dimension minus
the projective centralizer dimension. Without a smooth witness it is only
an expected dimension.

After a successful audit, the entry point tests the reconstructed basis.
Its first coefficient vector is `[i^2+1 : i=1..dim(V)]`; further fixed
integer vectors follow if necessary. No unrecorded random state is used.
A failed dimension audit aborts the run, rather than producing a
`singular` status. A bounded failure to find a smooth member is `unknown`.

```text
for source in [large, liftable abelian, non-liftable abelian]:
    for record in stored order:
        reconstruct invariant cubics V and the linear centralizer
        require all three stored dimensions to match
        test the deterministic integer coefficient vectors in order
        if one member is certified smooth in characteristic zero:
            record smooth, coefficients, polynomial, and trials
        else:
            record unknown
```

The abelian input has theoretical smooth members: subgroups of the
[Peng–Zheng maximal liftable models](../../REFERENCES.md#abelian-actions)
preserve a smooth cubic, and the two non-liftable models are supplied
separately. Nevertheless, all 55 abelian records are tested independently.
There are no smoothness exemptions in this entry point.

## Small non-abelian screening

The exact order in `CF_SNS_ClassifyCandidate` is:

1. dimension obstruction;
2. common monomial factor;
3. forced coordinate singularity, rechecked on every basis partial;
4. deterministic smooth-member batch: good split primes first, then bounded
   characteristic-zero fallback if necessary;
5. bounded common-point search, with exact rechecking;
6. exact characteristic-zero common Jacobian locus;
7. `unknown` if neither conclusion has been certified.

The member batch starts with `i^2+1` when the invariant-space dimension is
greater than one. For a one-dimensional space, the sole vector is `[1]`.
It includes fixed dense and sparse vectors; a fixed-seed integer recurrence
can complete the batch without changing the search order between runs.

The common-point search normalizes the first supported coordinate to 1.
The other supported coordinates range over
`1,-1,2,-2,E(3),E(3)^2`, in that order.

```text
for candidate in retained enumeration order:
    validate the saved data and preceding-filter flags
    if a dimension, monomial-factor, or coordinate-point obstruction holds:
        record singular and the family-wide certificate
        continue
    seek a smooth member in the prescribed coefficient batch
    if one is certified:
        record smooth, its coefficients, polynomial, and test data
        continue
    search for and recheck a common singular point of the basis
    if one is found:
        record singular and the point
        continue
    test the exact projective common Jacobian locus
    if a common point is certified to exist:
        record singular, the chart, and test data
    else:
        record unknown and the unresolved tests
count statuses and proof types without renumbering candidates
```

The options control which certificates are sought, not their validity.
Neither exhaustion of the coefficient batch nor emptiness of
the common locus is treated as proof of smoothness or singularity.

## Outputs and interpretation

| Status | Content |
|---|---|
| `smooth` | One explicit smooth member; a generically smooth invariant family. |
| `singular` | An exact obstruction valid for every member. |
| `unknown` | Neither conclusion was certified within the chosen bounds. |

The verification `.out` defines `LargeAbelianSmoothnessRun` and
`LargeAbelianSmoothnessResults`. Records are matched by
`sourceCategory` and `sourcePosition`; their coefficients refer to the
basis reconstructed by that entry point.

The screening `.out` defines `SmallNonabelianSmoothnessRun`,
`SmallNonabelianSmoothnessResults`, and `SmallNonabelianSmoothnessSummary`.
Its coefficients refer to the saved enumeration basis. Its
`candidateNumber` is not a new smoothness number or a final-table number.
The numbered progress log separately counts positions in the retained list.

Neither `.out` duplicates all input matrices and invariant bases.
Keep the saved inputs with the results. Some screening fields retain the
name `guessedMemberTest`: their successful tests are exact certificates,
although the choice of the member is only a bounded search.

The seven saved `unknown` records are set aside for separate exact
singularity arguments; they are not silently discarded or added to the
automatic `singular` count.

External scripts and transcript files are created in GAP-managed temporary
directories. GAP attempts cleanup when the session exits, not after every
external call. The screening retains relevant Singular output text in
`singularOutput` fields; the large/abelian results retain compact trial
statuses. No standalone Singular file is required as persistent input.

## Running and options

The saved environment is WSL (Ubuntu), GAP `4.12.1`,
`/usr/bin/Singular`, and GNU `/usr/bin/timeout`. The Windows enumeration
environment was GAP `4.15.1`; a different recorded version does not require
rerunning its saved candidates. These scripts do not use `cohomolo`.

Both entry points support the repository root (`anc`), `gap_classification`,
or this module as the working directory. The examples below use this module.
Use a fresh GAP session for each deliberate run:

```gap
Read("gap_large_abelian_smoothness.g");
```

or:

```gap
Read("gap_small_nonabelian_smoothness.g");
```

To load definitions only:

```gap
CF_LAS_AUTO_RUN := false;;
Read("gap_large_abelian_smoothness.g");

CF_SNS_AUTO_RUN := false;;
Read("gap_small_nonabelian_smoothness.g");
```

These flags stay false until explicitly changed. Loading the common
functions has no automatic run. Loading either saved `.out` also runs no
external calculation.

### Large/abelian controls

| Control | Default |
|---|---:|
| `CF_LAS_MAX_MEMBER_TRIALS` | 12 |
| `CF_LAS_MEMBER_TIMEOUT_SECONDS` | 120 |
| `CF_LAS_PRINT_PROGRESS` | `true` |

The log and output paths can be set by `CF_LAS_LOG_FILE` and
`CF_LAS_OUTPUT_FILE`. Explicit external paths can be supplied through
`CF_LAS_SINGULAR_EXECUTABLE` and `CF_LAS_TIMEOUT_EXECUTABLE`.

### Small-candidate controls

Set overrides in `CF_SNS_RUN_OPTIONS` before a deliberate run.
Unknown option names are rejected.

| Option | Default |
|---|---:|
| `useFiniteFieldTest` | `true` |
| `maxCoefficientCandidates` | 32 |
| `maxPrimeTrials` | 3 |
| `maxSplitPrimes` | 8 |
| `maxPrime` | 10000 |
| `finiteFieldTimeoutSeconds` | 30 |
| `useExactCharacteristicZeroFallback` | `true` |
| `maxExactMemberTrials` | 6 |
| `exactMemberTimeoutSeconds` | 60 |
| `maxCommonPointSupport` | 4 |
| `maxCommonPointChecks` | 8000 |
| `useExactCommonSingularLocusTest` | `true` |
| `commonLocusTimeoutSeconds` | 60 |
| `printProgress` | `true` |

The prime list is bounded by `maxSplitPrimes`; only its first
`maxPrimeTrials` primes are tried. The finite-field timeout applies to each
batch or individual recheck; the characteristic-zero timeout applies to
each member or common-locus call, not to the whole family.

External paths can be supplied as `singularExecutable` and
`timeoutExecutable`; `fail` requests automatic discovery.
`CF_SNS_INPUT_FILE`, `CF_SNS_LOG_FILE`, and `CF_SNS_OUTPUT_FILE` control
the file paths.

Each deliberate run replaces its corresponding `.log` and `.out`.
The result Markdown is a separate summary and is not regenerated by these
entry points. Finish writing the enumeration inputs before running screening.
See [README.md](README.md) for saved-result loading and
[the reference guide](../../REFERENCES.md) for the mathematical sources.
