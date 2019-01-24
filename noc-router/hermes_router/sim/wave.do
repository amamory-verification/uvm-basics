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
add wave -noupdate /top/dut1/FEast/buf
add wave -noupdate /top/dut1/FWest/buf
add wave -noupdate /top/dut1/FNorth/buf
add wave -noupdate /top/dut1/FSouth/buf
add wave -noupdate /top/dut1/FLocal/buf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
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
WaveRestoreZoom {0 ns} {578 ns}
