`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:05:29 07/05/2018
// Design Name:   USBController
// Module Name:   C:/Users/Saman/Documents/Xilinx Projects/NeuroChip/NeuroChip/USBControllerTest.v
// Project Name:  NeuroChip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: USBController
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module USBControllerTest;

	// Inputs
	reg clk_pll;
	reg reset_n;
	reg [7:0] FIFO_output_data;
	reg FIFO_empty;
	reg FIFO_full;

	// Outputs
	wire FIFO_pop_data;
	wire [7:0] FIFO_input_data;
	wire FIFO_push_data;

	// Instantiate the Unit Under Test (UUT)
	USBController uut (
		.clk_pll(clk_pll), 
		.reset_n(reset_n), 
		.FIFO_output_data(FIFO_output_data), 
		.FIFO_empty(FIFO_empty), 
		.FIFO_full(FIFO_full), 
		.FIFO_pop_data(FIFO_pop_data), 
		.FIFO_input_data(FIFO_input_data), 
		.FIFO_push_data(FIFO_push_data)
	);

	initial begin
		// Initialize Inputs
		clk_pll = 0;
		reset_n = 0;
		FIFO_output_data = 0;
		FIFO_empty = 0;
		FIFO_full = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

