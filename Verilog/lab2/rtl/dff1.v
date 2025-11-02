module dff1 ( input din,
				input rst,clk,
				output reg q, 
				output qn);
				
				
		always @ (posedge clk) 
			begin
				if(rst)
				q<=0;
				else
				q <= din;	
				
			end
			assign qn = ~q;
	endmodule
	
	
	
				