// Verilog test fixture created from schematic C:\fpga\projects\pci-e-finish0\axi4_stream0.sch - Tue Aug 27 10:32:56 2013

`timescale 1ns / 1ps

module axi4_stream0_axi4_stream0_sch_tb();

// Inputs
   reg [131:0] fifo0_datain;
   reg fifo0_wr_en;
   reg clk;
   reg reset;
   reg fifo1_rd_en;

// Output
   wire [131:0] fifo1_dataout;
   wire [10:0] fifo1_data_count;

// Bidirs

// Instantiate the UUT
   axi4_stream0 UUT (
		.fifo0_datain(fifo0_datain), 
		.fifo0_wr_en(fifo0_wr_en), 
		.clk(clk), 
		.reset(reset), 
		.fifo1_dataout(fifo1_dataout), 
		.fifo1_rd_en(fifo1_rd_en), 
		.fifo1_data_count(fifo1_data_count)
   );
	
initial begin
clk = 0;
forever begin
#1 clk = ~ clk;
end
end

task write4DWtofifo0(input [127:0] data, input [3:0] mask);
begin
@(posedge clk)
fifo0_datain[127:0] = data;
fifo0_datain[131:128] = mask;
fifo0_wr_en = 1'b1;
@(posedge clk)
fifo0_wr_en = 1'b0;
fifo0_datain = 0;
end
endtask

task read4DWfromfifo1;
begin
@(posedge clk)
fifo1_rd_en = 1'b1;
@(posedge clk)
@(posedge clk)
fifo1_rd_en = 1'b0;
end
endtask

task resettask();
begin
	fifo0_datain = 0;
	fifo0_wr_en = 0;
	reset = 0;
	fifo1_rd_en = 0;
	#10;
	reset = 1;
	#10;
	reset = 0;
end
endtask
	

initial begin
resettask();
#50;
$display("4 DW  ", $realtime);
write4DWtofifo0({{112'b0},{6'b1},{10'd4} },4'b1111);
write4DWtofifo0(128'hFBFCA23BD6,4'b1111);
#10;
$display("2 DW  ", $realtime);
write4DWtofifo0({{112'b0},{6'b1},{10'd2} },4'b1111);
write4DWtofifo0(128'hFBFCA23BD6,4'b11);
#10;
$display("4 DW  + 4DW ", $realtime);
write4DWtofifo0({{112'b0},{6'b1},{10'd4} },4'b1111);
write4DWtofifo0(128'hFBFCA5435438923423BD6,4'b1111);
write4DWtofifo0({{112'b0},{6'b1},{10'd4} },4'b1111);
write4DWtofifo0(128'hFBFb42376349234A23BD6,4'b0011);
#20;
write4DWtofifo0({{112'b0},{6'b1},{10'd6} },4'b1111);
write4DWtofifo0(128'hFBFCA5435438923423BD6,4'b1111);
write4DWtofifo0(128'h7768452554A23BD6,4'b0011);
//write4DWtofifo0(128'hFBFCA23BD6,4'b0011);
#20;
write4DWtofifo0({{112'b0},{6'b1},{10'd10} },4'b1111);
write4DWtofifo0(128'hF2347823784238673423BD6,4'b1111);
write4DWtofifo0(128'h1894237838923423BD6,4'b1111);
write4DWtofifo0(128'h4512786785349234A23BD6,4'b0011);
#20;
write4DWtofifo0({{112'b0},{6'b1},{10'd10} },4'b1111);
write4DWtofifo0(128'hF2347823784238673423BD6,4'b1111);
write4DWtofifo0(128'h1894237838923423BD6,4'b1111);
write4DWtofifo0(128'h4512786785349234A23BD6,4'b0011);
#300;
fifo1_rd_en = 1'b1;
#50;
$finish;
end
endmodule
