// The param_containter class hold the values
// for all parameters in the design
// from https://verificationacademy.com/verification-horizons/june-2012-volume-8-issue-2/Relieving-the-Parameterized-Coverage-Headache
class my_param_container extends uvm_object;
   `uvm_object_utils(my_param_container)
 
   // Data members to hold parameter values
   // Each parameter is set to a default value
   // these values are overwritten in the
   // parameterized test base when the object
   // is created.
   int data_width = 31;
   int max_val = 20000;
   // other parameter values
    
   // constructor, etc.

   function new(string name = "");
      super.new(name);
   endfunction

endclass : my_param_container