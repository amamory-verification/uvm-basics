
#if [file exists "work"] {vdel -all}
#vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom ../../../dut/HeMPS_defaults.vhd 
vcom ../../../dut/Hermes_buffer.vhd
vcom ../../../dut/Hermes_crossbar.vhd  
vcom ../../../dut/Hermes_switchcontrol.vhd  
vcom ../../../dut/RouterCC.vhd

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv
#vlog dut.v

# TB
vlog -f tb.f


vsim top -coverage +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=smoke_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

