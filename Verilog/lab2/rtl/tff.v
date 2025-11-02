module tff ( input t, clk, rst,
				output reg q,
				output qn);
				
				
		wire tw;
		xor(tw,t,q);
		
		
		always@(posedge clk) begin
		
			if(rst)
				q<=0;
				
			else begin
			
				q<=tw;
				
			end
			


		end		
		
		
		assign qn = ~q;
		
		
endmodule