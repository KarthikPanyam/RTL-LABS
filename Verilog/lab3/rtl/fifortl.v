module fifo16x8 (
input clk, rst,
input [7:0] din,
input re, we,
output reg [7:0] dout,
output empty, full);

reg [4:0] wr_ptr, rd_ptr;

integer i;

reg [7:0] mem [0:15];

always @ (posedge clk)
begin

	if(rst) begin
		dout<=0;
		{wr_ptr, rd_ptr} <= 0;
		for (i = 0; i<16; i = i+1)
			mem[i] <= 0;
	end


	else begin

		if(we && !full) begin

			mem[wr_ptr[3:0]] <= din;
			wr_ptr <= wr_ptr + 1;
		end

		if(re && !empty) begin

			dout<= mem[rd_ptr[3:0]];
			rd_ptr <= rd_ptr + 1;
		end
	end


end

assign empty = ( wr_ptr == rd_ptr) ? 1'b1:1'b0;

assign full = ( (wr_ptr[3:0] == rd_ptr[3:0]) && (wr_ptr[4] != rd_ptr[4]) ) ? 1'b1:1'b0;


endmodule
