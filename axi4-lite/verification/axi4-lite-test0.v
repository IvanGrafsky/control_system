// Verilog test fixture created from schematic C:\fpga\projects\pci-e-finish0\axi4lite.sch - Tue Aug 20 22:35:21 2013

`timescale 1ns / 1ps

module axi4lite_axi4lite_sch_tb();

// Inputs
   reg rd_cmd;
   reg wr_cmd;
   reg [7:0] userwrrdaddr;
   reg [31:0] userwrdata;
   reg reset;
   reg clk;
   reg rf_busy;

// Output
   wire data_valid;
   wire [31:0] userrddata;
   wire [1:0] error;
   wire slave_need_rf;
	
	
	integer i;

// Bidirs

// Instantiate the UUT
   axi4lite UUT (
		.rd_cmd(rd_cmd), 
		.wr_cmd(wr_cmd), 
		.userwrrdaddr(userwrrdaddr), 
		.userwrdata(userwrdata), 
		.data_valid(data_valid), 
		.userrddata(userrddata), 
		.error(error),  
		.reset(reset), 
		.clk(clk), 
		.slave_need_rf(slave_need_rf), 
		.rf_busy(rf_busy)
   );
	
initial begin
clk = 0;
forever begin
#1 clk = ~ clk;
end
end

task writedata(input [7:0] addr, input [31:0] data);
begin
@(posedge clk)
wr_cmd = 1;
userwrrdaddr = addr;
userwrdata = data;
@(posedge clk)
wr_cmd = 0;
userwrrdaddr = 0;
userwrdata = 0;
#20;
end
endtask


task readdata(input [7:0] addr);
begin
@(posedge clk)
rd_cmd = 1;
userwrrdaddr = addr;
@(posedge clk)
rd_cmd = 0;
userwrrdaddr = 0;
#20;
end
endtask


task resettask;
begin
rd_cmd = 0;
wr_cmd = 0;
userwrrdaddr = 0;
userwrdata = 0;
reset = 0;
rf_busy = 0;
#10;
reset = 1;
#10;
reset = 0;
end
endtask	

initial begin
resettask;
#10;

writedata(0, 5);
#20;
readdata(0);
#10;
for(i = 0; i < 16; i = i + 1)
begin
writedata(i, 2*i + 3);
#10;
readdata(i);
#10;
end
#10;
for(i = 0; i < 31; i = i + 1)
begin
readdata(i);
#10;
end
writedata(3,8);
#20;
rf_busy = 1;
readdata(3);
#10;
rf_busy = 0;
#20;
readdata(35);
#20;
$finish;
end
	

endmodule
