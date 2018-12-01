virtual class dut_if_base extends uvm_object;
	`uvm_object_utils(dut_if_base)

	function new(string name = "");
	  super.new(name);
	endfunction: new

	pure virtual task reset_dut();
	pure virtual task do_mult(input int iA, input int iB, output int oRes);
	pure virtual task get_mult(ref shortint oA, ref shortint oB, ref int oRes);
	pure virtual task do_nothing();
endclass : dut_if_base

