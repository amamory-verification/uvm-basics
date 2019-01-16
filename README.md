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

The design is the NoC design presented in the paper [HERMES: an infrastructure for low area overhead packet-switching networks on chip](https://www.sciencedirect.com/science/article/pii/S0167926004000185). This testbench is divided into two parts: TB for a single router (under construction) and TB for a NoC with NxM routers (to be done).

The router TB is a more advanced TB, compared to the previous ones, with multiple agents, each one attached to a different router port. It has several different types of randomization and constraints to generate valid packet headers and to randomize the time the packets and the flits are injected into the router. It uses virtual and hierarchical sequences to coordinate various sequences in parallel. It has a scoreboard, and different coverage points/crosses, and a more advanced use of config_db to distribute parameters to the multiple interfaces (5 input and 5 output interfaces), to pass parameters from tests to sequences, and few general configuration parameters.

This router TB is functional but there are more features I want to implement, in order of importance, such as:
 - Document the TB architecture, tests, sequences, checks, and converage. Perhaps using Markdown and ReadTheDocs.
 - Set tests with plusargs, making the tests more configurable without recompilation and also reducing the number of tests 
 - Implement some simple seed management approach 
 - Include SV assertions in the DUT
 - Design a Power Aware Simulation using Unified Power Format (UPF)
 - Describe sequences for error injection
 - Include a fault injection method with UVM and/or using formal methods, such as 
[How Formal Reduces Fault Analysis for ISO 26262](https://www.mentor.com/products/fv/resources/overview/how-formal-reduces-fault-analysis-for-iso-26262-82758134-85e7-4753-92f4-6f90e36e7d96)
 - More open-ended task would be to keep studying SV and UVM usage methods to improve the reuse for this testbench.

The NoC TB ... to be done.

## UART interface

An UVM testbench for an [UART interface](http://www.asic-world.com/examples/verilog/uart.html). To be done !

