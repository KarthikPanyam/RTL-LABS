module countertb ();

	reg load, clk,rst;
	reg [3:0] datain;
	wire [3:0] count;
	
	counter c1 ( .load(load), .rst(rst), .datain(datain), .count(count), .clk(clk));
	
	initial begin
	
		clk = 0;
		
		forever #5 clk = ~clk;
	
	end
	
	
	task intialize();
	
		begin
		
			load= 0;
			rst =1;
			datain =0;
			
		end
		
	endtask
	
	
	
	
	task lden ( input [3:0] i);
	
		begin 
		
			@(negedge clk); 
			load = 1;
			datain = i;
			
			@(negedge clk);
			load = 0;
			datain = 0;
			
			
		
		end
		
	
	endtask
	
	
	task reset ( input x);
	
		begin
	
			rst = x;
		
		end
	endtask
	
	
	
	task waitclk ( input n);
	
		begin
		
			repeat(n) @(negedge clk);
		
		end
	
	endtask
	
	
	
	initial begin
	
			intialize();
			
			
			
			reset(0);
			lden(4'b0110);
			
			waitclk(8);
			
			lden(4'b0001);
			
			
			
			
		#300 $finish();	
	
	end
	
	
	
endmodule
