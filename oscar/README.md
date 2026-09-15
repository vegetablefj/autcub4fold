# OSCAR computations

This directory contains the lattice computations for *Automorphism Groups of
Smooth Cubic Fourfolds through Lattice Theory*.

## Files

| File | Purpose |
| --- | --- |
| [`oscar_script.jl`](oscar_script.jl) | Executable lattice-search functions. |
| [`oscar_script.md`](oscar_script.md) | Mathematical and implementation notes, together with an exact copy of the executable code. |
| [`input.jl`](input.jl) | The 29 executed lattice data and their candidate orders, in the order used throughout this directory. |
| [`oscar_run_search.jl`](oscar_run_search.jl) | Runs the 29 cases in order, saves after each completed case, and resumes a compatible partial run. |
| [`oscar_script_data.mrdi`](oscar_script_data.mrdi) | Complete machine-readable objects retained by the 29-case search. |
| [`oscar_result.md`](oscar_result.md) | Human-readable summary and recorded terminal representations of the search results. |
| [`oscar_auxiliary_equivalence_check.jl`](oscar_auxiliary_equivalence_check.jl) | Rechecks the ambiguous multiplicities for $M_9$ and $A_{3,3}$ from the saved search objects. |
| [`oscar_auxiliary_equivalence_data.mrdi`](oscar_auxiliary_equivalence_data.mrdi) | Machine-readable auxiliary extension classes, comparison data, and conclusions. |
| [`list_S.txt`](list_S.txt) | Numbered reference list of Gram matrices for the symplectic coinvariant lattices; it is not read directly by the scripts. |

There is no separate auxiliary check for $S_{3,3}$. Its two retained outputs
have nonisomorphic full automorphism groups and are distinguished directly in
[`oscar_result.md`](oscar_result.md).

## Running the checks

Use the Julia and OSCAR versions recorded in [`oscar_script.md`](oscar_script.md).
This directory does not supply a Julia `Project.toml` or `Manifest.toml`.
If the tested OSCAR installation is in the default Julia environment, run
the following commands from this directory:

```text
julia oscar_run_search.jl
julia oscar_auxiliary_equivalence_check.jl
```

For a separate existing environment, add `--project=/path/to/environment`
with the actual environment path. Do not assume that `--project=.` selects
the recorded OSCAR installation.

With the saved MRDI files present, the first command validates the completed
main search without repeating it. The second command loads the main search
data, recomputes the fixed-pair auxiliary extensions, saves them in
`oscar_auxiliary_equivalence_data.mrdi`, and reloads that file to verify
serialization. A different data path may be supplied as the first
command-line argument to either script. The auxiliary script also accepts an
alternative output path as its second argument.

## Saved data

`oscar_script_data.mrdi` has format version 3. It records the relative source filenames, the 29 case labels and candidate-order lists, runtimes, and all retained OSCAR lattice objects. `oscar_auxiliary_equivalence_data.mrdi` has format version 1. It records one auxiliary class for $M_9$, two for $A_{3,3}$, the relevant equality and isometry checks, and the traces $(-4,-1)$ that distinguish the two $A_{3,3}$ outputs.

MRDI is OSCAR's native serialization format and should be read in a compatible OSCAR environment. The Markdown files provide stable human-readable summaries; the MRDI files retain the objects needed for computational inspection.

The auxiliary class counts resolve the indicated lattice equivalences.
Passing from the lattice table to geometric families also uses the period
argument, explicit smooth realizations, and the relevant self-conjugacy
checks. These are not consequences of MRDI serialization or class counts
alone. See the [reference guide](../REFERENCES.md#classification-papers).
