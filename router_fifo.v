module router_fifo(
input clk,resetn,soft_reset,write_enb,read_enb,lfd_state,
input [7:0] data_in,
output empty,full,
output reg [7:0] data_out
);

//extra signals
reg [8:0] mem [15:0];
reg [6:0] fifo_counter;
reg [4:0] rd_ptr,wr_ptr;
reg lfd_state_temp;
integer i;
//lfd_state with one clock cycle delay
always@(posedge clk)
begin
if(!resetn)
lfd_state_temp <= 0;
else
lfd_state_temp <= lfd_state;
end
//logic for incrementing write pointer ---- no soft_reset
always@(posedge clk)
begin
if(~resetn)
begin
wr_ptr<=1'b0;

end
else if(soft_reset)
begin
wr_ptr<=1'b0;
end
else if((write_enb) && (~full))
wr_ptr <= wr_ptr+1;
else
wr_ptr <= wr_ptr;
end
// logic for incrementing read pointer ---- no soft_reset
always@(posedge clk)
begin
if(~resetn)
begin
rd_ptr<=1'b0;
end
else if(soft_reset)
begin
rd_ptr<=1'b0;
end
else if((read_enb) && (~empty))
rd_ptr <= rd_ptr+1;
else
rd_ptr <= rd_ptr;
end
//logic for fifo_counter
always@(posedge clk)
begin
if(~resetn || soft_reset)
fifo_counter<=7'b0;
else if(read_enb && ~empty)
begin
if(mem[rd_ptr[3:0]][8]==1'b1)

fifo_counter<=mem[rd_ptr[3:0]][7:2]+1; // header 15
else if(fifo_counter!=0)
fifo_counter<=fifo_counter-1;
end
else
fifo_counter<=fifo_counter;
end

//read logic
always@(posedge clk)
begin
if(~resetn)
data_out<=8'b0;
else if(soft_reset)
data_out<=8'bz;
else if(read_enb && ~empty)
data_out<=mem[rd_ptr[3:0]][7:0];
else if(fifo_counter == 0)
data_out <= 8'bz;
else
data_out <= data_out;
end
//write logic
always@(posedge clk)
begin
if(~resetn || soft_reset)
for(i=0;i<16;i=i+1)
begin
mem[i]<=9'b0;
end
else if((write_enb)&&(~full))

begin
if(lfd_state_temp)
begin
mem[wr_ptr[3:0]][8]<=1'b1;
mem[wr_ptr[3:0]][7:0]<=data_in;
end
else
begin
mem[wr_ptr[3:0]][8]<=1'b0;
mem[wr_ptr[3:0]][7:0]<=data_in;
end
end
end
//logic for full and empty
assign full =(wr_ptr == ({~rd_ptr[4],rd_ptr[3:0]}))?1'b1:1'b0;
assign empty =(rd_ptr == wr_ptr)?1'b1:1'b0;
endmodule
