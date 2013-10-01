/*
AXI4-Stream slave
Designed by Ivan Grafsky
Zelenograd, 2013
*/
`timescale 1ps/1ps

module axi4_stream_slave #(
parameter DATABUSWIDTH = 16, //in bytes
parameter TDESTWIDTH = 2, // in bits
parameter TUSERWIDTH = 22, // in bits
parameter FIFODATAWIDTH = 132, // in bits
parameter TDESTADDR = 2'b01
)
(
//common signals
input                           	clk,
input                           	reset,
//axi4stream signals
input                           	s_axis_tvalid,
output reg                      	s_axis_tready,
input [(8*DATABUSWIDTH-1):0]    	s_axis_tdata,
input [(DATABUSWIDTH-1):0]     	s_axis_tkeep,
input                           	s_axis_tlast,
input [(TDESTWIDTH-1):0]			s_axis_tdest,

   //
//user signals
output reg [(FIFODATAWIDTH-1):0] fifo1_wr_data,
output reg                       fifo1_wr_en,
input                            fifo1_prog_full_flag,
input 									fifo1_full_flag,
input										fifo1_empty_flag                            
);

localparam [2:0] idle = 3'b000,
                 start = 3'b001,
                 transmit = 3'b010,
                 state0   = 3'b011;

reg [2:0] state_reg;


always@(posedge clk or posedge reset)
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
            fifo1_wr_en <= 1'b0;
            fifo1_wr_data <= 0;
				s_axis_tready <= 1'b0;
            if(s_axis_tvalid & (s_axis_tdest == TDESTADDR) & (~fifo1_prog_full_flag) & (~(fifo1_full_flag & fifo1_empty_flag)))
                begin
                    state_reg <= transmit;
						  s_axis_tready <= 1'b1;
                end 
            end
        state0:
            begin
                state_reg <= transmit;
					 fifo1_wr_en <= 1'b1;
                fifo1_wr_data[127:0] <= s_axis_tdata;
					 if(s_axis_tkeep[0])
						begin
							fifo1_wr_data[128] <= 1'b1;
						end
					if(s_axis_tkeep[4])
						begin
							fifo1_wr_data[129] <= 1'b1;
						end
					if(s_axis_tkeep[8])
						begin
							fifo1_wr_data[130] <= 1'b1;
						end
					if(s_axis_tkeep[12])
						begin
							fifo1_wr_data[131] <= 1'b1;
						end
            end
        transmit:
            begin
					fifo1_wr_en <= 1'b1;
               fifo1_wr_data[127:0] <= s_axis_tdata;
					 if(s_axis_tkeep[0])
						begin
							fifo1_wr_data[128] <= 1'b1;
						end
					if(s_axis_tkeep[4])
						begin
							fifo1_wr_data[129] <= 1'b1;
						end
					if(s_axis_tkeep[8])
						begin
							fifo1_wr_data[130] <= 1'b1;
						end
					if(s_axis_tkeep[12])
						begin
							fifo1_wr_data[131] <= 1'b1;
						end
               if(s_axis_tlast)
                   begin
							s_axis_tready <= 1'b0;
							state_reg <= idle;
                   end
                end  
    endcase 
end
end




endmodule

