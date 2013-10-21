`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:44:33 10/21/2013 
// Design Name: 
// Module Name:    axi4_lite_top 
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
module axi4_lite_top(
    );
	 
	 
axi4_lite_slave axi4_lite_slave (
    .reset(reset), 
    .clk(clk), 
    .awvalid(awvalid), 
    .awready(awready), 
    .awprot(awprot), 
    .awaddr(awaddr), 
    .wrvalid(wrvalid), 
    .wrready(wrready), 
    .wrstrb(wrstrb), 
    .wrdata(wrdata), 
    .bready(bready), 
    .bvalid(bvalid), 
    .bresp(bresp), 
    .arvalid(arvalid), 
    .arready(arready), 
    .araddr(araddr), 
    .arprot(arprot), 
    .rdata(rdata), 
    .rready(rready), 
    .rvalid(rvalid), 
    .rresp(rresp), 
    .rfwrcmd(rfwrcmd), 
    .rfrdcmd(rfrdcmd), 
    .rfrdaddr(rfrdaddr), 
    .rfwraddr(rfwraddr), 
    .rfwrdata(rfwrdata), 
    .rfrddata(rfrddata), 
    .rf_busy(rf_busy), 
    .slave_need_rf(slave_need_rf), 
    .rf_data_valid(rf_data_valid)
    );	 
	 
	 
	 
axi4_lite_master axi4_lite_master (
    .reset(reset), 
    .clk(clk), 
    .awvalid(awvalid), 
    .awready(awready), 
    .awprot(awprot), 
    .awaddr(awaddr), 
    .wrvalid(wrvalid), 
    .wrready(wrready), 
    .wrstrb(wrstrb), 
    .wrdata(wrdata), 
    .bready(bready), 
    .bvalid(bvalid), 
    .bresp(bresp), 
    .arvalid(arvalid), 
    .arready(arready), 
    .araddr(araddr), 
    .arprot(arprot), 
    .rddata(rddata), 
    .rdready(rdready), 
    .rdvalid(rdvalid), 
    .rdresp(rdresp), 
    .userrdcmd(userrdcmd), 
    .userwrcmd(userwrcmd), 
    .userrdwraddr(userrdwraddr), 
    .userwrdata(userwrdata), 
    .userrddata(userrddata), 
    .data_valid(data_valid), 
    .error(error)
    );


register_file instance_name (
    .reset(reset), 
    .clk(clk), 
    .rd_en(rd_en), 
    .wr_en(wr_en), 
    .wr_addr(wr_addr), 
    .rd_addr(rd_addr), 
    .wr_data(wr_data), 
    .rd_data(rd_data), 
    .rf_data_valid(rf_data_valid)
    );	 


endmodule
