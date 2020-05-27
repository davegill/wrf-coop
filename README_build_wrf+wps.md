# wrf-coop

The purpose of the README is to provide information on how to build and run the 
WRF model and the WPS package using docker.  It takes too long to always rebuild 
the container from scratch with both WRF and WPS inside (the external libraries take more 
than an hour to complete).

So, the solution is to first build an image with everything except for the WRF and
WPS source (which takes a long time). Then, we add the WRF and WPS into the second
image. The advantage is that we can generate the first image infrequently and share
it on dockerhub. The second image builds quickly.


### Build first image 
As of December 2019, this build / tag / push sequence must take place on a Linux machine. Do not build on a Mac.

This first image has the libs, data, directory structure, etc inside. The construction of this image uses the `Dockerfile-first_part` from this repository. 

```
> cp Dockerfile-first_part Dockerfile
> docker build -t wrf_and_wps --build-arg argname=tutorial .
```
The argument `argname=tutorial` informs Docker as to how to build the image, specifically we need all of the WPS source and the large meteorological data and static data. 

Here is the first image (wrf_and_wps).
```
> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
wrf_and_wps         latest              157b1412b786        2 minutes ago       4.93 GB
docker.io/centos    7                   b5b4d78bc90c        3 weeks ago         203 MB
```

Once we have that image, we want to save it. That is the _WHOLE_ purpose of this exercise. Then we just pull it down and add in the WRF and WPS repositories, and voi-fricking-la. Note, that I am at `secondtry`.
```
> docker tag 157b1412b786 davegill/wrf_and_wps:secondtry

> docker push davegill/wrf_and_wps
The push refers to a repository [docker.io/davegill/wrf_and_wps]
980d92b51ca7: Pushed 
b3d45dd96987: Pushed 
f50b7e767dae: Pushed 
195cc7b4b67c: Pushed 
5d255a1ac93a: Pushed 
96039858d988: Pushed 
0ac25e54937f: Pushed 
1c39062e3f2a: Pushed 
9f9d2f2751e3: Pushed 
036b5436d99b: Pushed 
bf119f99308b: Pushed 
31adb15fe528: Pushed 
5fd9dccada31: Pushed 
0eb264c9f1c3: Pushed 
757695533832: Pushed 
846b799886cb: Pushed 
57f1cb0b27f1: Pushed 
79477c5ed600: Pushed 
fb46e659ec3e: Pushed 
25589cf1981c: Pushed 
2a06fe576292: Pushed 
bb4c81dd7a6c: Pushed 
7834ce739c9b: Pushed 
dba71a427f8b: Pushed 
7119909d8a35: Pushed 
e370e976b805: Pushed 
089921344c05: Pushed 
e4d4958a3d9d: Pushed 
adf862c2dc98: Pushed 
e6e179ba6577: Pushed 
911314a6276f: Pushed 
ff1cd8abed1b: Pushed 
1516bb4729e6: Pushed 
b3a5cb506a93: Pushed 
76af5e70ee5f: Pushed 
edf3aa290fb3: Layer already exists 
secondtry: digest: sha256:957081222ba591fa84bcfa2cea7da979bfd50af3b5b79ca803cc5a8262c60b12 size: 7876
```

### Build the second image
The second image is faster (it requires a much shorter time to build the image), thank you very much. This `Dockerfile_wps` is set up to provide a few standard branches for both WRF and WPS. Feel free to add your own instead.
```
> cp Dockerfile_wps Dockerfile
> docker build -t wrfwps .
```

### With the second image, build a container
We construct a container from the `wrfwps` image to build and run the WPS and WRF codes. Included in the container is sample test data and configuration files.
```
> docker run -d -t --name wrf_and_wps wrfwps
```


### Get into the container, build and run WRF and WPS
Build the specific containers: em_real (test_001), NMM (test_002), Chem (test_003), Chem KPP (test_019). These each require 5-20 minutes each, with most of the time consumed in the compilation of the WRF object files from source.
