`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Designed by Ivan Grafskiy
// Zelenograd, August,2012
// Module Axi4-lite slave
//////////////////////////////////////////////////////////////////////////////////
module axi4_lite_slave
				#(
					parameter ADDR_WIDTH = 8,
					parameter ADDR_WIDTH_SLAVE = 5,
					parameter DATA_WIDTH = 32,
					parameter STRB_WIDTH = DATA_WIDTH/8,
					parameter AXI_SLAVE_ADDR = 3'b000
				)


				(
					input 									reset,
					input 									clk,
					//write address channel
					input 									awvalid,
					output reg 								awready,
					input 		[1:0]						awprot,
					input 		[ADDR_WIDTH-1:0]		awaddr,
					//write data channel 
					input 									wrvalid,
					output reg 								wrready,
					input 		[STRB_WIDTH-1:0]		wrstrb,
					input  		[DATA_WIDTH-1:0]		wrdata,
					//write response channel
					input 									bready,
					output reg 								bvalid,
					output reg [1:0]						bresp,
					//read address channel
					input 									arvalid,
					output reg 								arready,
					input  		[ADDR_WIDTH-1:0]		araddr,
					input 		[1:0]						arprot,
					//read data channel
					output reg [DATA_WIDTH-1:0]		rdata,
					input 									rready,
					output reg 								rvalid,
					output reg [2:0]						rresp,
					//reg file interface
					output reg 								rfwrcmd,
					output reg 								rfrdcmd,
					output reg [ADDR_WIDTH_SLAVE-1:0] rfrdaddr,
					output reg [ADDR_WIDTH_SLAVE-1:0] rfwraddr,
					output reg[(DATA_WIDTH)-1:0] 	rfwrdata,
					input 		[(DATA_WIDTH)-1:0] 	rfrddata,
					input 									rf_busy,
					output reg 								slave_need_rf,
					input										rf_data_valid
					);
					
					  
localparam 		idle = 3'b000,
					write1 = 3'b001,
					write2 = 3'b010,
					read1 = 3'b100,
					read2 = 3'b101;
reg [2:0]statereg;
reg [DATA_WIDTH-1:0] datareg;




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
						bvalid <= 0;
						wrready <= 1'b0;
						arready <= 1'b0;
						rdata <= 0;
						rfrdaddr <= 1'b0;
						rfwraddr <= 1'b0;
						rvalid <= 1'b0;
						rresp <= 2'b00;
						awready <= 1'b0;
						bresp <= 2'b00;
						rfwrcmd <= 1'b0;
						rfrdcmd <= 0;
						rfwrdata <= 0;
						statereg <= idle;  
						slave_need_rf <= 1'b0;
						if(awvalid)
							begin
								if(awaddr[7:5] == AXI_SLAVE_ADDR)
									begin
										statereg <= write1;
										rfwraddr <= awaddr[4:0];
										awready <= 1'b1;
										slave_need_rf <= 1'b1;
									end
							end 
						if(arvalid)
							begin
								if(araddr[7:5] == AXI_SLAVE_ADDR)
									begin
										statereg <= read1;
										rfrdaddr <= araddr[4:0];
										rfrdcmd <= 1'b1;
										arready <= 1'b1;
										slave_need_rf <= 1'b1;
									end
							end
					end
				read1:
					begin
						arready <= 1'b0;
						if(~rf_busy)
							begin
								rfrdcmd <= 1'b0;
								if(rf_data_valid)
									begin
										rdata <= rfrddata;
										rvalid <= 1'b1;
										rresp <= 2'b00;
										statereg <= read2;
										slave_need_rf <= 1'b0;
									end
							end
					end
				read2:
					begin
						if(rready)
							begin
								rvalid <= 1'b0;
								statereg <= idle;
							end
					end
				write1:
					begin
						awready <= 1'b0;
						if(wrvalid)
							begin
								wrready <= 1'b1;
								rfwrdata <= wrdata;
								statereg <= write2;
								if(~rf_busy)
									begin
										rfwrcmd <= 1'b1;
										bresp <= 2'b00;
										bvalid <= 1'b1;
									end
							end
					end
				write2:
					begin
						rfwrcmd <= 1'b0;
						wrready <= 1'b0;
						bvalid <= 1'b1;
						slave_need_rf <= 1'b0;
						if(bready)
							begin
								statereg <= idle;
								bvalid <= 1'b0;
							end
					end
		endcase
	end
end


endmodule
