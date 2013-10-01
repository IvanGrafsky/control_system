`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:04 07/30/2013 
// Design Name: 
// Module Name:    tlp-encoder 
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
module axi_tlp_encoder 
#(
parameter AXIWIDTH = 8    
	 
)
(
//common signals
input clk,
input reset,

// pci-e configuration interface
input [7:0] cfg_bus_number,
input [4:0] cfg_device_number,
input [2:0] cfg_function_number,

//configuration interface
input [31:0]cfg_rd_data,
input cfg_valid,

//tlp_decoder interface
input               req_compl,
input [2:0] 			compl_code,
output reg          tlp_encoder_ready,

input [2:0]         tenc_tc,
input [1:0]         tenc_attr,
input [9:0]         tenc_len,
input [15:0]        tenc_rid,
input [7:0]         tenc_tag,
input [7:0]         tenc_be,
input [12:0]        tenc_addr,


//axi4-lite interface
input 						a4lm_valid,
input [31:0]				a4lm_data,
input [1:0] 				a4lm_err_code,

//fifo1 interface
input 				fifo1_full_flag,
input 				fifo1_empty_flag,
output reg       	fifo1_rd_cmd,
input	[131:0]		fifo1_rd_data,
//input 

//axi4-stream tx interface
output reg 								tx_tvalid,
output reg [8*AXIWIDTH-1:0] tx_tdata,
input 									tx_tready,
output reg [AXIWIDTH-1:0] tx_tstrb,
output reg								 tx_tlast
);

localparam [2:0] idle = 3'b000,
						cfg_rd_state = 3'b001,
						cfg_wr_state = 3'b010,
						reg_rd_state = 3'b100,
						adc_mem_state0 = 3'b101,
						adc_mem_state1 = 3'b110,
						adc_mem_state2 = 3'b011,
						waiting = 3'b111;


localparam PIO_64_CPLD_FMT_TYPE = 7'b10_01010;
localparam PIO_64_CPL_FMT_TYPE  = 7'b00_01010;


localparam [2:0] reg_rd_compl = 3'b001,
						cfg_rd_compl = 3'b010,
						cfg_wr_compl = 3'b011,
						adc_mem_compl = 3'b100;


reg [2:0] state_reg;
reg err_reg;
reg [131:0] 	buffer;
reg [31:0]     buffer0;
reg [9:0]	 counter;
reg [15:0] 	requester_id;
reg [7:0]	tag_reg;
reg [11:0] 	byte_count_reg;
reg [1:0] compl_reg;
reg [6:0] lower_addr;
reg flag0;
reg flag1;
reg flag2;
reg flag3;



// THIS CODE FROM PIO_64_TX_ENGINE.v

    /*
     * Calculate byte count based on byte enable
     */ //  PCI EXPRESS BASE SPECIFICATION, REV. 2.1 page 114
 
always @(clk)
begin
	casex (tenc_be[7:0])
		8'b00001xx1: byte_count_reg <= 4;
		8'b000001x1: byte_count_reg <= 3;
		8'b00001x10: byte_count_reg <= 3;
		8'b00000011: byte_count_reg <= 2;
		8'b00000110: byte_count_reg <= 2;
		8'b00001100: byte_count_reg <= 2;
		8'b00000001: byte_count_reg <= 1;
		8'b00000010: byte_count_reg <= 1;
		8'b00000100: byte_count_reg <= 1;
		8'b00001000: byte_count_reg <= 1;
		8'b00000000: byte_count_reg <= 1;
		8'b1xxxxxx1: byte_count_reg <= (tenc_len << 2);
		8'b01xxxxx1: byte_count_reg <= (tenc_len << 2)-1;
		8'b001xxxx1: byte_count_reg <= (tenc_len << 2)-2;
		8'b0001xxx1: byte_count_reg <= (tenc_len << 2)-3;
		8'b1xxxxx10: byte_count_reg <= (tenc_len << 2)-1;
		8'b01xxxx10: byte_count_reg <= (tenc_len << 2)-2;
		8'b001xxx10: byte_count_reg <= (tenc_len << 2)-3;
		8'b0001xx10: byte_count_reg <= (tenc_len << 2)-4;
		8'b1xxxx100: byte_count_reg <= (tenc_len << 2)-2;
		8'b01xxx100: byte_count_reg <= (tenc_len << 2)-3;
		8'b001xx100: byte_count_reg <= (tenc_len << 2)-4;
		8'b0001x100: byte_count_reg <= (tenc_len << 2)-5;
		8'b0001x100: byte_count_reg <= (tenc_len << 2)-5;
		8'b1xxx1000: byte_count_reg <= (tenc_len << 2)-3;
		8'b01xx1000: byte_count_reg <= (tenc_len << 2)-4;
		8'b001x1000: byte_count_reg <= (tenc_len << 2)-5;
		8'b00011000: byte_count_reg <= (tenc_len << 2)-6;
	endcase
end

    /*
     * Calculate lower address based on  byte enable
     */
	//  PCI EXPRESS BASE SPECIFICATION, REV. 2.1 page 115
/*
always @(clk) 
begin
	if(flag1 ==0)
		begin
			casex ({flag0, tenc_be[3:0]})
			5'b0_xxxx : lower_addr = 7'h0;
			5'bx_0000 : lower_addr = {tenc_addr[6:2], 2'b00};
			5'bx_xxx1 : lower_addr = {tenc_addr[6:2], 2'b00};
			5'bx_xx10 : lower_addr = {tenc_addr[6:2], 2'b01};
			5'bx_x100 : lower_addr = {tenc_addr[6:2], 2'b10};
			5'bx_1000 : lower_addr = {tenc_addr[6:2], 2'b11};
		endcase
		end
end
*/
// THIS CODE FROM PIO_64_TX_ENGINE.v



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
					flag2 <= 0;
					buffer0 <= 0;
					flag3 <= 0;
					flag0 <= 0;
					flag1 <= 0;
					requester_id <= 0;
					tag_reg <= 0;
					compl_reg <= 0;
					counter = 0;
					err_reg <= 0;
					tlp_encoder_ready <= 1'b1;
					fifo1_rd_cmd = 0;
					tx_tvalid <= 0;
					tx_tdata <= 0;
					tx_tstrb <= 0;
					tx_tlast <= 0;
					err_reg <= 0;
					buffer <= 0;
					if(req_compl&~(fifo1_empty_flag  & fifo1_full_flag))
						begin
							tlp_encoder_ready <= 1'b0;
							case(compl_code)
									reg_rd_compl:
										begin
											tx_tdata[30:24] <= PIO_64_CPLD_FMT_TYPE;
											state_reg <= waiting;
											compl_reg <= 2'd1;
											tx_tdata[9:0] <= 10'b1; // 1 DW
											tx_tdata[43:32] <= byte_count_reg;
											flag0 <= 1;
										end
									cfg_rd_compl:
										begin
											tx_tdata[30:24] <= PIO_64_CPLD_FMT_TYPE;
											state_reg <= waiting;
											tx_tdata[9:0] <= 10'b1; // 1 DW
											tx_tdata[43:32] <= 4;
											tx_tdata[47:45] <= 000;
											flag0 <= 1;
										end
									cfg_wr_compl:
										begin
											tx_tvalid <= 1'b1;
											tx_tdata[30:24] <= PIO_64_CPL_FMT_TYPE;
											state_reg <= cfg_wr_state;
											tx_tdata[9:0] <= 10'b1; // 1 DW ??????
											tx_tdata[47:45] <= 000;
											tx_tdata[43:32] <= 4;
										end
									adc_mem_compl:
										begin
											flag0 <= 1;
											compl_reg <= 2'd3;
											tx_tdata[30:24] <= PIO_64_CPLD_FMT_TYPE;
											state_reg <= waiting;
											tx_tdata[9:0] <= tenc_len; 
											counter = tenc_len;
											tx_tdata[43:32] <= byte_count_reg;
										end
							endcase
							requester_id <= tenc_rid;
							tag_reg <= tenc_tag;
							tx_tdata[63:48] <= {	cfg_bus_number,
														cfg_device_number,
														cfg_function_number  
														};
							tx_tdata[44] <= 1'b0;//BCM 
							tx_tdata[31] <= 0;
							tx_tdata[23] <= 1'b0;
							tx_tdata[22:20] <= tenc_tc;
							tx_tdata[19:14] <= 6'b0;
							tx_tdata[13:12] <= tenc_attr;
							tx_tdata[11:10] <= 2'b0;
							tx_tstrb   <= 8'hFF;
							flag1 <= 0;
						end
				end
			waiting:
				begin
					if(flag1 == 0)
						begin
							casex ({flag0, tenc_be[3:0]})
								5'b0_xxxx : lower_addr <= 7'h0;
								5'bx_0000 : lower_addr <= {tenc_addr[4:0], 2'b00};
								5'bx_xxx1 : lower_addr <= {tenc_addr[4:0], 2'b00};
								5'bx_xx10 : lower_addr <= {tenc_addr[4:0], 2'b01};
								5'bx_x100 : lower_addr <= {tenc_addr[4:0], 2'b10};
								5'bx_1000 : lower_addr <= {tenc_addr[4:0], 2'b11};
							endcase
							flag1 <= 1;
						end
					case(compl_reg)
						2'd1: // wait for a4lm data
							begin
								if(a4lm_valid)
									begin
										case(a4lm_err_code)
											2'b10:
												begin
													tx_tdata[30:24] <= PIO_64_CPL_FMT_TYPE;
													tx_tdata[47:45] <= 3'b100;//axi4-lite master can't read data ;(
													err_reg <= 1'b1;
												end
											2'b01:
												begin
													tx_tdata[30:24] <= PIO_64_CPL_FMT_TYPE;
													tx_tdata[47:45] <= 3'b001;//unsupported request
													err_reg <= 1'b1;
												end
											2'b00:
												begin
													tx_tdata[47:45] <= 3'b000;
													buffer[31:0] <= a4lm_data;
												end
										endcase
										tx_tvalid <= 1;
										state_reg <= reg_rd_state;
									end
							end
						2'd2: // wait for cfg_data
							begin
								if(cfg_valid)
									begin
										buffer[31:0] <= cfg_rd_data;
										tx_tvalid <= 1'b1;
										state_reg <= cfg_rd_state;
									end
							end
						2'd3: // wait for a4ss data
							begin
								if(fifo1_empty_flag == 0)
									begin
										tx_tdata[47:45] <= 3'b000;
										state_reg <= adc_mem_state0;
										fifo1_rd_cmd <= 1'b1;
									end
							end
					endcase
				end
			reg_rd_state:
				begin
					if(tx_tready)
						begin
							if(err_reg)
								begin
									tx_tdata[63:32] <= 32'h0;
									tx_tstrb   <= 8'h0F;
								end
							else
								begin
									tx_tstrb   <= 8'hFF;
									tx_tdata[63:32] <= buffer[31:0];
								end
							tx_tdata[31:16] <= requester_id;//
							tx_tdata[15:8] <= tag_reg;
							tx_tdata[7] <= 1'b0;
							tx_tdata[6:0] <= lower_addr;
							tx_tlast <= 1'b1;
							state_reg <= idle;
						end
				end
			cfg_rd_state:
				begin
					if(tx_tready)
						begin
							tx_tstrb <= 8'hFF;
							tx_tlast <= 1'b1;
							state_reg <= idle;
							tx_tdata[63:32] <= buffer[31:0];
							tx_tdata[31:16] <= requester_id;//
							tx_tdata[15:8] <= tag_reg;
							tx_tdata[7] <= 1'b0;
							tx_tdata[6:0] <= 7'b0;
						end
				end
			cfg_wr_state:
				begin
					if(tx_tready)
						begin
							tx_tstrb <= 8'h0F;
							tx_tlast <= 1'b1;
							state_reg <= idle;
							tx_tdata[31:16] <= tenc_rid;//
							tx_tdata[15:8] <= tenc_tag;
							tx_tdata[7] <= 1'b0;
							tx_tdata[6:0] <= 7'b0;
						end
				end
			adc_mem_state0:
				begin
					buffer <= fifo1_rd_data;
					state_reg <= adc_mem_state1;
					fifo1_rd_cmd <= 1'b0;
					tx_tvalid <= 1'b1;
				end
			adc_mem_state1:
				begin
					if(tx_tready)
						begin
							tx_tdata[31:16] <= requester_id;//
							tx_tdata[15:8] <= tag_reg;
							tx_tdata[7] <= 1'b0;
							tx_tdata[6:0] <= lower_addr;
							tx_tdata[63:32] <= buffer[31:0];
							state_reg <= adc_mem_state2;
							counter = counter - 1'b1;
						end
				end
			adc_mem_state2:
				begin
					case(counter)
					10'd1:
						begin
							state_reg <= idle;
							tx_tlast <= 1'b1;
							tx_tdata[63:32] <= 0;
							if(~buffer[130])
								begin
									tx_tdata[31:0] <= buffer[63:32];
								end
							else
								begin
									tx_tdata[31:0] <= buffer0;
								end
							tx_tstrb <= 8'h0F;
						end
					10'd3:
						begin
							fifo1_rd_cmd <= 1'b0;
							counter = counter - 2;
							buffer0 <= buffer[127:96];
							tx_tdata <= buffer[95:32];
							tx_tstrb <= 8'hFF;
						end
					default:
						begin
							if(counter[1])
								begin
									fifo1_rd_cmd <= 1'b1;
									buffer0 <= buffer[127:96];
									tx_tdata <= buffer[95:32];
									counter = counter - 2;
								end
							else
								begin
									fifo1_rd_cmd <= 1'b0;
									tx_tdata[31:0] <= buffer0;
									tx_tdata[63:32] <= fifo1_rd_data[31:0];
									buffer = fifo1_rd_data;
									counter = counter - 2;
								end
						end
					endcase
				/*	if(counter < 2)
						begin
							fifo1_rd_cmd <= 1'b0;
							state_reg <= idle;
							tx_tlast <= 1'b1;
							tx_tdata[63:32] <= 0;
							if(~flag3)
								begin
									tx_tdata[31:0] <= buffer[63:32];
								end
							else
								begin
									tx_tdata[31:0] <= buffer0;
								end
							tx_tstrb <= 8'h0F;
						end
					else
						begin
							fifo1_rd_cmd <= 1'b0;
							counter = counter - 2;
							if(counter[1])
								begin
									
								end
							else
								begin
								
								end
							/*tx_tdata <= buffer[95:32];
							buffer0 <= buffer[127:96];
							flag3 <= 1;
							if(counter[1])
								begin
									fifo1_rd_cmd <= 1'b0;
									buffer <= fifo1_rd_data;
								end
							else
								begin
									fifo1_rd_cmd <= 1'b1;
								end 
							tx_tstrb <= 8'hFF; */
						//end
				end
		endcase
	end
end





endmodule
