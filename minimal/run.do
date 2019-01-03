#if [file exists "work"] {vdel -all}
#vlib work

vlog design.sv
vlog tb.sv

vsim top  +UVM_CONFIG_DB_TRACE
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

