## Hermes Network-on-Chip Router Testbench

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
