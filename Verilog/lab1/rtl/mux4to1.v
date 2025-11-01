module mux4to1 ( input [3:0] in,
				input [1:0] sel,
				output y);
				
				
		wire [1:0] w;
		
		mux2to1 m1( .in(in[1:0]),.sel(sel[0]), .y(w[0]) );
		mux2to1 m2( .in(in[3:2]), .sel(sel[0]), .y(w[1]) );
		mux2to1 m3( .in(w[1:0]), .sel(sel[1]), .y(y) );
		
		
	endmodule