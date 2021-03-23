#
FROM davegill/wrf-coop:fourteenthtry
LABEL maintainer="Dave Gill <gill@ucar.edu>"

ENV FORK https://github.com/davegill
ENV REPO WRF
ENV BRANCH irr=3

RUN git clone ${FORK}/${REPO}.git WRF \
  && cd WRF \
  && git checkout ${BRANCH} \
  && cd ..

RUN git clone https://github.com/davegill/SCRIPTS.git SCRIPTS \
  && cp SCRIPTS/rd_l2_norm.py . && chmod 755 rd_l2_norm.py \
  && cp SCRIPTS/script.csh .    && chmod 755 script.csh    \
  && ln -sf SCRIPTS/Namelists . 

VOLUME /wrf
CMD ["/bin/tcsh"]
