`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:03:28 07/05/2018
// Design Name:   FTDIInterface
// Module Name:   C:/Users/Saman/Documents/Xilinx Projects/NeuroChip/NeuroChip/FTDIIterfaceTest.v
// Project Name:  NeuroChip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FTDIInterface
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FTDIIterfaceTest;

	// Inputs
	reg clk_pll;
	reg reset_n;
	reg FTDI_data_avilable;
	reg FTDI_empty_for_write;
	reg [7:0] FIFO_input_data;
	reg FIFO_push_data;

	// Outputs
	wire FTDI_pop_data;
	wire FTDI_push_data;
	wire [7:0] FIFO_output_data;
	wire FIFO_empty;
	wire FIFO_full;

	// Bidirs
	wire [7:0] FTDI_data;
	wire FIFO_pop_data;

	// Instantiate the Unit Under Test (UUT)
	FTDIInterface uut (
		.clk_pll(clk_pll), 
		.reset_n(reset_n), 
		.FTDI_data(FTDI_data), 
		.FTDI_data_avilable(FTDI_data_avilable), 
		.FTDI_pop_data(FTDI_pop_data), 
		.FTDI_empty_for_write(FTDI_empty_for_write), 
		.FTDI_push_data(FTDI_push_data), 
		.FIFO_output_data(FIFO_output_data), 
		.FIFO_empty(FIFO_empty), 
		.FIFO_pop_data(FIFO_pop_data), 
		.FIFO_input_data(FIFO_input_data), 
		.FIFO_push_data(FIFO_push_data), 
		.FIFO_full(FIFO_full)
	);

	initial begin
		// Initialize Inputs
		clk_pll = 0;
		reset_n = 0;
		FTDI_data_avilable = 0;
		FTDI_empty_for_write = 0;
		FIFO_input_data = 0;
		FIFO_push_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

