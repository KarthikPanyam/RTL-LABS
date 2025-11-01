module ripple (input [3:0] a,
				input [3:0] b,
				input cin,
				output [3:0] sum,
				output cout);
				
		wire c0,c1,c2;
		
		
		fulladder f1 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry_out(c0));
		fulladder f2 (.a(a[1]), .b(b[1]), .cin(c0), .sum(sum[1]), .carry_out(c1));
		fulladder f3 (.a(a[2]), .b(b[2]), .cin(c1), .sum(sum[2]), .carry_out(c2));
		fulladder f4 (.a(a[3]), .b(b[3]), .cin(c2), .sum(sum[3]), .carry_out(cout));
		
		
	endmodule
	