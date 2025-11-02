module updown (
				input clk,rst,load,mode,
				input [3:0] datain,
				output reg [3:0] count);
				
	always @ ( posedge clk)
	begin
	
		if (rst) 
			count <=0;
			
		else if ( load == 1)
			count <= datain;
			
		else
		begin
			if(mode == 1)
				count <= count +1;
			
			else
				count <= count-1;
		end
		

	end	
	
endmodule
