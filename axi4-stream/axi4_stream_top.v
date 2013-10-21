`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:29 10/21/2013 
// Design Name: 
// Module Name:    axi4_stream_top 
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
module axi4_stream_top(
    );


axi4_stream_slave instance_name (
    .clk(clk), 
    .reset(reset), 
    .s_axis_tvalid(s_axis_tvalid), 
    .s_axis_tready(s_axis_tready), 
    .s_axis_tdata(s_axis_tdata), 
    .s_axis_tkeep(s_axis_tkeep), 
    .s_axis_tlast(s_axis_tlast), 
    .s_axis_tdest(s_axis_tdest), 
    .fifo1_wr_data(fifo1_wr_data), 
    .fifo1_wr_en(fifo1_wr_en), 
    .fifo1_prog_full_flag(fifo1_prog_full_flag), 
    .fifo1_full_flag(fifo1_full_flag), 
    .fifo1_empty_flag(fifo1_empty_flag)
    );
	 
	 
axi4_stream_master instance_name (
    .clk(clk), 
    .reset(reset), 
    .m_axis_tvalid(m_axis_tvalid), 
    .m_axis_tready(m_axis_tready), 
    .m_axis_tdata(m_axis_tdata), 
    .m_axis_tkeep(m_axis_tkeep), 
    .m_axis_tlast(m_axis_tlast), 
    .m_axis_tdest(m_axis_tdest), 
    .fifo0_dataout(fifo0_dataout), 
    .fifo0_rd_en(fifo0_rd_en), 
    .ready_to_transmit(ready_to_transmit), 
    .fifo0_empty_flag(fifo0_empty_flag), 
    .fifo0_full_flag(fifo0_full_flag), 
    .fifo0_prog_empty_flag(fifo0_prog_empty_flag)
    );	 

endmodule
