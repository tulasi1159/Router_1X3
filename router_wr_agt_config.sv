class router_wr_agt_config extends uvm_object; // why it is extended as uvm_object?

	`uvm_object_utils(router_wr_agt_config)
	
virtual router_if vif;
static int drv_data_count = 0; // keep track of how many data driver is driving
static int mon_data_count = 0; // keep track of how many data monitor is   collecting

uvm_active_passive_enum is_active = UVM_ACTIVE;

extern function new(string name = "router_wr_agt_config");

endclass
//-----------------  constructor new method  -------------------//

function router_wr_agt_config::new(string name = "router_wr_agt_config");
  super.new(name);
endfunction

