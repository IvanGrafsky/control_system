`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:50 08/19/2013 
// Design Name: 
// Module Name:    reg_file_wrapper 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module reg_file_wrapper(

input clk0,
input reset,

input wr_en0,
input wr_en1,
output reg wr_en_rf,

input [31:0]	wr_data0,
input [31:0]	wr_data1,
output reg wr_en_rf,


input [3:0]  	wr_addr0,
input [3:0] 	wr_addr1,
output reg [3:0] wr_addr_rf,

input rd_en0,
input rd_en1,
output reg rd_en_rf,

input [3:0] 	rd_addr0,
input [3:0] 	rd_addr0,
output reg [3:0] rd_addr_rf,


output reg [31:0] rd_data0,
output reg [31:0] rd_data1,
input reg [31:0] rd_data_rf


    );
	 
reg	 
	 
always@(posedge clk)
begin

end
	 


endmodule
