module vendingtb ();



		reg clk, rst;
		reg [1:0] in;
		wire [1:0] y;
		
		
		
	vending    v1 ( clk, rst, in, y);


	initial begin
	
	clk = 0;
	
	forever #10 clk = ~clk;
	
	end
	
	
	
	task initialize();
	
		begin
		
			{rst, in} = 0;
		
		end
	
	
	endtask
	
	
	
	task coin(input [1:0] x);
	
		begin
		
			@( negedge clk)
			in = x;
			
					
		end
	
	
	
	endtask
	
	
	
	
	task reset ();
		begin
		
			@(negedge clk)
			
			rst = 1;
			
			
			@(negedge clk)
			
			rst = 0;
		
		end
	
	
	
	endtask
	
	
	
	
	initial 
	
		begin
		
			initialize();
			reset();
			
			coin(2'b11);
			coin(2'b11);
			
			reset();
			
			coin(2'b10);
			coin(2'b00);
			coin(2'b11);
			reset();
			
			
			coin(2'b01);
			coin(2'b01);
			coin(2'b01);
			reset();
			
			
			#1000 $finish();
			
		
		
		
		end
		
		
endmodule
