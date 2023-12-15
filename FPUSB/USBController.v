`timescale 1ns / 1ps

module USBController (
	input wire clk_pll,
	input wire reset_n,
	
	input wire [7:0] FIFO_output_data,
	input wire FIFO_empty,
	input wire FIFO_full,
	output wire FIFO_pop_data,
	output wire [7:0] FIFO_input_data,
	output wire FIFO_push_data
	);
		
		
	wire [63:0] data_packer_out;
	wire data_packer_output_valid;
	DataPacker data_packer(
		.clk_pll(clk_pll),
		.reset_n(reset_n),
		.FIFO_output_data(FIFO_output_data),
		.FIFO_empty(FIFO_empty),
		.FIFO_pop_data(FIFO_pop_data),
		.out(data_packer_out),
		.output_valid(data_packer_output_valid)
	);
	
	wire [31:0] data_unpacker_data;
	
	wire data_packer_output_valid_pipe;
	
	//adder:
	/*
	//is internally 2 level pipelined.
	FloatingPointAdder fp_adder(
		.in_1(data_packer_out[26:0]),
		.in_2(data_packer_out[58:32]),
		.clk_pll(clk_pll),
		.out(data_unpacker_data[26:0])
	);
	
	//to sync with FloatingPointAdder output,
	//we most add 2 layers of pipeline to data_packer_output_valid.
	PipeReg #(.num_of_pipes(2), .num_of_bits(1)) pipe_reg(
		.in(data_packer_output_valid),
		.clk_pll(clk_pll),
		.out(data_packer_output_valid_pipe)
	);
	*/
	
	//multiplier:
	//is internally 1 level pipelined.
	FloatingPointMultiplier fp_mul(
		.in_1(data_packer_out[26:0]),
		.in_2(data_packer_out[58:32]),
		.clk_pll(clk_pll),
		.out(data_unpacker_data[26:0])
	);
	
	//to sync with FloatingPointMultiplier output,
	//we most add 1 layers of pipeline to data_packer_output_valid.
	PipeReg #(.num_of_pipes(1), .num_of_bits(1)) pipe_reg(
		.in(data_packer_output_valid),
		.clk_pll(clk_pll),
		.out(data_packer_output_valid_pipe)
	);
	
	DataUnpacker data_unpacker(
		.clk_pll(clk_pll),
		.reset_n(reset_n),
		.data(data_unpacker_data),
		//.data_valid(data_packer_output_valid_pipe), //adder
		.data_valid(data_packer_output_valid_pipe), //multiplier
		.FIFO_input_data(FIFO_input_data),
		.FIFO_push_data(FIFO_push_data)
	);
	
endmodule
