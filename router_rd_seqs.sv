// Extend router_rd_seq from uvm_sequence parameterized by read_xtn
        class router_rd_seq extends uvm_sequence #(read_xtn);

  // Factory registration using `uvm_object_utils

        `uvm_object_utils(router_rd_seq)
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="router_rd_seq");
        endclass
//-----------------  constructor new method  -------------------//
        function router_rd_seq::new(string name ="router_rd_seq");
                super.new(name);
        endfunction
//--------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
        class router_rxtns1 extends router_rd_seq;


  // Factory registration using `uvm_object_utils
        `uvm_object_utils(router_rxtns1)

        extern function new(string name ="router_rxtns1");
	extern task body();

endclass

//-----------------  constructor new method  -------------------//
        function router_rxtns1::new(string name ="router_rxtns1");
                super.new(name);
        endfunction
//-----------------------------------task body----------------------------------------
	task router_rxtns1::body();
         
           req=read_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with {no_of_cycles inside {[1:28]};} );
           `uvm_info("ROUTER_RD_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
	 finish_item(req);
        endtask
//-----------------------------------------------------------------------------------//


/*class router_rxtns2 extends router_rd_seq;
  
	`uvm_object_utils(router_rxtns2)
  
	//standard methods
		
	extern function new(string name="router_rxtns2");
	extern task body();
endclass
//--------------------- new --------------------------------

function router_rxtns2::new(string name="router_rxtns2");
    	super.new(name);
endfunction
//------------------- body --------------------------------  
  
task router_rxtns2::body();
    
	req = read_xtn::type_id::create("req");
    	start_item(req);
    	assert(req.randomize() with {no_of_cycles inside {[30:40]};});
    	`uvm_info("router_rd_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
    	finish_item(req);
  
endtask*/
  
