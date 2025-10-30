QUESTA := /home/share/questa.csh
SHELL := /bin/csh

IGNORE:
	make clean
	make view
 
.ONESHELL:
 
all:
	source $(QUESTA) 
	make clean 
	make compile 
	make simulate
 
main:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l top.log top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
 
read:
	source $(QUESTA)
	vcover report -details coverage.ucdb

view:
	firefox ./covReport/index.html
 
compile:
	vlog -sv top.sv
 
simulate:
	vsim -c top +UVM_VERBOSITY=UVM_MEDIUM -do "run -all;exit"
 
clean:
	rm -rf transcript work/
	rm simulation.log
	rm covReport/covsummary.html
	rm covReport/testlist.html
	rm coverage.ucdb
	rm dump.vcd
	rm top.log
	clear
