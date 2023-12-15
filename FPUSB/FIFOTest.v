`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:23:46 07/05/2018
// Design Name:   FIFO
// Module Name:   C:/Users/Saman/Documents/Xilinx Projects/NeuroChip/NeuroChip/FIFOTest.v
// Project Name:  NeuroChip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FIFOTest;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] din;
	reg wr_en;
	reg rd_en;

	// Outputs
	wire [7:0] dout;
	wire full;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	FIFO uut (
		.clk(clk), 
		.rst(rst), 
		.din(din), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.dout(dout), 
		.full(full), 
		.empty(empty)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		
		din = 0;
		wr_en = 0;
		rd_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		#20;
		// Add stimulus here

		din = 10;
		#10;
		wr_en = 1;
		
		#10;
		
		wr_en = 0;
		
		#100;
		
		din = 7;
		#10;
		wr_en = 1;
		
		#20;
		
		wr_en = 0;
		
		#100;
		
		rd_en = 1;
		
		#20;
		
		rd_en = 0;
		
		#100;
		
		rd_en = 1;
		
		#20;
		
		rd_en = 0;
		
	end
	
	always
	begin
		#5 clk = ~clk;
	end
      
endmodule

