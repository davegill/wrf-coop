#!/bin/csh
#####################   TOP OF JOB    #####################

#	This script builds the docker image for the rest of the testing harness 

date
set SHARED = /classroom/dave
if ( ! -d ${SHARED}/OUTPUT ) mkdir ${SHARED}/OUTPUT

date
docker build -t wrf_regtest .
date

#####################   END OF JOB    #####################
