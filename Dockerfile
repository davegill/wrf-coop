#
FROM davegill/wrf-coop:fourteenthtry
MAINTAINER Dave Gill <gill@ucar.edu>

RUN git clone https://github.com/wrf-model/WRF.git WRF \
  && cd WRF \
  && git checkout release-v4.3.1 \
  && cd ..

RUN git clone https://github.com/davegill/SCRIPTS.git SCRIPTS \
  && cp SCRIPTS/rd_l2_norm.py . && chmod 755 rd_l2_norm.py \
  && cp SCRIPTS/script.csh .    && chmod 755 script.csh    \
  && ln -sf SCRIPTS/Namelists . 

RUN git clone https://github.com/davegill/wrf_feature_testing.git wrf_feature_testing \
  && cd wrf_feature_testing && mv * .. && cd ..

ARG argname=no_feature_tests
RUN if [ "$argname" = "feature_tests" ]  ; then curl -SL https://www2.mmm.ucar.edu/wrf/dave/feature_data.tar.gz | tar -xzC /wrf ; fi

VOLUME /wrf
CMD ["/bin/tcsh"]
