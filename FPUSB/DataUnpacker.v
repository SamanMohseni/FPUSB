`timescale 1ns / 1ps

module DataUnpacker (
	input wire clk_pll,
	input wire reset_n,
	input wire [31:0] data,
	input wire data_valid,
	
	output reg [7:0] FIFO_input_data,
	output reg FIFO_push_data
	);
	
	reg [7:0] buffer [3:0];
	reg [1:0] address;
	
	reg we;
	
	always @(posedge clk_pll)
	begin
		if(!reset_n)
		begin
			FIFO_push_data <= 0;
			address <= 0;
			we <= 0;
		end
		else
		begin
			if(data_valid)
			begin
				buffer[0] <= data[7:0];
				buffer[1] <= data[15:8];
				buffer[2] <= data[23:16];
				buffer[3] <= data[31:24];
				we <= 1;
			end
			
			if(we)
			begin
				FIFO_input_data <= buffer[address];
				FIFO_push_data <= 1;
				if(address == 3)
				begin
					address <= 0;
					we <= 0;
				end
				else
				begin
					address <= address + 1;
				end
				
			end
			else
			begin
				FIFO_push_data <= 0;
			end
			
		end
	end
	
endmodule
