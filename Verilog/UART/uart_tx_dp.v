module uart_tx_dp (

					input clk, rst,
					input load_en,
					input shift_en,
					input inc_count,
					input clear_count,
					input [1:0] sel,
					
					input [7:0] din,
					
					
					output dout,
					output done_8);
					
					
	reg [7:0] mem;

	reg [2:0] count;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin

			count <= 0;

		end
		
		
		else begin
			if (clear_count)
				count <=0;
			else if( inc_count)
				count<= count +1 ;
		end
		
	end
	
	
	assign done_8 = (count == 7);
	
	always@(posedge clk or posedge rst) begin
		
		if (rst)
			mem<=0;		
		
		else begin 
		
			if(load_en)
				mem <= din;
			
			else if(shift_en) begin
				mem <= {1'b1,mem[7:1]};
			end
		end
		
		
		
	end
	
	assign dout = sel[1]? ( sel[0]? 0: mem[0]) : 1;
	
	
endmodule	