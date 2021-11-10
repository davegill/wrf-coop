# wrf-coop

### Purpose

This README provides information on the recipe to add in a new feature
test to the WRF regression testing system. The feature tests tend to be restart-oriented
tests that run for a short time period, and are able to provide bit-wise identical
results upon completion.

Only two files (currently) need to be modified. Once a large number of feature tests are
added, then this README file will be updated.

And possibly, "large number of tests" is defined as about two more. 🙂


### build.csh

The file build.csh needs to
be modified. This script generates the list of all tests that may be conducted. The restart
tests are associated with the string `restartA`. The restart tests are also associated with
the second column of the shell variable arrays (such as SERIAL, OPENMP, ... NP, FEATURE), but until
we add LOTS of new feature tests, we make no changes in that area of the file.

The _two_ lines that have _multiple_ entries for `restartA` should be modified. For example, let us
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

### cases/adapt

The second change is in a separate repository. 
https://github.com/davegill/wrf_feature_testing.
The `cases` directory has the name of each of the required feature tests. 

A new directory is added, with three files. The directory name, in this instance,
would be `cases/adapt`. The files added to this new directory are 
`namelist.input.1`, `namelist.input.2`, and
`namelist.input.3`. By convention, for the feature restart cases, 
the first namelist is to run real, the 
second is to run WRF (full run), and the third namelist is for the restart WRF
run. Typically, having a nest with 12 fine-grid time steps (for the full run) is
sufficient to check that restarts work.

