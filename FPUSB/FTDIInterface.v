`timescale 1ns / 1ps

module FTDIInterface
	(
	input wire clk_pll,
	input wire reset_n,
	
	//FTDI side:
	inout wire [7 : 0] FTDI_data,
	
	input wire FTDI_data_avilable,
	output wire FTDI_pop_data,
	
	input wire FTDI_empty_for_write,
	output wire FTDI_push_data,
	
	
	//output fifo:
	output wire [7 : 0] FIFO_output_data,
	output wire FIFO_empty,
	inout wire FIFO_pop_data,
	
	//input fifo:
	input wire [7 : 0] FIFO_input_data,
	input wire FIFO_push_data,
	output wire FIFO_full
    );
	
	//output to fifo:
	wire [7 : 0] fifo_data_out;
	wire fifo_push_data;
	wire fifo_full; //this is not handled, data will be lost...
	
	//input from fifo:
	wire [7 : 0] fifo_data_in;
	wire fifo_data_avilable;
	wire fifo_pop_data;
	
	wire fifo_empty;
	assign fifo_data_avilable = ~fifo_empty;
	
	FTDIController ftdi_controller(
		.clk_pll(clk_pll),
		.reset_n(reset_n),
		
		.FTDI_data(FTDI_data),
		.FTDI_data_avilable(FTDI_data_avilable),
		.FTDI_pop_data(FTDI_pop_data),
		.FTDI_empty_for_write(FTDI_empty_for_write),
		.FTDI_push_data(FTDI_push_data),
		
		.fifo_data_out(fifo_data_out),
		.fifo_push_data(fifo_push_data),
		.fifo_full(fifo_full),
		
		.fifo_data_in(fifo_data_in),
		.fifo_data_avilable(fifo_data_avilable),
		.fifo_pop_data(fifo_pop_data)
	);
		
	FIFO to_out(
		.clk(clk_pll),
		.rst(~reset_n),
		
		.din(fifo_data_out),
		.wr_en(fifo_push_data),
		.full(fifo_full),
		
		.dout(FIFO_output_data),
		.rd_en(FIFO_pop_data),
		.empty(FIFO_empty)
	);

	FIFO from_in(
		.clk(clk_pll),
		.rst(~reset_n),
		
		.din(FIFO_input_data),
		.wr_en(FIFO_push_data),
		.full(FIFO_full),
		
		.dout(fifo_data_in),
		.rd_en(fifo_pop_data),
		.empty(fifo_empty)
	);
	
endmodule
