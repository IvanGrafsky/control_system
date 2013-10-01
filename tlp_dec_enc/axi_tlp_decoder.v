`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:38:20 07/29/2013 
// Design Name: 
// Module Name:    axi_tlp_decoder 
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
module axi_tlp_decoder 
#(
parameter AXIDATAWIDTH = 8
)
(
// common signals
input clk,
input reset,

// axi4-stream input interface
input tvalid,
input [8*AXIDATAWIDTH-1:0] tdata,
output reg tready,
input [AXIDATAWIDTH-1:0] tstrb,
input [21:0] tuser,
input tlast,

// axi4-lite master interface
output reg [7:0]  a4lm_addr,
output reg [31:0] a4lm_wr_data,
output reg a4lm_wr_cmd,
output reg a4lm_rd_cmd,

//configuration interface
output reg [7:0] cfg_addr,
output reg [31:0] cfg_wr_data,
output reg cfg_rd_cmd,
output reg cfg_wr_cmd,
// fifo interface
output reg fifo0_wr_cmd,
output reg [16*AXIDATAWIDTH+4-1:0] fifo0_wr_data,
input fifo0_empty_flag,
input fifo0_full_flag,
input fifo0_prog_full_flag,


//tlp encoder interface
output reg req_compl,
output reg [2:0] compl_code,
input tlp_enc_ready,

output reg [2:0]   tenc_tc,                        // Memory Read TC
output reg [1:0]   tenc_attr,                      // Memory Read Attribute
output reg [9:0]   tenc_len,                       // Memory Read Length (1DW)
output reg [15:0]  tenc_rid,                       // Memory Read Requestor ID
output reg [7:0]   tenc_tag,                       // Memory Read Tag
output reg [7:0]   tenc_be,                        // Memory Read Byte Enables
output reg [12:0]  tenc_addr,                      // Memory Read Address
//other signals
input lnk_up,
input cfg_to_turnoff,
output reg cfg_to_turnoff_ok
);

localparam [3:0] idle = 4'b0000,
						discharge_tlp = 4'b1111,
						cfg_rd = 4'b0001,
						cfg_wr = 4'b0010,
						a4lm_rd = 4'b0011,
						a4lm_wr = 4'b0100,
						a4sm_wr0 = 4'b0101,
						a4sm_wr1 = 4'b1001,
						wait_state = 4'b1000,
						receiving = 4'b1100;
						

reg [3:0] state_reg;
reg  tlp_digest;
reg [16*AXIDATAWIDTH+4-1:0] buffer0;


localparam [2:0] reg_rd_compl = 3'b001,
						cfg_rd_compl = 3'b010,
						cfg_wr_compl = 3'b011,
						adc_mem_compl = 3'b100;


localparam ADC_MEM_RD32 = 9'b00_00000_01;
localparam ADC_MEM_WR32 = 9'b10_00000_01;	
localparam REG_RD32 = 9'b00_00000_10;
localparam REG_WR32 = 9'b10_00000_10;
localparam CFG_RD   = 9'b00_00100_00; 
localparam CFG_WR   = 9'b10_00100_00;


always@(posedge clk)
begin
if(reset)
	begin
		state_reg <= idle;
	end
else
	begin
		case(state_reg)
			idle:
				begin
					cfg_to_turnoff_ok <= 1'b0;
					buffer0 = 0;
					tenc_tc <= 0;
					tenc_attr <= 0;
					tenc_len <= 0;
					tenc_rid <= 0;
					tenc_tag <= 0;
					tenc_be <= 0;
					tenc_addr <= 0;
					a4lm_wr_data <= 0;
					a4lm_addr <= 0;
					a4lm_wr_cmd <= 0;
					a4lm_rd_cmd <= 0;
					cfg_addr <= 0;
					cfg_wr_data <= 0;
					cfg_rd_cmd <= 0;
					cfg_wr_cmd <= 0;
					fifo0_wr_cmd = 0;
					fifo0_wr_data = 0;
					req_compl <= 0;
					compl_code <= 0;
					tready <= 1'b0;
					if(cfg_to_turnoff)
						begin
							cfg_to_turnoff_ok <= 1'b1;
						end
					if(lnk_up & tlp_enc_ready & tvalid & ~tlast & (~(fifo0_empty_flag & fifo0_full_flag)) & (~fifo0_prog_full_flag) &(~cfg_to_turnoff))
						begin
							state_reg <= receiving;
							tready <= 1'b1;
/*							tready <= 1'b1;
							if(tdata[14] == 0)
								begin
									tlp_digest <= tdata[15];
									case ({tdata[30:24],{tuser[4],tuser[3] | tuser[2]}})
										REG_RD32:
											begin
												state_reg <= a4lm_rd;
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl <= 1'b1;
												req_compl_w_data <= 1'b1;
												compl_code <= 3'b001;
											end
										REG_WR32:
											begin
												state_reg <= a4lm_wr;
											end
										ADC_MEM_RD32:
											begin
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl <= 1'b1;
												req_compl_w_data <= 1'b1;
												compl_code <= 3'b010;
												state_reg <= idle;
											end
										ADC_MEM_WR32:
											begin
												state_reg <= a4sm_wr0;
											end
										CFG_RD:
											begin
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl_w_data <= 1'b1;
												req_compl <= 1'b1;
												state_reg <= cfg_rd;
											end
										CFG_WR:
											begin
												req_compl <= 1'b1;
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												compl_code <= 3'b100;
												state_reg <= cfg_wr;
											end
										default:
											begin
												state_reg <= discharge_tlp;
											end
									endcase
								end
							else
								begin
									state_reg <= discharge_tlp;
								end */
						end 
				end
			receiving:
				begin
					if(tdata[14] == 0)
							begin
								tlp_digest <= tdata[15];
								case ({tdata[30:24],{tuser[6],tuser[4] | tuser[2]}})
										REG_RD32:
											begin
												state_reg <= a4lm_rd;
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl <= 1'b1;
												compl_code <= reg_rd_compl;
											end
										REG_WR32:
											begin
												state_reg <= a4lm_wr;
											end
										ADC_MEM_RD32:
											begin
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl <= 1'b1;
												compl_code <= adc_mem_compl;
												state_reg <= idle;
											end
										ADC_MEM_WR32:
											begin
												buffer0[9:0] = tdata[9:0];
												buffer0[15:10] = tuser[7:2];
												state_reg <= a4sm_wr0;
											end
										CFG_RD:
											begin
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												req_compl <= 1'b1;
												state_reg <= cfg_rd;
												compl_code <= cfg_rd_compl;
											end
										CFG_WR:
											begin
												req_compl <= 1'b1;
												tenc_tc     <= tdata[22:20]; 
												tenc_attr   <= tdata[13:12];
												tenc_len    <= tdata[9:0];
												tenc_rid    <= tdata[63:48];
												tenc_tag    <= tdata[47:40];
												tenc_be     <= tdata[39:32];
												compl_code <= cfg_wr_compl;
												state_reg <= cfg_wr;
											end
										default:
											begin
												state_reg <= discharge_tlp;
											end
								endcase
							end
						else
							begin
								state_reg <= discharge_tlp;
							end
				end
			a4lm_rd:
				begin
					req_compl <= 1'b0;
					a4lm_addr <= tdata[9:2];
					tenc_addr <= tdata[14:2];
					a4lm_rd_cmd <= 1'b1;
					state_reg <= idle;
				end
			a4lm_wr:
				begin
					a4lm_addr <= tdata[9:2];
					a4lm_wr_data <= tdata[63:32];
					a4lm_wr_cmd <= 1'b1;
					if(tlp_digest)
						begin
							state_reg <= discharge_tlp;
						end
					else
						begin
							state_reg <= idle;
							tready <= 1'b0;
						end
				end
			a4sm_wr0:
				begin
					buffer0[45:16] = tdata[31:2];
					fifo0_wr_data = buffer0;
					fifo0_wr_cmd = 1'b1;
					buffer0[31:0] = tdata[63:32];
					buffer0[128] = 1;
					state_reg <= a4sm_wr1;
				end
			a4sm_wr1:
				begin
					fifo0_wr_cmd = 1'b0;
					if(tlast)
						begin
							if(buffer0[129])
								begin
									buffer0[127:96] = tdata[31:0];
									buffer0[131] = 1'b1;
									fifo0_wr_cmd = 1'b1;
									fifo0_wr_data = buffer0;
									tready <= 1'b0;
									state_reg <= idle;
								end
							else
								begin
									buffer0[63:32] = tdata[31:0];
									buffer0[129] = 1'b1;
									buffer0[131:130] = 2'b00;
									fifo0_wr_cmd = 1'b1;
									fifo0_wr_data = buffer0;
									tready <= 1'b0;
									state_reg <= idle;
								end
						end
					else
						begin
							if(buffer0[129])
								begin
									buffer0[127:96] = tdata[31:0];
									buffer0[131] = 1'b1;
									fifo0_wr_cmd = 1'b1;
									fifo0_wr_data = buffer0;
									buffer0[31:0] = tdata[63:32];
									buffer0[131:128] = 4'b0001;
								end
							else
								begin
									buffer0[95:32] = tdata[63:0];
									buffer0[130:129] =  2'b11;
								end
						end
				end
			cfg_rd:
				begin
					tenc_addr <= tdata[14:2];
					req_compl <= 1'b0;
					cfg_addr <= tdata[9:2];
					cfg_rd_cmd <= 1'b1;
				end
			cfg_wr:
				begin
					tenc_addr <= tdata[14:2];
					req_compl <= 1'b0;
					cfg_wr_cmd <= 1'b1;
					cfg_addr <= tdata[9:2];
					cfg_wr_data <= tdata[63:32];
					if(tlast)
						begin
							state_reg <= idle;
						end
					else
						begin
							state_reg <= discharge_tlp;
						end
				end
			discharge_tlp:
				begin
					a4lm_wr_cmd <= 1'b0;
					if(tlast)
						begin
							state_reg <= idle;
							tready <= 1'b0;
						end
				end
		endcase
	end
end

endmodule
