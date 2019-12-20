# wrf-coop

Build a container without WRF, then use that to build a container with WRF.

It takes too long to always rebuild the container with WRF from scratch.

### Build first image. 
This image has the libs, data, directory structure, etc inside. The construction of this image uses the `Dockerfile-first_part` from this repository. This Docker setup was tested at https://github.com/davegill/travis_test. In the docker branch of the travis_test repo are the original `Dockerfile-template` and the `.travis.yml` files.
```
> cp Dockerfile-first_part Dockerfile
> docker build -t wrf-coop --build-arg argname=regtest .
```
The argument `argname=regtest` informs Docker as to how to build the image. With a regression test, we do not need all of the WPS source (and importantly, the large meteorological data and static data).

Here's the first image (wrf-coop). A coop is the structure surrounding the actual things that we care about.
```
> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf-coop            latest              bd2082d1eb7d        19 minutes ago      3.66GB
centos              latest              9f38484d220f        5 weeks ago         202MB
```

Once we have that image, we want to save it. That is the _WHOLE_ purpose of this exercise. Then we just pull it down and add in the WRF repository, and voi-fricking-la. Note, this is `firsttry`. I am at `fifthhtry`.
```
> docker tag bd2082d1eb7d davegill/wrf-coop:firsttry

> docker push davegill/wrf-coop
The push refers to repository [docker.io/davegill/wrf-coop]
558695d708da: Pushed 
e2d555398d6f: Pushed 
8c6b7d91fee6: Pushed 
69546d177ec5: Pushed 
c6642718d3ef: Pushed 
d51d0cae8443: Pushed 
0d6735cc3a9d: Pushed 
f0c24a1f05d6: Pushed 
6d588957998b: Pushed 
46ffc6fb925d: Pushed 
d73f3af5ea55: Pushed 
9d666d5e7bee: Pushed 
846be23583e9: Pushed 
b3bb66559ed6: Pushed 
8a7ba6af0616: Pushed 
aa7024be0b9f: Pushed 
076949cb22c2: Pushed 
f181df8f34ab: Pushed 
ecb2ee9d3bbd: Pushed 
48eebd1ee432: Pushed 
a9e237664972: Pushed 
2071e95ee939: Pushed 
7fe5cff2f68a: Pushed 
b19f30d7cdc9: Pushed 
ed2a4e81b34d: Pushed 
0c36a2e67633: Pushed 
c8219ce2694a: Pushed 
d69483a6face: Mounted from library/centos 
firsttry: digest: sha256:5ee88699d04e2867ff1bc2c437f604426483968608d6bab031ff721a1c037892 size: 6192
```

### Build the second image
The second image is faster (it requires a much shorter time to build the image), thank you very much. 
```
> cp Dockerfile-second_part Dockerfile
> docker build -t wrftest .
```

### With the second image, build three containers
We do a few of these containers: real, nmm, chem. These are a few seconds each.
```
> docker run -d -t --name test_001 wrftest
> docker run -d -t --name test_002 wrftest
> docker run -d -t --name test_003 wrftest
```


### With those available containers, build the WRF code in three separate ways
Build the specific containers: em_real, NMM, Chem. These are 5-10 minutes each.
```
> docker exec test_001 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3
> docker exec test_002 ./script.csh BUILD CLEAN 34 1 nmm_real -d J=-j@3 WRF_NMM_CORE=1
> docker exec test_003 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 WRF_CHEM=1
```
If your machine is _beefy_ enough, put these build jobs (as in "build a wrf executable") in the background, and run them all at the same time. Since each job is asking for `make` to use three parallel threads to speed up the build process of the WRF executables (`J=-j@3`), a _beefy_ enough machine would have more than 9 non-hyperthreaded processors.	
```
> docker exec test_001 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 &
> docker exec test_002 ./script.csh BUILD CLEAN 34 1 nmm_real -d J=-j@3 WRF_NMM_CORE=1 &
> docker exec test_003 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 WRF_CHEM=1 &
> wait
```

### Do a simulation
Run a single test in each container, takes less than a minute for each.
```
> docker exec test_001 ./script.csh RUN em_real 34 em_real 01 NP=3 ; set OK = $status ; echo $OK for test 01
0 for test 01
> docker exec test_002 ./script.csh RUN nmm_real 34 nmm_nest 01 NP=3 ; set OK = $status ; echo $OK for test 01
0 for test 01
> docker exec test_003 ./script.csh RUN em_real 34 em_chem 1 NP=3 ; set OK = $status ; echo $OK for test 1
0 for test 1
```

Remember to stop and remove the containers, and remove the images. 
```
> docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3f280433fd76        wrf_regtest         "/bin/tcsh"         About an hour ago   Up About an hour                        test_002m
```
```
> docker stop test_002m
> docker rm test_002m
```

There likely are volumes that need to be pruned, also.
```
> docker system df
> docker volume prune -f
```


### Using the `build.csh` script

A script is available to run through all of the available tests that are possible from inside the container. The `build.csh` script has a few user-definable options. These options are mostly to allow the script to be used on a single desktop machine (where jobs would need to be procesed sequentially), or on multiple machines (where the assumption is that each build uses a single node, and no other build uses that node).

Single machine, with 3 available processors (the available processors determine how many threads to use with parallel Make, how many OpenMP threads for the WRF model, and how many MPI ranks for the WRF model).
```
set TEST_GEN = SOME
set PROCS = 3
set JOB = SEQUENTIAL
```

Multiple machines, each with 8 (non-hyperthreaded) processors
```
set TEST_GEN = ALL
set PROCS = 8
set JOB = INDEPENDENT
```

The script `build.csh` generates executables files. The `build.csh` does not run any test.
```
> build.csh
Run ./single.csh
Run ./test_001s.csh
Run ./test_001o.csh
Run ./test_001m.csh
Run ./test_002s.csh
Run ./test_002m.csh
```

Each manufactured job script looks similar to this:
```
#!/bin/csh
#####################   TOP OF JOB    #####################
echo TEST CASE = test_001s
date
#	Build: case = em, SERIAL
echo Build container
docker run -d -t --name test_001s wrf_regtest
date
echo Build WRF executable
docker exec test_001s ./script.csh BUILD CLEAN 32 1 em_real -d J=-j@3
date
docker exec test_001s ls -ls WRF/main/wrf.exe
docker exec test_001s ls -ls WRF/main/real.exe
date
 
set TCOUNT = 1
foreach t ( em_real        03DF   )
	date
	if ( $TCOUNT == 1 )  goto SKIP_test_001s
	echo RUN WRF test_001s for em_real 32 em_real, NML =  $t
	docker exec test_001s ./script.csh RUN em_real 32 em_real $t
	set OK = $status
	echo $OK for test $t
	date
	
	docker exec test_001s cat WRF/test/em_real/wrf.print.out 
	
	docker exec test_001s ls -ls WRF/test/em_real | grep wrfout 
	docker exec test_001s ls -ls wrfoutput
	date
SKIP_test_001s:
	@ TCOUNT ++
end
date
docker stop test_001s
date
docker rm test_001s
date
echo docker rmi wrf_regtest
date
#####################   END OF JOB    #####################
```

On a single desktop, a reasonable run-time command would be:
```
> date ; ( ./single.csh ; ./test_001s.csh ; ./test_001o.csh ; ./test_001m.csh ; ./test_002s.csh ; ./test_002m.csh ) >& output ; date
```

To view how the status of the testing after the command is complete, search for `SUCCESS`. There should be four `SUCCESS` messages for each test conducted (in this example, we did five tests):
1. From inside of the WRF model print out
2. Build the executable
3. Run the preprocessor (real or ideal)
4. Run the WRF model (correct number of time periods, no NaNs, correct number of output files)
```
> grep SUCCESS OUTPUT
d01 2000-01-24_12:30:00 wrf: SUCCESS COMPLETE WRF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:32 SUCCESS_BUILD_WRF_em_real_32
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:32 SUCCESS_RUN_REAL_em_real_32_03DF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:35 SUCCESS_RUN_WRF_d01_em_real_32_03DF
wrf: SUCCESS COMPLETE WRF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:38 SUCCESS_BUILD_WRF_em_real_33
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:38 SUCCESS_RUN_REAL_em_real_33_03DF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:39 SUCCESS_RUN_WRF_d01_em_real_33_03DF
d01 2000-01-24_12:30:00 wrf: SUCCESS COMPLETE WRF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:43 SUCCESS_BUILD_WRF_em_real_34
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:43 SUCCESS_RUN_REAL_em_real_34_03DF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:44 SUCCESS_RUN_WRF_d01_em_real_34_03DF
d01 2008-01-11_00:15:00 wrf: SUCCESS COMPLETE WRF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:46 SUCCESS_BUILD_WRF_nmm_real_32
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:46 SUCCESS_RUN_REAL_nmm_real_32_01
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:47 SUCCESS_RUN_WRF_d01_nmm_real_32_01
d01 2008-01-11_00:15:00 wrf: SUCCESS COMPLETE WRF
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:48 SUCCESS_BUILD_WRF_nmm_real_34
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:48 SUCCESS_RUN_REAL_nmm_real_34_01
0 -rw-r--r-- 1 wrfuser wrf 0 Apr 29 15:49 SUCCESS_RUN_WRF_d01_nmm_real_34_01
```

When intending to run on multiple nodes, with the appropriate modifications, the `build.csh` would generate:
```
> build.csh
Run ./single.csh
Run ./test_001s.csh
Run ./test_001o.csh
Run ./test_001m.csh
Run ./test_002s.csh
Run ./test_002m.csh
Run ./test_003s.csh
Run ./test_003m.csh
Run ./test_004s.csh
Run ./test_004o.csh
Run ./test_004m.csh
Run ./test_005s.csh
Run ./test_005o.csh
Run ./test_005m.csh
Run ./test_006s.csh
Run ./test_006o.csh
Run ./test_006m.csh
Run ./test_007s.csh
Run ./test_007o.csh
Run ./test_007m.csh
Run ./test_008m.csh
Run ./test_009s.csh
Run ./test_009o.csh
Run ./test_009m.csh
Run ./test_010s.csh
```

The correct usage would be to assign each test to a separate node.
```
> date ; ( ./single.csh ; ./test_001s.csh ) >& output ; date
```
```
> date ; ( ./single.csh ; ./test_001o.csh ) >& output ; date
```
```
> date ; ( ./single.csh ; ./test_001s.csh ) >& output ; date
```


