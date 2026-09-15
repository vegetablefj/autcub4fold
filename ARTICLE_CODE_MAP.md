# Article-to-code map

This file connects the computational assertions in the third paper with the
current executable source and saved results. Paths are relative to the
repository root. The paper remains the source of the mathematical reduction;
a saved calculation is cited only for the finite step that it actually
performs.

## Cubic fourfolds

| Article assertion | Executable or mathematical input | Saved result | What is proved computationally |
|---|---|---|---|
| YYZ abstract bounds and the non-abelian target lists | `gap_yyz_bounds/gap_yyz_bounds.g`; target functions in `gap_classification/gap_small_nonabelian/gap_small_nonabelian_functions.g` | `gap_yyz_bounds/gap_yyz_bounds.md` and current target lists in the small non-abelian module | The necessary abstract groups and indices. This does not realize a group by a smooth cubic. |
| The 76 candidates with `rank(S) >= 15` | External lattice classification; exact matrix models in `gap_classification/gap_saturation/gap_large_koike_families.g` | `gap_classification/gap_saturation/gap_large_family_candidates.md` | The lattice list is matched with exact equation-side representations. Lattice completeness and matrix realization are separate inputs. |
| Liftable abelian candidates | `gap_classification/gap_liftable_abelian/gap_liftable_abelian.g` and its preserved diagonal core | `gap_liftable_abelian_data.g`, `.out`, `.log`, and `gap_liftable_abelian_results.md` | All 53 saved candidates, including the explicit `C32` and `C48` examples. |
| Non-liftable abelian cases | Theoretical classification and exact records in `gap_classification/gap_nonliftable_abelian/` | `gap_nonliftable_abelian_data.g` and its README | The two smooth projective-abelian models. There is no hidden exhaustive driver in this folder. |
| Small non-abelian representation enumeration | `gap_classification/gap_small_nonabelian/gap_small_nonabelian.g`, the shared central-extension enumeration, and four case files | `gap_small_nonabelian_data.g`, `.out`, `.log`, and `gap_small_nonabelian_result.md` | The Ext classes and compatible characters are enumerated, with conjugacy, generic-index and nonnegative-dimension conditions. The prime-order restriction is applied after the four cases are collected. |
| Absence of an additional non-liftable branch for the small non-abelian targets | Universal coefficient sequence and the scalar-kernel criterion; `gap_classification/gap_small_nonabelian/gap_multiplier_audit.g` | `gap_multiplier_audit.out`, `.log`, and the multiplier-audit section of `gap_small_nonabelian_result.md` | The current 16 target groups and the direct `S3 x C24` example have trivial multiplier 3-part, so the existing Ext enumeration exhausts `H^2(G,C3)`. |
| Smoothness of generated families | `gap_classification/gap_smoothness/gap_large_abelian_smoothness.g` and `gap_small_nonabelian_smoothness.g`; shared Singular functions | The two `.out` and `.log` files and `gap_smoothness_result.md` | Explicit smooth members or family-wide singularity tests. For the 182 small non-abelian inputs the saved output is 46 smooth, 129 singular and 7 unknown; the last seven are proved singular in the appendix, not relabelled by the program. |
| The seven remaining singular families | Exact mathematical arguments in the accompanying paper's appendix | The paper's Appendix A; source matrices and bases remain in the smoothness input | These are proofs in the article, not guessed negative smoothness tests. |
| Reduction from 177 smooth candidates to 156 saturated rows | `gap_classification/gap_saturation/gap_equal_dimension_saturation.g` | `gap_equal_dimension_saturation.out`, `.log`, and module README | Each omitted candidate has an exact conjugate proper inclusion in an equal-dimensional overgroup; every performed comparison is decided. The 60 independently known saturated groups are retained without testing their inclusion in larger groups. |
| Presentable matrices and the final numbering | `gap_classification/gap_manuscript_validation/gap_ordered_family_catalogue.g`; saved disambiguation in `gap_classification/gap_coordinate_presentation/` | `gap_family_catalogue.g`, `gap_family_correspondence.out`, `.log`, and `.md` in the manuscript-validation module | All 156 survivors correspond to the final presentations in the exact numbered table order. Exact coordinate matrices identify full, symplectic, and generic full groups; all cubic bases and family dimensions pass. |
| Self-conjugacy of all 156 families | Theoretical exemptions plus `gap_classification/gap_self_conjugacy/gap_self_conjugacy.g` | Module `.out`, `.log`, and `.md` | 56 rows are covered theoretically and 100 by exact intertwiners; every row passes. |
| Liftability and F-liftability columns | `gap_classification/gap_liftability/gap_liftability_all.g`; full-group small-subgroup criterion and independent derived-subgroup/cube criterion | Module `gap_liftability.out`, `.log`, and `gap_liftability_result.md` | All 156 final rows are assigned and independently checked; totals are 134 liftable and 131 F-liftable. The small-subgroup criterion uses the full automorphism-group hypothesis. |
| Cross-dimensional containment and action-maximal rows | Pair search in `gap_classification/gap_fourfold_cross_dimension/`; post-processing by `gap_fourfold_maximal.g` | Complete all-pairs file, verified positive matrices, `gap_fourfold_cross_dimension_result.md`, and `gap_fourfold_maximal.out` | 6568 cross-dimensional pairs are decided, giving 1793 strict relations, 433 covers, and 21 action-maximal rows. |

## Cubic threefolds

| Article assertion | Executable or mathematical input | Saved result | What is proved computationally |
|---|---|---|---|
| Extraction of all threefold rows | Additive-splitting and centralizer propositions in the paper; `gap_classification/gap_threefold/gap_threefold_index_three.g` | Module `input/gap_threefold_extraction.g`, `output/gap_threefold_index_three.log`, and `result/gap_threefold_result.md` | Among 63 index-divisible sources, exactly 40 contain a Fermat element. The saved class decisions are retained. |
| Final threefold coordinates, cubic bases, and full groups | Saved `gap_classification/gap_threefold/input/gap_threefold_display_input.g` and `gap_threefold_verify_coordinates.g` | Module `result/gap_threefold_extracted_families.g`, `gap_threefold_families.g`, `gap_threefold_coordinate_audit.out`, and the verification log | The extracted and presented lists have the same 40 rows in source order. Exact coordinate matrices identify their complete groups and cubic spaces and bind both to the final six-dimensional catalogue. Full centralizers, restriction kernels, dimensions and available GL/PGL IDs are checked. |
| Group data in the final threefold table | `gap_classification/gap_threefold/gap_threefold_table_data.g` | Module `result/gap_threefold_table_data.out` and `gap_threefold_result.md` | Strict/projective orders, GAP IDs when available, Fermat ranks, dimensions and seven action-maximal flags are recorded in increasing source-fourfold order. |
| No new deduplication or saturation after extraction | Uniqueness of the maximal additive splitting | The extraction result together with the one-to-one source-row assertion | This is a mathematical consequence, not a negative output of an embedding search. |
| Threefold containment and maximal actions | `gap_classification/gap_threefold/gap_threefold_cross_dimension.g`; verification and cover computation in `gap_threefold_containment.g` | Module direct all-pairs result and manifest, `result/gap_threefold_containment.out`, and `gap_threefold_result.md` | Each of the 493 eligible pairs is tested directly in five variables. Positive matrices are checked on every source generator, and undecided pairs are not negative decisions. The complete relation also agrees with the relation induced from fourfolds, giving 260 strict pairs, 83 covers, and seven action-maximal rows. |

## Mathematical inputs and scope

The YYZ bound calculation is included in `gap_yyz_bounds/`. The lattice
classification is a mathematical input; its source and role are listed in
[REFERENCES.md](REFERENCES.md).
The current multiplier audit proves that a multiplier/stem branch adds no
non-abelian target to the Ext enumeration. The direct threefold calculation uses
the final five-dimensional coordinates; comparison with the relation
induced from fourfolds is a separate check, not a source of its decisions.

## Final article tables

The integrated manuscript includes the 156-row fourfold table and the 40-row
threefold table. Threefold rows follow increasing source-fourfold number.
A dagger in either table marks an
action-maximal row for strict linear-group containment up to conjugacy. The
fourfold flags are the 21 maxima in `gap_fourfold_maximal.out`; the threefold
flags are the seven maxima in `gap_threefold_containment.out`. Every
displayed threefold ID and order was checked from the current
five-dimensional matrix group.

[`gap_classification/export_results.g`](gap_classification/export_results.g)
collects the final lists, metadata, containment relations and maximal flags
in [`gap_result/`](gap_result/README.md). Those files display the completed
results and are not read by classification drivers.
