  module top;

        import router_pkg::*;

        import uvm_pkg::*;// builtin 

        bit clk;
                always
                #10 clk=!clk;

        // Instantiate 4 router_if interface instances in0,in1,in2,in3 with clk as input
                router_if   in(clk);   //connect signals  for source
                router_if   in0(clk);  //connect client 0
                router_if   in1(clk);  // connect client 1
                router_if   in2(clk);	// connect client 2

        // Instantiate rtl and pass ip argument

				router_top duv(.clk(clk),
                                .resetn(in.rst),
                                .pkt_vld(in.pkt_valid),
                                .data_in(in.data_in),
                                .error(in.error),
                                .busy(in.busy),

                                .read_enb_0(in0.read_enb),
                                .vld_out_0(in0.v_out),
                                .data_out_0(in0.data_out),

                                .read_enb_1(in1.read_enb),
                                .vld_out_1(in1.v_out),
                                .data_out_1(in1.data_out),

                                .read_enb_2(in2.read_enb),
                                .vld_out_2(in2.v_out),
                                .data_out_2(in2.data_out));

        initial
                begin
                     `ifdef VCS
                     $fsdbDumpvars(0, top);
                      `endif

                        uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
                        uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
                        uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
                        uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2); // static interface is pointing to virtual interface 												//handle

                        run_test();//create object for test and call build phase of test.

                end


property pkt_vld;
   		@(posedge clk)
   		$rose(in.pkt_valid) |=> in.busy;
 	endproperty
  
  	A1:assert property(pkt_vld);
  
  	property stable;
    		@(posedge clk)
    		in.busy |=> $stable(in.data_in);
  	endproperty
  
  	A2:assert property(stable);
    
 	property read1;
   		@(posedge clk)
   		$rose(in1.v_out) |=> ##[0:29] in1.read_enb;
 	endproperty
  
 	R1:assert property(read1);
  
 	property read2;
    		@(posedge clk)
    		$rose(in2.v_out) |=> ##[0:29] in2.read_enb;
 	endproperty

 	R2:assert property(read2);
   
  	property read0;
    		@(posedge clk)
    		$rose(in0.v_out) |=> ##[0:29] in0.read_enb;
 	endproperty
   
	R3:assert property(read0);
     
  	property valid1;
    		bit[1:0]addr;
    		@(posedge clk)
    		($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==0) |->in0.v_out;
  	endproperty
     
  	property valid2;
    		bit[1:0]addr;
    		@(posedge clk)
    		($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==1) |->in1.v_out;
  	endproperty
     
  	property valid3;
    		bit[1:0]addr;
    		@(posedge clk)
    		($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==2) |->in2.v_out;
  	endproperty
     
  	property valid;
    		@(posedge clk)
    		$rose(in.pkt_valid) |-> ##3 in0.v_out | in2.v_out |in1.v_out;
  	endproperty
     
     	V:assert property(valid);
     	V1:assert property(valid1);
     	V2:assert property(valid2);
     	V3:assert property(valid3);
       
  	 property read_1;
     		bit[1:0]addr;
     		@(posedge clk)
     		(in1.v_out) ##1 !in1.v_out |=>$fell(in1.read_enb);
   	endproperty
       
  	property read_2;
    		bit[1:0]addr;
    		@(posedge clk)
    		(in2.v_out) ##1 !in2.v_out |=>$fell(in2.read_enb);
  	endproperty
       
  	property read_3;
    		bit[1:0]addr;
    		@(posedge clk)
    		(in0.v_out) ##1 !in0.v_out |=>$fell(in0.read_enb);
  	endproperty
         
  	RR1:assert property(read_1);  
  	RR2:assert property(read_2);
  	RR3:assert property(read_3);
endmodule

