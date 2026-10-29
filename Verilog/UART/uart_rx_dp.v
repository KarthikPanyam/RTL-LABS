module uart_rx_dp (

					input clk, rst,
					input RX_in,
					input clr_count,
					input inc_count,
					input shift_en,
					input load_out,
					
					
					output done_8,
					output [7:0] dout);
					
	reg [7:0] hold_mem;
	reg [2:0] count;
	reg [7:0] sipo;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin	
			count <=0;
		end
		
		else begin
		
			if (clr_count)
				count<=0;
			else if (inc_count)
				count <= count + 1'b1;
				
		end
		
	end
	
	
	always@(posedge clk or posedge rst) begin
		if (rst) begin
			
			sipo<=0;
		end
		
		else begin
			if(shift_en)
				sipo <= {RX_in,sipo[7:1]};
				
		end
	end
	
	always@(posedge clk or posedge rst) begin
		if (rst) 
			hold_mem <= 0;
		else if (load_out)
			hold_mem <= sipo;

	end

	
	assign dout = hold_mem;
	assign done_8 =( count == 3'd7);
	
endmodule
