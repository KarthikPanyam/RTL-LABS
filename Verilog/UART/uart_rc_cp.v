module uart_rx_cp (

					input RX_in,
					input clk, rst,
					
					input done_8,
					output reg clr_count,
					output reg inc_count, shift_en, load_out, rx_complete);
					
	parameter IDLE = 2'b00,
				START = 2'b01,
				DATA = 2'b10,
				STOP = 2'b11;
				
				
	reg [1:0] current_state, next_state;
	
	always @(posedge clk or posedge rst) begin
		if(rst) 
			current_state <= IDLE;
			
		else 
			current_state <= next_state;
			
	end
	
	
	always @ (*) begin
		next_state = current_state;
	
		case(current_state)
			IDLE: if(RX_in == 0)
				next_state = DATA;
				
					
			DATA: if(done_8)
				next_state = STOP;
				
			STOP: next_state = IDLE;
		endcase
		
	end
	
	
	always @(*) begin
	
		
	
			clr_count = 1;
			inc_count = 0;
			shift_en = 0;
			load_out = 0;
			
		
		
		
		
		
			case(current_state)
				IDLE: begin
					clr_count = 1;
				end
			
				DATA: begin
					clr_count = 0;
					shift_en = 1;
					inc_count = 1;
				end
			
				STOP: begin
					load_out =1;
					
				end
			
			endcase
		
	
	end
	
	
always @(posedge clk or posedge rst) begin
    if (rst)
        rx_complete <= 1'b0;
    else
        rx_complete <= (current_state == STOP);
end
	
endmodule