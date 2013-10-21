`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:23 10/21/2013 
// Design Name: 
// Module Name:    tlp_dec_enc_top 
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
module tlp_dec_enc_top(
    );

axi_tlp_decoder instance_name (
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
    .a4lm_wr_cmd(a4lm_wr_cmd), 
    .a4lm_rd_cmd(a4lm_rd_cmd), 
    .cfg_addr(cfg_addr), 
    .cfg_wr_data(cfg_wr_data), 
    .cfg_rd_cmd(cfg_rd_cmd), 
    .cfg_wr_cmd(cfg_wr_cmd), 
    .fifo0_wr_cmd(fifo0_wr_cmd), 
    .fifo0_wr_data(fifo0_wr_data), 
    .fifo0_empty_flag(fifo0_empty_flag), 
    .fifo0_full_flag(fifo0_full_flag), 
    .fifo0_prog_full_flag(fifo0_prog_full_flag), 
    .req_compl(req_compl), 
    .compl_code(compl_code), 
    .tlp_enc_ready(tlp_enc_ready), 
    .tenc_tc(tenc_tc), 
    .tenc_attr(tenc_attr), 
    .tenc_len(tenc_len), 
    .tenc_rid(tenc_rid), 
    .tenc_tag(tenc_tag), 
    .tenc_be(tenc_be), 
    .tenc_addr(tenc_addr), 
    .lnk_up(lnk_up), 
    .cfg_to_turnoff(cfg_to_turnoff), 
    .cfg_to_turnoff_ok(cfg_to_turnoff_ok)
    );
	 
	 
axi_tlp_encoder instance_name (
    .clk(clk), 
    .reset(reset), 
    .cfg_bus_number(cfg_bus_number), 
    .cfg_device_number(cfg_device_number), 
    .cfg_function_number(cfg_function_number), 
    .cfg_rd_data(cfg_rd_data), 
    .cfg_valid(cfg_valid), 
    .req_compl(req_compl), 
    .compl_code(compl_code), 
    .tlp_encoder_ready(tlp_encoder_ready), 
    .tenc_tc(tenc_tc), 
    .tenc_attr(tenc_attr), 
    .tenc_len(tenc_len), 
    .tenc_rid(tenc_rid), 
    .tenc_tag(tenc_tag), 
    .tenc_be(tenc_be), 
    .tenc_addr(tenc_addr), 
    .a4lm_valid(a4lm_valid), 
    .a4lm_data(a4lm_data), 
    .a4lm_err_code(a4lm_err_code), 
    .fifo1_full_flag(fifo1_full_flag), 
    .fifo1_empty_flag(fifo1_empty_flag), 
    .fifo1_rd_cmd(fifo1_rd_cmd), 
    .fifo1_rd_data(fifo1_rd_data), 
    .tx_tvalid(tx_tvalid), 
    .tx_tdata(tx_tdata), 
    .tx_tready(tx_tready), 
    .tx_tstrb(tx_tstrb), 
    .tx_tlast(tx_tlast)
    );
	 


endmodule
