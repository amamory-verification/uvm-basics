onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut1/CC/clock(0)
add wave -noupdate /top/dut1/CC/reset
add wave -noupdate -divider -height 50 INPUT
add wave -noupdate -expand /top/dut1/CC/rxLocal
add wave -noupdate -expand /top/dut1/CC/data_inLocal
add wave -noupdate /top/dut1/CC/credit_oLocal
add wave -noupdate -divider -height 50 OUTPUT
add wave -noupdate /top/dut1/CC/clock(0)
add wave -noupdate -expand /top/dut1/CC/txLocal
add wave -noupdate -expand /top/dut1/CC/data_outLocal
add wave -noupdate -expand /top/dut1/CC/credit_iLocal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 286
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
WaveRestoreZoom {0 ps} {553245 ps}
