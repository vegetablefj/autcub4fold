# Family containment helper functions

`gap_containment_functions.g` supplies the list-level interface for the
equivalence, containment, and saturation calculations. It does not replace
the strict group-theoretic kernel in `../gap_functions.g`.

## Mathematical direction

For matrix groups $H_i,H_j\leq\mathrm{GL}_6(\mathbb C)$, the strict test
searches for

$$
P^{-1}H_iP\leq H_j.
$$

After the corresponding coordinate change, the complete $H_j$-invariant
cubic space is contained in the $H_i$-invariant space. Thus the direction
of containment of their moduli images is reversed:

$$
\mathcal F_{H_j}\subseteq\mathcal F_{H_i}.
$$

Here the families allow automorphism groups larger than the displayed group.
They are not the disjoint strata where that group is the exact full group.

Every returned positive edge therefore has a smaller source group and a
larger target group, but the target family is contained in the source family.
For equal group orders, a positive edge is a linear conjugacy; only one
orientation is tested.

## Loading

From the repository root:

```gap
Read("gap_classification/gap_saturation/gap_saturation_input.g");
Read("gap_classification/gap_saturation/gap_containment_functions.g");
```

The helper file loads `gap_functions.g` automatically if the strict functions
are not already available.

## Input records

The normalized `SaturationInputCandidates` list works directly. The accessors
also recognize the principal field names in the earlier catalogues:

- generators: `matrixGenerators`, `generators`, `linearGenerators`, or
  `group`;
- linear group ID: `linearGroupId`, `linearGId`, `GLId`, or `groupId`;
- family dimension: `familyDimension` or `expectedModuliDimension`;
- labels: `sourceKey`, `label`, or `inputNumber`.

`CF_PrepareContainmentRecords(list)` constructs the finite matrix groups and
their faithful permutation models once. Its result can be reused in both
search modes:

```gap
prepared := CF_PrepareContainmentRecords(SaturationInputCandidates);
```

## Traceable equal-dimensional saturation search

The current driver uses

```gap
traced := CF_TraceEqualDimensionSaturationLazy(
    CF_PrepareContainmentRecordHeaders(SaturationInputCandidates),
    rec(
        stop_first := true,
        construct_witness := false,
        try_literal_inclusion := true,
        use_abstract_id_filter := true,
        pair_progress := true,
        progress_interval := 5
    )
);
```

The calculation has two phases. First, equal-order actions are compared and
proved conjugate copies are merged. A family tagged `known_saturated` is
preferred as the representative of its equal-order class. Second, the
remaining non-tagged representatives are processed by increasing family
dimension and increasing group order. For each source, all strictly larger
equal-dimensional representatives of compatible order are tried in
increasing order, and the first proved embedding is recorded.

The target list is the complete list of representatives from the first
phase. In particular, a target remains available after it has itself been
mapped to a larger group. The direct edges therefore form chains. The
function resolves every chain and returns both its direct target and its
final saturated target.

The principal audit fields are:

- `directEdges`, containing the proved equal-order and proper-order edges;
- `familyTraces`, containing the direct target, final target, full path, and
  edge numbers for every input family;
- `saturationClasses`, grouping all input families by final target;
- `knownSaturatedSurvivorPositions`, `computedSaturatedPositions`, and
  `unresolvedSurvivorPositions`;
- `noEmbeddingPairs` and `undecidedPairs`.

An `undecided` result never removes a family. A surviving family is marked
unresolved if at least one of its possible comparisons was undecided.

## Exhaustive pair searches

### Equal-dimension search

```gap
equalDimension := CF_ContainmentsEqualDimension(prepared);
```

Only pairs having the same `familyDimension` are tested. This is the version
used to find whole-family duplicates and saturated representatives. A
positive proper-order edge between smooth records identifies the same
irreducible moduli closure when the dimensions agree. This uses the complete
invariant spaces and the finite-stabilizer dimension formula. It is not
inferred from group orders and stored dimensions without an embedding.
Calling a survivor saturated further uses completeness of the candidate
list and the separately justified protected records.

### Search without a dimension filter

```gap
allDimensions := CF_ContainmentsAllDimensions(prepared);
```

This version does not use family dimension to omit any pair. Group order is
still used to orient a pair, since a larger finite group cannot inject into a
strictly smaller one.

It also returns the maximal records and the proved containment relation:

```gap
allDimensions.maximalRecords;
allDimensions.maximalPositions;
allDimensions.maximalKeys;
allDimensions.containmentPairs;
allDimensions.maximaComplete;
```

Here `containmentPairs` contains every proved ordered pair, including
relations implied transitively; it is not merely the Hasse edges. A record is
removed from `maximalRecords` when it embeds in a strictly larger record. For
an equal-order conjugacy, the earlier input record is retained. The field
`maximaComplete` is `true` exactly when the search contains no `undecided`
pairs. Otherwise the list is maximal only relative to the currently proved
edges.

Both functions return four lists:

- `allPairs`;
- `embeddedEdges`;
- `noEmbeddingPairs`;
- `undecidedPairs`.

The default bulk options are

```gap
rec(stop_first := true, construct_witness := false)
```

so a complete character-theoretic positive certificate is retained but the
optional conjugating matrix is not constructed. To request matrices, use:

```gap
equalDimension := CF_ContainmentsEqualDimension(
    prepared,
    rec(stop_first := true, construct_witness := true,
        allow_hard_iso := true)
);
```

For long reductions, useful options include:

```gap
rec(
    target_order := "ascending",
    pair_progress := true,
    progress_interval := 1,
    try_literal_inclusion := true,
    use_abstract_id_filter := true
)
```

`pair_progress` prints the source and target keys before every potentially
long pair test and prints its status, method, reason, and elapsed time after
completion. In the earlier dynamic helper, `target_order := "ascending"` tries
the smallest compatible retained target first. The traceable function always
uses increasing target order. Literal inclusion is only a positive fast
path; a failed literal test always falls through to the complete strict
search.

An `undecided` result is never treated as a negative or as a removal edge.

## Removing records from an existing list

The removal function does not modify its input list:

```gap
stripped := CF_StripListByContainment(
    SaturationInputCandidates,
    equalDimension,
    "smaller_group"
);
remaining := stripped.remainingRecords;
```

Its third argument has two values.

### `smaller_group`

For every proved proper embedding $H_i\preceq H_j$, remove the source
$H_i$. With equal-dimensional input, this keeps the groups that are maximal
under conjugate embedding and is the appropriate direction for saturation.

### `larger_group`

For every proved proper embedding $H_i\preceq H_j$, remove the target
$H_j$. This keeps minimal groups and can reduce the number of family-wide
singularity tests: once the complete $H_i$-invariant family is proved
singular, every contained $H_j$-invariant family is singular as well.

This second mode is only a mechanical list reduction. It is a valid final
singularity elimination only when the relevant smaller-family singularity has
already been certified. If the smaller family is smooth or still unknown,
the removed larger group must remain deferred rather than being declared
singular.

For an equal-order conjugacy, neither endpoint is mathematically larger. Both
removal modes keep the earlier list entry and remove the later duplicate.

The returned audit record includes `keptPositions`, `removedPositions`,
`remainingRecords`, `removedRecords`, and `removalCertificates`. If only the
list is needed, use:

```gap
remaining := CF_ContainmentFilteredList(
    SaturationInputCandidates,
    equalDimension,
    "smaller_group"
);
```
