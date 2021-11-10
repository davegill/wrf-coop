# wrf-coop

The purpose of the README is to provide information on add in a new feature
test to the WRF regression testing system. The feature tests tend to be restart-oriented
tests that run for a short time period, and are able to provide bit-wise identical
results upon completion.


1. The file build.csh needs to
be modified. This script generates the list of all tests that may be conducted. The restart
tests are associated with the string `restartA` and the second column of the shell variable
arrays (such as SERIAL, OPENMP, ... NP, FEATURE).

The two lines that have _multiple_ entries for `restartA` should be modified. For example, let us
assume that the new test is for adaptive time stepping, with the mnemonic `adapt`.

Original:
```
"restartA       basic dfi " \
```

New:
```
"restartA       basic dfi adapt " \
```
No other changes are required in the build.csh file.

2. The second change is in a separate repository. 
https://github.com/davegill/wrf_feature_testing
The `cases` directory has the name of each of the required feature test. 
A new directory is added, with three files. The directory name, in this instance,
would be `adapt`. The added files are `namelist.input.1`, `namelist.input.2`, and
`namelist.input.3`. For a restart case, the first namelist is to run real, the 
second is to run WRF (full run), and the third namelist is for the restart WRF
run. Typically, having a nest with 12 fine-grid time steps (for the full run) is
sufficient to check that restarts work.

