# WRF Docker Containers for Code Contributors

**Contents**
* [Purpose](#Purpose)
* [What is tested](#Tested)
* [Get the WRF docker infrastructure](#Getdocker)
* [Prepare the docker image](#Prepareimage)
* [Contruct the docker containers](#Constrcutcontainers)
* [Build executables from source, run tests](#Buildexec)
    * [Run a sample test case](#Runsample)
    * [Check the simulation results](#Checkresults)
    * [Compare the simulation results](#Compareresults)
    * [Checking WRF Chem results](#WRFChem)
    * [Checking WRF DA results](#WRFDA)
    * [Checking NMM results](#WRFNMM)
* [Docker Clean Up](#Cleanup)
    * [Stop, re-enter, and remove a docker container](#Stop) 
        * [still even deeper](#Stop)
* [Remove a docker image](#RemoveImage)

### Purpose<a name="Purpose"/>

Contributors who intend to propose modifications to the WRF repository have responsibilities beyond their own personal tests that they have previously used to validate the proper functioning of the new feature or option. 

Please see [WRF User's Page for Code Contributors](https://www2.mmm.ucar.edu/wrf/users/contrib_info.php) for the full process for getting code into the WRF repository. 

The primary responsibilities for a contributing developer include:
   * Meeting WRF coding standards
   * Performing code testing
   * Warning the Development Committee of limiting assumptions or possible code conflicts
   * Providing commit information
   * Documentation

Performing code testing for the WRF model can present a challenge to developers. The particular test case (or cases) used during the model development may be appropriate for demonstrating the correct and effective application for the specific purposes of the new option or enhanced feature. However, in many existing uses of the WRF model, the modified code may unintentionally break some other WRF model functionality. 

Code proposed for WRF must be thoroughly tested prior
to submission, and it is the proposing developer’s responsibility to perform
all required positive and negative testing.  The developer must ensure that the proposed change
_does_ work as described, and importantly that the modification _does not_ accidentally impact other parts of the model.  

This page describes how to use docker containers for both the positive tests (activated option must perform as expected) and negative tests (no unintended consequences) of code proposed to WRF. This document provides developers with simple instructions to allow them to more fully vet their code by providing data and configuration files for a wide variety of known working setups. Before issuing a pull request to the WRF github repository, the developer's code modification must demonstrate the continued proper functioning of these existing WRF capabilities.

### What is tested<a name="Tested"/>

The real-data ARW simulations are tested for the 2000 Jan 24-25 1200 UTC case (though typically for only the first half hour of the time period). 

The domain for the ARW real-data simulations is shown in the figure.
![Screen Shot 2020-04-06 at 10 52 27 AM](https://user-images.githubusercontent.com/12666234/78584017-d5263d00-77f4-11ea-89b3-54cdf8357090.png)

Several types of tests are accessible within this docker testing system.

1. Various build options are possible:

|  Build Type        | Precision | 3D/2D | SERIAL | OPENMP | MPI | Ideal/Real | Nested |
| ------------------ |:---------:|:-----:|:------:|:------:|:---:|:----------:|:--:|
|ARW em_real         |  4 and 8  |   3D  |  yes   | yes    | yes |    real    | Y |
|NMM HWRF            |     4     |   3D  |        |        | yes |    real    | Y |
|ARW chemistry       |     4     |   3D  |  yes   |        | yes |    real    | N |
|ARW super cell      |  4 and 8  |   3D  |  yes   | yes    | yes |   ideal    | Y |
|ARW baroclinic wave |     4     |   3D  |  yes   | yes    | yes |   ideal    | Y |
|ARW fire            |     4     |   3D  |  yes   | yes    | yes |   ideal    | N |
|ARW moving nest     |     4     |   3D  |        |        | yes |    real    | Y |
|ARW 2D hill         |     4     |   2D  |  yes   |        |     |   ideal    | N |

2. The testing uses the WRF run-time configuration file, `namelist.input` to exercise an expandable list of features that are all included within the WRF docker container. The current list of tests conducted is produced from information within two githhub respositories:
   * All available namelists choices for em_real: https://github.com/davegill/SCRIPTS/tree/master/Namelists/weekly/em_real/MPI
   * Requested tests: https://github.com/davegill/wrf-coop/blob/master/build.csh

| Test | MP | CU | LW | SW | PBL | SFC | LSM | URB |
| ------|:--:|:--:|:--:|:--:|:--: |:--: |:--: |:--: |
| 3dtke | D | D | D | D |  D |  1 | D |  0 |
| conus | D | D | D | D | D | D | D |  0 |
| rap |  28 |  3 |  4 |  4 |  5 |  5 |  3 |  0 |
| tropical | D | D | D | D | D | D | D |  0 |
| 03 |  3 |  3 |  24 |  24 |  4 |  4 |  1 |  0 |
| 03DF |  3 |  3 |  4 |  4 |  4 |  4 |  1 |  0 |
| 03FD |  3 |  3 |  4 |  4 |  4 |  4 |  1 |  0 |
| 06 |  6 |  6 |  24 |  24 |  8 |  2 |  1 |  0 |
| 07NE |  8 | 14 |  5 |  5 | 8 | 1 |  2 |  2 |
| 10 |  10 |  2 |  1 |  2 |  4 |  4 |  7 |  0 |
| **Test** | **MP** | **CU** | **LW** | **SW** | **PBL** | **SFC** | **LSM** | **URB** |
| 11 |  10 |  2 |  1 |  2 |  4 |  4 |  7 |  0 |
| 14 |  3 |  6 |  3 |  3 |  4 |  4 |  3 |  0 |
| 16 |  8 | 14 |  5 |  5 | 9 | 2 |  7 |  0 |
| 16DF |  8 | 14 |  5 |  5 | 9 | 2 |  7 |  0 |
| 17 |  4 |  2 |  3 |  3 |  2 |  2 |  2 |  0 |
| 17AD |  4 |  2 |  3 |  3 |  2 |  2 |  2 |  0 |
| 18 |  8 | 6 |  5 |  5 | 10 | 10 |  7 |  0 |
| 20 |  4 |  1 |  1 |  2 |  12 |  1 |  2 |  0 |
| 20NE |  4 |  1 |  1 |  2 |  12 |  1 |  2 |  0 |
| 38 |  2 | 14 |  4 |  4 | 2 | 2 |  7 |  0 |
| **Test** | **MP** | **CU** | **LW** | **SW** | **PBL** | **SFC** | **LSM** | **URB** |
| 48 |  3 |  3 |  24 |  24 |  4 |  4 |  1 |  0 |
| 49 |  3 |  1 |  24 |  24 |  1 |  91 |  2 |  0 |
| 50 |  3 |  1 |  24 |  24 |  1 |  91 |  4 |  0 |
| 51 |  3 |  1 |  24 |  24 |  1 |  91 |  4 |  0 |
| 52 |  17 |  3 |  24 |  24 |  4 |  4 |  1 |  0 |
| 52DF |  17 |  3 |  4 |  4 |  4 |  4 |  1 |  0 |
| 52FD |  17 |  3 |  4 |  4 |  4 |  4 |  1 |  0 |
| 60 |  6 |  11 |  24 |  24 |  1 |  1 |  4 |  0 |
| 60NE |  6 |  11 |  4 |  4 |  1 |  1 |  4 |  0 |
| 65DF |  28 |  7 |  4 |  4 |  9 |  2 |  3 |  0 |
| **Test** | **MP** | **CU** | **LW** | **SW** | **PBL** | **SFC** | **LSM** | **URB** |
| 66FD |  3 |  1 |  4 |  4 |  4 |  4 |  1 |  0 |
| 71 |  8 |  1 |  4 |  4 |  1 |  1 |  2 |  0 |
| 78 |  52 |  1 |  4 |  4 |  1 |  1 |  2 |  0 |
| 79 |  2 | 14 |  4 |  4 | 5 | 2 |  7 |  0 |
| cmt |  6 |  11 |  4 |  4 |  1 |  1 |  2 |  0 |
| kiaps1NE |  16 |  14 |  14 |  14 |  11 |  1 |  4 |  0 |
| kiaps2 |  16 |  14 |  14 |  14 |  1 |  91 |  4 |  1 |
| solaraNE |  8 |  1 |  4 |  4 |  5 |  5 |  2 |  3 |
| **Test** | **MP** | **CU** | **LW** | **SW** | **PBL** | **SFC** | **LSM** | **URB** |

## Get the WRF docker infrastructure<a name="Getdocker"/>

1. Docker is needed   

The capability for the build and run testing (using the WRF container) necessarily requires the use of the the docker utility on your local machine (docker.com).

2. To start the process of constructing a working WRF docker container, clone the WRF-specific wrf-coop repository. This is the code that eventually builds the container structures for WRF.
```
git clone https://github.com/davegill/wrf-coop
cd wrf-coop
```

## Prepare the docker image<a name="Prepareimage"/>

1. From inside the top-level `wrf-coop` directory, edit the runtime files for docker to test the single specific WRF fork, repository, and branch: `Dockerfile` and `Dockerfile-NMM`. 

Here is the entire Dockerfile for ARW: `Dockerfile`:
```
#
FROM davegill/wrf-coop:thirteenthtry
MAINTAINER Dave Gill <gill@ucar.edu>

RUN git clone _FORK_/_REPO_.git WRF \
  && cd WRF \
  && git checkout _BRANCH_ \
  && cd ..

RUN git clone https://github.com/davegill/SCRIPTS.git SCRIPTS \
  && cp SCRIPTS/rd_l2_norm.py . && chmod 755 rd_l2_norm.py \
  && cp SCRIPTS/script.csh .    && chmod 755 script.csh    \
  && ln -sf SCRIPTS/Namelists . 

VOLUME /wrf
CMD ["/bin/tcsh"]
```

Here is the entire Dockerfile for NMM: `Dockerfile-NMM`:
```
#
FROM davegill/wrf-coop:sixthtry
MAINTAINER Dave Gill <gill@ucar.edu>

RUN git clone _FORK_/_REPO_.git WRF \
  && cd WRF \
  && git checkout _BRANCH_ \
  && cd ..

RUN git clone https://github.com/davegill/SCRIPTS.git SCRIPTS \
  && cp SCRIPTS/rd_l2_norm.py . && chmod 755 rd_l2_norm.py \
  && cp SCRIPTS/script.csh .    && chmod 755 script.csh    \
  && ln -sf SCRIPTS/Namelists . 

VOLUME /wrf
CMD ["/bin/tcsh"]
```

What needs to be modified in both files is the location of the WRF repository to test. Look for the section (in both files) that has:
```
RUN git clone _FORK_/_REPO_.git WRF \
  && cd WRF \
  && git checkout _BRANCH_ \
  && cd ..
```

For example, replacing those italicized names (including the leading and closing underscore characters) with the following:   
*\_FORK\_* => `https://github.com/davegill`   
*\_REPO\_* => `WRF`   
*\_BRANCH\_* => `irr=3`   

would yield the same final text to be used within both `Dockerfile` and `Dockerfile-NMM`.
```
RUN git clone https://github.com/davegill/WRF.git WRF \
  && cd WRF \
  && git checkout irr=3 \
  && cd ..
```

Please note that some people have their repository name as `WRF-1` (instead of the more traditional `WRF`).

2. Construct the docker image

Using the `Dockerfile` and the `Dockerfile-NMM`, build two docker images. Note that there are indeed periods at the trailing ends of these commands!

```
docker build -t wrf_regtest .
docker build -f Dockerfile-NMM -t wrf_nmmregtest .
```

You have to be in the directory where the Dockerfiles are located (or else use the `-f` option). Each of the two commands takes about 5 minutes to complete (downloading several GB of data and code). Afterwards, there are two docker images (`wrf_regtest` and `wrf_nmmregtest`) that can be used to build your WRF containers. The images that include the name `wrf-coop` are the public dockerhub pieces that include Linux, the compiler, user libraries (such as netcdf and mpi), user executables (again such as from netcdf and mpi), and directory structure for the WRF model. These preparatory images are not used directly by users.
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
wrf_nmmregtest      latest              13b80465a2f4        2 days ago           5.78GB
wrf_regtest         latest              cb75a489c00c        About a minute ago   5.67 GB
davegill/wrf-coop   thirteenthtry       c06fd248f249        6 hours ago          5.21 GB
davegill/wrf-coop   sixthtry            c36f5f2b0cc6        3 months ago         5.32GB
```

## Contruct the docker containers<a name="Constrcutcontainers"/>

1. Choose a shared directory for docker

To share data and files back and forth between the host OS and the docker container, a user-defined assignment maps a local host OS directory to a directory inside of the WRF container. For example, let's assume that the existing local directory on the host OS is `/users/gill/DOCKER_STUFF`.

2. Build the containers 

Each of these take about 30 seconds to complete (nothing to download, just local processing). These commands should each be issued from separate terminal windows from the host OS (i.e. don't issue a docker command inside of a WRF docker container).

```
docker run -it --name ARW -v /users/gill/DOCKER_STUFF:/wrf/wrfoutput wrf_regtest /bin/tcsh
```
You are now in the ARW container. You'll notice that the prompt has changed:
```
[wrfuser@cc600ad4caea ~]$
```

In another window execute:
```
docker run -it --name NMM -v /users/gill/DOCKER_STUFF:/wrf/wrfoutput wrf_nmmregtest /bin/tcsh
```
You are now in the NMM container.

## Build executables from source, run tests<a name="Buildexec"/>

Once the WRF containers are built and you are inside of the ARW container, building the WRF code is as usual. 

1. From inside the ARW container, do the usual process of `clean`, `configure`, `compile`. 

2. Note that while you are inside of the container, you are in a Linux environment. You will be setting up WRF to run natively in a Linux OS, _NOT_ for your host OS. The `configure` options for GNU LInux will always be:
   * 32: serial build
   * 33: OpenMP (threaded, shared memory, SM)
   * 34: MPI (message passing, distributed memory, DM)
   
3. Since this is the entire WRF source code that is in the container, all of the standard `configure` options are available. 
   * -d: debug, traceback, no optimization
   * -D: -d + bounds check + identify uninitialized 
   * -r8: 8-byte reals as default
```
cd WRF
configure -d << EOF
34
1
EOF
compile em_real -j 4 >& foo ; tail -20 foo
```

### Run a sample test case<a name="Runsample"/>

1. All of the required gridded fields, such as from metgrid, are inside the container. Those need to be in the working directory. With the shared directory between the docker container and the host OS, other data can easily be brought into the container.
```
cd test/em_real
ln -sf /wrf/Data/em_real/* .
```
2. From the lengthy run-time configuration table above, choose a suffix from the test names. For example, the first few are listed as:
   * 3dtke
   * conus
   * rap
   * tropical

This example shows selecting to run the `conus` namelist.
```
cp /wrf/Namelists/weekly/em_real/MPI/namelist.input.conus namelist.input
```
3. Since the code was built with DM (option 34 on the `configure` script), we can request multiple processors. Depending on the initial setup of your docker system, there may be fewer processes available within the container than physically available on your host machine. The `--oversubscribe` option permits multiple MPI ranks to be handled by the same process sequentially. The timing performance suffers, but the parallel testing is valid.
```
mpirun -np 3 --oversubscribe real.exe
mpirun -np 3 --oversubscribe wrf.exe
```
### Check the simulation results<a name="Checkresults"/>

1. The output from standard err and standard out in the container are treated similarly as typical WRF simulations. The last line should contain the string "SUCCESS".
```
cat rsl.out.0000 | tail -20
ThompMP: read qr_acr_qsV2.dat instead of computing
ThompMP: read freezeH2O.dat instead of computing
Timing for Writing wrfout_d01_2000-01-24_12:00:00 for domain        1:    0.43323 elapsed seconds
d01 2000-01-24_12:00:00  Input data is acceptable to use: wrfbdy_d01
Timing for processing lateral boundary for domain        1:    0.15323 elapsed seconds
 Tile Strategy is not specified. Assuming 1D-Y
WRF TILE   1 IS      1 IE     74 JS      1 JE     20
WRF NUMBER OF TILES =   1
Timing for main: time 2000-01-24_12:03:00 on domain   1:    5.54555 elapsed seconds
Timing for main: time 2000-01-24_12:06:00 on domain   1:    1.12536 elapsed seconds
Timing for main: time 2000-01-24_12:09:00 on domain   1:    1.09936 elapsed seconds
Timing for main: time 2000-01-24_12:12:00 on domain   1:    1.20909 elapsed seconds
Timing for main: time 2000-01-24_12:15:00 on domain   1:    1.17452 elapsed seconds
Timing for main: time 2000-01-24_12:18:00 on domain   1:    1.22385 elapsed seconds
Timing for main: time 2000-01-24_12:21:00 on domain   1:    1.13674 elapsed seconds
Timing for main: time 2000-01-24_12:24:00 on domain   1:    6.43835 elapsed seconds
Timing for main: time 2000-01-24_12:27:00 on domain   1:    1.20856 elapsed seconds
Timing for main: time 2000-01-24_12:30:00 on domain   1:    1.26051 elapsed seconds
Timing for Writing wrfout_d01_2000-01-24_12:30:00 for domain        1:    0.15855 elapsed seconds
d01 2000-01-24_12:30:00 wrf: SUCCESS COMPLETE WRF
```
2. There should be two time periods of data.
```
ncdump -h wrfout_d01_2000-01-24_12:00:00 | grep Time | grep UNLIMITED
	Time = UNLIMITED ; // (2 currently)
```
3. There should be no NaN values in the generated model output file.
```
ncdump wrfout_d01_2000-01-24_12:00:00 | grep -i nan
		IVGTYP:description = "DOMINANT VEGETATION CATEGORY" ;
		ISLTYP:description = "DOMINANT SOIL CATEGORY" ;
```

To visualize the data, copy or link the file to `/wrf/wrfoutput` (which was chosen as the docker shared directory location). 
```
cp wrfout_d01_2000-01-24_12:00:00 /wrf/wrfoutput/
```

In the host OS, go to the shared volume directory:
```
cd /users/gill/DOCKER_STUFF
ls -ls
total 78936
78936 -rw-r--r--  1 gill  1500  40413808 Apr  3 14:19 wrfout_d01_2000-01-24_12:00:00
```
### Compare the simulation results<a name="Compareresults"/>

The listed run-time configuration options (in the above table) provide bit-wise identical results with serial, OpenMP, and MPI simulations. Confirming these bit identical results is via two pair-wise comparisons (serial vs OpenMP, and serial vs MPI).

1. Save the MPI results to a separate directory.
```
mkdir MPI
mv wrfout_d01_2000-01-24_12:00:00 MPI
cp wrf.exe MPI
```
2. With the steps listed above, generate a serial executable, run the test case, and save the results. To allow us to eventually check bit-for-bit identical results, remember to use the `-d` option on `configure`. This removes the optimization, and the compiler can return identical results. To use four parallel threads for compiling the code, use `-j 4` on the `compile` command. This can cut the time to build the executables in half.
```
cd /wrf/WRF
clean -a
configure -d << EOF
32
1
EOF
compile em_real -j 4 >& foo ; tail -20 foo
cd test/em_real
real.exe
wrf.exe
mkdir SERIAL
mv wrfout_d01_2000-01-24_12:00:00 SERIAL
cp wrf.exe SERIAL
```
3. Similarly, build the code for OpenMP processing. Before running the model, set the OpenMP environment variable for the number of parallel threads to use.
```
cd /wrf/WRF
clean -a
configure -d << EOF
33
1
EOF
compile em_real -j 4 >& foo ; tail -20 foo
cd test/em_real
real.exe
setenv OMP_NUM_THREADS 4
wrf.exe
mkdir OPENMP
mv wrfout_d01_2000-01-24_12:00:00 OPENMP
cp wrf.exe OPENMP
```
4. Compare results

When there are no differences (the results are bit-wise identical), only the column headers are listed for each time period.
Serial vs OpenMP:
```
../../external/io_netcdf/diffwrf SERIAL/wrfout_d01_2000-01-24_12:00:00 OPENMP/wrfout_d01_2000-01-24_12:00:00 
 Just plot  F
Diffing SERIAL/wrfout_d01_2000-01-24_12:00:00 OPENMP/wrfout_d01_2000-01-24_12:00:00
 Next Time 2000-01-24_12:00:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
 Next Time 2000-01-24_12:30:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
 ```
Serial vs MPI:
```
../../external/io_netcdf/diffwrf SERIAL/wrfout_d01_2000-01-24_12:00:00 MPI/wrfout_d01_2000-01-24_12:00:00 
 Just plot  F
Diffing SERIAL/wrfout_d01_2000-01-24_12:00:00 MPI/wrfout_d01_2000-01-24_12:00:00
 Next Time 2000-01-24_12:00:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
 Next Time 2000-01-24_12:30:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
 ```
By introducing a modification to induce differences (changing the radiation frequency), this shows what the utility program reports when simulation results are not identical. Every field that is different between the two simulations is listed.
```
../../external/io_netcdf/diffwrf SERIAL/wrfout_d01_2000-01-24_12:00:00 wrfout_d01_2000-01-24_12:00:00
 Just plot  F
Diffing SERIAL/wrfout_d01_2000-01-24_12:00:00 wrfout_d01_2000-01-24_12:00:00
 Next Time 2000-01-24_12:00:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
 Next Time 2000-01-24_12:30:00
     Field   Ndifs    Dims       RMS (1)            RMS (2)     DIGITS    RMSE     pntwise max
         U    199915    3   0.2077143625E+02   0.2077142723E+02   6   0.5675E-02   0.1523E-01
         V    200665    3   0.1790809805E+02   0.1790801621E+02   5   0.7353E-02   0.1104E-01
         W    213150    3   0.4382839517E-01   0.4384699643E-01   3   0.8522E-03   0.1233E+00
        PH    197467    3   0.2233241586E+04   0.2233207488E+04   4   0.1643E+00   0.1681E-02
         T    185501    3   0.7661905661E+02   0.7661891936E+02   5   0.5147E-02   0.1553E-02
       THM    185536    3   0.7656888566E+02   0.7656875243E+02   5   0.5291E-02   0.1326E-02
        MU      4113    2   0.1424778637E+04   0.1424783101E+04   5   0.2007E+00   0.1980E-02
         P    188623    3   0.6987745239E+03   0.6987797266E+03   5   0.7223E+00   0.2656E-01
     P_HYD     81851    3   0.5370673102E+05   0.5370672897E+05   7   0.1578E+00   0.2037E-03
        Q2      4344    2   0.8673683758E-02   0.8671582948E-02   3   0.1359E-04   0.2213E-01
        T2      4261    2   0.2782406813E+03   0.2782413176E+03   5   0.4033E-01   0.2445E-02
       TH2      4263    2   0.2780485661E+03   0.2780492517E+03   5   0.4039E-01   0.2456E-02
      PSFC      3842    2   0.1001839581E+06   0.1001839539E+06   7   0.3410E+00   0.2036E-03
       U10      4365    2   0.2901385710E+01   0.2901844605E+01   3   0.8936E-02   0.1514E-01
       V10      4360    2   0.5981108836E+01   0.5982545091E+01   3   0.1847E-01   0.2226E-01
    QVAPOR    189027    3   0.3205001952E-02   0.3204968135E-02   4   0.1712E-05   0.9504E-02
    QCLOUD      8947    3   0.2336827518E-04   0.2347073090E-04   2   0.8883E-06   0.9983E-01
     QRAIN      5615    3   0.1997838925E-06   0.2001461333E-06   2   0.1645E-08   0.2284E-01
      QICE     25159    3   0.6405221210E-05   0.6411338238E-05   3   0.1761E-06   0.1271E+00
     QSNOW     28793    3   0.1192688229E-04   0.1191915427E-04   3   0.1350E-06   0.2526E-01
    QGRAUP       854    3   0.1947443381E-07   0.1962026883E-07   2   0.5489E-09   0.3075E-01
     QNICE     24405    3   0.4873312695E+06   0.4862787234E+06   2   0.2858E+05   0.2757E+00
    QNRAIN      5616    3   0.2722437200E+02   0.2724165286E+02   3   0.4243E+00   0.5268E-01
      TSLB      1599    3   0.2754714840E+03   0.2754715979E+03   6   0.2528E-02   0.2247E-03
     SMOIS      2389    3   0.7157583399E+00   0.7157582866E+00   7   0.2024E-05   0.1424E-03
      SH2O      3543    3   0.7084023035E+00   0.7084027496E+00   6   0.1625E-04   0.5382E-03
    SMCREL      2341    3   0.8343049862E+00   0.8343046966E+00   6   0.5891E-05   0.9123E-04
    SFROFF       277    2   0.1055065282E-04   0.1061663350E-04   2   0.6749E-07   0.6495E-02
    UDROFF       215    2   0.2071690287E+02   0.2071692973E+02   5   0.3284E-03   0.3883E-04
    GRDFLX      2349    2   0.3280135341E+02   0.3305123211E+02   2   0.1627E+01   0.2072E+00
  ACGRDFLX      2349    2   0.6020761759E+05   0.5994200453E+05   2   0.1311E+04   0.5809E-01
    ACSNOM        32    2   0.6084211585E-04   0.9523415932E-04   0   0.3713E-04   0.4409E+00
      SNOW      1133    2   0.1243978355E+02   0.1243974196E+02   5   0.2038E-03   0.2198E-04
     SNOWH      1160    2   0.6219826981E-01   0.6219791613E-01   5   0.3564E-05   0.2075E-03
    CANWAT       684    2   0.4445508257E-02   0.4451814742E-02   2   0.6865E-04   0.2958E-01
    COSZEN      4380    2   0.9974722728E-01   0.1009434751E+00   1   0.1471E-01   0.7694E-01
      U10E      4368    2   0.3020588728E+01   0.3020997928E+01   3   0.1102E-01   0.1466E-01
      V10E      4361    2   0.6179267792E+01   0.6180845772E+01   3   0.2425E-01   0.2896E-01
   TKE_PBL     42145    3   0.1741388386E+00   0.1747809270E+00   2   0.3890E-02   0.1368E+00
    EL_PBL     14120    3   0.1401868182E+02   0.1402771353E+02   3   0.1504E+01   0.5185E+00
       TSK      2348    2   0.2792221534E+03   0.2792034899E+03   4   0.1166E+00   0.5388E-02
     RAINC       432    2   0.8087492262E-01   0.8270815313E-01   1   0.6664E-02   0.2434E+00
    RAINNC       858    2   0.3602370490E-02   0.3604607713E-02   3   0.5705E-05   0.2978E-02
    SNOWNC       629    2   0.3563623709E-02   0.3565756517E-02   3   0.6800E-05   0.4096E-02
 GRAUPELNC         8    2   0.3697328233E-07   0.3769433904E-07   1   0.1154E-08   0.4349E-01
    CLDFRA      3632    3   0.2770395579E+00   0.2613639466E+00   1   0.9812E-01   0.1000E+01
    SWDOWN      2188    2   0.4270942575E+02   0.3790899295E+02   0   0.6194E+01   0.3240E+00
       GLW      4380    2   0.2915490577E+03   0.2904352124E+03   2   0.4723E+01   0.1401E+00
   ACSWUPT      2188    2   0.3240405227E+05   0.3223664365E+05   2   0.2470E+04   0.2698E+00
  ACSWUPTC      2188    2   0.2271701030E+05   0.2231482204E+05   1   0.9134E+03   0.5798E-01
   ACSWDNT      2188    2   0.1098642656E+06   0.1073244794E+06   1   0.3785E+04   0.3516E-01
  ACSWDNTC      2188    2   0.1098642656E+06   0.1073244794E+06   1   0.3785E+04   0.3516E-01
   ACSWUPB      2188    2   0.3957730300E+04   0.3825888753E+04   1   0.3346E+03   0.1503E+00
  ACSWUPBC      2188    2   0.4377922509E+04   0.4223275379E+04   1   0.3155E+03   0.1191E+00
   ACSWDNB      2188    2   0.4875914027E+05   0.4745256201E+05   1   0.2644E+04   0.1503E+00
  ACSWDNBC      2188    2   0.5403992505E+05   0.5243958371E+05   1   0.2014E+04   0.2006E-01
   ACLWUPT      4380    2   0.4254680595E+06   0.4245412468E+06   2   0.4473E+04   0.4266E-01
  ACLWUPTC      4380    2   0.4320672146E+06   0.4319657873E+06   3   0.4461E+03   0.3761E-02
   ACLWUPB      4378    2   0.6397582477E+06   0.6395422783E+06   3   0.1251E+04   0.8610E-02
  ACLWUPBC      4375    2   0.6393635490E+06   0.6390398419E+06   3   0.1289E+04   0.8613E-02
   ACLWDNB      4380    2   0.4994158782E+06   0.5021246382E+06   2   0.5935E+04   0.4472E-01
  ACLWDNBC      4380    2   0.4886655848E+06   0.4885339661E+06   3   0.2075E+03   0.1074E-02
     SWUPT      2188    2   0.3969815577E+02   0.3271946513E+02   0   0.8081E+01   0.5039E+00
    SWUPTC      2188    2   0.1942421402E+02   0.1734232072E+02   0   0.2847E+01   0.1814E+00
     SWDNT      2188    2   0.9918293670E+02   0.8687890112E+02   0   0.1418E+02   0.9296E-01
    SWDNTC      2188    2   0.9918293670E+02   0.8687890112E+02   0   0.1418E+02   0.9296E-01
     SWUPB      2188    2   0.3634598267E+01   0.3103841565E+01   0   0.8106E+00   0.3651E+00
    SWUPBC      2188    2   0.4393716892E+01   0.3653870715E+01   0   0.9462E+00   0.3651E+00
     SWDNB      2188    2   0.4270942633E+02   0.3790899357E+02   0   0.6194E+01   0.3240E+00
    SWDNBC      2188    2   0.5254713709E+02   0.4488580214E+02   0   0.8385E+01   0.1123E+00
     LWUPT      4380    2   0.2282915116E+03   0.2299704349E+03   2   0.5588E+01   0.1690E+00
    LWUPTC      4380    2   0.2394362106E+03   0.2395117591E+03   3   0.1745E+00   0.3213E-02
     LWUPB      4377    2   0.3544427431E+03   0.3545018756E+03   3   0.3436E+00   0.7631E-02
    LWUPBC      4372    2   0.3537143400E+03   0.3538060350E+03   3   0.2847E+00   0.6144E-02
     LWDNB      4380    2   0.2915490577E+03   0.2904352124E+03   2   0.4723E+01   0.1401E+00
    LWDNBC      4380    2   0.2708427912E+03   0.2708878724E+03   3   0.2643E+00   0.3326E-02
       OLR      4380    2   0.2282915116E+03   0.2299704349E+03   2   0.5588E+01   0.1690E+00
    ALBEDO       834    2   0.2897951198E+00   0.2897925515E+00   5   0.5130E-04   0.3185E-02
     EMISS       315    2   0.9584721578E+00   0.9584721457E+00   7   0.9572E-07   0.1946E-05
   NOAHRES      2334    2   0.1957383304E+00   0.2039653757E+00   1   0.3565E-01   0.9842E+00
       UST      4373    2   0.3621059031E+00   0.3620335588E+00   3   0.3475E-02   0.6739E-01
      PBLH      4054    2   0.5835742037E+03   0.5839932195E+03   3   0.2342E+02   0.1633E+00
       HFX      4372    2   0.5986418778E+02   0.5987161655E+02   3   0.1372E+01   0.7971E-01
       QFX      4372    2   0.5626051984E-04   0.5626636626E-04   3   0.2462E-06   0.2580E-01
        LH      4372    2   0.1406542974E+03   0.1406689535E+03   3   0.6233E+00   0.2581E-01
     ACHFX      4373    2   0.1019344107E+06   0.1017145494E+06   2   0.2027E+04   0.3408E-01
     ACLHF      4368    2   0.2108091636E+06   0.2108122824E+06   4   0.7391E+03   0.1038E-01
     SNOWC       895    2   0.3391681058E+00   0.3391674524E+00   5   0.5540E-05   0.8187E-04
        SR       176    2   0.3535776588E+00   0.3538681369E+00   3   0.3389E-01   0.1000E+01
```
5. By saving the WRF executables (`wrf.exe`) in each directory, a user can now run through all of the tests for each parallel build to verify identical results.
6. A contributor should also modify a standard namelist to include a positive test for the new source code to be included. Of course, most of the infrastructure inside the container is in place to verify that the new code has not broken anything. However, the same infrastructure should be used to ensure bit-wise identical results among the three parallel build options with the new feature or option.

### Checking WRF Chem results<a name="WRFChem"/>

Compiling the chemistry code requires significantly more time and resorces than the ARW build without chemistry. If your compile is killed, open Docker's preferences, go to Resources, and increase Memory and Swap.

1. Build the WRF-Chem code
```
cd WRF
setenv WRF_EM_CORE 1
setenv WRF_CHEM 1
configure -d << EOF
34
1
EOF
compile em_real -j 4 >& foo
ls -ls main/*.exe
 98856 -rwxr-xr-x 1 wrfuser wrf 101227120 Apr 20 20:08 main/ndown.exe
 99128 -rwxr-xr-x 1 wrfuser wrf 101505816 Apr 20 20:08 main/real.exe
 96408 -rwxr-xr-x 1 wrfuser wrf  98718320 Apr 20 20:08 main/tc.exe
113652 -rwxr-xr-x 1 wrfuser wrf 116378112 Apr 20 20:02 main/wrf.exe
```

To build the WRF-Chem executables with KPP, a couple of extra environment variables are required but otherwise the process is identical. The compilation and build takes longer with WRF-Chem, and the KPP build is even longer.
```
cd WRF
setenv WRF_EM_CORE 1
setenv WRF_CHEM 1
setenv WRF_KPP 1
setenv FLEX_LIB_DIR /usr/lib64
setenv YACC '/usr/bin/yacc -d'
configure -d << EOF
34
1
EOF
compile em_real -j 4 >& foo
ls -ls main/*.exe
101896 -rwxr-xr-x 1 wrfuser wrf 104339744 May 11 03:01 ndown.exe
102172 -rwxr-xr-x 1 wrfuser wrf 104622976 May 11 03:01 real.exe
 99444 -rwxr-xr-x 1 wrfuser wrf 101827832 May 11 03:01 tc.exe
132888 -rwxr-xr-x 1 wrfuser wrf 136076608 May 11 03:00 wrf.exe
```

2. Run the WRF-Chem code
```
cd test/em_real
ln -sf /wrf/Data/em_chem/* .
cp /wrf/Namelists/weekly/em_chem/namelist.input.1 namelist.input
mpirun -np 3 --oversubscribe real.exe
mpirun -np 3 --oversubscribe wrf.exe
```
3. Check the WRF-Chem ouput

This includes looking at the standard out, looking for "SUCCESS COMPLETE WRF".
```
tail rsl.out.0000
Timing for main: time 2006-04-06_00:12:00 on domain   1:    0.45490 elapsed seconds
Timing for main: time 2006-04-06_00:16:00 on domain   1:    0.44533 elapsed seconds
Timing for main: time 2006-04-06_00:20:00 on domain   1:    0.46689 elapsed seconds
Timing for main: time 2006-04-06_00:24:00 on domain   1:    0.29783 elapsed seconds
Timing for main: time 2006-04-06_00:28:00 on domain   1:    0.30349 elapsed seconds
Timing for main: time 2006-04-06_00:32:00 on domain   1:    0.28939 elapsed seconds
Timing for main: time 2006-04-06_00:36:00 on domain   1:    0.52982 elapsed seconds
Timing for main: time 2006-04-06_00:40:00 on domain   1:    0.30653 elapsed seconds
Timing for Writing wrfout_d01_2006-04-06_00:40:00 for domain        1:    0.12587 elapsed seconds
d01 2006-04-06_00:40:00 wrf: SUCCESS COMPLETE WRF
```
Verify that there are two time perids in the output.
```
ncdump -h wrfout_d01_2006-04-06_00:00:00 | grep Time | grep UNLIMITED
        Time = UNLIMITED ; // (2 currently)
```
And check that there are no NaN (not a number) values in the gridded model output:
```
ncdump -h wrfout_d01_2006-04-06_00:00:00 | grep -i nan
                IVGTYP:description = "DOMINANT VEGETATION CATEGORY" ;
                ISLTYP:description = "DOMINANT SOIL CATEGORY" ;
```
4. For WRF-Chem, the following tests (i.e., namelist.input.$TESTNUMBER) should be conducted
   * 1
   * 5
   * 6 (namelist in MPI subdirectory)

### Checking WRF DA results<a name="WRFDA"/>

1. Build the WRFDA code

WRFDA can be built in 4DVar mode or non-4DVar mode. The 4DVar build allows a user to also run
3DVar and hybrid-3D/4DEnVar. The 4DVar build needs to additionally build WRFPlus (i.e., the tangent linear and adjoint (TL/AD) of WRF).
Users may find a benefit to having separate directories for WRF, WRFPLUS, and WRFDA.

For WRFPlus build:
```
cd ~
cp -pr WRF WRFPLUS
cd WRFPLUS 
./configure wrfplus << EOF
18
EOF
./compile wrfplus >& foo
ls -ls main/*.exe
-rwxr-xr-x 1 liuz ncar 64177872 Mar 12 10:56 wrfplus.exe
```

For WRFDA-4DVar build:
<!--
setenv RTTOV rttov-lib-directory # 3rd part software, optional
setenv HDF5 hdf5-lib-directory # optional, some obs file I/O need this.
-->
```
cd ~
cp -pr WRF WRFDA
cd WRFDA
setenv CRTM 1   # will build with CRTM, optional
setenv WRFPLUS_DIR built-wrfplus-directory # must have for 4DVar
./configure 4dvar << EOF
18
EOF
./compile all_wrfvar >& foo
ls -lrt var/build/*.exe  # 43 executables
-rwxr-xr-x 1 liuz ncar 110278320 Mar 12 11:28 var/build/da_wrfvar.exe
-rwxr-xr-x 1 liuz ncar     30184 Mar 12 11:28 var/build/da_advance_time.exe
-rwxr-xr-x 1 liuz ncar   5314584 Mar 12 11:28 var/build/da_update_bc.exe
-rwxr-xr-x 1 liuz ncar   5277832 Mar 12 11:28 var/build/da_update_bc_ad.exe
-rwxr-xr-x 1 liuz ncar   6090656 Mar 12 11:28 var/build/gen_be_stage0_wrf.exe
-rwxr-xr-x 1 liuz ncar   6070440 Mar 12 11:28 var/build/gen_be_stage0_gsi.exe
-rwxr-xr-x 1 liuz ncar   6041080 Mar 12 11:28 var/build/gen_be_ep1.exe
-rwxr-xr-x 1 liuz ncar   6114944 Mar 12 11:29 var/build/gen_be_ep2.exe
-rwxr-xr-x 1 liuz ncar   6012408 Mar 12 11:29 var/build/gen_be_stage1.exe
-rwxr-xr-x 1 liuz ncar   5955120 Mar 12 11:29 var/build/gen_be_vertloc.exe
-rwxr-xr-x 1 liuz ncar   5997040 Mar 12 11:29 var/build/gen_be_addmean.exe
-rwxr-xr-x 1 liuz ncar   6004432 Mar 12 11:29 var/build/gen_be_stage1_gsi.exe
-rwxr-xr-x 1 liuz ncar   6000128 Mar 12 11:29 var/build/gen_be_stage1_1dvar.exe
-rwxr-xr-x 1 liuz ncar   5983736 Mar 12 11:29 var/build/gen_be_stage2.exe
-rwxr-xr-x 1 liuz ncar    171512 Mar 12 11:29 var/build/gen_be_stage2_gsi.exe
-rwxr-xr-x 1 liuz ncar   6090424 Mar 12 11:29 var/build/gen_mbe_stage2.exe
-rwxr-xr-x 1 liuz ncar   6004280 Mar 12 11:29 var/build/gen_be_stage2_1dvar.exe
-rwxr-xr-x 1 liuz ncar   5971448 Mar 12 11:29 var/build/gen_be_stage2a.exe
-rwxr-xr-x 1 liuz ncar   5983736 Mar 12 11:29 var/build/gen_be_stage3.exe
-rwxr-xr-x 1 liuz ncar   5959168 Mar 12 11:29 var/build/gen_be_stage4_global.exe
-rwxr-xr-x 1 liuz ncar   5992208 Mar 12 11:29 var/build/gen_be_stage4_regional.exe
-rwxr-xr-x 1 liuz ncar   5959160 Mar 12 11:29 var/build/gen_be_cov2d.exe
-rwxr-xr-x 1 liuz ncar   5959160 Mar 12 11:29 var/build/gen_be_cov3d.exe
-rwxr-xr-x 1 liuz ncar   5971656 Mar 12 11:29 var/build/gen_be_cov3d3d_bin3d_contrib.exe
-rwxr-xr-x 1 liuz ncar   5975744 Mar 12 11:29 var/build/gen_be_cov3d3d_contrib.exe
-rwxr-xr-x 1 liuz ncar   5971648 Mar 12 11:30 var/build/gen_be_cov2d3d_contrib.exe
-rwxr-xr-x 1 liuz ncar   5971648 Mar 12 11:30 var/build/gen_be_cov3d2d_contrib.exe
-rwxr-xr-x 1 liuz ncar   5950968 Mar 12 11:30 var/build/gen_be_diags.exe
-rwxr-xr-x 1 liuz ncar   5967544 Mar 12 11:30 var/build/gen_be_diags_read.exe
-rwxr-xr-x 1 liuz ncar   5967352 Mar 12 11:30 var/build/gen_be_hist.exe
-rwxr-xr-x 1 liuz ncar   5979744 Mar 12 11:30 var/build/gen_be_ensrf.exe
-rwxr-xr-x 1 liuz ncar   6054528 Mar 12 11:30 var/build/gen_be_etkf.exe
-rwxr-xr-x 1 liuz ncar   5963320 Mar 12 11:30 var/build/gen_be_ensmean.exe
-rwxr-xr-x 1 liuz ncar    270480 Mar 12 11:30 var/build/da_tune_obs_hollingsworth1.exe
-rwxr-xr-x 1 liuz ncar    180488 Mar 12 11:30 var/build/da_tune_obs_hollingsworth2.exe
-rwxr-xr-x 1 liuz ncar    129800 Mar 12 11:30 var/build/da_tune_obs_desroziers.exe
-rwxr-xr-x 1 liuz ncar   5133368 Mar 12 11:30 var/build/da_verif_obs.exe
-rwxr-xr-x 1 liuz ncar   5364056 Mar 12 11:30 var/build/da_verif_grid.exe
-rwxr-xr-x 1 liuz ncar    109920 Mar 12 11:30 var/build/da_bias_airmass.exe
-rwxr-xr-x 1 liuz ncar     47520 Mar 12 11:30 var/build/da_bias_sele.exe
-rwxr-xr-x 1 liuz ncar    101296 Mar 12 11:30 var/build/da_bias_scan.exe
-rwxr-xr-x 1 liuz ncar     56104 Mar 12 11:30 var/build/da_bias_verif.exe
-rwxr-xr-x 1 liuz ncar   5169112 Mar 12 11:30 var/build/da_rad_diags.exe
```

WRFDA non-4DVar build can skip the step of building WRFPlus:
<!--
setenv RTTOV rttov-lib-directory # 3rd part software, optional
setenv HDF5 hdf5-lib-directory # optional, some obs file I/O need this.
-->
```
cd ~
cp -pr WRF WRFDA
cd WRFDA
setenv CRTM 1   # will build with CRTM, optional
./configure wrfda << EOF
34
EOF
./compile all_wrfvar >& foo
ls -lrt var/build/*.exe will get the same 43 executables.
```

### Checking NMM results<a name="WRFNMM"/>

Most developers do not anticipate sharing contributions with the NMM dynamical core. It is mandatory that the existing build of the NMM WRF model work with the new code, a peaceful co-existence. This is an example of negative testing: tests need to be undertaken to demonstrate that no harm has been done to the existing NMM WRF capabilities. This testing must be done inside the NMM container. A couple of NMM-specific environment variables are required to be set prior to the build. The ARW tests are much smaller than the NMM tests. While the ARW jobs are able to run with only 2 GB of memory, the NMM jobs use 8 GB. 

1. Build the NMM WRF code
```
cd WRF
setenv WRF_NMM_CORE 1
setenv HWRF 1
configure -d << EOF
34
EOF
compile nmm_real >& foo
ls -ls main/*.exe
39756 -rwxr-xr-x 1 wrfuser wrf 40708544 Apr  7 18:55 main/real_nmm.exe
49948 -rwxr-xr-x 1 wrfuser wrf 51144032 Apr  7 18:55 main/wrf.exe
```
2. Run the NMM WRF code
```
cd test/nmm_real
ln -sf /wrf/Data/nmm_hwrf/* .
cp /wrf/Namelists/weekly/nmm_hwrf/namelist.input.1NE namelist.input
mpirun -np 3 --oversubscribe real_nmm.exe 
mpirun -np 3 --oversubscribe wrf.exe
```
3. Check the NMM WRF output

This includes looking at the standard print out, looking for the "SUCCESS" message.
```
tail rsl.out.0000
Timing for main: time 2012-10-28_06:09:30 on domain   2:    0.37067 elapsed seconds
Timing for main: time 2012-10-28_06:09:45 on domain   2:    0.51848 elapsed seconds
Timing for main: time 2012-10-28_06:09:45 on domain   1:   12.89504 elapsed seconds
Timing for main: time 2012-10-28_06:10:00 on domain   2:    0.36900 elapsed seconds
Timing for Writing wrfout_d02_2012-10-28_06:10:00 for domain        2:    1.00879 elapsed seconds
Timing for main: time 2012-10-28_06:10:15 on domain   2:    1.52304 elapsed seconds
Timing for main: time 2012-10-28_06:10:30 on domain   2:    0.36961 elapsed seconds
Timing for main: time 2012-10-28_06:10:30 on domain   1:    4.61200 elapsed seconds
Timing for Writing wrfout_d01_2012-10-28_06:10:30 for domain        1:    7.46972 elapsed seconds
d01 2012-10-28_06:10:30 wrf: SUCCESS COMPLETE WRF
```

Verify that there are two time periods in the output (check both domains):
```
ncdump -h wrfout_d01_2012-10-28_06:00:00 | grep Time | grep UNLIMITED
	Time = UNLIMITED ; // (2 currently)
ncdump -h wrfout_d02_2012-10-28_06:00:00 | grep Time | grep UNLIMITED
	Time = UNLIMITED ; // (2 currently)
```

Check that there are no NaN values in the history output (check both domains):
```
ncdump wrfout_d01_2012-10-28_06:00:00 | grep -i nan
ncdump wrfout_d02_2012-10-28_06:00:00 | grep -i nan
```
4. For NMM, the following run-time tests should be conducted:
   * 1NE
   * 2NE
   * 3NE

## Docker Clean Up<a name="Cleanup"/>

When running docker containers, approximately 5-6 GB of disk space is used per container. Exiting from a container simply stops the container, but does not kill the container process. Similarly, removing the container process does not remove the docker WRF images. 

### Stop, re-enter, and remove a docker container<a name="Stop"/>

From a host OS terminal window and while you are still in the docker container in another terminal window, you can see the running containers:
```
docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cc600ad4caea        wrf_regtest         "/usr/bin/entrypoint…"   3 minutes ago       Up 2 minutes                            ARW
```
Once you exit the docker container, the status of the container changes from `Up` to `Exited`.
```
docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS               NAMES
cc600ad4caea        wrf_regtest         "/usr/bin/entrypoint…"   4 minutes ago       Exited (0) 5 seconds ago                       ARW
```
You can get back into that exact container:
```
docker start -ai ARW
```
Once a container is running, other host OS terminal windows may enter the same container:
```
docker exec -it ARW /bin/tcsh
```
Once the docker container status is `Exited`, the container may be removed. This step is typically used when building a new container. Removing the container is also required when the intention is to remove the docker image (by default, you cannot remove an image that has a container).

To remove a docker container, first exit all processes from the container (just `exit` from inside the container in each terminal window). Then stop the container, and then remove the container.
```
docker stop ARW
docker rm ARW
```

### Remove a docker image<a name="RemoveImage"/>

What docker images are available to remove:
```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
wrf_nmmregtest      latest              13b80465a2f4        2 days ago           5.78GB
wrf_regtest         latest              cb75a489c00c        About a minute ago   5.67 GB
davegill/wrf-coop   thirteenthtry       c06fd248f249        6 hours ago          5.21 GB
davegill/wrf-coop   sixthtry            c36f5f2b0cc6        3 months ago         5.32GB
```
As mentioned previously, leave the `wrf-coop` images alone. To remove the images that made both the `ARW` and `NMM` containers (in the above example):
```
docker rmi 13b80465a2f4 d7dd1400f486
```
The final clean-up step is to let docker do some removal of unnecessary space.
```
docker volume prune -f
```
