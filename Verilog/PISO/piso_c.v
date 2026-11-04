module piso_c ( input clk, rst,
				input count_done,
				input start,
				
				output reg load_en, done,
				output reg shift,
				output reg inc_count,
				output reg clr_count);
				
	localparam IDLE = 2'b00,
				DATA_IN = 2'b01,
				DATA_SHIFT = 2'b10,
				FINAL_out = 2'b11;
				
	reg [1:0] current_state, next_state;
	
	always@(posedge clk or posedge rst) begin
		if(rst)
			current_state <= IDLE;
		else
			current_state <= next_state;
			
	end
	
	
	always@ (*) begin
	next_state = current_state;
	
		case(current_state)
			IDLE : begin
						if(start)
						next_state = DATA_IN;
					end
			DATA_IN: next_state = DATA_SHIFT;
			
			DATA_SHIFT :begin
							if(count_done)
								next_state = FINAL_out;
						end
						
			FINAL_out: next_state = IDLE;
			
		endcase
		
	end
	
	
	always@(*) begin
	
	load_en =0;
	shift = 0;
	inc_count =0;
	clr_count = 0;
	done = 0;
		case(current_state)
			DATA_IN : begin
						load_en = 1;
						
						end
			DATA_SHIFT : begin
							load_en = 0;
							shift = 1;
							inc_count = 1;
						end
			IDLE: clr_count =1;
			
			FINAL_out: done = 1; 			
		endcase
					
						
	end


endmodule