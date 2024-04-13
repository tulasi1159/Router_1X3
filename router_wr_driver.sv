class router_wr_driver extends uvm_driver #(write_xtn);

	`uvm_component_utils(router_wr_driver)  // factory registration

	virtual router_if.WDR_MP vif;  //interface
	router_wr_agt_config m_cfg;     

 extern function new(string name ="router_wr_driver",uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);
 extern task send_to_dut(write_xtn xtn);
 extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
        function router_wr_driver::new(string name ="router_wr_driver",uvm_component parent);
                super.new(name,parent);
        endfunction

//-----------------  build() phase method  -------------------//
        function void router_wr_driver::build_phase(uvm_phase phase);
        // call super.build_phase(phase);
          super.build_phase(phase);
        // get the config object using uvm_config_db
          if(!uvm_config_db #(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))  // why?
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

//-----------------  connect() phase method  -------------------//
        // in connect phase assign the configuration object's virtual interface
        // to the driver's virtual interface instance(handle --> "vif")
        function void router_wr_driver::connect_phase(uvm_phase phase);
          vif = m_cfg.vif;
        endfunction


//-----------------  run() phase method  -------------------//
         // In forever loop
            // Get the sequence item using seq_item_port
            // Call send_to_dut task
            // Get the next sequence item using seq_item_port

        task router_wr_driver::run_phase(uvm_phase phase);

         @(vif.wdr_cb);
                vif.wdr_cb.rst<=0;
             @(vif.wdr_cb);
                 vif.wdr_cb.rst<=1;
        
	forever 
		begin
                seq_item_port.get_next_item(req);
                send_to_dut(req);
                seq_item_port.item_done();
                end
        endtask
//-----------------  task send_to_dut() method  -------------------//

   // Add task send_to_dut(write_xtn handle as an input argument)

        task router_wr_driver::send_to_dut(write_xtn xtn);
                // Print the transaction
          `uvm_info("ROUTER_WR_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
          // Add the write logic
		@(vif.wdr_cb);
	while(vif.wdr_cb.busy)//0 it comes out , 1 infinity loop
		@(vif.wdr_cb);//wait 1 it comes out, 0 it stays
	
	vif.wdr_cb.pkt_valid <= 1;
             
     
              vif.wdr_cb.data_in<= xtn.header;
	@(vif.wdr_cb);
	
	foreach(xtn.payload_data[i])
	begin
		//if(vif.wdr_cb.busy)
		//begin
		while(vif.wdr_cb.busy)
		@(vif.wdr_cb);
		//end
		//$display($time,"INSIDE LOOOOOOOOOOP i = %d",i0;
		vif.wdr_cb.data_in<= xtn.payload_data[i];
		@(vif.wdr_cb);
	end

         	 while(vif.wdr_cb.busy)
                @(vif.wdr_cb);
                vif.wdr_cb.pkt_valid <= 0;
		vif.wdr_cb.data_in <= xtn.parity;
	//	@(vif.wdr_cb);
		repeat(2)
		@(vif.wdr_cb);

	xtn.err= vif.wdr_cb.error;
	m_cfg.drv_data_count++;
	 @(vif.wdr_cb);
	
endtask


// UVM report_phase
  function void router_wr_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ROUTER write driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction
