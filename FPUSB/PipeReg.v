`timescale 1ns / 1ps

module PipeReg
#(parameter num_of_pipes = 2, num_of_bits = 27)( 
	input wire [num_of_bits - 1 : 0] in,
	input wire clk_pll,
	
	output wire [num_of_bits - 1 : 0] out
    );
	
	reg [num_of_bits - 1 : 0] pipe [num_of_pipes - 1 : 0];
	
	
	integer i;
	always @(posedge clk_pll)
	begin
		pipe [0] <= in;
		for(i = 1; i < num_of_pipes; i = i + 1)
		begin
			pipe[i]  <= pipe[i - 1];
		end
	end
	
	assign out = pipe[num_of_pipes - 1];
	
endmodule
