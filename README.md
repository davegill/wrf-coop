# wrf-coop

Build a container without WRF, then use that to build a container with WRF.

It takes too long to always rebuild the container from scratch.

Build first image. This has the libs, data, diretory, etc. This uses the `Dockerfile-first_part`.
```
> cp Dockerfile-first_part Dockerfile
> docker build -t wrf-coop --build-arg argname=regtest .
```


Here's the first image (wrf-coop). A coop is the thing surrounding the area that we actually care about.
```
> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf-coop            latest              bd2082d1eb7d        19 minutes ago      3.66GB
centos              latest              9f38484d220f        5 weeks ago         202MB
```

Once we have that image, we want to save it. That is the _WHOLE_ purpose of this exercise. Then we just pull it down and add in the WRF repository, and voi-fricking-la. Note, this is `firsttry`. I am at `secondtry`.
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

Then we build the second image, much shorter time, thank you very much. 
```
> cp Dockerfile-second_part Dockerfile
> docker build -t wrftest .
```

We do a few of these containers: real, nmm, chem. These are a few seconds each.
```
> docker run -d -t --name test_001 wrftest
> docker run -d -t --name test_002 wrftest
> docker run -d -t --name test_003 wrftest
```

Build the specific containers. These are 5-10 minutes each.
```
docker exec test_001 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3
docker exec test_002 ./script.csh BUILD CLEAN 34 1 nmm_real -d J=-j@3 WRF_NMM_CORE=1
docker exec test_003 ./script.csh BUILD CLEAN 34 1 em_real -d J=-j@3 WRF_CHEM=1
```
