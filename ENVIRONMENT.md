# Computational environments

Reading the saved data does not require repeating a calculation. To run a
script, use the working directory and prerequisites given in its module
README.

## GAP on Windows

The small-group nonabelian representation enumeration and most group,
coordinate, liftability, and containment checks use GAP 4.15.1. The
enumeration also uses `smallgrp` 1.5.4 and `cohomolo` 1.6.12, with the
SmallGroups data needed for the recorded orders. Most later checks do not
require `cohomolo`.

The Windows distribution is launched through its bundled login shell so that
its runtime libraries are available. For example, replace the installation
and repository paths in this command with your own:

```powershell
& 'D:/GAP/runtime/bin/bash.exe' -lc 'cd "/cygdrive/c/path/to/repository" && /opt/gap-4.15.1/gap.exe -r -q -b gap_classification/gap_manuscript_validation/gap_display_basis_audit.g'
```

`-r` disables user startup files. The local installation path is not a
dependency of these files. Python launchers that use this environment accept
alternative executable paths; consult their `--help` output.

## GAP with Singular

The saved smoothness calculations use WSL (Ubuntu), GAP 4.12.1, the external
`Singular` executable at `/usr/bin/Singular`, and GNU `timeout` at
`/usr/bin/timeout`. Singular is not a GAP package. The helpers use temporary
files to exchange exact rational or cyclotomic polynomial data and remove
them after the calculation.

The two smoothness outputs record the actual executable paths, versions,
options, and witnesses. Their data may be read by Windows GAP; installing
Singular is unnecessary when only reading results or running group checks.

The separate [large-group representation engines](gap_classification/gap_large_group_enumeration/README.md)
were run with GAP 4.16.0, `cohomolo`, `repsn` for nonliftable branches,
external Singular, and GNU `timeout`. Their saved results do not require
this environment merely to be read.

## Python

The launch and consistency utilities use the Python standard library. They do
not make mathematical embedding or smoothness decisions. The exact coordinate
inputs needed for the saved checks are included in the GAP modules; no TeX
source file is needed to read or verify them.

The complete [basis and dimension check](gap_classification/gap_manuscript_validation/gap_display_basis_audit.g)
uses GAP rather than Singular and does not enumerate groups or search for
embeddings. Final combined result files are generated mechanically by
`gap_classification/export_results.g` from the saved module results.

## Julia and OSCAR

The versions below describe the recorded runs, not a single environment for
the whole repository. No Julia `Project.toml` or `Manifest.toml` is supplied;
to rerun a calculation, use a compatible project and the instructions for
that module. A later OSCAR version is not presumed to reproduce an earlier
run without checking its version-sensitive code.

The original lattice search in [`oscar/`](oscar/README.md) records Julia
1.10.11 and OSCAR 1.7.3; its version-sensitive compatibility wrapper is
described in the [search notes](oscar/oscar_script.md). Later local WSL
results in the [low-rank case guide](remark/low_rank/maximal_cases/README.md)
record Julia 1.10.11 and OSCAR 1.8.2. These are separate saved runs, so use
the version and project environment specified by each script or result.

The imported [Brown low-rank results](remark/low_rank/maximal_cases/brown_results/)
record Julia 1.12.4 and OSCAR 1.8.2. The
[Brown rerun instructions](remark/enumeration/BROWN_RUN.txt) specify the same
versions for their selected high-rank and cyclic cases. Their
[saved results and postchecks](remark/enumeration/results/2026-10-05/README.md)
cover only those cases, not every catalogue row. The [direct-source
assembly guide](remark/catalogue/assembly/README.md) records the
156-row ambient catalogue and its separate full-cohomology algebraic
calculation, run locally with Julia 1.10.11 and OSCAR 1.8.2. The
[earlier source table](remark/catalogue/ambient_completion/sources/family_156_sources_current.md)
gives the separate evidence for each row. None of these OSCAR
environments is needed for the GAP checks above or for reading Markdown
summaries.
