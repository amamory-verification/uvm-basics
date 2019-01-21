onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut1/CC/address
add wave -noupdate /top/dut1/clock
add wave -noupdate /top/dut1/reset
add wave -noupdate -divider -height 50 INPUT
add wave -noupdate /top/dut1/clock_rx
add wave -noupdate -expand /top/dut1/rx
add wave -noupdate -expand /top/dut1/data_in
add wave -noupdate /top/dut1/credit_o
add wave -noupdate -height 50 /uvm_root/uvm_test_top/env/agent_master_0/sequencer/seq_0
add wave -noupdate -height 50 /uvm_root/uvm_test_top/env/agent_master_1/sequencer/seq_1
add wave -noupdate -height 50 /uvm_root/uvm_test_top/env/agent_master_2/sequencer/seq_2
add wave -noupdate -height 50 /uvm_root/uvm_test_top/env/agent_master_3/sequencer/seq_3
add wave -noupdate -height 50 /uvm_root/uvm_test_top/env/agent_master_4/sequencer/seq_4
add wave -noupdate -divider -height 50 OUTPUT
add wave -noupdate /top/dut1/clock_tx
add wave -noupdate -expand /top/dut1/tx
add wave -noupdate -expand /top/dut1/data_out
add wave -noupdate -expand /top/dut1/credit_i
add wave -noupdate -divider -height 50 BUFFERS
add wave -noupdate /top/dut1/CC/FEast/EA
add wave -noupdate /top/dut1/CC/FEast/buf
add wave -noupdate /top/dut1/CC/FEast/first
add wave -noupdate /top/dut1/CC/FEast/last
add wave -noupdate /top/dut1/CC/FEast/counter_flit
add wave -noupdate /top/dut1/CC/FEast/tem_espaco
add wave -noupdate /top/dut1/CC/FWest/EA
add wave -noupdate /top/dut1/CC/FWest/buf
add wave -noupdate /top/dut1/CC/FWest/first
add wave -noupdate /top/dut1/CC/FWest/last
add wave -noupdate /top/dut1/CC/FWest/tem_espaco
add wave -noupdate /top/dut1/CC/FWest/counter_flit
add wave -noupdate /top/dut1/CC/FNorth/EA
add wave -noupdate /top/dut1/CC/FNorth/buf
add wave -noupdate /top/dut1/CC/FNorth/first
add wave -noupdate /top/dut1/CC/FNorth/last
add wave -noupdate /top/dut1/CC/FNorth/tem_espaco
add wave -noupdate /top/dut1/CC/FNorth/counter_flit
add wave -noupdate /top/dut1/CC/FSouth/EA
add wave -noupdate /top/dut1/CC/FSouth/buf
add wave -noupdate /top/dut1/CC/FSouth/first
add wave -noupdate /top/dut1/CC/FSouth/last
add wave -noupdate /top/dut1/CC/FSouth/tem_espaco
add wave -noupdate /top/dut1/CC/FSouth/counter_flit
add wave -noupdate /top/dut1/CC/FLocal/EA
add wave -noupdate /top/dut1/CC/FLocal/buf
add wave -noupdate /top/dut1/CC/FLocal/first
add wave -noupdate /top/dut1/CC/FLocal/last
add wave -noupdate /top/dut1/CC/FLocal/tem_espaco
add wave -noupdate /top/dut1/CC/FLocal/counter_flit
add wave -noupdate -divider -height 50 SWITCH
add wave -noupdate /top/dut1/CC/SwitchControl/h
add wave -noupdate /top/dut1/CC/SwitchControl/ack_h
add wave -noupdate /top/dut1/CC/SwitchControl/address
add wave -noupdate /top/dut1/CC/SwitchControl/data
add wave -noupdate /top/dut1/CC/SwitchControl/sender
add wave -noupdate /top/dut1/CC/SwitchControl/free
add wave -noupdate /top/dut1/CC/SwitchControl/mux_in
add wave -noupdate /top/dut1/CC/SwitchControl/mux_out
add wave -noupdate /top/dut1/CC/SwitchControl/ES
add wave -noupdate /top/dut1/CC/SwitchControl/ask
add wave -noupdate /top/dut1/CC/SwitchControl/sel
add wave -noupdate /top/dut1/CC/SwitchControl/prox
add wave -noupdate /top/dut1/CC/SwitchControl/incoming
add wave -noupdate /top/dut1/CC/SwitchControl/header
add wave -noupdate /top/dut1/CC/SwitchControl/dirx
add wave -noupdate /top/dut1/CC/SwitchControl/diry
add wave -noupdate /top/dut1/CC/SwitchControl/lx
add wave -noupdate /top/dut1/CC/SwitchControl/ly
add wave -noupdate /top/dut1/CC/SwitchControl/tx
add wave -noupdate /top/dut1/CC/SwitchControl/ty
add wave -noupdate /top/dut1/CC/SwitchControl/auxfree
add wave -noupdate /top/dut1/CC/SwitchControl/source
add wave -noupdate /top/dut1/CC/SwitchControl/sender_ant
add wave -noupdate /top/dut1/CC/SwitchControl/clock
add wave -noupdate /uvm_root/uvm_test_top/env/scoreboard/in_mon_ap
add wave -noupdate /uvm_root/uvm_test_top/env/scoreboard/out_mon_ap
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 ns}
