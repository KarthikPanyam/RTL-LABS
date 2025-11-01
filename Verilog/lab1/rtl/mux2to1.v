module mux2to1 (input [1:0] in, 
		input sel,
		output y);
		
	assign y = (~sel & in[0] )| (sel & in[1] );
	
	
	
endmodule

