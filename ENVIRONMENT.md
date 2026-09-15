# Computational environments

Reading the saved data does not require repeating a calculation. To run a
script, use the working directory and prerequisites given in its module
README.

## GAP on Windows

The final representation enumeration and the group, coordinate, liftability,
and containment checks use GAP 4.15.1. The enumeration also uses `smallgrp`
1.5.4 and `cohomolo` 1.6.12, with the SmallGroups data needed for the recorded
orders. Most later checks do not require `cohomolo`.

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

## Python

The launch and consistency utilities use the Python standard library. They do
not make mathematical embedding or smoothness decisions. The exact coordinate
inputs needed for the saved checks are included in the GAP modules; no TeX
source file is needed to read or verify them.

The complete [basis and dimension check](gap_classification/gap_manuscript_validation/gap_display_basis_audit.g)
uses GAP rather than Singular and does not enumerate groups or search for
embeddings. Final combined result files are generated mechanically by
`gap_classification/export_results.g` from the saved module results.

The lattice classification uses a separate Julia/OSCAR calculation in
[`oscar/`](oscar/README.md). Its environment is not needed for the GAP checks.
