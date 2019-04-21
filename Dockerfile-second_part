#
FROM davegill/wrf-coop:fourthtry
MAINTAINER Dave Gill <gill@ucar.edu>

#RUN echo _HERE1_
#RUN git clone https://github.com/davegill/WRF.git davegill/WRF \
#  && cd davegill/WRF \
#  && git fetch origin +refs/pull/4/merge: \
#  && git checkout -qf FETCH_HEAD \
#  && cd .. \
#  && mv WRF /wrf/WRF
#RUN echo _HERE2_

RUN git clone https://github.com/wrf-model/WRF.git WRF \
  && cd WRF \
  && git checkout release-v4.1.1 \
  && git checkout master \
  && git checkout develop \
  && git checkout release-v4.1 \
  && cd ..

VOLUME /wrf
CMD ["/bin/tcsh"]
