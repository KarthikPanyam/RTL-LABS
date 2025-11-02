module counter (
				input load,
				input [3:0] datain,
				input clk, rst,
				output reg [3:0]count);
				
			
				
				
				
	always@( posedge clk ) begin
	
		if (rst) 
			count<=0;
		
		else if(load == 1)
			count <=datain;
			
		else
			begin
				count <= count + 1;
				
			end
			
	end	

endmodule