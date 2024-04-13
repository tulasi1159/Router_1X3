// Extend router_wr_sequencer from uvm_sequencer parameterized by write_xtn
        class router_rd_sequencer extends uvm_sequencer #(read_xtn);

// Factory registration using `uvm_component_utils
        `uvm_component_utils(router_rd_sequencer)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name = "router_rd_sequencer",uvm_component parent);
        endclass
//-----------------  constructor new method  -------------------//
        function router_rd_sequencer::new(string name="router_rd_sequencer",uvm_component parent);
                super.new(name,parent);
        endfunction


