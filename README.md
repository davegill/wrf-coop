# wrf-coop

Build a container without WRF, then use that to build a container with WRF.

It takes too long to always rebuild the container with WRF from scratch.

### Build first image 
As of December 2019, this build / tag / push sequence must take place on a Linux machine. When trying to run this on a Mac, after 45 minutes of build time, you get:
```
etotheipi> docker push davegill/wrf-coop
The push refers to repository [docker.io/davegill/wrf-coop]
1c01cbaea4b8: Preparing 
96dd30e2d9ec: Preparing 
dbd99cfb48e8: Preparing 
d2077632857f: Preparing 
336a0a4ad4f4: Preparing 
cc575835f8d4: Waiting 
8844f6dd5393: Waiting 
ef3923c49da1: Waiting 
c57ce027abec: Waiting 
d95b9b793e55: Waiting 
d3d99b43d791: Waiting 
987b6f729113: Waiting 
aaf171c968f9: Waiting 
38ae20a05bbf: Waiting 
00cb8d467c5a: Waiting 
9e8f7cbd1249: Waiting 
d9767a7f89ec: Waiting 
3e5c4dab6989: Waiting 
d6304121d9e9: Waiting 
2d3c96b16c25: Waiting 
5239d65fffbc: Waiting 
efb9e1f528df: Waiting 
56c191e44487: Waiting 
5dc1f34a4acf: Waiting 
25c575725839: Waiting 
d3709005b6e6: Waiting 
1b5810566615: Waiting 
217b19599265: Waiting 
0e0618c626be: Waiting 
2f6eb8fce98a: Waiting 
cfd9822dfbcf: Waiting 
a4cf543cbf0f: Waiting 
bdc7e8c79d1f: Waiting 
9c8f4f160f2a: Waiting 
913a6c3d7109: Waiting 
77b174a6a187: Waiting 
denied: requested access to the resource is denied
```
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

Once we have that image, we want to save it. That is the _WHOLE_ purpose of this exercise. Then we just pull it down and add in the WRF repository, and voi-fricking-la. Note, this is `firsttry`. I am at `fifteenthtry`.
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
> docker build -t wrf_regtest .
```

### With the second image, build three containers
We construct a few containers from the `wrf_regtest` image: WRF Chem (test_001), Restart feature (test_002), Real (test_003). These containers take only a few seconds each to create.
```
> docker run -d -t --name test_001 wrf_regtest
> docker run -d -t --name test_002 wrf_regtest
> docker run -d -t --name test_003 wrf_regtest
```


### With those available containers, build the WRF code in four separate ways
Build the specific containers: WRF Chem (test_001), Restart feature (test_002), Real (test_003). These each require 5-20 minutes each, with most of the time consumed in the compilation of the WRF object files from source.
```
> docker exec test_001 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 WRF_CHEM=1
> docker exec test_002 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3
> docker exec test_003 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3
```
If your machine is _beefy_ enough, put these build jobs (as in "build a wrf executable") in the background, and run them all at the same time. Since each job is asking for `make` to use three parallel threads to speed up the build process of the WRF executables (`J=-j@3`), a _beefy_ enough machine for these four tasks (the fourseparate builds) would have twelve or more non-hyperthreaded processors.	
```
> docker exec test_001 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 WRF_CHEM=1 &
> docker exec test_002 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 &
> docker exec test_003 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 &
> wait
```

### Do a simulation
Run a single test in each container, takes less than a minute for each.
```
> docker exec test_001 ./script.csh RUN em_real 34 em_chem 1 NP=3 ; set OK = $status ; echo $OK for test 1
0 for test 1

> docker exec test_002 \
	./feature_testing.csh /wrf/wrfoutput /wrf/WRF/test/em_real \
	restartA /wrf/cases/basic /wrf/input/additional /wrf/input/standard mpi-3 ; \
	set OK = $status ; echo $OK for test basic
0 for test basic

> docker exec test_003 ./script.csh RUN em_real 34 em_real 01 NP=3 ; set OK = $status ; echo $OK for test 01
0 for test 01
```

### When the tests are completed
Remember to stop and remove the containers, remove the images, and remove all local volumes. 
```
> docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3f280433fd76        wrf_regtest         "/bin/tcsh"         About an hour ago   Up About an hour                        test_002m
```
```
> docker stop test_002m
> docker rm test_002m
```
```
> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf_regtest         latest              cb75a489c00c        About a minute ago   5.67 GB
davegill/wrf-coop   fifteenthtry        c06fd248f249        6 hours ago          5.21 GB
```
```
> docker rmi 196313365c17 efc665da99ef
```

There likely are volumes that need to be pruned, also.
```
> docker volume prune -f
> docker system df
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
Run ./single_init.csh
Run ./test_001s.csh
Run ./test_001m.csh
Run ./test_002m.csh
Run ./test_003s.csh
Run ./test_003o.csh
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
Run ./test_011s.csh
Run ./test_011o.csh
Run ./test_011m.csh
Run ./test_012s.csh
Run ./test_012o.csh
Run ./test_012m.csh
Run ./test_013s.csh
Run ./test_013o.csh
Run ./test_013m.csh
Run ./test_014s.csh
Run ./test_014o.csh
Run ./test_014m.csh
Run ./test_015s.csh
Run ./test_015o.csh
Run ./test_015m.csh
Run ./test_016s.csh
Run ./test_016o.csh
Run ./test_016m.csh
Run ./test_017s.csh
Run ./test_017o.csh
Run ./test_017m.csh
Run ./test_018s.csh
Run ./test_018m.csh
Run ./test_019s.csh
Run ./test_019o.csh
Run ./test_019m.csh
Run ./test_020s.csh
Run ./test_020o.csh
Run ./test_020m.csh
Run ./test_021s.csh
Run ./test_021o.csh
Run ./test_021m.csh
Run ./test_022s.csh
Run ./test_022o.csh
Run ./test_022m.csh
Run ./test_023s.csh
Run ./test_023m.csh
Run ./last_only_once.csh
```

Each manufactured job script looks similar to this:
```
#!/bin/csh
#####################   TOP OF JOB    #####################
touch /classroom/dave/wrf-coop/DOING_NOW_test_003s
chmod 666 /classroom/dave/wrf-coop/DOING_NOW_test_003s
echo TEST CASE = test_003s
date
set SHARED = /classroom/dave/wrf-coop
#	Build: case = em, SERIAL
echo Build container
#docker run -it --name test_003s  -v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest /bin/tcsh
#docker exec -it test_003s /bin/tcsh
#docker start -ai test_003s
docker run -d -t --name test_003s  -v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest
date
echo Build WRF executable
docker exec test_003s ./script.csh BUILD CLEAN 32 1 em_real -d J=-j@8
date
docker exec test_003s ls -ls WRF/main/wrf.exe
set OK_WRF = $status
docker exec test_003s ls -ls WRF/main/real.exe
set OK_PRE = $status
if ( ( $OK_WRF == 0 ) && ( $OK_PRE == 0 ) ) then
	echo "SUCCESSFUL BUILD"
	docker exec test_003s ls -ls wrfoutput | grep _BUILD_ | grep em_real_32 
else
	echo "FAILED BUILD LOG START"
	docker exec test_003s cat WRF/compile.log.em_real.32
	echo "FAILED BUILD LOG END"
endif
date
 
set TCOUNT = 1
foreach t ( em_real        3dtke conus rap tropical    )
	date
	if ( $TCOUNT == 1 )  goto SKIP_test_003s
	echo '======================================================================'
	echo RUN WRF test_003s for em_real 32 em_real, NML =  $t
	docker exec test_003s ./script.csh RUN em_real 32 em_real $t
	set OK = $status
	echo $OK = STATUS test_003s em em_real 32 $t
	date
	
	echo 'PRE-PROC OUTPUT' 
	docker exec test_003s cat WRF/test/em_real/real.print.out 
	echo 'MODEL OUTPUT' 
	docker exec test_003s cat WRF/test/em_real/wrf.print.out 
	
	docker exec test_003s ls -ls WRF/test/em_real | grep wrfout 
	docker exec test_003s ls -ls wrfoutput | grep _RUN_ | grep em_real_32_em_real_$t 
	date
SKIP_test_003s:
	@ TCOUNT ++
end
date
docker stop test_003s
date
docker rm test_003s
date
touch /classroom/dave/wrf-coop/COMPLETE_test_003s
chmod 666 /classroom/dave/wrf-coop/COMPLETE_test_003s
mv /classroom/dave/wrf-coop/DOING_NOW_test_003s /classroom/dave/wrf-coop/COMPLETE_test_003s
#####################   END OF JOB    #####################
```

On a single desktop, a reasonable run-time command would be:
```
> date ; ( ./single_init.csh Dockerfile wrf_regtest ; ./test_001s.csh ; ./test_001m.csh ; ./test_002m.csh ; ./test_003s.csh ; ./test_003o.csh ; ./test_003m.csh ; single_end.csh wrf_regtest ; last_only_once.csh OUTPUT ) >& output ; date
```

To view how the status of the testing after the command is complete, search for `SUCCESS`. There should be three `SUCCESS` messages for each test conducted (in this example, we did five tests):
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
```

When intending to run on multiple nodes, with the appropriate modifications, the `build.csh` generates the
long list of availble tests.

The correct usage would be to assign each test to a separate node.
```
> date ; ( ./single_init.csh Dockerfile wrf_regtest ; ./test_001s.csh ; ./single_end.csh wrf_regtest ) >& output ; date
```
```
> date ; ( ./single_init.csh Dockerfile wrf_regtest ; ./test_001o.csh ; ./single_end.csh wrf_regtest ) >& output ; date
```
```
> date ; ( ./single_init.csh Dockerfile wrf_regtest ; ./test_001m.csh ; ./single_end.csh wrf_regtest ) >& output ; date
```
When all of the jobs are complete, then issue
```
> date ; ( ./last_only_once.csh OUTPUT ) >& output ; date
```


