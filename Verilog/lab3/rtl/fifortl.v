module fifortl(
			input clk, rst, we, re,
			input [7:0] din,
			output reg [7:0] dout,
			output empty, full);
			
			
			
	reg [4:0] wrptr, rdptr;
	reg [7:0] mem [0:15];
	
	
	integer i;
	
	
	assign full = ((wrptr[4] != rdptr[4] ) && (wrptr[3:0] == rdptr[3:0]) ) ? 1'b1: 1'b0;
	assign empty = (rdptr == wrptr)? 1'b1: 1'b0;
	
	// Write operation
	
	always @ (posedge clk) 
		begin
		
			if (rst) begin
			
				for(i=0;i<16;i = i+1) begin
					mem[i] <= 0;
				end
				wrptr <= 0;
				
			
			end
		
		
			else if ( we && !full) begin
				mem[wrptr[3:0]] <= din;
				wrptr <= wrptr + 1;
			end
		
		
			else 
				wrptr<=wrptr;
			
		end
		
		
	// end of Write operation
	
	
	
	
	// Read operation
	
	
	always @ ( posedge clk)
		begin
		
			if (rst) begin
			rdptr<=0;
			dout<=0;
			
			end
			
			
			
			else if ( re && !empty) begin
				dout <= mem[rdptr[3:0]];
				rdptr <= rdptr + 1;
				
			end
			
			else begin
			
				dout<= dout;
				rdptr <= rdptr;
				
			end
			
		end
		
		
	// End of Read operation
	
	
	

	
endmodule