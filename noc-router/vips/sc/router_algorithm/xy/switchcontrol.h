//---------------------------------------------------------------------------------------
//
//  DISTRIBUTED HEMPS  - version 5.0
//
//  Research group: GAPH-PUCRS    -    contact   fernando.moraes@pucrs.br
//
//  Distribution:  September 2013
//
//  Source name:  switchcontrol.h
//
//  Brief description: Signals of control of the states of the NoC, and executions for each state.
//
//---------------------------------------------------------------------------------------

#ifndef _switchcontrol
#define _switchcontrol
#include <systemc.h>
#include "packet.h"

SC_MODULE(switch_control){
	
	sc_in<bool> 		clock;
	sc_in<bool> 		reset;
	sc_in<bool> 		h[NPORT];
	sc_out<bool>	 	ack_h[NPORT];
	sc_in<regflit> 		data[NPORT];
	sc_in<bool>			sender[NPORT];
	sc_out<bool>		free[NPORT];
	sc_out<reg_mux> 	mux_in;
	sc_out<reg_mux> 	mux_out;

	//sinais do arbitro
	sc_signal<bool>				ask;
	sc_signal<sc_uint<4> >		sel, prox;

	//sinais do controle
	sc_signal<regquartoflit>		dirx,diry;
	sc_signal<regquartoflit>	lx,ly,tx,ty;
	sc_signal<reg3>  			source[NPORT];
	sc_signal<bool>				sender_ant[NPORT];

	enum state {S0,S1,S2,S3,S4,S5,S6,S7};
	sc_signal<state>			EA,PE;


	int number_pck;
	
	void controle_comb();
	void controle_sequ();
	void arbitro_comb();
	void arbitro_sequ();
	void state_sequ();
	
	//SC_CTOR(switch_control){
	SC_HAS_PROCESS(switch_control);
	switch_control(sc_module_name name_, regaddress address_ = 0x0000) :
    sc_module(name_), address(address_)
    {
		//data = new sc_in<regflit >[NPORT];
		
		SC_METHOD(controle_sequ);
		sensitive << reset.neg();
		sensitive << clock.pos();
		
		SC_METHOD(controle_comb);
		sensitive << reset;
		sensitive << ask;
		sensitive << EA;
		sensitive << h[EAST];
		sensitive << h[WEST];
		sensitive << h[NORTH];
		sensitive << h[SOUTH];
		sensitive << h[LOCAL];
		sensitive << lx;
		sensitive << ly;
		sensitive << tx;
		sensitive << ty;
		sensitive << free[EAST];
		sensitive << free[WEST];
		sensitive << free[NORTH];
		sensitive << free[SOUTH];
		sensitive << free[LOCAL];
		sensitive << dirx;
		sensitive << diry;
				
		SC_METHOD(arbitro_comb);
		sensitive << h[EAST];
		sensitive << h[WEST];
		sensitive << h[NORTH];
		sensitive << h[SOUTH];
		sensitive << h[LOCAL];
		sensitive << sel;
		sensitive << data[EAST];
		sensitive << data[WEST];
		sensitive << data[NORTH];
		sensitive << data[SOUTH];
		sensitive << data[LOCAL];
		
		SC_METHOD(state_sequ);
		sensitive << reset.neg();
		sensitive << clock.neg();
		
	}
	private:
		regaddress address;
	
};

#endif
