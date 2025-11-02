module mod12counter (
						input clk,rst,load,
						input [3:0] datain,
						output reg [3:0] count) ;
						
						
	always @ (posedge clk) 
	begin
	
		if (rst) 
			count<=0;
			
		else if (load == 1)
			count<=datain;
			
			
		else 
		begin
			if (count >= 4'b1011)
				count<=0;
			else
				count <= count +1;
		end
		
	
	end
	
endmodule