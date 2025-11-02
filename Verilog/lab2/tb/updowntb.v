module updowntb();


	reg load, clk,rst,mode;
	reg [3:0] datain;
	wire [3:0] count;
	
	updown c1 ( .load(load), .rst(rst), .datain(datain), .count(count), .clk(clk), .mode(mode));
	
	initial begin
	
		clk = 0;
		
		forever #5 clk = ~clk;
	
	end
	
	
	
	task intialize();
	
		begin
			mode = 0;
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
			datain = i;				
		end		
	
	endtask
	
	
	task reset ();
	
		begin
	
			@ (negedge clk);
			rst = 1;
			@ (negedge clk);
			rst = 0;
		
		end
	endtask
	
	
	
	task waitclk ( input n);
	
		begin
		
			repeat(n) @(negedge clk);
		
		end
	
	endtask
	
	
	task mod(input k);
	
		begin
		
			@(negedge clk) mode = k;
		
		end	
	
	endtask
	
	
	
	initial begin
	
			intialize();
			
			
			
			reset();
			lden(4'b0110);
			mod(0);
			#40 mod(1);
			
			#100;
			
			lden(4'b0001);
			
			
			
			
		#300 $finish();	
	
	end
	
	
	
endmodule
