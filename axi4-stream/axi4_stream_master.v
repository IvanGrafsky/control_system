/*
AXI4-Stream master
Designed by Ivan Grafsky
Zelenograd, 2012 */


`timescale 1ps/1ps

module axi4_stream_master #(
parameter DATABUSWIDTH = 16, //in bytes
parameter TIDWIDTH = 2, // in bits
parameter TDESTWIDTH = 2, // in bits
parameter TUSERWIDTH = 4, // in bits
parameter FIFODATAWIDTH = 132 // in bits
)
(

//common signals
input                            	clk,
input                            	reset,
//axi4stream signals
output reg									m_axis_tvalid,
input						     				m_axis_tready,
output reg [(8*DATABUSWIDTH-1):0]   m_axis_tdata,
output reg[(DATABUSWIDTH-1):0]      m_axis_tkeep,
output reg									m_axis_tlast,
output reg [TDESTWIDTH-1:0]			m_axis_tdest,
//output reg [(TUSERWIDTH-1):0]       m_axis_tuser,

//user signals
input [(FIFODATAWIDTH-1):0]      	fifo0_dataout,
output reg                       	fifo0_rd_en,
output reg                       	ready_to_transmit,
input                            	fifo0_empty_flag,
input 										fifo0_full_flag,
input											fifo0_prog_empty_flag
);

localparam [2:0] idle     =  3'b000,
				 start    =  3'b001,
				 waitstate  = 3'b010,
				 state0   =  3'b100,
				 state1   =  3'b101,
				 state2  = 3'b110,
				 state3  = 3'b011,
				 transmit = 3'b111;
 
reg [2:0] state_reg;
reg flag;
reg [131:0] buffer;
reg [9:0] counter;
reg [4:0] counter0;

always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			state_reg <= idle;
		end
	else
		begin
			case(state_reg)
				waitstate:
					begin
						m_axis_tvalid = 1'b0;
						m_axis_tlast = 1'b0;
						if(counter0 == 30)
							begin
								state_reg <= idle;
							end
						else
							begin
								counter0 <= counter0 + 1;
							end
					end
				idle:
					begin
						counter0 <= 0;
						flag <= 1'b0;
						buffer <= 0;
						m_axis_tlast = 1'b0;
						counter = 0;
						fifo0_rd_en <= 1'b0;
						m_axis_tvalid = 1'b0;
						m_axis_tdest <= 2'b00;
						m_axis_tdata <= 0;
						m_axis_tkeep <= 0;
						ready_to_transmit <= 1'b1;
						if((~fifo0_empty_flag) & (~fifo0_prog_empty_flag) & (~(fifo0_empty_flag & fifo0_full_flag)))
							begin
								fifo0_rd_en <= 1'b1;
								ready_to_transmit <= 1'b0;
								state_reg <= state0;
							end
					end
				state0:
					begin
						case(fifo0_dataout[9:0])
							10'b0:
								begin
									counter = 1024;
								end
							default:
								begin
									counter = fifo0_dataout[9:0];
								end
						endcase
						m_axis_tdest[0] <= fifo0_dataout[10];
						m_axis_tdest[1] <= fifo0_dataout[12];
						state_reg <= state1;
					end
				state1:
					begin
						m_axis_tdata <= fifo0_dataout[127:0];
						case(fifo0_dataout[131:128])
							4'b11:
								begin
									m_axis_tkeep <= 16'h00FF;
								end
							4'b1111:
								begin
									m_axis_tkeep <= 16'hFFFF;
								end
						endcase
						if(counter < 5)
							begin
								fifo0_rd_en <= 1'b0;
								state_reg <= state2;
							end
						else
							begin
								counter = counter - 4;
								state_reg <= state3;
							end
					end
				state2:
					begin
						m_axis_tvalid = 1'b1;
						m_axis_tlast = 1'b1;
						if(m_axis_tready)
							begin
								state_reg <= waitstate;
							end
					end
				state3:
					begin
						buffer <= fifo0_dataout;
						fifo0_rd_en <= 1'b0;
						state_reg <= start;
						m_axis_tvalid = 1'b1;
						if(counter < 5)
							begin
								flag <= 1'b1;
							end
						else
							begin
								counter = counter - 4;
							end
					end
				start:
					begin
						if(m_axis_tready)
							begin
								m_axis_tdata <= buffer[127:0];
								if(flag)
									begin
										state_reg <= waitstate;
										m_axis_tlast = 1'b1;
									end
								else
									begin
										state_reg <= transmit;
									//	counter = counter - 4;
									end
							end
					end
				transmit:
					begin
						m_axis_tdata <= fifo0_dataout[127:0];
						case(fifo0_dataout[131:128])
							4'b11:
								begin
									m_axis_tkeep <= 16'h00FF;
								end
							4'b1111:
								begin
									m_axis_tkeep <= 16'hFFFF;
								end
						endcase
						if(counter < 5)
							begin
								m_axis_tlast = 1'b1;
								state_reg <= waitstate;
							end
						else
							begin
								counter = counter - 4;
							end
					end
			endcase
		end
end


endmodule
