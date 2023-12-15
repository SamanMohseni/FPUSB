`timescale 1ns / 1ps

module FTDIController
	(
	input wire clk_pll,
	input wire reset_n,
	
	//FTDI side:
	inout wire [7 : 0] FTDI_data,
	
	input wire FTDI_data_avilable,
	output reg FTDI_pop_data,
	
	input wire FTDI_empty_for_write,
	output reg FTDI_push_data,
	
	
	//output to fifo:
	output wire [7 : 0] fifo_data_out,
	output reg fifo_push_data,
	input wire fifo_full, //this is not handled, data will be lost...
	
	//input from fifo:
	input wire [7 : 0] fifo_data_in,
	input wire fifo_data_avilable,
	output reg fifo_pop_data	
    );
	
	//tri state: ////////////////////////////////////////////////////
	reg tri_state_ctrl;
	
	assign FTDI_data = tri_state_ctrl ? fifo_data_in : 8'bzzzzzzzz;
	/////////////////////////////////////////////////////////////////
	
	//input next_state:
	reg next_fifo_pop_data;
	
	assign fifo_data_out = FTDI_data;
	
	reg [2 : 0] state;
	reg [2 : 0] next_state;
	
	localparam IDLE = 0;
	localparam READ_PRE_WAIT = 1;
	localparam READ_POST_WAIT = 2;
	localparam READ_COMPLETE = 3;
	localparam WRITE_PRE_WAIT = 4;
	localparam WRITE_POST_WAIT = 5;
	
	reg [1 : 0] wait_cdt; //count down timer
	reg [1 : 0] next_wait_cdt;
	
	always @(posedge clk_pll)
	begin
		if(!reset_n)
		begin
			state <= IDLE;
			wait_cdt <= 0;
			fifo_pop_data <= 0;
		end
		else
		begin
			state <= next_state;
			wait_cdt <= next_wait_cdt;
			fifo_pop_data <= next_fifo_pop_data;
		end
	end
	
	always @(*)
	begin
		next_state = state;
		
		//defult values:
		tri_state_ctrl = 0;
		FTDI_pop_data = 1;
		FTDI_push_data = 1;
		
		fifo_push_data = 0;
		next_fifo_pop_data = 0;
		
		next_wait_cdt = wait_cdt - 1;
		
		
		case (state)
			IDLE:
			begin
				if(FTDI_data_avilable == 0)
				begin
					FTDI_pop_data = 0;
					next_wait_cdt = 2;
					next_state = READ_PRE_WAIT;
				end
				else if(FTDI_empty_for_write == 0 && fifo_data_avilable)
				begin
					tri_state_ctrl = 1;
					next_wait_cdt = 1;
					next_state = WRITE_PRE_WAIT;
				end
			end
			READ_PRE_WAIT:
			begin
				FTDI_pop_data = 0;
				if(wait_cdt == 0)
				begin
					fifo_push_data = 1;
					next_wait_cdt = 1;
					next_state = READ_POST_WAIT;
				end
			end
			READ_POST_WAIT:
			begin
			FTDI_pop_data = 0;
				if(wait_cdt == 0)
				begin
					FTDI_pop_data = 1;
					next_wait_cdt = 1;
					next_state = READ_COMPLETE;
				end
			end
			READ_COMPLETE:
			begin
				if(wait_cdt == 0)
				begin
					next_state = IDLE;
				end
			end
			WRITE_PRE_WAIT:
			begin
				tri_state_ctrl = 1;
				if(wait_cdt == 0)
				begin
					FTDI_push_data = 0;
					next_fifo_pop_data = 1;
					next_wait_cdt = 2;
					next_state = WRITE_POST_WAIT;
				end
			end
			WRITE_POST_WAIT:
			begin
				FTDI_push_data = 0;
				if(wait_cdt == 0)
				begin
					FTDI_push_data = 1;
					next_state = IDLE;
				end
			end
		endcase
	end
	
endmodule
