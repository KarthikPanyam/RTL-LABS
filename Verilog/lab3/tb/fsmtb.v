module fsmtb ();

		reg clk,rst,in;
		wire y;

	fsm1 f1 ( .in(in), .rst(rst), .clk(clk), .y(y));
	
	initial begin
	clk  = 0;
	
	forever begin
	#10 clk = ~clk;
	end
	
	end
	
	initial
	begin
	
	rst = 0;
	in = 1;
	#10 in = 0;
	#10 in = 1;
	#10 in = 0;
	#10 in = 0;
	#10 in = 1;
	#10 in = 1;
	#10 in = 1;
	#10 in = 0;
	#10 in = 1;
	
	rst = 1;
	
	end
	
endmodule