##############################################################
## Logical / Physical synthesis constraints ##
## GAPH/FACIN/PUCRS ##
##############################################################

## DEFINE VARS
set sdc_version 1.5
set_load_unit -picofarads 1

create_clock -name {clock} -period 2.0 [get_ports {clock}]

set_false_path -from [get_ports {reset}] 

## INPUTS
set_input_delay -clock clock -max 0.2 [all_inputs]
set_input_transition -min -rise 0.003 [all_inputs]
set_input_transition -max -rise 0.16 [all_inputs]
set_input_transition -min -fall 0.003 [all_inputs]
set_input_transition -max -fall 0.16 [all_inputs]

## OUTPUTS
set_load -min 0.0014 [all_outputs]
set_load -max 0.32 [all_outputs]
