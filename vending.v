module vending ( 
				input clk, rst,
				input [1:0] in,
				output reg [1:0] y);
				
				
	parameter s0 = 2'b00,
				s1 = 2'b01,
				s2 = 2'b11;
				
				
	reg [1:0] next_state, state;
	
	
	always @(posedge clk)
	begin
	
		if(rst)
			state <= s0;
			
		else
			state <= next_state;
	end
	
	
	
	always @ (*)
	begin
	
		next_state = s0;
	
	
		case(state)
	
			s0 : begin
					if( in==2'b11) 
						next_state = s2;

					 else if (in == 2'b10)
						next_state = s1;
					else 
						next_state = s0;

				end
				
				
			s1: begin

					if (in == 2'b10)
						next_state = s2;
					else if (in == 2'b11)
						next_state = s0;
					else
						next_state = s1;
				end
				
			s2: begin
					if(in == 2'b11)
						next_state = s0;

					else if( in == 2'b10)
						next_state = s0;
					else 
						next_state = s2;
				end
			
			default: next_state = s0;
				
		endcase
					
	end
	
	
	
	always @ ( posedge clk or posedge rst)
	begin
	
		if (rst)
			begin
			
			y=0;
			
		end
		
		
		else 
			begin
			
				case(state)
				
				s0: begin 
						if( in == 2'b11)
							y = 2'b00;
						else if ( in == 2'b10)
							y = 0;
						else
							y=0;
					end
					
				s1: begin 
						if( in == 2'b11)
							y = 2'b10;
						else if ( in == 2'b10)
							y = 2'b00;
						else
							y=0;
					end
					
					
				s2: begin 
						if( in ==2'b11)
							y = 2'b11;
						else if ( in == 2'b10)
							y = 2'b10;
						else
							y=0;
					end 
					
					
					default: y = 0;
				
				endcase
			
			
			
			end
		
	
	
	end
	
endmodule
