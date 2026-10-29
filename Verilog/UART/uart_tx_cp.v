module uart_tx_cp (
					input clk, rst,
					
					input start_tx, 
					
					
					input done_8,
					output reg load_en, shift, inc, clear_count,
					output reg [1:0] sel,
					output wire tx_complete);
					
					
	parameter IDLE = 2'b00,
				START = 2'b01,
				DATA = 2'b10,
				STOP = 2'b11 ;
	reg [1:0] current_state, next_current_state;			
				
	always@ (posedge clk or posedge rst) begin
		
		if(rst)
			current_state <= IDLE;
		else
			current_state <= next_current_state;
			
	end
	
	
	always@ (*) begin

		next_current_state = current_state;
		
		case(current_state)
		
			IDLE: if(start_tx)
					next_current_state = START;
						
			START: next_current_state = DATA;
		
			DATA: if(done_8)
				next_current_state = STOP;
				
			STOP: next_current_state = IDLE;
		
		endcase
	end	

	
	
	
	always @(*) begin
		
		sel = 0;
		load_en = 0;
		shift = 0;
		inc = 0;
		clear_count = 0;
		

	
		case (current_state)
			IDLE: begin
				sel = 0;
				load_en = 0;
				shift = 0;
				inc = 0;
				clear_count = 1;
			end
			
			START: begin
				sel = 2'b11; // dout = 0 for 1 clk cycle
				load_en = 1;

				end
				
			DATA: begin
				sel = 2'b10;
				load_en = 0;
				shift = 1;
				inc = 1;
				end
				
			STOP: begin
				sel = 2'b00;
				end
		endcase
		
	end
	
	
	assign tx_complete = (current_state == STOP);
	
endmodule


				
				
				