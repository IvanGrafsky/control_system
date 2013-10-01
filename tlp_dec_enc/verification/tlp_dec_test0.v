`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:45:17 07/31/2013
// Design Name:   axi_tlp_decoder
// Module Name:   C:/fpga/projects/pci-e-finish0/tlp_dec_test0.v
// Project Name:  pci-e-finish0
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: axi_tlp_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tlp_dec_test0;

	// Inputs
	reg clk;
	reg reset;
	reg tvalid;
	reg [63:0] tdata;
	reg [7:0] tstrb;
	reg [21:0] tuser;
	reg tlast;
	reg tlp_enc_ready;
	reg lnk_up;

	// Outputs
	wire tready;
	wire [7:0] a4lm_addr;
	wire [31:0] a4lm_wr_data;
	wire a4lm_to_start;
	wire a4lm_wr_cmd;
	wire a4lm_rd_cmd;
	wire [7:0] cfg_addr;
	wire [31:0] cfg_wr_data;
	wire cfg_rd_cmd;
	wire cfg_wr_cmd;
	wire a4sm_go;
	wire [63:0] a4sm_data;
	wire [7:0] a4sm_addr;
	wire req_compl;
	wire req_compl_w_data;
	wire [2:0] compl_code;
	wire [2:0] tenc_tc;
	wire [1:0] tenc_attr;
	wire [9:0] tenc_len;
	wire [15:0] tenc_rid;
	wire [7:0] tenc_tag;
	wire [7:0] tenc_be;
	wire [12:0] tenc_addr;

	// Instantiate the Unit Under Test (UUT)
	axi_tlp_decoder uut (
		.clk(clk), 
		.reset(reset), 
		.tvalid(tvalid), 
		.tdata(tdata), 
		.tready(tready), 
		.tstrb(tstrb), 
		.tuser(tuser), 
		.tlast(tlast), 
		.a4lm_addr(a4lm_addr), 
		.a4lm_wr_data(a4lm_wr_data), 
		.a4lm_to_start(a4lm_to_start), 
		.a4lm_wr_cmd(a4lm_wr_cmd), 
		.a4lm_rd_cmd(a4lm_rd_cmd), 
		.cfg_addr(cfg_addr), 
		.cfg_wr_data(cfg_wr_data), 
		.cfg_rd_cmd(cfg_rd_cmd), 
		.cfg_wr_cmd(cfg_wr_cmd), 
		.a4sm_go(a4sm_go), 
		.a4sm_data(a4sm_data), 
		.a4sm_addr(a4sm_addr), 
		.req_compl(req_compl), 
		.req_compl_w_data(req_compl_w_data), 
		.compl_code(compl_code), 
		.tlp_enc_ready(tlp_enc_ready), 
		.tenc_tc(tenc_tc), 
		.tenc_attr(tenc_attr), 
		.tenc_len(tenc_len), 
		.tenc_rid(tenc_rid), 
		.tenc_tag(tenc_tag), 
		.tenc_be(tenc_be), 
		.tenc_addr(tenc_addr), 
		.lnk_up(lnk_up)
	);
	
initial begin
clk = 0;
forever begin
	#1 clk = ~clk;
end
end


	
task resettask();
begin
	reset = 0;
	tvalid = 0;
	tdata = 0;
	tstrb = 0;
	tuser = 0;
	tlast = 0;
	tlp_enc_ready = 0;
	lnk_up = 0;
	#10;
	reset = 1;
	#10;
	reset = 0;
	#10;
end
endtask	


initial begin
resettask;
lnk_up = 1;
tlp_enc_ready = 1;
#10;
// testing axi4-lm write
@(posedge clk)
tuser[6] = 1;
tvalid = 1;
tdata = 64'h01a0090f40000001;
@(posedge tready)
@(posedge clk)
tlast = 1;
tdata = 64'h04f302f100000010;
@(posedge clk)
tlast = 0;
tvalid = 0;
tdata = 0;
tuser[6] = 0;
#10;
//testing axi4-stream write
@(posedge clk)
tuser [2] = 1;
tvalid = 1;
tdata = 64'h01a00a0f40000001;
@(posedge tready)
@(posedge clk)
tdata = 64'hb4a3a2b100000010;
@(posedge clk)
tdata = 64'ha6c8b4f20fc4d8a5;
@(posedge clk)
tdata = 64'hb4f7c9a0d5c6a2f6;
tlast = 1'b1;
@(posedge clk)
tdata = 64'h0;
tvalid = 0;
tlast = 0;
tuser[2] = 0;
#10;
//testing configuration write
@(posedge clk)
tvalid = 1;
tdata = 64'h01a00b0f44000001;
@(posedge tready)
@(posedge clk)
tdata = 64'hd6f8a2c5000000c4;
@(posedge clk)
tdata = 64'h00000000a6d8c5f4;
tlast = 1;
@(posedge clk)
tdata = 0;
tlast = 0;
tvalid = 0;
#10;
$finish;
end
      
endmodule

