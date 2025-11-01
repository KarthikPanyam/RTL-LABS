module priencoder( input [7:0] in,
					output [2:0] out,
					output idle);
		
		wire [7:0]temp;

		
		pricirk p1(.in(in), .out(temp), .idle(idle));
		encoder e1(.encin(temp), .out(out));
		
		endmodule
		