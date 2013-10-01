`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:48 06/26/2012 
// Design Name: 
// Module Name:    axi4-master 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: v1.01
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////





module axi4_lite_master
				#(
					parameter ADDR_WIDTH = 8,
					parameter DATA_WIDTH = 32,
					parameter STRB_WIDTH = DATA_WIDTH/8
				)
				(
					input 								reset,
					input 								clk,
					//write address channel
					output reg 							awvalid,
					input 								awready,
					output reg	[1:0]					awprot,
					output reg	[ADDR_WIDTH-1:0]	awaddr,
					//write data channel 
					output reg 							wrvalid,
					input 								wrready,
					output reg  [STRB_WIDTH-1:0]	wrstrb,
					output reg 	[DATA_WIDTH-1:0]	wrdata,
					//write response channel
					output reg 							bready,
					input 								bvalid,
					input [1:0]							bresp,
					//read address channel
					output reg 							arvalid,
					input 								arready,
					output reg [ADDR_WIDTH-1:0]	araddr,
					output reg [1:0]					arprot,
					//read data channel
					input  [DATA_WIDTH-1:0]			rddata,
					output reg 							rdready,
					input 								rdvalid,
					input  [2:0]						rdresp,
					//user interface
					input 								userrdcmd, 
					input 								userwrcmd,
					input  [ADDR_WIDTH-1:0] 		userrdwraddr,
					input  [DATA_WIDTH-1:0] 		userwrdata,
					output reg	[DATA_WIDTH-1:0] 	userrddata,
					output reg 							data_valid,
					output reg [1:0] 					error
					
				);
//states for FSM
localparam  idle   = 4'b0000,
				read1  = 4'b0001,
				read2  = 4'b0010,
				read3  = 4'b0011,
				write1 = 4'b0100, 
				write2 = 4'b0101,
				write3 = 4'b0110,

//answers of response
				okay = 2'b00, //all right!
				exokay = 2'b01, //
				slverr = 2'b10, //
				decerr = 2'b11; //
				
				
reg [3:0] statereg;


always@(posedge clk)
begin
	if(reset)
		begin
			statereg <= idle;
		end
	else
		begin
			case(statereg)
				idle:
					begin	
						araddr <= 0;
						awaddr <= 0;
						userrddata <=  32'h0;
						statereg <= idle;
						bready <= 1'b0;
						awvalid <= 1'b0;
						awprot <= 2'b00;
						wrdata <= 0;
						wrstrb <= 0;
						wrvalid <= 1'b0;
						bready <= 1'b0;
						arvalid <= 1'b0;
						arprot <= 0;
						data_valid <= 1'b0;
						rdready <= 1'b0;
						error <= 0;
						if(userrdcmd)
							begin
								araddr <= userrdwraddr;
								statereg <= read1;
								arvalid <= 1'b1;
							end
						else	
							begin
								if(userwrcmd)
									begin
										wrdata <= userwrdata;
										wrstrb <= 4'b1111;
										awvalid <= 1'b1;
										awaddr <= userrdwraddr;
										statereg <= write1;
									end
							end
					end
				read1:
					begin
						if(arready)
							begin
								arvalid <= 1'b0;
								araddr <= 1'b0;
								statereg <= read2;
							end
					end
				read2:
					begin
						if(rdvalid)
							begin
								rdready <= 1'b1;
								case (rdresp)
									okay:
										begin
											userrddata <= rddata;
											data_valid <= 1'b1;
										end
									exokay:
										begin
											userrddata <= rddata;
											data_valid <= 1'b1;
										end
									slverr:
										begin
											data_valid <= 1'b1;
											error <= 2'b10;
										end
									decerr:
										begin
											data_valid <= 1'b1;
											error <= 2'b11;
										end
								endcase 
								statereg <= idle;
							end
					end
				write1:
					begin
						if(awready)
							begin
								awvalid <= 1'b0;
								statereg <= write2;
								wrvalid <= 1'b1;
							end
					end
				write2:
					begin
						if(wrready)
							begin
								wrvalid <= 1'b0;
								statereg <= write3;
							end
					end
				write3:
					begin
						if(bvalid)
							begin
								case(bresp)
									okay:
										begin
											error <= 2'b00;
											data_valid <= 1'b1;
										end
									exokay:
										begin
											error <= 2'b00;
											data_valid <= 1'b1;
										end
									slverr:
										begin
											data_valid <= 1'b1;
											error <= 2'b10;
										end
									decerr:
										begin
											data_valid <= 1'b1;
											error <= 2'b11;
										end
								endcase
								statereg <= idle;
								bready <= 1'b1;
							end
					end
			endcase
		end
end


endmodule
