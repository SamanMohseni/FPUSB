`timescale 1ps / 1ps

module USBTest (
	input wire clk_24,
	inout wire async_reset,
	
	inout wire [7 : 0] FTDI_data,
	
	input wire FTDI_data_avilable,
	output wire FTDI_pop_data,
	
	input wire FTDI_empty_for_write,
	output wire FTDI_push_data
	);
	
	wire clk_pll;
	wire reset;
	wire reset_n;
	wire async_reset_n;
	
	wire FIFO_empty;
	wire FIFO_pop_data;
	wire FIFO_full;
	wire FIFO_push_data;
	wire [7:0] FIFO_output_data;
	wire [7:0] FIFO_input_data;

	assign async_reset_n = ~(async_reset);
	assign reset = ~(reset_n);

	PLLClock pll_clk
	(
		.CLK_IN1(clk_24),
		.CLK_OUT1(clk_pll),
		.LOCKED(reset_n),
		.RESET(async_reset_n)
	);

	FTDIInterface ftdi_interface
	(
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

	USBController usb_controller
	(
		.clk_pll(clk_pll), 
		.reset_n(reset_n), 
		.FIFO_output_data(FIFO_output_data), 
		.FIFO_empty(FIFO_empty), 
		.FIFO_full(FIFO_full), 
		.FIFO_pop_data(FIFO_pop_data), 
		.FIFO_input_data(FIFO_input_data), 
		.FIFO_push_data(FIFO_push_data)
	);

endmodule 
