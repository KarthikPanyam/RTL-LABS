module decod3to8_behav( input [2:0] in,
					input en,	output [7:0] out);
						
	reg [7:0] dout;					
						
	always@(*) 
	
		begin
			case(in)
				3'd0: dout = 8'b00000001;
				3'd1: dout = 8'd2;
				3'd2: dout = 8'd4;
				3'd3: dout = 8'd8;
				3'd4: dout = 8'd16;
				3'd5: dout = 8'd32;
				3'd6: dout = 8'd64;
				3'd7: dout = 8'd128;
				
				
				default: dout = 8'd0;
				
			endcase
		end
		
	
	
	assign out = en?dout:8'h00;
	
	
endmodule
		
		