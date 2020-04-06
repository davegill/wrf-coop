# How to use the WRF Docker Containers

### Purpose

Contributors who intend to propose modifications to the WRF repository have responsibilities beyond their own personal tests that they have used to validate the proper functioning of the new feature or option. 

Please see https://www2.mmm.ucar.edu/wrf/users/contrib_info.php for the full process for getting code into the WRF repository. 

The primary repsponsibilities for a contributing developer include:
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

This page describes how to use docker containers for the negative testing of code proposed to WRF (no unintended consequences). This document provides developers with simple instructions to allow them to more fully vet their code by providing data and configuration files for a wide variety of known working setups. Before issuing a pull request to the WRF github repository, the developer's code modifcation must demonstrate the continued proper functioning of these existing WRF capabilities.

### What is tested

The real-data ARW simulations are tested for the 2000 Jan 24-25 1200 UTC case (though typically for only the first half hour of the time period). 

The domain for the ARW real-data simulations is shown in the figure.
![Screen Shot 2020-04-06 at 10 52 27 AM](https://user-images.githubusercontent.com/12666234/78584017-d5263d00-77f4-11ea-89b3-54cdf8357090.png)

Several types of tests are easily available within this testing system.

1. Various build options are possible:

|  Name              | Precision | 3D/2D | SERIAL | OPENMP | MPI | Ideal/Real | Nested |
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
| urb3bNE |  16 |  16 |  14 |  14 |  8 |  2 |  4 |  3 |
| **Test** | **MP** | **CU** | **LW** | **SW** | **PBL** | **SFC** | **LSM** | **URB** |

## Get the WRF container infrastructure

1. Docker is needed   

The capability for the build and run testing (using the WRF container) necessarily requires the use of the the docker utility on your local machine (docker.com).

2. To start the process of constructing a working WRF docker container, clone the WRF-specific wrf-coop repository. This is the code that eventually builds the container structures for WRF.
```
git clone https://github.com/davegill/wrf-coop
cd wrf-coop
```

## Prepare the docker image

1. From inside the top-level `wrf-coop` directory, edit the runtime files for docker to test the single specific WRF fork, repository, and branch: `Dockerfile` and `Dockerfile-NMM`. 

Here is the entire Dockerfile for ARW: `Dockerfile`:
```
#
FROM davegill/wrf-coop:eighthtry
MAINTAINER Dave Gill <gill@ucar.edu>

RUN git clone _FORK_/_REPO_.git WRF \
  && cd WRF \
  && git checkout _BRANCH_ \
  && cd ..

RUN git clone https://github.com/davegill/SCRIPTS.git SCRIPTS \
  && cp SCRIPTS/rd_l2_norm.py . && chmod 755 rd_l2_norm.py \
  && cp SCRIPTS/script.csh .    && chmod 755 script.csh    \
  && ln -sf SCRIPTS/Namelists . 

RUN curl -SL https://www2.mmm.ucar.edu/wrf/dave/sbm.tar.gz | tar -xzC /wrf

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

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf_nmmregtest      latest              13b80465a2f4        2 days ago          5.78GB
wrf_regtest         latest              d7dd1400f486        2 days ago          6.14GB
davegill/wrf-coop   eighthtry           56930417513a        5 weeks ago         5.59GB
davegill/wrf-coop   sixthtry            c36f5f2b0cc6        3 months ago        5.32GB
```

## Contruct the docker containers

1. Choose a shared directory for docker

To share data and files back and forth between the host OS and the docker container, a user-defined assignment maps a local host OS directory to a directory inside of the WRF container. For example, let's assume that the existing local directory on the host OS is `/users/gill/DOCKER_STUFF`.

2. Build the containers. Each of these take about 30 seconds to complete (nothing to download, just local processing). These commands should each be issued from separate terminal windows from the host OS (i.e. don't issue a docker command inside of a WRF docker container).

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

## Build executables from source, run tests

Now, build the WRF code as usual. From inside the ARW container:

```
cd WRF
configure -d << EOF
34
1
EOF
compile em_real -j 4 >& foo ; tail -20 foo
```

Run a sample test case:

```
cd test/em_real
cp /wrf/Namelists/weekly/em_real/MPI/namelist.input.conus namelist.input
ln -sf /wrf/Data/em_real/* .
mpirun -np 3 --oversubscribe real.exe
mpirun -np 3 --oversubscribe wrf.exe
```
To check the results, you can look at the rsl files:
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

## Docker Clean Up

When running docker containers, approximately 5-6 GB of disk space is used per container. Exiting from a container simply stops the container, but does not kill the container process. Similarly, removing the container process does not remove the docker WRF images. 

### Stop, re-enter, and remove a docker container

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

To remove a docker container, first exit all processes from the container (just `exit` from inside the container in each terminal window). Then stop the container, then remove the container.
```
docker rm ARW
```

### Remove a docker image

What docker images are available to remove:
```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf_nmmregtest      latest              13b80465a2f4        2 days ago          5.78GB
wrf_regtest         latest              d7dd1400f486        2 days ago          6.14GB
davegill/wrf-coop   eighthtry           56930417513a        5 weeks ago         5.59GB
davegill/wrf-coop   sixthtry            c36f5f2b0cc6        3 months ago        5.32GB
```
As mentioned previously, leave the `wrf-coop` images alone. To remove the images that made both the `ARW` and `NMM` containers (in the above example):
```
docker rmi 13b80465a2f4 d7dd1400f486
```
