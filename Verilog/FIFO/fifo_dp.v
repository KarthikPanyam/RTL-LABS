module fifo_dp (

				input clk, rst,
				input [7:0] din,
				input ld_en,
				input inc_rptr, inc_wptr,
				
				output full, empty,
				output [7:0] dout);
				
				
	reg [4:0] w_ptr, r_ptr;
	
	reg [7:0] mem [15:0];
	
	always @ (posedge clk or posedge rst) begin
	
		if (rst) begin
			w_ptr <= 0;
			r_ptr <= 0;

		end
		
		
		else begin
			if(inc_wptr)
				w_ptr <= w_ptr + 1;
			if (inc_rptr)
				r_ptr <= r_ptr + 1;
			
		end
			
	end
	
	always @ (posedge clk) begin
	
		if( ld_en)
			mem[w_ptr[3:0]] <= din;
			
	end
	
	
	assign dout = mem[r_ptr[3:0]]; 
	assign empty = (w_ptr == r_ptr);
	assign full = (w_ptr[3:0] == r_ptr[3:0]) && (w_ptr[4] != r_ptr[4]);
	
endmodule




			