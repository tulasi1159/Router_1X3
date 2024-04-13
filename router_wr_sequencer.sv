// Extend router_wr_sequencer from uvm_sequencer parameterized by write_xtn
        class router_wr_sequencer extends uvm_sequencer #(write_xtn);

// Factory registration using `uvm_component_utils
        `uvm_component_utils(router_wr_sequencer)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name = "router_wr_sequencer",uvm_component parent);
        endclass
//-----------------  constructor new method  -------------------//
        function router_wr_sequencer::new(string name="router_wr_sequencer",uvm_component parent);
                super.new(name,parent);
        endfunction

