class mult_config extends uvm_object;
	rand int width;
	constraint wc {soft width == 32;}
endclass
