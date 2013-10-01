`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:12 06/28/2012 
// Design Name: 
// Module Name:    register_file 
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
module register_file
					#(
						parameter   NMBROFDATABITS       =    32,//number of bits
										NMBROFADDRBITS   =    5 // number of address bits
					)
					
					(
						input 												reset,
						input													 clk,
						input 												rd_en,
						input 												wr_en,
						input	 		[NMBROFADDRBITS-1:0]				 wr_addr, 
						input 		[NMBROFADDRBITS-1:0]					 rd_addr,
						input 		[NMBROFDATABITS-1:0]			 	wr_data,
						output reg 	[NMBROFDATABITS-1:0]	 			rd_data,
						output reg 											rf_data_valid
					);	

reg [NMBROFDATABITS-1:0] /* [3:0] */ array_reg/*[NMBROFDATABITS-1:0] */ [0:15]; 

reg statereg;

localparam idle = 1'b0,
				read = 1'b1;



always@(posedge clk)
begin
	if(reset)  
		begin
			statereg <= idle;
			array_reg[0] <= 32'hFFFFFFFF;
			array_reg[1] <= 32'hFFFFFFFF;
			array_reg[2] <= 32'hFFFFFFFF;
			array_reg[3] <= 32'hFFFFFFFF;
			array_reg[4] <= 32'hFFFFFFFF; 
			array_reg[5] <= 32'hFFFFFFFF;
			array_reg[6] <= 32'hFFFFFFFF;
			array_reg[7] <= 32'hFFFFFFFF;
			array_reg[8] <= 32'hFFFFFFFF;
			array_reg[9] <= 32'hFFFFFFFF;
			array_reg[10] <= 32'hFFFFFFF;
			array_reg[11] <= 32'hFFFFFFF;
			array_reg[12] <= 32'hFFFFFFF;
			array_reg[13] <= 32'hFFFFFFF;
			array_reg[14] <= 32'hFFFFFFF;
			array_reg[15] <= 32'hFFFFFFF;
		end
	else
		begin
			case(statereg)
				idle:
					begin
						rd_data <= 32'h0;
						rf_data_valid <= 0;
						if(rd_en)
							begin
								rf_data_valid <= 1'b1;
								statereg <= read;
								if(rd_addr < 16)
									begin
										rd_data <= array_reg[rd_addr[3:0]];
									end
								else 
									begin
										rd_data <= 32'hFFFFFFFF;
									end
							end
						if(wr_en)
							begin
								if(wr_addr < 16)
									begin
										array_reg[wr_addr[3:0]] <= wr_data;
									end
							end
					end
				read:
					begin
						statereg <= idle;						
					end
			endcase
		
		end
end

endmodule
