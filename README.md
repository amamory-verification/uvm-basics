# uvm-basics
The goal of this repository is to share the designs I am using to learn UVM. The examples are gradually increasing in complexity, providing a gradual learning process.
All examples were tested with Questa 10.3c and 10.6e. The examples have a 'run.do' file which compiles and executes the tests.

## Training Requirements

Before starting training for UVM, it is highly recommended to check these requirements:
 - Access to Questa. Those without access to Questa can try to use [EDA PlayGround](https://www.edaplayground.com/);
 - Object-oriented programming concepts and basic design patterns;
 - Basic experience with SystemVerilog;
 - Basic experience with Verilog/VHDL;
 - Basic experience with git.

## The Branch Structure

The *Master* branch is supposed to be the stable one while *Devel* is under development. Branches such as, for instance, *devel_router* would have under development code for the router TB. Similarly, a branch called *devel_router_feature* is for the development of some specific feature for the router TB. The current branches can be seen [here](https://github.com/amamory/uvm-basics/network).

## Minimal UVM

This is a minimal working UVM example, adapted from https://www.edaplayground.com/s/example/546
to work with Questa. The DUT is an adder. The testbench has just an environment with a single test, 2+3=5.

## Basic design 

The DUT is a simple counter. The TB is inspired by the videos [Basics of UVM](https://www.youtube.com/playlist?list=PL589BOiAVX7ZuFi6omNpuSd3WGGFmcu-Q).
I just watched the videos and tried to code the mentioned examples, including some free adaptations on my own.  
Compared to the previous example, the Minimal UVM, this one resembles a recommended TB architecture, 
with agents, monitors, drivers, coverage, scoreboard, sequence, sequence items, randomization, and functional coverage.

## Multipliers

It is a parametrizable UVM testbench tested on 4 different multipliers. The idea here was to devise a single TB that would work with different mult designs, to show a certain level of TB reuse. The reused part of the TB is located at [tb/common](mult/tb/common) and the TB specific part is located at the DUT's respective dir names found under TB dir. This TB includes a basic use of config_db to pass interfaces to the driver/monitor.

## Network-on-Chip

The design is the NoC design presented in the paper [HERMES: an infrastructure for low area overhead packet-switching networks on chip](https://www.sciencedirect.com/science/article/pii/S0167926004000185). This testbench is divided into two parts: TB for a single router (under construction) and TB for a NoC with NxM routers (to be done). Check the [router TB document](noc-router/hermes_router/docs/readme.md). The NoC TB will be under developed soon.

## UART interface

An UVM testbench for an [UART interface](http://www.asic-world.com/examples/verilog/uart.html). To be done !

