module piso_d(
				input clk, rst,
				input load_en,
				input [7:0] din,
				input shift,
				input inc_count,
				input clr_count,
				
				output  dout,
				output count_done);
				
				
		reg [7:0] mem;
		
		reg [2:0] count;
		
		always@(posedge clk or posedge rst) begin
			if (rst)
				count<=0;
			else begin
				if (clr_count)
					count <= 0;
				else if (inc_count)
					count <= count + 1'b1;
					
			end
			
		end
		
		assign count_done = (count == 3'b111);
		
		always @ (posedge clk or posedge rst) begin
			if(rst)
				mem <= 0;
			else begin
				if(load_en)
					mem <= din;
				else if (shift)
					mem <= {1'b0,mem[7:1]};
				
				
			end
		end
		
		assign dout = mem[0];
		
endmodule

