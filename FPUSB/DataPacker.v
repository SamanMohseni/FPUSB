`timescale 1ns / 1ps

module DataPacker (
	input wire clk_pll,
	input wire reset_n,
	
	input wire [7:0] FIFO_output_data,
	input wire FIFO_empty,
	output reg FIFO_pop_data,
	
	output wire [63:0] out,
	output reg output_valid
	);
		
	localparam IDLE = 0;
	localparam SAMPLE = 1;
	
	reg state;
	reg next_state;
	
	reg load_cmd;
	
	reg [7:0] next_data_to_load;
	
	reg [7:0] input_buffer [7:0];
	reg [2:0] input_buffer_write_address;
	reg [2:0] next_input_buffer_write_address;
	
	assign out[7:0] = input_buffer[0];
	assign out[15:8] = input_buffer[1];
	assign out[23:16] = input_buffer[2];
	assign out[31:24] = input_buffer[3];
	assign out[39:32] = input_buffer[4];
	assign out[47:40] = input_buffer[5];
	assign out[55:48] = input_buffer[6];
	assign out[63:56] = input_buffer[7];
	
	always @(posedge clk_pll)
	begin
		if(!reset_n)
		begin
			state <= IDLE;
			input_buffer_write_address <= 0;
		end
		else
		begin
			state <= next_state;
			input_buffer_write_address <= next_input_buffer_write_address;
			if(load_cmd)
			begin
				input_buffer[input_buffer_write_address] <= next_data_to_load;
			end
		end
	end
	
	always @(*)
	begin
		//defult values:
		output_valid = 0;
		next_state = state;
		load_cmd = 0;
		next_data_to_load = 8'bxxxxxxxx;
		next_input_buffer_write_address = input_buffer_write_address;
		FIFO_pop_data = 0;
		
		case (state)
			IDLE:
			begin
				if(!FIFO_empty)
				begin
					next_state = SAMPLE;
					load_cmd = 1;
					next_data_to_load = FIFO_output_data;
				end
			end
			SAMPLE:
			begin
				FIFO_pop_data = 1;
				if(input_buffer_write_address == 7)
				begin
					next_input_buffer_write_address = 0;
					output_valid = 1;
				end
				else
				begin
					next_input_buffer_write_address = input_buffer_write_address + 1;
				end
				next_state = IDLE;
			end
		endcase
	end
	
endmodule
