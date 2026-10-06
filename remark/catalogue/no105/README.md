# Family No. 105

This directory contains the supplementary integral-lattice search for family
No. 105. The starting symplectic lattice pair is the verified No. 97,
class-1 restriction in `../restriction_97_100_from_74.verified.mrdi`.
The search and the geometric family assignment are separate checks.

| File | Purpose |
| --- | --- |
| [no105_script.md](no105_script.md) | Input, exact filters, mathematical scope, and reproducibility guide. |
| [no105_result.md](no105_result.md) | Counts, selected action, geometric identification, and result boundaries. |
| `run_no105_T_enumeration.jl` | Enumerate exact order-six actions on the rank-ten invariant lattice. |
| `no105_T_raw_genus_classes.mrdi`, `no105_T_enumeration.mrdi` | Saved raw genus classes and checked actions on the input lattice. |
| `check_no105_discriminant3.jl` | Independent exact check of the necessary residual order-three discriminant condition. |
| `run_no105_extensions.jl` | Enumerate compatible primitive extensions and apply the final lattice tests. |
| `no105_extensions.mrdi` | Saved complete ambient result; the raw file intentionally makes no numbered-family claim. |
| `verify_no104_no105_character.g` | Exact geometric characters for Nos. 104 and 105 and an explicit Fermat-to-listed-coordinate linear conjugacy. |
| `audit_no105_extensions.jl` | Read-only consistency audit of the saved result and inputs. |
| `audit_no105_recompute.jl` | Independently recompute roots, discriminant-kernel orders, and the projective group ID for the retained action. |
| `process.md` | Chronological run record, including corrected startup and serialization attempts. |

The six `no105_extensions_action_*.mrdi` files are per-action checkpoints.
The retained `no105_audit_recompute.log` records the independent
recomputation; the earlier run logs and status files are not included here.
Earlier `verify_no105_character.g` checks the Fermat presentation alone; the joint
No. 104/105 certificate above is the one used for numbered identification.

The selected output is T-action 1, primitive extension 1. It has group
`[24,13]`, quotient index 6, and ranks `(S,T,P,K,Lambda0)=(12,10,6,16,22)`.
The complete counts and their interpretation are in
[no105_result.md](no105_result.md). Its MRDI result is also incorporated in
the current [156-row ambient catalogue](../ambient_completion/README.md).
