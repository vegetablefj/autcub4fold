# Smoothness verification

This directory provides exact smooth-member verification and conservative
singularity screening for invariant cubic spaces. It does not enumerate
representations or test equivalence, containment, saturation, or complex
self-conjugacy.

## Files

```text
gap_smoothness/
|-- README.md
|-- gap_smoothness_script.md
|-- gap_smoothness_result.md
|-- gap_smoothness_functions.g
|-- gap_large_abelian_smoothness.g
|-- gap_large_abelian_smoothness.log
|-- gap_large_abelian_smoothness.out
|-- gap_small_nonabelian_smoothness.g
|-- gap_small_nonabelian_smoothness.log
`-- gap_small_nonabelian_smoothness.out
```

| File | Purpose |
|---|---|
| [gap_smoothness_script.md](gap_smoothness_script.md) | Criteria, function interfaces, input order, pseudocode, options, and running instructions. |
| [gap_smoothness_result.md](gap_smoothness_result.md) | Saved counts, dimension distributions, certificate types, and unresolved records. |
| `gap_smoothness_functions.g` | Common exact coefficient conversion, GAP–Singular calls, Jacobian tests, and smooth-member functions. Loading it only defines functions. |
| `gap_large_abelian_smoothness.g` | Reconstruct and dimension-audit 76 large-group and 55 abelian invariant spaces; seek an exact characteristic-zero smooth member for every record. |
| `gap_small_nonabelian_smoothness.g` | Screen the 182 retained small non-abelian candidates, using family-wide singularity certificates and explicit smooth members. |
| The two `.out` files | GAP-readable results, witness data, and summaries. |
| The two `.log` files | Run configuration, progress, certificate counts, and recorded runtimes. |

## Inputs and certificates

The large/abelian entry point reads the large-group candidates in
`../gap_saturation` and the saved candidates in
`../gap_liftable_abelian` and `../gap_nonliftable_abelian`.
The small entry point reads
`../gap_small_nonabelian/gap_small_nonabelian_data.g`.
Neither reads a result-display directory.

A `smooth` status certifies one explicit member and hence a nonempty
Zariski-open set of smooth cubics. A `singular` status certifies every
member of the invariant space. A failed bounded search remains `unknown`.

The saved verification has 131 smooth records. The small screening has
46 `smooth`, 129 `singular`, and 7 `unknown` records. The latter remain
unresolved in the automatic output and require separate exact singularity
arguments. These are candidate counts before equivalence and saturation
reduction, not counts of distinct final families.

Certificates are linked to their saved inputs by source category and
position, or by the enumeration's `candidateNumber`. The `.out` files
do not duplicate every input matrix group and invariant basis.

Singular input and transcript files are created in GAP-managed temporary
directories, not in the repository. GAP attempts to remove these
directories on exit. Relevant output text is retained inside some
GAP-readable result records; immediate deletion after each call, or cleanup
after a forced termination, is not promised.

## Loading saved results

From this directory:

```gap
Read("gap_large_abelian_smoothness.out");
Read("gap_small_nonabelian_smoothness.out");
```

This loads certificates without running Singular or repeating enumeration.

## Running

The saved runs used WSL (Ubuntu), GAP `4.12.1`, the external system
Singular, and GNU `timeout`. Representation enumeration used Windows GAP
`4.15.1`; the different versions are recorded separately. The smoothness
scripts do not require `cohomolo`.

To load definitions without running:

```gap
CF_LAS_AUTO_RUN := false;;
Read("gap_large_abelian_smoothness.g");

CF_SNS_AUTO_RUN := false;;
Read("gap_small_nonabelian_smoothness.g");
```

To deliberately run either calculation, use a fresh session in this directory:

```gap
Read("gap_large_abelian_smoothness.g");
```

or:

```gap
Read("gap_small_nonabelian_smoothness.g");
```

A run replaces its corresponding `.log` and `.out`, not the result
Markdown. If the corresponding automatic-run variable was previously set
to `false`, explicitly enable it first. Do not run while another process
is replacing the saved input candidates. Consult the
[script guide](gap_smoothness_script.md#running-and-options) for the options
and the supported working directories.

Mathematical and software references are collected in the
[reference guide](../../REFERENCES.md).
