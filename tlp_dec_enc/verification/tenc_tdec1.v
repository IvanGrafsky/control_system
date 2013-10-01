// Verilog test fixture created from schematic C:\fpga\projects\pci-e-finish0\decoder_encoder0.sch - Mon Aug 12 15:59:07 2013

`timescale 1ns / 1ps

module decoder_encoder0_decoder_encoder0_sch_tb();

// Inputs
   reg clk;
   reg reset;
   reg dec_tvalid;
   reg dec_tlast;
   reg lnk_up;
   reg [63:0] dec_tdata;
   reg [7:0] dec_tstrb;
   reg [21:0] dec_tuser;
   reg cfg_valid;
   reg [1:0] a4lm_err_code;
   reg [31:0] cfg_rd_data;
   reg a4lm_valid;
   reg fifo0_empty_flag;
   reg fifo0_full_flag;
   reg fifo0_prog_full;
   reg enc_tx_tready;
   reg fifo1_full_flag;
   reg fifo1_empty_flag;
   reg [7:0] cfg_bus_number;
   reg [4:0] cfg_device_number;
   reg [2:0] cfg_func_number;
   reg [31:0] a4lm_data;
   reg [31:0] fifo1_rd_data;

// Output
   wire tlp_enc_ready;
   wire [2:0] tenc_tc;
   wire [1:0] tenc_attr;
   wire [9:0] tenc_length;
   wire [15:0] tenc_rid;
   wire [7:0] tenc_tag;
   wire [7:0] tenc_be;
   wire [12:0] tenc_addr;
   wire dec_tready;
   wire a4lm_wr_cmd;
   wire a4lm_rd_cmd;
   wire cfg_rd_cmd;
   wire cfg_wr_cmd;
   wire enc_tx_tvalid;
   wire enc_tx_tlast;
   wire [63:0] enc_tx_tdata;
   wire [7:0] enc_tx_tstrb;
   wire tenc_req_compl;
   wire [7:0] a4lm_addr;
   wire [31:0] a4lm_wr_data;
   wire [7:0] cfg_addr;
   wire [31:0] cfg_wr_data;
   wire [2:0] tenc_compl_code;
   wire fifo1_rd_cmd;
   wire fifo0_wr_cmd;
   wire [131:0] fifo0_wr_data;

// Bidirs

// Instantiate the UUT
   decoder_encoder0 UUT (
		.clk(clk), 
		.reset(reset), 
		.dec_tvalid(dec_tvalid), 
		.dec_tlast(dec_tlast), 
		.tlp_enc_ready(tlp_enc_ready), 
		.lnk_up(lnk_up), 
		.dec_tdata(dec_tdata), 
		.dec_tstrb(dec_tstrb), 
		.dec_tuser(dec_tuser), 
		.tenc_tc(tenc_tc), 
		.tenc_attr(tenc_attr), 
		.tenc_length(tenc_length), 
		.tenc_rid(tenc_rid), 
		.tenc_tag(tenc_tag), 
		.tenc_be(tenc_be), 
		.tenc_addr(tenc_addr), 
		.dec_tready(dec_tready), 
		.a4lm_wr_cmd(a4lm_wr_cmd), 
		.a4lm_rd_cmd(a4lm_rd_cmd), 
		.cfg_rd_cmd(cfg_rd_cmd), 
		.cfg_wr_cmd(cfg_wr_cmd), 
		.enc_tx_tvalid(enc_tx_tvalid), 
		.enc_tx_tlast(enc_tx_tlast), 
		.enc_tx_tdata(enc_tx_tdata), 
		.enc_tx_tstrb(enc_tx_tstrb), 
		.cfg_valid(cfg_valid), 
		.a4lm_err_code(a4lm_err_code), 
		.tenc_req_compl(tenc_req_compl), 
		.a4lm_addr(a4lm_addr), 
		.a4lm_wr_data(a4lm_wr_data), 
		.cfg_addr(cfg_addr), 
		.cfg_wr_data(cfg_wr_data), 
		.cfg_rd_data(cfg_rd_data), 
		.a4lm_valid(a4lm_valid), 
		.tenc_compl_code(tenc_compl_code), 
		.fifo0_empty_flag(fifo0_empty_flag), 
		.fifo0_full_flag(fifo0_full_flag), 
		.fifo0_prog_full(fifo0_prog_full), 
		.enc_tx_tready(enc_tx_tready), 
		.fifo1_rd_cmd(fifo1_rd_cmd), 
		.fifo1_full_flag(fifo1_full_flag), 
		.fifo1_empty_flag(fifo1_empty_flag), 
		.cfg_bus_number(cfg_bus_number), 
		.cfg_device_number(cfg_device_number), 
		.cfg_func_number(cfg_func_number), 
		.a4lm_data(a4lm_data), 
		.fifo1_rd_data(fifo1_rd_data), 
		.fifo0_wr_cmd(fifo0_wr_cmd), 
		.fifo0_wr_data(fifo0_wr_data)
   );
// Initialize Inputs
 initial begin
clk = 0;
forever begin
#1 clk = ~clk;
end
end


task resettask();
begin
	fifo0_empty_flag = 0;
	fifo0_full_flag = 0;
	fifo0_prog_full = 0;
	reset = 0;
	cfg_valid = 0;
	dec_tvalid = 0;
	dec_tlast = 0;
	lnk_up = 0;
	dec_tdata = 0;
	dec_tstrb = 0;
	dec_tuser = 0;
	a4lm_err_code = 0;
	cfg_rd_data = 0;
	enc_tx_tready = 0;
	a4lm_data = 0;
	a4lm_valid = 0;
	#10;
	reset = 1;
	#10;
	reset = 0;
	#10;
end
endtask	
	
initial begin
resettask();
lnk_up = 1;
cfg_bus_number = 8'hFF;
cfg_func_number = 3'd4;
cfg_device_number = 5'd18;
#10;
$display("Testing AXI4-Lite Master write  ", $realtime);
@(posedge clk)
dec_tstrb = 8'hFF;
dec_tuser[6] = 1;
dec_tvalid = 1;
dec_tdata = 64'h01a0090f40000001;
@(posedge dec_tready)
@(posedge clk)
dec_tlast = 1;
dec_tdata = 64'h04f302f100000010;
@(posedge clk)
dec_tlast = 0;
dec_tvalid = 0;
dec_tdata = 0;
dec_tuser[6] = 0;
dec_tstrb = 8'h00;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Lite Master write with TLP DIGEST  ", $realtime);
@(posedge clk)
dec_tstrb = 8'hFF;
dec_tuser[6] = 1;
dec_tvalid = 1;
dec_tdata = 64'h01a0090f40008001;
@(posedge dec_tready)
@(posedge clk)
dec_tlast = 0;
dec_tdata = 64'h04f302f100000010;
@(posedge clk)
dec_tlast = 1;
dec_tstrb = 8'h0F;
dec_tdata = 64'h0000f3d400c4b4a1;
@(posedge clk)
dec_tlast = 0;
dec_tstrb = 8'h00;
dec_tdata = 0;
dec_tvalid = 0;
dec_tuser[6] = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing handling of error-poisoned TLP  ", $realtime);
@(posedge clk)
dec_tstrb = 8'hFF;
dec_tuser[6] = 1;
dec_tvalid = 1;
dec_tdata = 64'h01a0090f40004001;
@(posedge dec_tready)
@(posedge clk)
dec_tlast = 1;
dec_tdata = 64'h04f302f100000010;
@(posedge clk)
dec_tlast = 0;
dec_tvalid = 0;
dec_tdata = 0;
dec_tuser[6] = 0;
dec_tstrb = 8'h00;
$display("Look at result!  ", $realtime);
#20;
$display("Testing AXI4-STREAM master write with 2 DW  ", $realtime);
@(posedge clk)
dec_tuser[2] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h01a00a0f40000002;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'hb4a3a2b100000010;
@(posedge clk)
dec_tdata = 64'ha6c8b4f20fc4d8a5;
dec_tstrb = 8'h0F;
dec_tlast = 1;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[2] = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-STREAM master write with 4 DW ", $realtime);
@(posedge clk)
dec_tuser[2] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h01a00a0f40000001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'hb4a3a2b100000010;
@(posedge clk)
dec_tdata = 64'ha6c8b4f20fc4d8a5;
@(posedge clk)
dec_tdata = 64'hb4f7c9a0d5c6a2f6;
dec_tlast = 1'b1;
dec_tstrb = 8'h0F;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[2] = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-STREAM master write with TLP Digest  ", $realtime);
@(posedge clk)
dec_tuser[2] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h01a00a0f40008001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'hb4a3a2b100000010;
@(posedge clk)
dec_tdata = 64'ha6c8b4f20fc4d8a5;
@(posedge clk)
dec_tdata = 64'hb4f7c9a0d5c6a2f6;
dec_tlast = 1'b1;
dec_tstrb = 8'hFF;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[2] = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Lite master read without TLP DIGEST  ", $realtime);
@(posedge clk)
dec_tuser[6] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h001a0090f00000001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'h00000000000000110;
dec_tstrb = 8'h0F;
dec_tlast = 1;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[6] = 0;
@(posedge clk)
a4lm_data = 32'hF0B6A5C4;
a4lm_valid = 1;
@(posedge clk)
a4lm_data = 32'h0;
a4lm_valid = 0;
@(posedge clk)
enc_tx_tready = 1;
@(negedge enc_tx_tlast)
enc_tx_tready = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Stream slave read with TLP DIGEST ", $realtime);
@(posedge clk)
dec_tuser[6] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h001a0090f00008001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'h00000000000000110;
dec_tstrb = 8'h0F;
dec_tlast = 1;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[6] = 0;
@(posedge clk)
a4lm_data = 32'hF0B6A5C4;
a4lm_valid = 1;
@(posedge clk)
a4lm_data = 32'h0;
a4lm_valid = 0;
@(posedge clk)
enc_tx_tready = 1;
@(negedge enc_tx_tlast)
enc_tx_tready = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Lite master read without TLP DIGEST  ", $realtime);
@(posedge clk)
dec_tuser[6] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h001a0090f00000001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'h00000000000000110;
dec_tstrb = 8'h0F;
dec_tlast = 1;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[6] = 0;
@(posedge clk)
a4lm_data = 32'hF0B6A5C4;
a4lm_valid = 1;
a4lm_err_code = 2;
@(posedge clk)
a4lm_data = 32'h0;
a4lm_valid = 0;
a4lm_err_code = 0;
@(posedge clk)
enc_tx_tready = 1;
@(negedge enc_tx_tlast)
enc_tx_tready = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Lite Master write on data from test of pci-e ", $realtime);
@(posedge clk)
dec_tstrb = 8'hFF;
dec_tuser[6] = 1;
dec_tvalid = 1;
dec_tdata = 64'h01a0090f40000001;
@(posedge dec_tready)
@(posedge clk)
dec_tlast = 1;
dec_tdata = 64'h0403020100000010;
@(posedge clk)
dec_tlast = 0;
dec_tvalid = 0;
dec_tdata = 0;
dec_tuser[6] = 0;
dec_tstrb = 8'h00;
$display("Look at result  ", $realtime);
#20;
$display("Testing AXI4-Lite master read without TLP DIGEST  ", $realtime);
@(posedge clk)
dec_tuser[6] = 1;
dec_tstrb = 8'hFF;
dec_tvalid = 1;
dec_tdata = 64'h01a00a0f00000001;
@(posedge dec_tready)
@(posedge clk)
dec_tdata = 64'hde03732000000010;
dec_tstrb = 8'h0F;
dec_tlast = 1;
@(posedge clk)
dec_tdata = 64'h0;
dec_tvalid = 0;
dec_tlast = 0;
dec_tuser[6] = 0;
@(posedge clk)
a4lm_data = 32'h04030201;
a4lm_valid = 1;
@(posedge clk)
a4lm_data = 32'h0;
a4lm_valid = 0;
@(posedge clk)
enc_tx_tready = 1;
@(negedge enc_tx_tlast)
enc_tx_tready = 0;
$display("Look at result  ", $realtime);
#20;
$display("Testing Configuration read  ", $realtime);
$display("Look at result  ", $realtime);
#20;
$display("Testing Configuration write  ", $realtime);
$display("Look at result  ", $realtime);
#20;
$display("The end!  ", $realtime);
$finish;
end
endmodule
