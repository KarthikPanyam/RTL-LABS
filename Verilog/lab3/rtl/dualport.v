module dualport (
					input clk, rst, we, re,
					input [3:0] rd_add, wr_add,
					input [7:0] datain,
					output reg [7:0] dataout);
		
		
		reg [7:0] ram [15:0];
		integer i;

		
		always @ (posedge clk) 
		begin
		
			if (rst)
			begin
				
				for(i=0;i<=15;i = i+1)begin
				ram[i] <= 0;	
				end
				
				dataout<=0;				
			end
			
			
			
			else if (we)
			begin
			
					ram[wr_add] <= datain;
			
			end
		
		
		
			else if (re)
			begin
			
					dataout <= ram[rd_add];
			
			end
			
			
			
			else
			begin
			
				dataout<=dataout;
				ram[wr_add] <= ram[wr_add];
			
			end
		
		end

endmodule