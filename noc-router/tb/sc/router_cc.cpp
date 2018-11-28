//---------------------------------------------------------------------------------------
//
//  DISTRIBUTED HEMPS  - version 5.0
//
//  Research group: GAPH-PUCRS    -    contact   fernando.moraes@pucrs.br
//
//  Distribution:  September 2013
//
//  Source name:  router_cc.cpp
//
//  Brief description: Functions of router_cc
//
//--------------------------------------------------------------------------------------

#include "router_cc.h"



void router_cc::traffic_monitor(){
	int i;
	char aux[255];
	FILE *fp;

	if(reset_n.read() == 0){
		for(i = 0; i < NPORT; i++) {
			bandwidth_allocation[i] = 0;
			SM_traffic_monitor[i] = 0;
		}
	}
	else if (clock.read() == 1){

		for(i = 0; i < NPORT; i++){

			//New flit coming
			if(rx[i].read() && credit_o[i]){

				if (payload_counter[i] != 0)
					payload_counter[i]--;

				//how many clock ticks were spent 
				//from header untill the last packet piece
				bandwidth_allocation[i]++;


				switch(SM_traffic_monitor[i])
				{

					case 0: //Header
						SM_traffic_monitor[i] = 1;
						target_router[i] = data_in[i].read() & 0xFFFF;
						header_time[i] = (unsigned int)tick_counter.read();
						
						//printf("%d   --      %d\n",  (unsigned int)data_in[i].read(), target_router[i]); //debug
						break;

					case 1: //Payload
						payload[i] = data_in[i].read();
						SM_traffic_monitor[i] = 2;
						payload_counter[i] = data_in[i].read();
						break;					

					case 2: //Service
						service[i] = data_in[i].read();

						/*switch(data_in[i].read()){
						case 0x10:
						case 0x20:
						case 0x40:
						case 0x50:
						case 0x60:
						case 0x70:
						case 0x80:
						case 0x90:
						case 0x130:
						case 0x140:
						case 0x150:
						case 0x160:
						case 0x170:
						case 0x180:
						case 0x190:
						case 0x200:
						break;
						default:
							cout << (unsigned int)address << " ############ ERROR - SERVICE UNKNOWED: " << data_in[i].read() << "Inport " << i << " time: " << (unsigned int)tick_counter.read() << endl;
						}*/

						if(service[i] != 0x40 && service[i] != 0x70 && service[i] != 0x221 && service[i] != 0x10 && service[i] != 0x20)
							SM_traffic_monitor[i] = 5;
						else
							SM_traffic_monitor[i] = 3;
						break;

					case 3: //If is task_allocation

						task_id[i] = data_in[i].read();
						if (service[i] == 0x10 || service[i] == 0x20)
							SM_traffic_monitor[i] = 4;
						else
							SM_traffic_monitor[i] = 5;

						break;

					case 4:
						consumer_id[i] = data_in[i].read();
						SM_traffic_monitor[i] = 5;
						break;

					case 5:

						if (payload_counter[i] == 0 ){
							
						//Store in aux the C's string way
						sprintf(aux, "debug/traffic_router.txt");

						//unsigned int aux2 = (unsigned int)address;
						//unsigned int newAdress = ((aux2 >> 8) << 4) | (aux2 & 0xFF);
						unsigned int newAdress = (unsigned int)address;
						//aux2 = target_router[i];
						//unsigned int targetRouter = ((aux2 >> 8) << 4) | (aux2 & 0xFF);
						unsigned int targetRouter = target_router[i];

												
						// Open a file called "aux" deferred on append mode
						fp = fopen (aux, "a");
						if(fp == NULL){
							cout << endl << endl << "ERROR: Can't open log file " << aux << " !" << endl << endl;
							sc_stop();
							exit(-1);
						}
							if (service[i] != 0x40 && service[i] != 0x70 && service[i] != 0x221 && service[i] != 0x10 && service[i] != 0x20){
								sprintf(aux, "%d\t%d\t%x\t%d\t%d\t%d\t%d\n", header_time[i], newAdress, service[i], payload[i], bandwidth_allocation[i], 2*i +1, targetRouter);
							} else {
								if (service[i] == 0x10 || service[i] == 0x20)
									sprintf(aux, "%d\t%d\t%x\t%d\t%d\t%d\t%d\t%d\t%d\n", header_time[i], newAdress, service[i], payload[i], bandwidth_allocation[i], 2*i +1, targetRouter, task_id[i], consumer_id[i]);
								else
									sprintf(aux, "%d\t%d\t%x\t%d\t%d\t%d\t%d\t%d\n", header_time[i], newAdress, service[i], payload[i], bandwidth_allocation[i], 2*i +1, targetRouter, task_id[i]);

							}

							fprintf(fp,"%s",aux);
						fclose (fp);

						payload_counter[i] = 0;	
						bandwidth_allocation[i] = 0;
						SM_traffic_monitor[i] = 0;
					}

					break;
					}
				}else if(bandwidth_allocation[i] > 0)
					bandwidth_allocation[i]++;	
			}

		}

	}

void router_cc::upd_header(){
         if(incoming.read()==EAST) header.write(data[EAST].read());
    else if(incoming.read()==WEST) header.write(data[WEST].read());
    else if(incoming.read()==NORTH) header.write(data[NORTH].read());
    else if(incoming.read()==SOUTH) header.write(data[SOUTH].read());
    else if(incoming.read()==LOCAL) header.write(data[LOCAL].read());
}

void router_cc::upd_dataout(){
	reg_mux localmux_out;
	localmux_out = mux_out.read();
	
	for (int i=0; i<NPORT; i++){
		sc_uint<3> j=localmux_out.range(i*3+2,i*3);
		if (i==j){
			data_out[i].write(0);
		}
		else{
			if (free[i].read()==0){
				data_out[i].write(data[j]);
			}
		}
	}
}


void router_cc::upd_dataack(){
	reg_mux local_mux_in;
	

	local_mux_in=mux_in.read();

	for (int i=0; i<NPORT; i++){
		int j=local_mux_in.range(i*3+2,i*3);
		if (i==j){
			sgn_data_ack[i].write(0);
		}
		else{
			if (sgn_data_av[i].read()==1){
				sgn_data_ack[i].write(credit_i[j]);
			}
			else{
				sgn_data_ack[i].write(0);
			}
		}
	}
	
}


void router_cc::upd_tx(){
	reg_mux local_mux_out=mux_out.read();

	for (int i=0; i<NPORT; i++){
		int j=local_mux_out.range(i*3+2,i*3);
		if (i==j){
			tx[i].write(0);
		}
		else{
			if (free[i].read()==0){
				tx[i].write(sgn_data_av[j]);
			}
		}
	}
}


void router_cc::upd_clock_tx(){
	
		if(reset_n.read() == 0){
			total_flits=0;
			wire_EAST=0;
			wire_WEST=0;
			wire_NORTH=0;
			wire_SOUTH=0;
			wire_LOCAL=0;
			
			fluxo_0=0;
			fluxo_1=0;
			fluxo_2=0;
			fluxo_3=0;
			fluxo_4=0;
			fluxo_5=0;
			
			aux=0;
			
		}
		else{
			if((tx[0].read() == 1 and credit_i[0].read() == 1) or (tx[1].read() == 1 and credit_i[1].read() == 1) or (tx[2].read() == 1 and credit_i[2].read() == 1) or
				(tx[3].read() == 1 and credit_i[3].read() == 1) or (tx[4].read() == 1 and credit_i[4].read() == 1)){
					
				aux=(tx[0].read() == 1 and credit_i[0].read() == 1) + (tx[1].read() == 1 and credit_i[1].read() == 1) + (tx[2].read() == 1 and credit_i[2].read() == 1) + 
					(tx[3].read() == 1 and credit_i[3].read() == 1) + (tx[4].read() == 1 and credit_i[4].read() == 1);
					
				
				if(aux == 1){
					fluxo_1++;
				}
				
				else if(aux ==2){
					fluxo_2++;
				}
				else if(aux ==3){
					fluxo_3++;
				}
				else if(aux ==4){
					fluxo_4++;
				}
				else{
					fluxo_5++;
				}
						
					
				if((tx[0].read() == 1 and credit_i[0].read() == 1)){
					wire_EAST++;
				}
				else if((tx[1].read() == 1 and credit_i[1].read() == 1)){

					wire_WEST++;
				}
				else if((tx[2].read() == 1 and credit_i[2].read() == 1)){

					wire_NORTH++;
				}				
				else if((tx[3].read() == 1 and credit_i[3].read() == 1)){

					wire_SOUTH++;
				}				
				else if((tx[4].read() == 1 and credit_i[4].read() == 1)){

					wire_LOCAL++;
				}
					total_flits++;
			}
			else{
				fluxo_0++;
			}
		}
}


