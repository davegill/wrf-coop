#!/bin/csh

#	Choose which scripts to manufacture

set TEST_GEN = ALL
set TEST_GEN = TEST
set TEST_GEN = SOME

#	How many procs do we play with: used for parallel build, openmp threads, mpi ranks

set PROCS = 8

#	Sequential jobs, or all independent. Basically, do we remove the images?

set JOB = SEQUENTIAL
set JOB = INDEPENDENT

#	Only input arg is the location where the OUTPUT (shared) volume for
#	docker should be located.

if ( ${#argv} == 2 ) then
	set DROPIT = $1
	set SHARED = $2
	if ( ! -d $SHARED ) then
		echo " "
		echo "Usage: $0 _directory_"
		echo "where _directory_ is full path to where the OUTPUT directory will exist, or does exist"
		echo "_directory_/OUTPUT is the host-machine's shared volume location that docker will use"
		echo The '"'$SHARED'"' directory does not exist
		echo " "
		exit ( 1 )
	else if ( `echo $SHARED | cut -c 1` != "/" ) then
		echo " "
		echo "Usage: $0 _directory_"
		echo "where _directory_ is full path to where the OUTPUT directory will exist, or does exist"
		echo "_directory_/OUTPUT is the host-machine's shared volume location that docker will use"
		echo The '"'$SHARED'"' directory is not an absolute path to a directory
		echo " "
		exit ( 2 )
	endif
endif

if ( ${#argv} == 0 ) then
	echo " "
	echo "Usage: $0 _dir_drop_ _dir_out_"
	echo "1. where _dir_drop_ is full path to where the RUN file will be placed"
	echo "2. where _dir_out_ is full path to where the OUTPUT directory will exist, or does exist"
	echo "example: _dir_out_/OUTPUT is the host-machine's shared volume location that docker will use"
	echo " "
	exit ( 3 )
endif

if      ( $TEST_GEN == ALL ) then

	set TEST      = ( \
	                  "em_real        3dtke cesm conus rap tropical " \
	                  "em_chem        1 2 5 " \
	                  "em_quarter_ss  02 02NE 03 03NE 04 04NE 05 05NE 06 06NE 08 09 10 11NE 12NE 13NE 14NE " \
	                  "em_b_wave      1 1NE 2 2NE 3 3NE 4 4NE 5 5NE " \
	                  "em_real8       14 16 17 17AD 18 38 78 79" \
	                  "em_quarter_ss8 02 03 04 05 06 08 09 10 " \
	                  "em_move        01 02 " \
	                  "em_fire        01 " \
	                  "em_hill2d_x    01 " \
	                  "em_realA       03 03DF " \
	                  "em_realB       10 11 14 16 16DF " \
	                  "em_realC       17 17AD 18 20 20NE " \
	                  "em_realD       38 48 49 " \
	                  "em_realE       52 52DF " \
	                  "em_realF       65DF " \
	                  "em_realG       kiaps1NE kiaps2 rala ralbNE " \
	                  "em_realH       cmt fsbm solaraNE solarb urb3aNE urb3bNE " \
	                  "em_realI       03FD 06 07NE " \
	                  "em_realJ       50 51 " \
	                  "em_realK       52FD 60 60NE " \
	                  "em_realL       66FD 71 78 79 " \
	                  "em_realM       basic " \
	                  "em_chem_kpp    101 107 120 201 " \
	                )
	set TEST_COUNT = $#TEST
	set COUNT = 0
	set NUMBER =
	while ( $COUNT < $TEST_COUNT )
		@ COUNT ++
		if ( $COUNT < 10 ) then
			set NUMBER = ( $NUMBER 0$COUNT )
		else
			set NUMBER = ( $NUMBER  $COUNT )
		endif
	end

else if ( $TEST_GEN == SOME ) then

	set TEST      = ( \
	                  "em_real        3dtke conus rap tropical " \
	                  "em_chem        1 2 5 " \
	                  "em_quarter_ss  02NE 03 03NE 04 " \
	                  "em_b_wave      1NE 2 2NE 3 " \
	                  "em_real8       14 17AD " \
	                  "em_quarter_ss8 08 09 " \
	                  "em_move        01 " \
	                  "em_fire        01 " \
	                  "em_hill2d_x    01 " \
	                  "em_realA       03 03DF " \
	                  "em_realB       10 11 14 16 " \
	                  "em_realC       17 17AD 18 20 20NE " \
	                  "em_realD       38 48 49 " \
	                  "em_realE       52 52DF " \
	                  "em_realF       65DF " \
	                  "em_realG       kiaps1NE kiaps2 " \
	                  "em_realH       cmt solaraNE urb3bNE " \
	                  "em_realI       03FD 06 07NE " \
	                  "em_realJ       50 51 " \
	                  "em_realK       52FD 60 60NE " \
	                  "em_realL       66FD 71 78 79 " \
	                  "em_realM       basic " \
	                  "em_chem_kpp    120 " \
	                )
	set TEST_COUNT = $#TEST
	set COUNT = 0
	set NUMBER =
	while ( $COUNT < $TEST_COUNT )
		@ COUNT ++
		if ( $COUNT < 10 ) then
			set NUMBER = ( $NUMBER 0$COUNT )
		else
			set NUMBER = ( $NUMBER  $COUNT )
		endif
	end

else if ( $TEST_GEN == test ) then

	set TEST      = ( \
	                  "em_real        conus  " \
	                  "em_chem        1      " \
	                  "em_quarter_ss  02     " \
	                  "em_b_wave      1      " \
	                  "em_real8       14     " \
	                  "em_quarter_ss8 02     " \
	                  "em_move        01     " \
	                  "em_fire        01     " \
	                  "em_hill2d_x    01     " \
	                  "em_realA       03     " \
	                  "em_realB       10     " \
	                  "em_realC       17     " \
	                  "em_realD       38     " \
	                  "em_realE       52     " \
	                  "em_realF       65DF   " \
	                  "em_realG       cmt    " \
	                  "em_realH       fsbm   " \
	                  "em_realI       03FD " \
	                  "em_realJ       50 " \
	                  "em_realK       52FD " \
	                  "em_realL       66FD " \
	                  "em_realM       basic " \
	                  "em_chem_kpp    120 " \
	                )
	set TEST_COUNT = $#TEST
	set COUNT = 0
	set NUMBER =
	while ( $COUNT < $TEST_COUNT )
		@ COUNT ++
		if ( $COUNT < 10 ) then
			set NUMBER = ( $NUMBER 0$COUNT )
		else
			set NUMBER = ( $NUMBER  $COUNT )
		endif
	end

endif

#	Options that are used for all test generation settings. 

set SERIAL    = ( T           T           T             T           T           T              F           T           T           T           T           T           T           T           T           T           T           T           T           T           T           F           T                       ) # SERIAL     
set OPENMP    = ( T           F           T             T           T           T              F           T           F           T           T           T           T           T           T           T           F           T           T           T           T           F           F                       ) # OPENMP     
set MPI       = ( T           T           T             T           T           T              T           T           F           T           T           T           T           T           T           T           T           T           T           T           T           T           T                       ) # MPI        
set NEST      = ( 1           1           1             1           1           1              3           1           0           1           1           1           1           1           1           1           1           1           1           1           1           1           1                       ) # NEST       
set NAME      = ( em          chem        qss           bwave       real8       qss8           move        fire        hill        em          em          em          em          em          em          em          em          em          em          em          em          em          kpp                     ) # NAME       
set COMPILE   = ( em_real     em_real     em_quarter_ss em_b_wave   em_real     em_quarter_ss  em_real     em_fire     em_hill2d_x em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real     em_real                 ) # COMPILE    
set RUNDIR    = ( em_real     em_chem     em_quarter_ss em_b_wave   em_real8    em_quarter_ss8 em_move     em_fire     em_hill2d_x em_realA    em_realB    em_realC    em_realD    em_realE    em_realF    em_realG    em_realH    em_realI    em_realJ    em_realK    em_realL    em_realM    em_chem_kpp             ) # RUNDIR     
set DASHOPT1  = ( -d          -d          -d            -d          -d          -d             -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d          -d                      ) # DASHOPT1   
set DASHOPT2  = ( F           F           F             F           -r8         -r8            F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F                       ) # DASHOPT2   
set BUILDENV1 = ( F           WRF_CHEM=1  F             F           F           F              F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           WRF_CHEM=1              ) # BUILDENV1  
set BUILDENV2 = ( J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS   J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS    J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS J=-j@$PROCS             ) # BUILDENV2  
set BUILDENV3 = ( F           F           F             F           F           F              F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           WRF_KPP=1               ) # BUILDENV3  
set BUILDENV4 = ( F           F           F             F           F           F              F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           FLEX_LIB_DIR=/usr/lib64 ) # BUILDENV4  
set BUILDENV5 = ( F           F           F             F           F           F              F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           YACC=/usr/bin/yacc@-d   ) # BUILDENV5  
set SERIALBG  = ( F           F           F             F           F           F              F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F           F                       ) # SERIALBG   
set NP        = ( $PROCS      $PROCS      $PROCS        $PROCS      $PROCS      $PROCS         $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS      $PROCS                  ) # NP         
set FEATURE   = ( FALSE       FALSE       FALSE         FALSE       FALSE       FALSE          FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       FALSE       TRUE        FALSE                   ) # FEATURE    


set SERIAL_OPT = 32
set OPENMP_OPT = 33
set    MPI_OPT = 34

#	Info to determine if we eventually accomplish what we originally intended.

set NUM_TESTS = ${#TEST}

set NUM_BUILDS = 0
set count = 0
while ( $count < $NUM_TESTS )
	@ count ++
	if ( $SERIAL[$count] == T ) @ NUM_BUILDS ++
	if ( $OPENMP[$count] == T ) @ NUM_BUILDS ++
	if (    $MPI[$count] == T ) @ NUM_BUILDS ++
end

set NUM_COMPARISONS = 0
set count = 0
while ( $count < $NUM_TESTS )
	@ count ++
	if ( ( $SERIAL[$count] == T ) && ( $OPENMP[$count] == T ) ) then
		set temp = `echo $TEST[$count] | wc -w`
		@ temp --
		@ NUM_COMPARISONS = $NUM_COMPARISONS + $temp
	endif
	if ( ( $SERIAL[$count] == T ) && (    $MPI[$count] == T ) ) then
		set temp = `echo $TEST[$count] | wc -w`
		@ temp --
		@ NUM_COMPARISONS = $NUM_COMPARISONS + $temp
	endif
end

set NUM_SIMS = 0
set count = 0
while ( $count < $NUM_TESTS )
	@ count ++
	if ( $SERIAL[$count] == T ) then
		set temp = `echo $TEST[$count] | wc -w`
		@ temp --
		@ NUM_SIMS = $NUM_SIMS + $temp
	endif
	if ( $OPENMP[$count] == T ) then
		set temp = `echo $TEST[$count] | wc -w`
		@ temp --
		@ NUM_SIMS = $NUM_SIMS + $temp
	endif
	if (    $MPI[$count] == T ) then
		set temp = `echo $TEST[$count] | wc -w`
		@ temp --
		@ NUM_SIMS = $NUM_SIMS + $temp
	endif
end

echo "                                                                                              " >  email_01.txt
echo " WRF Scala Jenkins AWS Automated GitHub Testing                                               " >> email_01.txt
echo " ==============================================                                               " >> email_01.txt
echo " Number of Tests        : $NUM_TESTS                                                          " >> email_01.txt
echo " Number of Builds       : $NUM_BUILDS                                                         " >> email_01.txt
echo " Number of Simulations  : $NUM_SIMS                                                           " >> email_01.txt
echo " Number of Comparisons  : $NUM_COMPARISONS                                                    " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 1. Download wrf_output.zip                                                                   " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 2. Remove previous output_testcase directory                                                 " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 3. Decompress file:                                                                          " >> email_01.txt
echo "      unzip wrf_output.zip                                                                    " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 4. Go to output_testcase directory                                                           " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 5. Check files for Number of Tests                                                           " >> email_01.txt
echo '      ls -1 | grep output_ | wc -l                                                            ' >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 6. Check files for Number of Builds                                                          " >> email_01.txt
echo '      grep -a " START" output_* | grep -av "CLEAN START" | grep -av "SIMULATION START" | grep -av "LOG START" | wc -l  ' >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo ' 7. Check files for Number of Executables (2 * # Builds)                                      ' >> email_01.txt
echo '      grep -aw wrfuser output_* | grep -aw wrf | grep -a "WRF/main/" | grep -a ".exe" | wc -l' >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 8. Check files for Number of Simulations                                                     " >> email_01.txt
echo '      grep -a " = STATUS" output_* | wc -l                                                    ' >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo " 9. Number of FAILed Simulations (should = 0)                                                 " >> email_01.txt
echo '      grep -a " = STATUS" output_* | grep -av "0 = STATUS" | wc -l                            ' >> email_01.txt
echo "    If there is a FAILed Simulation, which FAILed?                                            " >> email_01.txt
echo '      grep -a " = STATUS" output_* | grep -av "0 = STATUS"                                    ' >> email_01.txt
echo "    What are the namelist / IC specifics of a FAILed case?                                    " >> email_01.txt
echo "      wget https://www2.mmm.ucar.edu/wrf/dave/nml.tar.gz                                      " >> email_01.txt
echo "      wget https://www2.mmm.ucar.edu/wrf/dave/data_smaller.tar.gz                             " >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo "10. Check files for Number of Comparisons                                                     " >> email_01.txt
echo '      grep -a "status = " output_* | wc -l                                                    ' >> email_01.txt
echo "                                                                                              " >> email_01.txt
echo "11. Number of Comparisons not bit-for-bit (should = 0)                                        " >> email_01.txt
echo '      grep -a "status = " output_* | grep -av "status = 0" | wc -l                            ' >> email_01.txt
echo "    If there is a FAILed bit-for bit, which FAILed?                                           " >> email_01.txt
echo '      grep -a "status = " output_* | grep -av "status = 0"                                    ' >> email_01.txt
echo "                                                                                              " >> email_01.txt

#	The docker image needs to be constructed. 

if ( -e single_init.csh ) rm single_init.csh
touch single_init.csh
chmod +x single_init.csh
echo '#\!/bin/csh' >> single_init.csh
echo "#####################   TOP OF JOB    #####################" >> single_init.csh
echo "" >> single_init.csh
echo "#	This script builds the docker image for the rest of the testing harness " >> single_init.csh
echo "" >> single_init.csh
echo "#	The mandatory input argument is the name of the Dockerfile" >> single_init.csh
echo '#	If the name is "Dockerfile", the ARW code is run' >> single_init.csh
echo "" >> single_init.csh
echo "date" >> single_init.csh
echo "set SHARED = $SHARED" >> single_init.csh
echo 'if ( ! -d ${SHARED}/OUTPUT ) mkdir ${SHARED}/OUTPUT' >> single_init.csh
echo 'chmod -R 777 ${SHARED}/OUTPUT' >> single_init.csh
echo "" >> single_init.csh
echo "date" >> single_init.csh
echo 'set num_containers = `docker ps -a | wc -l`' >> single_init.csh
echo 'if ( $num_containers > 1 ) then' >> single_init.csh
echo '	set hash = `docker ps -a | sed -n 2,${num_containers}p | ' "awk '{print " '$1}' "'" '`' >>  single_init.csh
echo '#	docker rm $hash' >> single_init.csh
echo "endif" >> single_init.csh
echo "" >> single_init.csh
echo 'set num_images = `docker images | wc -l`' >> single_init.csh
echo 'if ( $num_images > 1 ) then' >> single_init.csh
echo '	set hash = `docker images | sed -n 2,${num_images}p | ' "awk '{print " '$3}' "'" '`' >>  single_init.csh
echo '#	docker rmi --force $hash' >> single_init.csh
echo "endif" >> single_init.csh
echo "" >> single_init.csh
echo "date" >> single_init.csh
echo "if ( -d ${DROPIT}/Namelists ) then" >> single_init.csh
echo "	cp -pr ${DROPIT}/Namelists ." >> single_init.csh
echo "	tar -cf nml.tar Namelists" >> single_init.csh
echo "	sed -e 's/#ADD/ADD/' Dockerfile > .foo" >> single_init.csh
echo "	mv .foo Dockerfile" >> single_init.csh
echo "endif" >> single_init.csh
echo "" >> single_init.csh
echo '#	-f $1 = name of the Dockerfile' >> single_init.csh
echo '#	-t $2 = name of the generated docker image' >> single_init.csh
echo "" >> single_init.csh
#echo 'docker build -f $1 -t $2 --build-arg argname=feature_tests .' >> single_init.csh
echo 'docker build -f $1 -t $2 .' >> single_init.csh
echo "date" >> single_init.csh
echo "" >> single_init.csh
echo "#####################   END OF JOB    #####################" >> single_init.csh
echo "Run ./single_init.csh"

#	The docker image needs to be removed

if ( -e single_end.csh ) rm single_end.csh
touch single_end.csh
chmod +x single_end.csh
echo '#\!/bin/csh' >> single_end.csh
echo "#####################   TOP OF JOB    #####################" >> single_end.csh
echo "" >> single_end.csh
echo "#	This script removes the docker image and" >> single_end.csh
echo "#	does some seasonal pruning" >> single_end.csh
echo "" >> single_end.csh
echo "date" >> single_end.csh
echo '#docker rmi $1' >> single_end.csh
echo "set hash = "'`'"docker images | grep davegill |  awk '{print  " '$3' "}'" ' `' >> single_end.csh
echo '#docker rmi --force $hash' >> single_end.csh
echo "docker volume prune -f" >> single_end.csh
echo "docker system df" >> single_end.csh
echo "date" >> single_end.csh
echo "" >> single_end.csh
echo "#####################   END OF JOB    #####################" >> single_end.csh

#	Build each of the scripts: serial, openmp, then mpi.

set COUNT = 1
foreach n ( $NUMBER )
	foreach p ( SERIAL OPENMP MPI )
		set string = ( docker exec )
		if      ( $p == SERIAL ) then
			if      ( ( $SERIAL[$COUNT] == T ) && ( $SERIALBG[$COUNT] == T ) ) then
				set test_suffix = s
				set fname = test_0${n}${test_suffix}.csh
				if ( -e $fname ) rm $fname
				touch $fname
				chmod +x $fname
				echo "Run ./$fname"

				echo '#\!/bin/csh' >> $fname
				echo "#####################   TOP OF JOB    #####################" >> $fname
				echo "touch $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "echo TEST CASE = test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "set SHARED = $SHARED" >> $fname
				echo "#	Build: case = $NAME[$COUNT], SERIAL" >> $fname
				set string = ( $string '$test' ./script.csh BUILD CLEAN $SERIAL_OPT $NEST[$COUNT] $COMPILE[$COUNT] )
				if ( "$DASHOPT1[$COUNT]" == "F" ) then
					set str = ""
				else
					set str = $DASHOPT1[$COUNT]
				endif
				if ( "$DASHOPT2[$COUNT]" != "F" ) then
					set str = ( $str $DASHOPT2[$COUNT] )
				endif
				set string = ( $string $str )
				if ( $BUILDENV1[$COUNT] == F ) then
					set str = ""
				else
					set str = $BUILDENV1[$COUNT]
				endif
				set string = ( $string $str )

				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] )" >> $fname
				echo "	set test = test_0${n}${test_suffix}"'_$t' >> $fname
				echo "	date" >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto aSKIP_test_0${n}${test_suffix}" >> $fname
				echo "	date" >> $fname
				echo "	echo Build container for" '$test' >> $fname
				echo "	#docker run -it --name" '$test -v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest /bin/tcsh' >> $fname
				echo "	#docker exec -it " '$test /bin/tcsh' >> $fname
				echo "	#docker start -ai " '$test' >> $fname
				echo "	docker run -d -t --name" '$test -v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest' >> $fname
				echo "	date" >> $fname
				echo "	echo Build WRF executable for" '$test' >> $fname
				echo "	( $string"' ) &' >> $fname
				echo "	date" >> $fname
				echo "aSKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname
				echo "echo waiting on BUILDs" >> $fname
				echo "wait" >> $fname
				echo "date" >> $fname

				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] )" >> $fname
				echo "	set test = test_0${n}${test_suffix}"'_$t' >> $fname
				echo "	date" >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto bSKIP_test_0${n}${test_suffix}" >> $fname
				echo "	date" >> $fname
				echo "	echo '======================================================================'" >> $fname
				echo "	echo RUN WRF" '$test' "for $COMPILE[$COUNT] $SERIAL_OPT $RUNDIR[$COUNT], NML = " '$t' >> $fname
				echo "	( docker exec" '$test' "./script.csh RUN $COMPILE[$COUNT] $SERIAL_OPT $RUNDIR[$COUNT]" '$t ) &' >> $fname
				echo "bSKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname
				echo "echo waiting on RUNs" >> $fname
				echo "wait" >> $fname
				echo "date" >> $fname

				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] )" >> $fname
				echo "	set test = test_0${n}${test_suffix}"'_$t' >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto cSKIP_test_0${n}${test_suffix}" >> $fname
				echo "	date" >> $fname

				echo "	docker exec" '$test ls -ls WRF/main/wrf.exe' >> $fname
				echo '	set OK_WRF = $status' >> $fname
				if      ( $COMPILE[$COUNT] == nmm_real ) then
					echo "	docker exec" '$test ls -ls WRF/main/real_nmm.exe' >> $fname
					echo '	set OK_PRE = $status' >> $fname
				else if ( $COMPILE[$COUNT] == em_real ) then
					echo "	docker exec" '$test ls -ls WRF/main/real.exe' >> $fname
					echo '	set OK_PRE = $status' >> $fname
				else
					echo "	docker exec" '$test ls -ls WRF/main/ideal.exe' >> $fname
					echo '	set OK_PRE = $status' >> $fname
				endif
				echo '	if ( ( $OK_WRF == 0 ) && ( $OK_PRE == 0 ) && ( $TCOUNT == 2 ) ) then' >> $fname
				echo '		echo "SUCCESSFUL BUILD"' >> $fname
				echo "		docker exec" '$test' "ls -ls wrfoutput | grep _BUILD_ | grep $COMPILE[$COUNT]_${SERIAL_OPT} " >> $fname
				echo '	else if ( $TCOUNT == 2 ) then' >> $fname
				echo '		echo "FAILED BUILD LOG START"' >> $fname
				echo "		docker exec test_0${n}${test_suffix} cat WRF/compile.log.$COMPILE[$COUNT].${SERIAL_OPT}" >> $fname
				echo '		echo "FAILED BUILD LOG END"' >> $fname
				echo '	endif' >> $fname
				echo "	date" >> $fname

				echo "	echo 'PRE-PROC OUTPUT' " >> $fname
				echo "	docker exec" '$test' "cat WRF/test/$COMPILE[$COUNT]/real.print.out " >> $fname
				echo "	echo 'MODEL OUTPUT' " >> $fname
				echo "	docker exec" '$test' "cat WRF/test/$COMPILE[$COUNT]/wrf.print.out " >> $fname
				echo "	" >> $fname
				echo "	docker exec" '$test' "ls -ls WRF/test/$COMPILE[$COUNT] | grep wrfout " >> $fname
				echo "	docker exec" '$test' "ls -ls wrfoutput | grep _RUN_ | grep $COMPILE[$COUNT]_${SERIAL_OPT}_$RUNDIR[$COUNT]_"'$t ' >> $fname
				echo "	" >> $fname

				echo "	docker stop" '$test' >> $fname
				echo "	date" >> $fname
				echo "	docker rm" '$test' >> $fname
				echo "	date" >> $fname
				echo "cSKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname

				echo "touch $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "mv $DROPIT/DOING_NOW_test_0${n}${test_suffix} $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "#####################   END OF JOB    #####################" >> $fname

			else if ( ( $SERIAL[$COUNT] == T ) && ( $SERIALBG[$COUNT] == F ) ) then
				set test_suffix = s
				set fname = test_0${n}${test_suffix}.csh
				if ( -e $fname ) rm $fname
				touch $fname
				chmod +x $fname
				echo "Run ./$fname"
				echo '#\!/bin/csh' >> $fname
				echo "#####################   TOP OF JOB    #####################" >> $fname
				echo "touch $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "echo TEST CASE = test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "set SHARED = $SHARED" >> $fname
				echo "#	Build: case = $NAME[$COUNT], SERIAL" >> $fname
				set string = ( $string test_0${n}${test_suffix} ./script.csh BUILD CLEAN $SERIAL_OPT $NEST[$COUNT] $COMPILE[$COUNT] )
				if ( "$DASHOPT1[$COUNT]" == "F" ) then
					set str = ""
				else
					set str = $DASHOPT1[$COUNT]
				endif
				if ( "$DASHOPT2[$COUNT]" != "F" ) then
					set str = ( $str $DASHOPT2[$COUNT] )
				endif
				set string = ( $string $str )
				if ( $BUILDENV1[$COUNT] == F ) then
					set str = ""
				else
					set str = $BUILDENV1[$COUNT]
				endif
				if ( $BUILDENV2[$COUNT] != F ) then
					set str = ( $str $BUILDENV2[$COUNT] )
				endif
				if ( $BUILDENV3[$COUNT] != F ) then
					set str = ( $str $BUILDENV3[$COUNT] )
				endif
				if ( $BUILDENV4[$COUNT] != F ) then
					set str = ( $str $BUILDENV4[$COUNT] )
				endif
				if ( $BUILDENV5[$COUNT] != F ) then
					set str = ( $str $BUILDENV5[$COUNT] )
				endif
				set string = ( $string $str )

				echo "echo Build container" >> $fname
				echo "#docker run -it --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest /bin/tcsh' >> $fname
				echo "#docker exec -it test_0${n}${test_suffix} /bin/tcsh" >> $fname
				echo "#docker start -ai test_0${n}${test_suffix}" >> $fname
				echo "docker run -d -t --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest' >> $fname
				echo "date" >> $fname
				echo "echo Build WRF executable" >> $fname
				echo $string >> $fname
				echo "date" >> $fname
				echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/wrf.exe" >> $fname
				echo 'set OK_WRF = $status' >> $fname
				if      ( $COMPILE[$COUNT] == nmm_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real_nmm.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else if ( $COMPILE[$COUNT] == em_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/ideal.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				endif
				echo 'if ( ( $OK_WRF == 0 ) && ( $OK_PRE == 0 ) ) then' >> $fname
				echo '	echo "SUCCESSFUL BUILD"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _BUILD_ | grep $COMPILE[$COUNT]_${SERIAL_OPT} " >> $fname
				echo 'else' >> $fname
				echo '	echo "FAILED BUILD LOG START"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/compile.log.$COMPILE[$COUNT].${SERIAL_OPT}" >> $fname
				echo '	echo "FAILED BUILD LOG END"' >> $fname
				echo 'endif' >> $fname
				echo "date" >> $fname
				echo " " >> $fname

				set D = $DROPIT/Namelists/weekly/$RUNDIR[$COUNT]
				if ( -d $D ) then
				        find $D -name namelist.input\* -exec ls -1 {} \; >& .foo1
	        			set EXTRAS = `cat .foo1 | sed 's/^.*\.//' | sort -u`
					rm .foo1
				else
				        set EXTRAS = " "
				endif
				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] $EXTRAS )" >> $fname
				echo "	date" >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto SKIP_test_0${n}${test_suffix}" >> $fname
				echo "	echo '======================================================================'" >> $fname
				echo "	echo RUN WRF test_0${n}${test_suffix} for $COMPILE[$COUNT] $SERIAL_OPT $RUNDIR[$COUNT], NML = " '$t' >> $fname
				echo "	docker exec test_0${n}${test_suffix} ./script.csh RUN $COMPILE[$COUNT] $SERIAL_OPT $RUNDIR[$COUNT]" '$t' >> $fname
        			echo '	set OK = $status' >> $fname
				echo '	echo $OK =' "STATUS test_0${n}${test_suffix} $NAME[$COUNT] $COMPILE[$COUNT] $SERIAL_OPT" '$t' >> $fname
				echo "	date" >> $fname
				echo "	" >> $fname
				echo "	echo 'PRE-PROC OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/real.print.out " >> $fname
				echo "	echo 'MODEL OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/wrf.print.out " >> $fname
				echo "	" >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls WRF/test/$COMPILE[$COUNT] | grep wrfout " >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _RUN_ | grep $COMPILE[$COUNT]_${SERIAL_OPT}_$RUNDIR[$COUNT]_"'$t ' >> $fname
				echo "	date" >> $fname
				echo "SKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname
				echo "docker stop test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "docker rm test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "touch $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "mv $DROPIT/DOING_NOW_test_0${n}${test_suffix} $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "#####################   END OF JOB    #####################" >> $fname

			else
				goto SKIP_THIS_ONE
			endif

		else if ( $p == OPENMP ) then
			if ( $OPENMP[$COUNT] == T ) then
				set test_suffix = o
				set fname = test_0${n}${test_suffix}.csh
				if ( -e $fname ) rm $fname
				touch $fname
				chmod +x $fname
				echo "Run ./$fname"
				echo '#\!/bin/csh' >> $fname
				echo "#####################   TOP OF JOB    #####################" >> $fname
				echo "touch $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "echo TEST CASE = test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "set SHARED = $SHARED" >> $fname
				echo "#	Build: case = $NAME[$COUNT], OPENMP" >> $fname
				set string = ( $string test_0${n}${test_suffix} ./script.csh BUILD CLEAN $OPENMP_OPT $NEST[$COUNT] $COMPILE[$COUNT] )
				if ( "$DASHOPT1[$COUNT]" == "F" ) then
					set str = ""
				else
					set str = $DASHOPT1[$COUNT]
				endif
				if ( "$DASHOPT2[$COUNT]" != "F" ) then
					set str = ( $str $DASHOPT2[$COUNT] )
				endif
				set string = ( $string $str )
				if ( $BUILDENV1[$COUNT] == F ) then
					set str = ""
				else
					set str = $BUILDENV1[$COUNT]
				endif
				if ( $BUILDENV2[$COUNT] != F ) then
					set str = ( $str $BUILDENV2[$COUNT] )
				endif
				if ( $BUILDENV3[$COUNT] != F ) then
					set str = ( $str $BUILDENV3[$COUNT] )
				endif
				if ( $BUILDENV4[$COUNT] != F ) then
					set str = ( $str $BUILDENV4[$COUNT] )
				endif
				if ( $BUILDENV5[$COUNT] != F ) then
					set str = ( $str $BUILDENV5[$COUNT] )
				endif
				set string = ( $string $str )

				echo "echo Build container" >> $fname
				echo "#docker run -it --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest /bin/tcsh' >> $fname
				echo "#docker exec -it test_0${n}${test_suffix} /bin/tcsh" >> $fname
				echo "#docker start -ai test_0${n}${test_suffix}" >> $fname
				echo "docker run -d -t --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest' >> $fname
				echo "date" >> $fname
				echo "echo Build WRF executable" >> $fname
				echo $string >> $fname
				echo "date" >> $fname
				echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/wrf.exe" >> $fname
				echo 'set OK_WRF = $status' >> $fname
				if      ( $COMPILE[$COUNT] == nmm_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real_nmm.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else if ( $COMPILE[$COUNT] == em_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/ideal.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				endif
				echo 'if ( ( $OK_WRF == 0 ) && ( $OK_PRE == 0 ) ) then' >> $fname
				echo '	echo "SUCCESSFUL BUILD"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _BUILD_ | grep $COMPILE[$COUNT]_${OPENMP_OPT} " >> $fname
				echo 'else' >> $fname
				echo '	echo "FAILED BUILD LOG START"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/compile.log.$COMPILE[$COUNT].${OPENMP_OPT}" >> $fname
				echo '	echo "FAILED BUILD LOG END"' >> $fname
				echo 'endif' >> $fname
				echo "date" >> $fname
				echo " " >> $fname

				set D = $DROPIT/Namelists/weekly/$RUNDIR[$COUNT]
				if ( -d $D ) then
				        find $D -name namelist.input\* -exec ls -1 {} \; >& .foo1
	        			set EXTRAS = `cat .foo1 | sed 's/^.*\.//' | sort -u`
					rm .foo1
				else
				        set EXTRAS = " "
				endif
				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] $EXTRAS )" >> $fname
				echo "	date" >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto SKIP_test_0${n}${test_suffix}" >> $fname
				echo "	echo '======================================================================'" >> $fname
				echo "	echo RUN WRF test_0${n}${test_suffix} for $COMPILE[$COUNT] $OPENMP_OPT $RUNDIR[$COUNT], NML = " '$t' >> $fname
				echo "	docker exec test_0${n}${test_suffix} ./script.csh RUN $COMPILE[$COUNT] $OPENMP_OPT $RUNDIR[$COUNT]" '$t' "OMP_NUM_THREADS=$NP[$COUNT]" >> $fname
        			echo '	set OK = $status' >> $fname
				echo '	echo $OK =' "STATUS test_0${n}${test_suffix} $NAME[$COUNT] $COMPILE[$COUNT] $OPENMP_OPT" '$t' >> $fname
				echo "	date" >> $fname
				echo "	" >> $fname
				echo "	echo 'PRE-PROC OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/real.print.out " >> $fname
				echo "	echo 'MODEL OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/wrf.print.out " >> $fname
				echo "	" >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls WRF/test/$COMPILE[$COUNT] | grep wrfout " >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _RUN_ | grep $COMPILE[$COUNT]_${OPENMP_OPT}_$RUNDIR[$COUNT]_"'$t ' >> $fname
				echo "	date" >> $fname
				echo "SKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname
				echo "docker stop test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "docker rm test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "touch $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "mv $DROPIT/DOING_NOW_test_0${n}${test_suffix} $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "#####################   END OF JOB    #####################" >> $fname

			else
				goto SKIP_THIS_ONE
			endif

		else if ( $p == MPI    ) then
			if (    $MPI[$COUNT] == T ) then
				set test_suffix = m
				set fname = test_0${n}${test_suffix}.csh
				if ( -e $fname ) rm $fname
				touch $fname
				chmod +x $fname
				echo "Run ./$fname"
				echo '#\!/bin/csh' >> $fname
				echo "#####################   TOP OF JOB    #####################" >> $fname
				echo "touch $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/DOING_NOW_test_0${n}${test_suffix}" >> $fname
				echo "echo TEST CASE = test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "set SHARED = $SHARED" >> $fname
				echo "#	Build: case = $NAME[$COUNT], MPI" >> $fname
				set string = ( $string test_0${n}${test_suffix} ./script.csh BUILD CLEAN    $MPI_OPT $NEST[$COUNT] $COMPILE[$COUNT] )
				if ( "$DASHOPT1[$COUNT]" == "F" ) then
					set str = ""
				else
					set str = $DASHOPT1[$COUNT]
				endif
				if ( "$DASHOPT2[$COUNT]" != "F" ) then
					set str = ( $str $DASHOPT2[$COUNT] )
				endif
				set string = ( $string $str )
				if ( $BUILDENV1[$COUNT] == F ) then
					set str = ""
				else
					set str = $BUILDENV1[$COUNT]
				endif
				if ( $BUILDENV2[$COUNT] != F ) then
					set str = ( $str $BUILDENV2[$COUNT] )
				endif
				if ( $BUILDENV3[$COUNT] != F ) then
					set str = ( $str $BUILDENV3[$COUNT] )
				endif
				if ( $BUILDENV4[$COUNT] != F ) then
					set str = ( $str $BUILDENV4[$COUNT] )
				endif
				if ( $BUILDENV5[$COUNT] != F ) then
					set str = ( $str $BUILDENV5[$COUNT] )
				endif
				set string = ( $string $str )

				echo "echo Build container" >> $fname
				echo "#docker run -it --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest /bin/tcsh' >> $fname
				echo "#docker exec -it test_0${n}${test_suffix} /bin/tcsh" >> $fname
				echo "#docker start -ai test_0${n}${test_suffix}" >> $fname
				echo "docker run -d -t --name test_0${n}${test_suffix} " '-v $SHARED/OUTPUT:/wrf/wrfoutput wrf_regtest' >> $fname
				echo "date" >> $fname
				echo "echo Build WRF executable" >> $fname
				echo $string >> $fname
				echo "date" >> $fname
				echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/wrf.exe" >> $fname
				echo 'set OK_WRF = $status' >> $fname
				if      ( $COMPILE[$COUNT] == nmm_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real_nmm.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else if ( $COMPILE[$COUNT] == em_real ) then
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/real.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				else
					echo "docker exec test_0${n}${test_suffix} ls -ls WRF/main/ideal.exe" >> $fname
					echo 'set OK_PRE = $status' >> $fname
				endif
				echo 'if ( ( $OK_WRF == 0 ) && ( $OK_PRE == 0 ) ) then' >> $fname
				echo '	echo "SUCCESSFUL BUILD"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _BUILD_ | grep $COMPILE[$COUNT]_${MPI_OPT} " >> $fname
				echo 'else' >> $fname
				echo '	echo "FAILED BUILD LOG START"' >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/compile.log.$COMPILE[$COUNT].${MPI_OPT}" >> $fname
				echo '	echo "FAILED BUILD LOG END"' >> $fname
				echo 'endif' >> $fname
				echo "date" >> $fname
				echo " " >> $fname

				set D = $DROPIT/Namelists/weekly/$RUNDIR[$COUNT]
				if ( -d $D ) then
				        find $D -name namelist.input\* -exec ls -1 {} \; >& .foo1
	        			set EXTRAS = `cat .foo1 | sed 's/^.*\.//' | sort -u`
					rm .foo1
				else
				        set EXTRAS = " "
				endif
				echo "set TCOUNT = 1" >> $fname
				echo "foreach t ( $TEST[$COUNT] $EXTRAS )" >> $fname
				echo "	date" >> $fname
				echo '	if ( $TCOUNT == 1 ) ' "goto SKIP_test_0${n}${test_suffix}" >> $fname
				echo "	echo '======================================================================'" >> $fname
				echo "	echo RUN WRF test_0${n}${test_suffix} for $COMPILE[$COUNT] $MPI_OPT $RUNDIR[$COUNT], NML = " '$t' >> $fname
				if ( ( $RUNDIR[$COUNT] == em_real  ) || \
				     ( $RUNDIR[$COUNT] == em_realA ) || \
				     ( $RUNDIR[$COUNT] == em_realB ) || \
				     ( $RUNDIR[$COUNT] == em_realC ) || \
				     ( $RUNDIR[$COUNT] == em_realD ) || \
				     ( $RUNDIR[$COUNT] == em_realE ) || \
				     ( $RUNDIR[$COUNT] == em_realF ) || \
				     ( $RUNDIR[$COUNT] == em_realG ) || \
				     ( $RUNDIR[$COUNT] == em_realH ) || \
				     ( $RUNDIR[$COUNT] == em_realI ) || \
				     ( $RUNDIR[$COUNT] == em_realJ ) || \
				     ( $RUNDIR[$COUNT] == em_realK ) || \
				     ( $RUNDIR[$COUNT] == em_realL ) || \
				     ( $RUNDIR[$COUNT] == em_realM ) || \
				     ( $RUNDIR[$COUNT] == em_real8 ) ) then
					echo '	set is_nest = `echo $t | rev | cut -c 1-2 | rev`' >> $fname
					echo '	if ( ( $is_nest == NE ) || ( $is_nest == VN ) ) then' >> $fname
					echo "		docker exec test_0${n}${test_suffix} ./script.csh RUN $COMPILE[$COUNT] $MPI_OPT $RUNDIR[$COUNT]" '$t' "NP=9" >> $fname
	        			echo '		set OK = $status' >> $fname
					echo '	else' >> $fname
					echo "		docker exec test_0${n}${test_suffix} ./script.csh RUN $COMPILE[$COUNT] $MPI_OPT $RUNDIR[$COUNT]" '$t' "NP=$NP[$COUNT]" >> $fname
	        			echo '		set OK = $status' >> $fname
					echo '	endif' >> $fname
				else
					echo "	docker exec test_0${n}${test_suffix} ./script.csh RUN $COMPILE[$COUNT] $MPI_OPT $RUNDIR[$COUNT]" '$t' "NP=$NP[$COUNT]" >> $fname
					echo '	set OK = $status' >> $fname
				endif
				echo '	echo $OK =' "STATUS test_0${n}${test_suffix} $NAME[$COUNT] $COMPILE[$COUNT] $MPI_OPT" '$t' >> $fname
				echo "	date" >> $fname
				echo "	" >> $fname
				echo "	echo 'PRE-PROC OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/real.print.out " >> $fname
				echo "	echo 'MODEL OUTPUT' " >> $fname
				echo "	docker exec test_0${n}${test_suffix} cat WRF/test/$COMPILE[$COUNT]/rsl.out.0000 " >> $fname
				echo "	" >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls WRF/test/$COMPILE[$COUNT] | grep wrfout " >> $fname
				echo "	docker exec test_0${n}${test_suffix} ls -ls wrfoutput | grep _RUN_ | grep $COMPILE[$COUNT]_${MPI_OPT}_$RUNDIR[$COUNT]_"'$t ' >> $fname
				echo "	date" >> $fname
				echo "SKIP_test_0${n}${test_suffix}:" >> $fname
				echo '	@ TCOUNT ++' >> $fname
				echo "end" >> $fname
				echo "date" >> $fname
				echo "docker stop test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "docker rm test_0${n}${test_suffix}" >> $fname
				echo "date" >> $fname
				echo "touch $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "chmod 666 $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "mv $DROPIT/DOING_NOW_test_0${n}${test_suffix} $DROPIT/COMPLETE_test_0${n}${test_suffix}" >> $fname
				echo "#####################   END OF JOB    #####################" >> $fname

			else
				goto SKIP_THIS_ONE
			endif
		endif

SKIP_THIS_ONE:
		set string = ""
	end

	@ COUNT ++
end

if ( -e last_only_once.csh ) rm last_only_once.csh
touch last_only_once.csh
chmod +x last_only_once.csh
echo '#\!/bin/csh' >> last_only_once.csh
echo "" >> last_only_once.csh
echo "#####################   TOP OF JOB    #####################" >> last_only_once.csh
echo "" >> last_only_once.csh
echo "date" >> last_only_once.csh
echo "" >> last_only_once.csh
echo "#	This compares serial vs openmp and serial vs mpi results" >> last_only_once.csh
echo "#	Run this script ONLY once" >> last_only_once.csh
echo "#	This job runs outside of a container" >> last_only_once.csh
echo "#	All test cases of all builds must finish first" >> last_only_once.csh
echo "" >> last_only_once.csh
echo "echo 'Current Working Directory'" >> last_only_once.csh
echo "pwd" >> last_only_once.csh
echo "" >> last_only_once.csh
echo "echo 'LISTING OF FILES'" >> last_only_once.csh
echo "ls -lsR" >> last_only_once.csh
echo "" >> last_only_once.csh
echo 'cd $1 >& /dev/null' >> last_only_once.csh
echo "" >> last_only_once.csh
set COUNT = 1
foreach n ( $NUMBER )

	set root1_file = SUCCESS_RUN_WRF

	set root2_file_s = $COMPILE[$COUNT]_${SERIAL_OPT}_$RUNDIR[$COUNT]
	set root2_file_o = $COMPILE[$COUNT]_${OPENMP_OPT}_$RUNDIR[$COUNT]
	set root2_file_m = $COMPILE[$COUNT]_${MPI_OPT}_$RUNDIR[$COUNT]

	set D = $DROPIT/Namelists/weekly/$RUNDIR[$COUNT]
	if ( -d $D ) then
	        find $D -name namelist.input\* -exec ls -1 {} \; >& .foo1
	        set EXTRAS = `cat .foo1 | sed 's/^.*\.//' | sort -u`
		rm .foo1
	else
	        set EXTRAS = " "
	endif
	set TCOUNT = 0
	foreach t ( $TEST[$COUNT] $EXTRAS )
		@ TCOUNT ++
		if ( $TCOUNT == 1 ) goto SKIP_THIS_TEST
		if ( ( $SERIAL[$COUNT] == T ) && ( $OPENMP[$COUNT] == T ) ) then
			foreach d ( d01 d02 d03 )
				set file1 = ${root1_file}_${d}_${root2_file_s}_$t
				set file2 = ${root1_file}_${d}_${root2_file_o}_$t
				echo "if ( ( -e $file1 ) && ( -e $file2 ) ) then" >> last_only_once.csh
				echo "	diff -q $file1 $file2" >> last_only_once.csh
				echo '	set OK = $status' >> last_only_once.csh
				echo "	echo $file1 vs $file2 status =" '$OK' >> last_only_once.csh
				echo "endif" >> last_only_once.csh
				echo "" >> last_only_once.csh
			end
		endif

		if ( ( $SERIAL[$COUNT] == T ) && (    $MPI[$COUNT] == T ) ) then
			foreach d ( d01 d02 d03 )
				set file1 = ${root1_file}_${d}_${root2_file_s}_$t
				set file2 = ${root1_file}_${d}_${root2_file_m}_$t
				echo "if ( ( -e $file1 ) && ( -e $file2 ) ) then" >> last_only_once.csh
				echo "	diff -q $file1 $file2" >> last_only_once.csh
				echo '	set OK = $status' >> last_only_once.csh
				echo "	echo $file1 vs $file2 status =" '$OK' >> last_only_once.csh
				echo "endif" >> last_only_once.csh
				echo "" >> last_only_once.csh
			end
		endif
SKIP_THIS_TEST:
	end

	@ COUNT ++
end
echo "" >> last_only_once.csh
echo "date" >> last_only_once.csh
echo "" >> last_only_once.csh
echo "#####################   END OF JOB    #####################" >> last_only_once.csh
echo "Run ./last_only_once.csh"




if ( -e part.sh ) then
	rm part.sh
endif
touch part.sh
echo "#########   Comparison.sh - autogenerated    ##############" >> part.sh
echo "" >> part.sh
echo "	# This compares both serial vs openmp and serial vs mpi results" >> part.sh
echo "" >> part.sh

set ALL = ${#NUMBER}
set FEWER = $ALL
@ FEWER --
set OVERALL_NUMBER_OF_TESTS = $ALL

echo "" >> part.sh

set INCR_FINE_GRAIN = ${#NUMBER}
set COUNT = 1
set n = 0
while ( $n < $OVERALL_NUMBER_OF_TESTS )
	set THIS_SERIAL = FALSE
	set THIS_OPENMP = FALSE
	set THIS_MPI    = FALSE

	set STRING1 = ""

	set root1_file = SUCCESS_RUN_WRF

	set root2_file_s = $COMPILE[$COUNT]_${SERIAL_OPT}_$RUNDIR[$COUNT]
	set root2_file_o = $COMPILE[$COUNT]_${OPENMP_OPT}_$RUNDIR[$COUNT]
	set root2_file_m = $COMPILE[$COUNT]_${MPI_OPT}_$RUNDIR[$COUNT]

	if     ( $SERIAL[$COUNT] == T ) then
		@ INCR_FINE_GRAIN ++
		set THIS_SERIAL = $INCR_FINE_GRAIN
		echo "	sudo -S unzip /tmp/raw_output/OUTPUT_output_${THIS_SERIAL}.zip -d /tmp/raw_output/OUTPUT_${COUNT}" >> part.sh
		set STRING1 = ( $STRING1 "/tmp/raw_output/output_${THIS_SERIAL}" )
		set STRING_SERIAL = "sudo -S ls -l /tmp/raw_output/OUTPUT_output_${INCR_FINE_GRAIN}/home/ubuntu/wrf-stuff/wrf-coop/OUTPUT | sudo tee -a /tmp/raw_output/final_output/output_$COUNT"
	endif
	if     ( $OPENMP[$COUNT] == T ) then
		@ INCR_FINE_GRAIN ++
		set THIS_OPENMP = $INCR_FINE_GRAIN
		echo "	sudo -S unzip /tmp/raw_output/OUTPUT_output_${THIS_OPENMP}.zip -d /tmp/raw_output/OUTPUT_${COUNT}" >> part.sh
		set STRING1 = ( $STRING1 "/tmp/raw_output/output_${THIS_OPENMP}" )
		set STRING_OPENMP = "sudo -S ls -l /tmp/raw_output/OUTPUT_output_${INCR_FINE_GRAIN}/home/ubuntu/wrf-stuff/wrf-coop/OUTPUT | sudo tee -a /tmp/raw_output/final_output/output_$COUNT"
	endif
	if     (    $MPI[$COUNT] == T ) then
		@ INCR_FINE_GRAIN ++
		set THIS_MPI    = $INCR_FINE_GRAIN
		echo "	sudo -S unzip /tmp/raw_output/OUTPUT_output_${THIS_MPI}.zip -d /tmp/raw_output/OUTPUT_${COUNT}" >> part.sh
		set STRING1 = ( $STRING1 "/tmp/raw_output/output_${THIS_MPI}"    )
		set STRING_MPI    = "sudo -S ls -l /tmp/raw_output/OUTPUT_output_${INCR_FINE_GRAIN}/home/ubuntu/wrf-stuff/wrf-coop/OUTPUT | sudo tee -a /tmp/raw_output/final_output/output_$COUNT"
	endif
	echo "	sudo -S cat $STRING1 | sudo tee -a /tmp/raw_output/final_output/output_$COUNT" >> part.sh
	echo "" >> part.sh
	if ( $THIS_SERIAL != FALSE ) then
		echo "	$STRING_SERIAL" >> part.sh
	endif
	if ( $THIS_OPENMP != FALSE ) then
		echo "	$STRING_OPENMP" >> part.sh
	endif
	if ( $THIS_MPI    != FALSE ) then
		echo "	$STRING_MPI   " >> part.sh
	endif
	echo "" >> part.sh

	echo "	./last_only_once.csh /tmp/raw_output/OUTPUT_${COUNT} | sudo tee -a /tmp/raw_output/final_output/output_${COUNT}" >> part.sh
	echo "" >> part.sh
	echo "" >> part.sh

	@ COUNT ++ 
	@ n ++
end
	
echo "###############   END OF SCRIPT INCLUSION   ###############" >> part.sh
