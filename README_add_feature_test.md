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

### How to activate the `Feature` feature

Temporarily, this is an option that is not run by default. To activate this ability
to run the restart tests, the labels need to be modified on the PR.
1. The label `Feature` has to be included.
2. The only label permitted is `Feature`.

You are thinking, hmmm, this restriction seems a bit problematic. But no, we are mostly testing on
https://github.com/wrf-model/WRF/pull/1569. It is a test PR, and only has a single label: `Feature`.

### Well, did the `Feature` feature work?

The standard file that is returned from jenkins looks like:
```
Please find result of the WRF regression test cases in the attachment. This build is for Commit ID: 8a00cd403a9a3f30cc1028fc88d6b7dcf22355ab, requested by: davegill for PR: https://github.com/wrf-model/WRF/pull/1580. For any query please send e-mail to David Gill.

    Test Type              | Expected  | Received |  Failed
    = = = = = = = = = = = = = = = = = = = = = = = =  = = = =
    Number of Tests        : 19           17
    Number of Builds       : 48           45
    Number of Simulations  : 160           155        0
    Number of Comparisons  : 101           100        0

    Failed Simulations are: 
    None
    Which comparisons are not bit-for-bit: 
    None
```
The restart test output is a bit different:
```
Please find result of the WRF regression test cases in the attachment. This build is for Commit ID: 7972b89949c71013b5d95571244f5ce3c1c9f571, requested by: davegill for PR: https://github.com/scala-computing/WRF/pull/1569. For any query please send e-mail to David Gill.

    Test Type              | Expected  | Received |  Failed
    = = = = = = = = = = = = = = = = = = = = = = = =  = = = =
    Number of Tests        : 23           23
    Number of Builds       : 60           58
    Number of Simulations  : 159           129        0
    Number of Comparisons  : 101           0        0

    Failed Simulations are: 
    None
    Which comparisons are not bit-for-bit: 
    None
```
Importantly, the attached file in the email can be unzipped. The file `output_testcase/output_2` has the 
standard printout from the triple real-WRF-WRF_restart.

### General info

```
RUN WRF test_002m for em_real 34 restartA, NML = basic
 
Restart test validation completed for /wrf/cases/basic
Started at Sat Nov 6 23:54:59 UTC 2021
Ended at Sat Nov 6 23:58:16 UTC 2021
 
0 = STATUS test_002m em em_real 34 basic
Sat Nov  6 23:58:16 UTC 2021
```

### Output from Real
PRE-PROC OUTPUT
```
taskid: 0 hostname: 91a4c311fcdc
 Ntasks in X            1 , ntasks in Y            1
*************************************
Configuring physics suite 'conus'

         mp_physics:      8      8
         cu_physics:      6      6
      ra_lw_physics:      4      4
      ra_sw_physics:      4      4
     bl_pbl_physics:      2      2
  sf_sfclay_physics:      2      2
 sf_surface_physics:      2      2
*************************************
  Domain # 1: dx = 30000.000 m
  Domain # 2: dx = 10000.000 m
REAL_EM V4.3 PREPROCESSOR
git commit 7972b89949c71013b5d95571244f5ce3c1c9f571
 *************************************
 Parent domain
 ids,ide,jds,jde            1          75           1          70
 ims,ime,jms,jme           -4          80          -4          75
 ips,ipe,jps,jpe            1          75           1          70
 *************************************
DYNAMICS OPTION: Eulerian Mass Coordinate
   alloc_space_field: domain            1 ,             265507156  bytes allocated
Time period #   1 to process = 2016-03-23_00:00:00.
Time period #   2 to process = 2016-03-23_03:00:00.
Total analysis times to input =    2.
  
 -----------------------------------------------------------------------------
  
 Domain  1: Current date being processed: 2016-03-23_00:00:00.0000, which is loop #   1 out of    2
 configflags%julyr, %julday, %gmt:        2016          83   0.00000000    
d01 2016-03-23_00:00:00  Yes, this special data is acceptable to use: OUTPUT FROM METGRID V4.2
d01 2016-03-23_00:00:00  Input data is acceptable to use: met_em.d01.2016-03-23_00:00:00.nc
 metgrid input_wrf.F first_date_input = 2016-03-23_00:00:00
 metgrid input_wrf.F first_date_nml = 2016-03-23_00:00:00
d01 2016-03-23_00:00:00 Timing for input          0 s.
d01 2016-03-23_00:00:00          flag_soil_layers read from met_em file is  1
d01 2016-03-23_00:00:00 Turning off use of MAX WIND level data in vertical interpolation
d01 2016-03-23_00:00:00 Turning off use of TROPOPAUSE level data in vertical interpolation
Max map factor in domain 1 =  1.00. Scale the dt in the model accordingly.
Using sfcprs3 to compute psfc
 using new automatic levels program
           1   50.0000000       50.0000000      0.993814707    
           2   64.0000000       114.000000      0.985950649       1.27999997    
           3   81.5615997       195.561600      0.976014256       1.27440000    
           4   103.369164       298.930756      0.963557541       1.26737535    
           5   130.105835       429.036591      0.948093116       1.25865233    
           6   162.366577       591.403198      0.929123759       1.24795771    
           7   200.531372       791.934570      0.906191230       1.23505330    
           8   244.605652       1036.54028      0.878942370       1.21978748    
           9   294.054565       1330.59485      0.847207963       1.20215774    
          10   347.683685       1678.27856      0.811077714       1.18237817    
          11   403.635223       2081.91382      0.770949006       1.16092658    
          12   459.557220       2541.47095      0.727525413       1.13854587    
          13   512.947266       3054.41821      0.681755364       1.11617708    
          14   564.242004       3618.66016      0.634503603       1.10000002    
          15   620.666199       4239.32617      0.586030483       1.10000002    
          16   682.732849       4922.05908      0.536650121       1.10000002    
   25416.3906       4922.05908              44          16
          17   731.940430       5653.99951      0.487943381    
          18   731.940430       6385.93994      0.443262488    
          19   731.940430       7117.88037      0.402274668    
          20   731.940430       7849.82080      0.364674717    
          21   731.940430       8581.76172      0.330182433    
          22   731.940430       9313.70215      0.298541158    
          23   731.940430       10045.6426      0.269515216    
          24   731.940430       10777.5830      0.242888346    
          25   731.940430       11509.5234      0.218462333    
          26   731.940430       12241.4639      0.196055204    
          27   731.940430       12973.4043      0.175500140    
          28   731.940430       13705.3447      0.156644031    
          29   731.940430       14437.2852      0.139346510    
          30   731.940430       15169.2256      0.123478681    
          31   731.940430       15901.1660      0.108922392    
          32   731.940430       16633.1055       9.55692530E-02
          33   731.940430       17365.0469       8.33197907E-02
          34   731.940430       18096.9883       7.20827952E-02
          35   731.940430       18828.9297       6.17745891E-02
          36   731.940430       19560.8711       5.23184016E-02
          37   731.940430       20292.8125       4.36438024E-02
          38   731.940430       21024.7539       3.56862135E-02
          39   731.940430       21756.6953       2.83863544E-02
          40   731.940430       22488.6367       2.16898583E-02
          41   731.940430       23220.5781       1.55468490E-02
          42   731.940430       23952.5195       9.91160050E-03
          43   731.940430       24684.4609       4.74211574E-03
          44   731.940430       25416.4023      -7.70970416E-08
    1.0000    0.9938    0.9860    0.9760    0.9636    0.9481    0.9291    0.9062    0.8789    0.8472
    0.8111    0.7709    0.7275    0.6818    0.6345    0.5860    0.5367    0.4879    0.4433    0.4023
    0.3647    0.3302    0.2985    0.2695    0.2429    0.2185    0.1961    0.1755    0.1566    0.1393
    0.1235    0.1089    0.0956    0.0833    0.0721    0.0618    0.0523    0.0436    0.0357    0.0284
    0.0217    0.0155    0.0099    0.0047    0.0000
Full level index =    1     Height =     0.0 m
Full level index =    2     Height =    50.0 m      Thickness =   50.0 m
Full level index =    3     Height =   113.9 m      Thickness =   63.9 m
Full level index =    4     Height =   195.2 m      Thickness =   81.3 m
Full level index =    5     Height =   298.0 m      Thickness =  102.8 m
Full level index =    6     Height =   427.2 m      Thickness =  129.1 m
Full level index =    7     Height =   587.8 m      Thickness =  160.7 m
Full level index =    8     Height =   785.5 m      Thickness =  197.7 m
Full level index =    9     Height =  1025.6 m      Thickness =  240.0 m
Full level index =   10     Height =  1312.6 m      Thickness =  287.0 m
Full level index =   11     Height =  1649.6 m      Thickness =  337.0 m
Full level index =   12     Height =  2037.7 m      Thickness =  388.2 m
Full level index =   13     Height =  2475.6 m      Thickness =  437.9 m
Full level index =   14     Height =  2959.3 m      Thickness =  483.7 m
Full level index =   15     Height =  3485.1 m      Thickness =  525.8 m
Full level index =   16     Height =  4056.1 m      Thickness =  570.9 m
Full level index =   17     Height =  4675.0 m      Thickness =  618.9 m
Full level index =   18     Height =  5328.0 m      Thickness =  653.0 m
Full level index =   19     Height =  5970.1 m      Thickness =  642.1 m
Full level index =   20     Height =  6601.4 m      Thickness =  631.2 m
Full level index =   21     Height =  7221.7 m      Thickness =  620.4 m
Full level index =   22     Height =  7831.2 m      Thickness =  609.5 m
Full level index =   23     Height =  8429.8 m      Thickness =  598.6 m
Full level index =   24     Height =  9017.5 m      Thickness =  587.7 m
Full level index =   25     Height =  9594.3 m      Thickness =  576.8 m
Full level index =   26     Height = 10160.3 m      Thickness =  566.0 m
Full level index =   27     Height = 10715.4 m      Thickness =  555.1 m
Full level index =   28     Height = 11259.6 m      Thickness =  544.2 m
Full level index =   29     Height = 11792.9 m      Thickness =  533.3 m
Full level index =   30     Height = 12315.3 m      Thickness =  522.4 m
Full level index =   31     Height = 12826.9 m      Thickness =  511.6 m
Full level index =   32     Height = 13331.3 m      Thickness =  504.5 m
Full level index =   33     Height = 13835.8 m      Thickness =  504.5 m
Full level index =   34     Height = 14340.3 m      Thickness =  504.5 m
Full level index =   35     Height = 14844.8 m      Thickness =  504.5 m
Full level index =   36     Height = 15349.2 m      Thickness =  504.5 m
Full level index =   37     Height = 15853.7 m      Thickness =  504.5 m
Full level index =   38     Height = 16358.2 m      Thickness =  504.5 m
Full level index =   39     Height = 16862.7 m      Thickness =  504.5 m
Full level index =   40     Height = 17367.1 m      Thickness =  504.5 m
Full level index =   41     Height = 17871.6 m      Thickness =  504.5 m
Full level index =   42     Height = 18376.1 m      Thickness =  504.5 m
Full level index =   43     Height = 18880.5 m      Thickness =  504.5 m
Full level index =   44     Height = 19385.0 m      Thickness =  504.5 m
Full level index =   45     Height = 19889.5 m      Thickness =  504.5 m
d01 2016-03-23_00:00:00 No average surface temperature for use with inland lakes
 Assume Noah LSM input
 LAND  CHANGE =            0
 WATER CHANGE =            0
d01 2016-03-23_00:00:00 Total post number of sea ice location changes (water to land) =      1
d01 2016-03-23_00:00:00 Timing for processing          1 s.
d01 2016-03-23_00:00:00 Timing for output          0 s.
d01 2016-03-23_00:00:00 Timing for loop #    1 =          1 s.
  
 -----------------------------------------------------------------------------
  
 Domain  1: Current date being processed: 2016-03-23_03:00:00.0000, which is loop #   2 out of    2
 configflags%julyr, %julday, %gmt:        2016          83   3.00000000    
d01 2016-03-23_03:00:00  Yes, this special data is acceptable to use: OUTPUT FROM METGRID V4.2
d01 2016-03-23_03:00:00  Input data is acceptable to use: met_em.d01.2016-03-23_03:00:00.nc
 metgrid input_wrf.F first_date_input = 2016-03-23_03:00:00
 metgrid input_wrf.F first_date_nml = 2016-03-23_00:00:00
d01 2016-03-23_03:00:00 Timing for input          0 s.
d01 2016-03-23_03:00:00          flag_soil_layers read from met_em file is  1
d01 2016-03-23_03:00:00 Turning off use of MAX WIND level data in vertical interpolation
d01 2016-03-23_03:00:00 Turning off use of TROPOPAUSE level data in vertical interpolation
Using sfcprs3 to compute psfc
d01 2016-03-23_03:00:00 No average surface temperature for use with inland lakes
 Assume Noah LSM input
 LAND  CHANGE =            0
 WATER CHANGE =            0
d01 2016-03-23_03:00:00 Total post number of sea ice location changes (water to land) =      1
d01 2016-03-23_03:00:00 Timing for processing          0 s.
 LBC valid between these times 2016-03-23_00:00:00 and 2016-03-23_03:00:00
d01 2016-03-23_03:00:00 Timing for output          0 s.
d01 2016-03-23_03:00:00 Timing for loop #    2 =          1 s.
 *************************************
 Nesting domain
 ids,ide,jds,jde            1          88           1          79
 ims,ime,jms,jme           -4          93          -4          84
 ips,ipe,jps,jpe            1          88           1          79
 INTERMEDIATE domain
 ids,ide,jds,jde           23          57          20          51
 ims,ime,jms,jme           18          62          15          56
 ips,ipe,jps,jpe           21          59          18          53
 *************************************
d01 2016-03-23_03:00:00  alloc_space_field: domain            2 ,              23670360  bytes allocated
d01 2016-03-23_03:00:00  alloc_space_field: domain            2 ,             338810508  bytes allocated
Time period #   1 to process = 2016-03-23_00:00:00.
Time period #   2 to process = 2016-03-23_03:00:00.
Total analysis times to input =    2.
  
 -----------------------------------------------------------------------------
  
 Domain  2: Current date being processed: 2016-03-23_00:00:00.0000, which is loop #   1 out of    2
 configflags%julyr, %julday, %gmt:        2016          83   0.00000000    
d02 2016-03-23_00:00:00  Yes, this special data is acceptable to use: OUTPUT FROM METGRID V4.2
d02 2016-03-23_00:00:00  Input data is acceptable to use: met_em.d02.2016-03-23_00:00:00.nc
 metgrid input_wrf.F first_date_input = 2016-03-23_00:00:00
 metgrid input_wrf.F first_date_nml = 2016-03-23_00:00:00
d02 2016-03-23_00:00:00 Timing for input          0 s.
d02 2016-03-23_00:00:00          flag_soil_layers read from met_em file is  1
d02 2016-03-23_00:00:00 Turning off use of MAX WIND level data in vertical interpolation
d02 2016-03-23_00:00:00 Turning off use of TROPOPAUSE level data in vertical interpolation
Using sfcprs3 to compute psfc
 using new automatic levels program
           1   50.0000000       50.0000000      0.993814707    
           2   64.0000000       114.000000      0.985950649       1.27999997    
           3   81.5615997       195.561600      0.976014256       1.27440000    
           4   103.369164       298.930756      0.963557541       1.26737535    
           5   130.105835       429.036591      0.948093116       1.25865233    
           6   162.366577       591.403198      0.929123759       1.24795771    
           7   200.531372       791.934570      0.906191230       1.23505330    
           8   244.605652       1036.54028      0.878942370       1.21978748    
           9   294.054565       1330.59485      0.847207963       1.20215774    
          10   347.683685       1678.27856      0.811077714       1.18237817    
          11   403.635223       2081.91382      0.770949006       1.16092658    
          12   459.557220       2541.47095      0.727525413       1.13854587    
          13   512.947266       3054.41821      0.681755364       1.11617708    
          14   564.242004       3618.66016      0.634503603       1.10000002    
          15   620.666199       4239.32617      0.586030483       1.10000002    
          16   682.732849       4922.05908      0.536650121       1.10000002    
   25416.3906       4922.05908              44          16
          17   731.940430       5653.99951      0.487943381    
          18   731.940430       6385.93994      0.443262488    
          19   731.940430       7117.88037      0.402274668    
          20   731.940430       7849.82080      0.364674717    
          21   731.940430       8581.76172      0.330182433    
          22   731.940430       9313.70215      0.298541158    
          23   731.940430       10045.6426      0.269515216    
          24   731.940430       10777.5830      0.242888346    
          25   731.940430       11509.5234      0.218462333    
          26   731.940430       12241.4639      0.196055204    
          27   731.940430       12973.4043      0.175500140    
          28   731.940430       13705.3447      0.156644031    
          29   731.940430       14437.2852      0.139346510    
          30   731.940430       15169.2256      0.123478681    
          31   731.940430       15901.1660      0.108922392    
          32   731.940430       16633.1055       9.55692530E-02
          33   731.940430       17365.0469       8.33197907E-02
          34   731.940430       18096.9883       7.20827952E-02
          35   731.940430       18828.9297       6.17745891E-02
          36   731.940430       19560.8711       5.23184016E-02
          37   731.940430       20292.8125       4.36438024E-02
          38   731.940430       21024.7539       3.56862135E-02
          39   731.940430       21756.6953       2.83863544E-02
          40   731.940430       22488.6367       2.16898583E-02
          41   731.940430       23220.5781       1.55468490E-02
          42   731.940430       23952.5195       9.91160050E-03
          43   731.940430       24684.4609       4.74211574E-03
          44   731.940430       25416.4023      -7.70970416E-08
    1.0000    0.9938    0.9860    0.9760    0.9636    0.9481    0.9291    0.9062    0.8789    0.8472
    0.8111    0.7709    0.7275    0.6818    0.6345    0.5860    0.5367    0.4879    0.4433    0.4023
    0.3647    0.3302    0.2985    0.2695    0.2429    0.2185    0.1961    0.1755    0.1566    0.1393
    0.1235    0.1089    0.0956    0.0833    0.0721    0.0618    0.0523    0.0436    0.0357    0.0284
    0.0217    0.0155    0.0099    0.0047    0.0000
Full level index =    1     Height =     0.0 m
Full level index =    2     Height =    50.0 m      Thickness =   50.0 m
Full level index =    3     Height =   113.9 m      Thickness =   63.9 m
Full level index =    4     Height =   195.2 m      Thickness =   81.3 m
Full level index =    5     Height =   298.0 m      Thickness =  102.8 m
Full level index =    6     Height =   427.2 m      Thickness =  129.1 m
Full level index =    7     Height =   587.8 m      Thickness =  160.7 m
Full level index =    8     Height =   785.5 m      Thickness =  197.7 m
Full level index =    9     Height =  1025.6 m      Thickness =  240.0 m
Full level index =   10     Height =  1312.6 m      Thickness =  287.0 m
Full level index =   11     Height =  1649.6 m      Thickness =  337.0 m
Full level index =   12     Height =  2037.7 m      Thickness =  388.2 m
Full level index =   13     Height =  2475.6 m      Thickness =  437.9 m
Full level index =   14     Height =  2959.3 m      Thickness =  483.7 m
Full level index =   15     Height =  3485.1 m      Thickness =  525.8 m
Full level index =   16     Height =  4056.1 m      Thickness =  570.9 m
Full level index =   17     Height =  4675.0 m      Thickness =  618.9 m
Full level index =   18     Height =  5328.0 m      Thickness =  653.0 m
Full level index =   19     Height =  5970.1 m      Thickness =  642.1 m
Full level index =   20     Height =  6601.4 m      Thickness =  631.2 m
Full level index =   21     Height =  7221.7 m      Thickness =  620.4 m
Full level index =   22     Height =  7831.2 m      Thickness =  609.5 m
Full level index =   23     Height =  8429.8 m      Thickness =  598.6 m
Full level index =   24     Height =  9017.5 m      Thickness =  587.7 m
Full level index =   25     Height =  9594.3 m      Thickness =  576.8 m
Full level index =   26     Height = 10160.3 m      Thickness =  566.0 m
Full level index =   27     Height = 10715.4 m      Thickness =  555.1 m
Full level index =   28     Height = 11259.6 m      Thickness =  544.2 m
Full level index =   29     Height = 11792.9 m      Thickness =  533.3 m
Full level index =   30     Height = 12315.3 m      Thickness =  522.4 m
Full level index =   31     Height = 12826.9 m      Thickness =  511.6 m
Full level index =   32     Height = 13331.3 m      Thickness =  504.5 m
Full level index =   33     Height = 13835.8 m      Thickness =  504.5 m
Full level index =   34     Height = 14340.3 m      Thickness =  504.5 m
Full level index =   35     Height = 14844.8 m      Thickness =  504.5 m
Full level index =   36     Height = 15349.2 m      Thickness =  504.5 m
Full level index =   37     Height = 15853.7 m      Thickness =  504.5 m
Full level index =   38     Height = 16358.2 m      Thickness =  504.5 m
Full level index =   39     Height = 16862.7 m      Thickness =  504.5 m
Full level index =   40     Height = 17367.1 m      Thickness =  504.5 m
Full level index =   41     Height = 17871.6 m      Thickness =  504.5 m
Full level index =   42     Height = 18376.1 m      Thickness =  504.5 m
Full level index =   43     Height = 18880.5 m      Thickness =  504.5 m
Full level index =   44     Height = 19385.0 m      Thickness =  504.5 m
Full level index =   45     Height = 19889.5 m      Thickness =  504.5 m
d02 2016-03-23_00:00:00 No average surface temperature for use with inland lakes
 Assume Noah LSM input
 LAND  CHANGE =            0
 WATER CHANGE =            0
d02 2016-03-23_00:00:00 Timing for processing          1 s.
d02 2016-03-23_00:00:00 Timing for output          0 s.
d02 2016-03-23_00:00:00 Timing for loop #    1 =          1 s.
d01 2016-03-23_03:00:00 real_em: SUCCESS COMPLETE REAL_EM INIT
```
### Output from the full-length WRF run
MODEL OUTPUT STEP 1
```
taskid: 0 hostname: 91a4c311fcdc
Quilting with   1 groups of   0 I/O tasks.
 Ntasks in X            2 , ntasks in Y            4
*************************************
Configuring physics suite 'conus'

         mp_physics:      8      8
         cu_physics:      6      6
      ra_lw_physics:      4      4
      ra_sw_physics:      4      4
     bl_pbl_physics:      2      2
  sf_sfclay_physics:      2      2
 sf_surface_physics:      2      2
*************************************
  Domain # 1: dx = 30000.000 m
  Domain # 2: dx = 10000.000 m
WRF V4.3 MODEL
git commit 7972b89949c71013b5d95571244f5ce3c1c9f571
 *************************************
 Parent domain
 ids,ide,jds,jde            1          75           1          70
 ims,ime,jms,jme           -4          44          -4          25
 ips,ipe,jps,jpe            1          37           1          18
 *************************************
DYNAMICS OPTION: Eulerian Mass Coordinate
   alloc_space_field: domain            1 ,              50590676  bytes allocated
  med_initialdata_input: calling input_input
   Input data is acceptable to use: wrfinput_d01
 CURRENT DATE          = 2016-03-23_00:00:00
 SIMULATION START DATE = 2016-03-23_00:00:00
Timing for processing wrfinput file (stream 0) for domain        1:    0.52529 elapsed seconds
Max map factor in domain 1 =  1.00. Scale the dt in the model accordingly.
 D01: Time step                              =    180.000000      (s)
 D01: Grid Distance                          =    30.0000000      (km)
 D01: Grid Distance Ratio dt/dx              =    6.00000000      (s/km)
 D01: Ratio Including Maximum Map Factor     =    6.02711725      (s/km)
 D01: NML defined reasonable_time_step_ratio =    6.00000000
INPUT LandUse = "MODIFIED_IGBP_MODIS_NOAH"
 LANDUSE TYPE = "MODIFIED_IGBP_MODIS_NOAH" FOUND          41  CATEGORIES           2  SEASONS WATER CATEGORY =           17  SNOW CATEGORY =           15
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
ThompMP: read qr_acr_qgV3.dat instead of computing
ThompMP: read qr_acr_qsV2.dat instead of computing
ThompMP: read freezeH2O.dat instead of computing
 *************************************
 Nesting domain
 ids,ide,jds,jde            1          88           1          79
 ims,ime,jms,jme           -4          54          -4          30
 ips,ipe,jps,jpe            1          44           1          20
 INTERMEDIATE domain
 ids,ide,jds,jde           23          57          20          51
 ims,ime,jms,jme           18          49          15          38
 ips,ipe,jps,jpe           21          39          18          28
 *************************************
d01 2016-03-23_00:00:00  alloc_space_field: domain            2 ,               9618432  bytes allocated
d01 2016-03-23_00:00:00  alloc_space_field: domain            2 ,              69759156  bytes allocated
d01 2016-03-23_00:00:00 *** Initializing nest domain # 2 from an input file. ***
d01 2016-03-23_00:00:00 med_initialdata_input: calling input_input
d01 2016-03-23_00:00:00  Input data is acceptable to use: wrfinput_d02
Timing for processing wrfinput file (stream 0) for domain        2:    0.97790 elapsed seconds
INPUT LandUse = "MODIFIED_IGBP_MODIS_NOAH"
 LANDUSE TYPE = "MODIFIED_IGBP_MODIS_NOAH" FOUND          41  CATEGORIES           2  SEASONS WATER CATEGORY =           17  SNOW CATEGORY =           15
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
INPUT LandUse = "MODIFIED_IGBP_MODIS_NOAH"
 LANDUSE TYPE = "MODIFIED_IGBP_MODIS_NOAH" FOUND          41  CATEGORIES           2  SEASONS WATER CATEGORY =           17  SNOW CATEGORY =           15
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
Max map factor in domain 1 =  1.00. Scale the dt in the model accordingly.
 D01: Time step                              =    180.000000      (s)
 D01: Grid Distance                          =    30.0000000      (km)
 D01: Grid Distance Ratio dt/dx              =    6.00000000      (s/km)
 D01: Ratio Including Maximum Map Factor     =    6.02711725      (s/km)
 D01: NML defined reasonable_time_step_ratio =    6.00000000
INPUT LandUse = "MODIFIED_IGBP_MODIS_NOAH"
 LANDUSE TYPE = "MODIFIED_IGBP_MODIS_NOAH" FOUND          41  CATEGORIES           2  SEASONS WATER CATEGORY =           17  SNOW CATEGORY =           15
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
Timing for Writing wrfout_d01_2016-03-23_00:00:00 for domain        1:    1.07135 elapsed seconds
d01 2016-03-23_00:00:00  Input data is acceptable to use: wrfbdy_d01
Timing for processing lateral boundary for domain        1:    1.04559 elapsed seconds
 Tile Strategy is not specified. Assuming 1D-Y
WRF TILE   1 IS      1 IE     37 JS      1 JE     18
WRF NUMBER OF TILES =   1
d01 2016-03-23_00:00:00  ----------------------------------------
d01 2016-03-23_00:00:00  W-DAMPING  BEGINS AT W-COURANT NUMBER =    1.00000000
d01 2016-03-23_00:00:00  ----------------------------------------
Timing for Writing wrfout_d02_2016-03-23_00:00:00 for domain        2:    1.99882 elapsed seconds
 Tile Strategy is not specified. Assuming 1D-Y
WRF TILE   1 IS      1 IE     44 JS      1 JE     20
WRF NUMBER OF TILES =   1
Timing for main: time 2016-03-23_00:01:00 on domain   2:   17.00772 elapsed seconds
Timing for main: time 2016-03-23_00:02:00 on domain   2:    2.12480 elapsed seconds
Timing for main: time 2016-03-23_00:03:00 on domain   2:    2.15391 elapsed seconds
Timing for main: time 2016-03-23_00:03:00 on domain   1:   44.81574 elapsed seconds
Timing for Writing wrfout_d01_2016-03-23_00:03:00 for domain        1:    1.79854 elapsed seconds
Timing for Writing wrfout_d02_2016-03-23_00:03:00 for domain        2:    2.01203 elapsed seconds
Timing for main: time 2016-03-23_00:04:00 on domain   2:    4.17007 elapsed seconds
Timing for main: time 2016-03-23_00:05:00 on domain   2:    2.26399 elapsed seconds
Timing for main: time 2016-03-23_00:06:00 on domain   2:    2.17902 elapsed seconds
Timing for main: time 2016-03-23_00:06:00 on domain   1:   13.91001 elapsed seconds
Timing for Writing wrfout_d01_2016-03-23_00:06:00 for domain        1:    1.80339 elapsed seconds
Timing for Writing wrfout_d02_2016-03-23_00:06:00 for domain        2:    2.03229 elapsed seconds
Timing for main: time 2016-03-23_00:07:00 on domain   2:    4.20616 elapsed seconds
Timing for main: time 2016-03-23_00:08:00 on domain   2:    2.19110 elapsed seconds
Timing for main: time 2016-03-23_00:09:00 on domain   2:    2.18091 elapsed seconds
Timing for main: time 2016-03-23_00:09:00 on domain   1:   13.83345 elapsed seconds
Timing for Writing wrfout_d01_2016-03-23_00:09:00 for domain        1:    1.80112 elapsed seconds
Timing for Writing restart for domain        1:    7.19699 elapsed seconds
Timing for Writing restart for domain        2:    8.03307 elapsed seconds
Timing for Writing wrfout_d02_2016-03-23_00:09:00 for domain        2:    1.99772 elapsed seconds
Timing for main: time 2016-03-23_00:10:00 on domain   2:    4.28678 elapsed seconds
Timing for main: time 2016-03-23_00:11:00 on domain   2:    2.17617 elapsed seconds
Timing for main: time 2016-03-23_00:12:00 on domain   2:    2.19362 elapsed seconds
Timing for Writing wrfout_d02_2016-03-23_00:12:00 for domain        2:    2.00237 elapsed seconds
Timing for main: time 2016-03-23_00:12:00 on domain   1:   31.35550 elapsed seconds
Timing for Writing wrfout_d01_2016-03-23_00:12:00 for domain        1:    1.81641 elapsed seconds
d01 2016-03-23_00:12:00 wrf: SUCCESS COMPLETE WRF
```
### Output from the WRF restart run
MODEL OUTPUT STEP 2
```
taskid: 0 hostname: 91a4c311fcdc
Quilting with   1 groups of   0 I/O tasks.
 Ntasks in X            2 , ntasks in Y            4
*************************************
Configuring physics suite 'conus'

         mp_physics:      8      8
         cu_physics:      6      6
      ra_lw_physics:      4      4
      ra_sw_physics:      4      4
     bl_pbl_physics:      2      2
  sf_sfclay_physics:      2      2
 sf_surface_physics:      2      2
*************************************
  Domain # 1: dx = 30000.000 m
  Domain # 2: dx = 10000.000 m
WRF V4.3 MODEL
git commit 7972b89949c71013b5d95571244f5ce3c1c9f571
 *************************************
 Parent domain
 ids,ide,jds,jde            1          75           1          70
 ims,ime,jms,jme           -4          44          -4          25
 ips,ipe,jps,jpe            1          37           1          18
 *************************************
DYNAMICS OPTION: Eulerian Mass Coordinate
   alloc_space_field: domain            1 ,              50590676  bytes allocated
 RESTART run: opening wrfrst_d01_2016-03-23_00:09:00 for reading
   Input data is acceptable to use: wrfrst_d01_2016-03-23_00:09:00
Timing for processing restart file for domain        1:    2.25749 elapsed seconds
Max map factor in domain 1 =  1.00. Scale the dt in the model accordingly.
 D01: Time step                              =    180.000000      (s)
 D01: Grid Distance                          =    30.0000000      (km)
 D01: Grid Distance Ratio dt/dx              =    6.00000000      (s/km)
 D01: Ratio Including Maximum Map Factor     =    6.02711725      (s/km)
 D01: NML defined reasonable_time_step_ratio =    6.00000000
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
ThompMP: read qr_acr_qgV3.dat instead of computing
ThompMP: read qr_acr_qsV2.dat instead of computing
ThompMP: read freezeH2O.dat instead of computing
 *************************************
 Nesting domain
 ids,ide,jds,jde            1          88           1          79
 ims,ime,jms,jme           -4          54          -4          30
 ips,ipe,jps,jpe            1          44           1          20
 INTERMEDIATE domain
 ids,ide,jds,jde           23          57          20          51
 ims,ime,jms,jme           18          49          15          38
 ips,ipe,jps,jpe           21          39          18          28
 *************************************
d01 2016-03-23_00:09:00  alloc_space_field: domain            2 ,               9618432  bytes allocated
d01 2016-03-23_00:09:00  alloc_space_field: domain            2 ,              69759156  bytes allocated
 RESTART: nest, opening wrfrst_d02_2016-03-23_00:09:00 for reading
d01 2016-03-23_00:09:00  Input data is acceptable to use: wrfrst_d02_2016-03-23_00:09:00
Timing for processing restart file for domain        2:    2.68952 elapsed seconds
INITIALIZE THREE Noah LSM RELATED TABLES
Skipping over LUTYPE = USGS
 LANDUSE TYPE = MODIFIED_IGBP_MODIS_NOAH FOUND          20  CATEGORIES
 INPUT SOIL TEXTURE CLASSIFICATION = STAS
 SOIL TEXTURE CLASSIFICATION = STAS FOUND          19  CATEGORIES
Timing for Writing wrfout_d01_2016-03-23_00:09:00 for domain        1:    1.78893 elapsed seconds
d01 2016-03-23_00:09:00  Input data is acceptable to use: wrfbdy_d01
d01 2016-03-23_00:09:00 WRF restart, LBC starts at 2016-03-23_00:00:00 and restart starts at 2016-03-23_00:09:00
 LBC for restart: Starting valid date = 2016-03-23_00:00:00, Ending valid date = 2016-03-23_03:00:00
 LBC for restart: Restart time            = 2016-03-23_00:09:00
 LBC for restart: Found the correct bounding LBC time periods
 LBC for restart: Found the correct bounding LBC time periods for restart time = 2016-03-23_00:09:00
Timing for processing lateral boundary for domain        1:    1.04289 elapsed seconds
 Tile Strategy is not specified. Assuming 1D-Y
WRF TILE   1 IS      1 IE     37 JS      1 JE     18
WRF NUMBER OF TILES =   1
d01 2016-03-23_00:09:00  ----------------------------------------
d01 2016-03-23_00:09:00  W-DAMPING  BEGINS AT W-COURANT NUMBER =    1.00000000
d01 2016-03-23_00:09:00  ----------------------------------------
Timing for Writing wrfout_d02_2016-03-23_00:09:00 for domain        2:    2.00010 elapsed seconds
 Tile Strategy is not specified. Assuming 1D-Y
WRF TILE   1 IS      1 IE     44 JS      1 JE     20
WRF NUMBER OF TILES =   1
Timing for main: time 2016-03-23_00:10:00 on domain   2:    4.25569 elapsed seconds
Timing for main: time 2016-03-23_00:11:00 on domain   2:    2.15497 elapsed seconds
Timing for main: time 2016-03-23_00:12:00 on domain   2:    2.15114 elapsed seconds
Timing for Writing wrfout_d02_2016-03-23_00:12:00 for domain        2:    1.99392 elapsed seconds
Timing for main: time 2016-03-23_00:12:00 on domain   1:   20.17770 elapsed seconds
Timing for Writing wrfout_d01_2016-03-23_00:12:00 for domain        1:    1.79646 elapsed seconds
d01 2016-03-23_00:12:00 wrf: SUCCESS COMPLETE WRF
```
