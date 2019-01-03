# uvm-basics
The goal of this repository is to share the designs I am using to learn UVM. The examples gradually increase regarding complexity.
All examples were tested with Questa 10.3c and 10.6e.

## Training Requirements

Before starting training for UVM, it is highly recommended to check these requirements:
 - Object Oriented programming concepts and basic design patterns
 - Basic experience with SystemVerilog
 - Basic experience with Verilog/VHDL
 - Basic experience with git

## Minimal UVM

This is a minimal working UVM example, adapted from https://www.edaplayground.com/s/example/546
to work with Questa. The DUT is an adder. The testbench has just an environment with a single test, 2+3=5.

## Basic design 

The DUT is a simple counter. The TB is inspired on the basic UVM TB structure following the steps presented in 
https://www.youtube.com/playlist?list=PL589BOiAVX7ZuFi6omNpuSd3WGGFmcu-Q.
Despite the previous example, this one resembles a recommended TB architecture, with agents, monitors, drivers, coverage, scoreboard, sequence, randomization, and functional coverage.

## Serial unsigned multiplier and a Booth signed multiplier

It is a parametrizable UVM testbench tested on 4 different multipliers. The idea here was to device a single TB that would work to different mult designs, to show a certain level of TB reuse. The reused part of the TB is located at tb/common and the TB specific part is located at the DUT's respective dir names found under TB dir. It has a basic use of config_db to pass interfaces to the driver/monitor.

## Network-on-Chip

The design is the NoC design presented in the paper [HERMES: an infrastructure for low area overhead packet-switching networks on chip](https://www.sciencedirect.com/science/article/pii/S0167926004000185). This testbench is divided into two parts: TB for a single router and TB for a NoC with NxM routers.

This is a more advanced TB with multiple agents, each one attached to each router port. It has several different types of randomization and constraints to generate valid packet headers, the randomize the time the packets and the flits are injected into the router. It uses virtual sequences to coordinate various sequences in parallel. It has a scoreboard and different coverage points/crosses. It has a more advanced use of config_db since it has multiple interfaces (5 input and 5 output interfaces) and few configuration parameters.

## UART interface

An UVM testbench for an [UART interface](http://www.asic-world.com/examples/verilog/uart.html).

