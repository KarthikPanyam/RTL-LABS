module mux4to1tri (input [1:0] sel,
					input [3:0] in,
					output y);
					
		wire [3:0] w;
		
		decoder2to4 d1 (.s(sel), .out(w));
		
		bufif1 b1 (y,in[0],w[0]);
		bufif1 b2 (y,in[1],w[1]);
		bufif1 b3 (y,in[2],w[2]);
		bufif1 b4 (y,in[3],w[3]);
		
		
		endmodule
		