#------------------------------------------------------------------------------
#   Copyright 2010-2018 Mentor Graphics Corporation
#   All Rights Reserved Worldwide
#   Licensed under the Apache License, Version 2.0 (the
#   "License"); you may not use this file except in
#   compliance with the License.  You may obtain a copy of
#   the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in
#   writing, software distributed under the License is
#   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied.  See
#   the License for the specific language governing
#   permissions and limitations under the License.
#------------------------------------------------------------------------------
SIMFLAGS=-coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_HIGH
TOP=top

all: work build opt sim

tarball: clean_up tar

work:
	vlib work

build:
	vcom ../../../dut/HeMPS_defaults.vhd 
	vcom ../../../dut/Hermes_buffer.vhd
	vcom ../../../dut/Hermes_crossbar.vhd  
	vcom ../../../dut/Hermes_switchcontrol.vhd  
	vcom ../../../dut/RouterCC.vhd
	vlog -f tb.f

opt:
	vopt -o opt $(TOP) -debug +designfile

sim: opt
	vsim -c -do sim.do

smoke_test: 
	vsim -c -do "run -all" $(TOP) $(SIMFLAGS) +UVM_TESTNAME=smoke_test 

sequential_test: 
	vsim -c -do "run -all" $(TOP) $(SIMFLAGS) +UVM_TESTNAME=sequential_test 

main_test: 
	vsim -c -do "run -all" $(TOP) $(SIMFLAGS) +UVM_TESTNAME=main_test 

vis:
	visualizer design.bin qwave.db

clean_up:
	rm -rf work transcript *~ vsim.wlf *.log design.bin qwave.db *.tgz

tar:
	@(cd ../.. ;\
	tar -zcf generation/ex1_sequence_randomization/uvm_generation_seq_randomization.tgz \
	generation/common \
	generation/sequence_library \
	generation/tests \
	generation/ex1_sequence_randomization/Makefile \
	generation/ex1_sequence_randomization/README.txt; \
	cd generation/ex1_sequence_randomization)
