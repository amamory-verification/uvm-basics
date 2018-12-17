onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut1/address
add wave -noupdate /top/dut1/clock
add wave -noupdate /top/dut1/reset
add wave -noupdate -divider -height 50 INPUT
add wave -noupdate /top/dut1/clock_rx
add wave -noupdate -expand /top/dut1/rx
add wave -noupdate -expand /top/dut1/data_in
add wave -noupdate /top/dut1/credit_o
add wave -noupdate -divider -height 50 OUTPUT
add wave -noupdate /top/dut1/clock_tx
add wave -noupdate -expand /top/dut1/tx
add wave -noupdate -expand /top/dut1/data_out
add wave -noupdate -expand /top/dut1/credit_i
add wave -noupdate -divider -height 50 BUFFERS
add wave -noupdate /top/dut1/FEast/EA
add wave -noupdate /top/dut1/FEast/buf
add wave -noupdate /top/dut1/FEast/first
add wave -noupdate /top/dut1/FEast/last
add wave -noupdate /top/dut1/FEast/counter_flit
add wave -noupdate /top/dut1/FEast/tem_espaco
add wave -noupdate /top/dut1/FWest/EA
add wave -noupdate /top/dut1/FWest/buf
add wave -noupdate /top/dut1/FWest/first
add wave -noupdate /top/dut1/FWest/last
add wave -noupdate /top/dut1/FWest/tem_espaco
add wave -noupdate /top/dut1/FWest/counter_flit
add wave -noupdate /top/dut1/FNorth/EA
add wave -noupdate /top/dut1/FNorth/buf
add wave -noupdate /top/dut1/FNorth/first
add wave -noupdate /top/dut1/FNorth/last
add wave -noupdate /top/dut1/FNorth/tem_espaco
add wave -noupdate /top/dut1/FNorth/counter_flit
add wave -noupdate /top/dut1/FSouth/EA
add wave -noupdate /top/dut1/FSouth/buf
add wave -noupdate /top/dut1/FSouth/first
add wave -noupdate /top/dut1/FSouth/last
add wave -noupdate /top/dut1/FSouth/tem_espaco
add wave -noupdate /top/dut1/FSouth/counter_flit
add wave -noupdate /top/dut1/FLocal/EA
add wave -noupdate /top/dut1/FLocal/buf
add wave -noupdate /top/dut1/FLocal/first
add wave -noupdate /top/dut1/FLocal/last
add wave -noupdate /top/dut1/FLocal/tem_espaco
add wave -noupdate /top/dut1/FLocal/counter_flit
add wave -noupdate -divider -height 50 SWITCH
add wave -noupdate /top/dut1/SwitchControl/h
add wave -noupdate /top/dut1/SwitchControl/ack_h
add wave -noupdate /top/dut1/SwitchControl/address
add wave -noupdate /top/dut1/SwitchControl/data
add wave -noupdate /top/dut1/SwitchControl/sender
add wave -noupdate /top/dut1/SwitchControl/free
add wave -noupdate /top/dut1/SwitchControl/mux_in
add wave -noupdate /top/dut1/SwitchControl/mux_out
add wave -noupdate /top/dut1/SwitchControl/ES
add wave -noupdate /top/dut1/SwitchControl/ask
add wave -noupdate /top/dut1/SwitchControl/sel
add wave -noupdate /top/dut1/SwitchControl/prox
add wave -noupdate /top/dut1/SwitchControl/incoming
add wave -noupdate /top/dut1/SwitchControl/header
add wave -noupdate /top/dut1/SwitchControl/dirx
add wave -noupdate /top/dut1/SwitchControl/diry
add wave -noupdate /top/dut1/SwitchControl/lx
add wave -noupdate /top/dut1/SwitchControl/ly
add wave -noupdate /top/dut1/SwitchControl/tx
add wave -noupdate /top/dut1/SwitchControl/ty
add wave -noupdate /top/dut1/SwitchControl/auxfree
add wave -noupdate /top/dut1/SwitchControl/source
add wave -noupdate /top/dut1/SwitchControl/sender_ant
add wave -noupdate /top/dut1/SwitchControl/clock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {250 ns} 0}
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
WaveRestoreZoom {0 ns} {561 ns}
