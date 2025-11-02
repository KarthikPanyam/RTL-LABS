module jkfftb ();

	reg clk,j,k,rst;
	wire q,qn;
	
	
	jkff jk1(.clk(clk), .j(j), .k(k), .rst(rst), .q(q), .qn(qn));
	
	parameter PERIOD = 10;
	
	
	
	initial 
	begin
	clk =0;
		forever 
		begin 
		#(PERIOD/2)clk = ~clk;
		end
	end
	
	
	task initialize();
		 begin
			{j,k,rst} = 0;
		end
	endtask
	
	
	task data( input x,y);
		begin
			@(negedge clk ) {j,k} = {x,y};
		end
	endtask
	
	task reset ( input i);
		begin
			@(negedge clk) rst = i;
		end
	
	endtask
	
	
	
	
	initial 
		begin
		
			initialize();
			data(0 ,1);
			data(1 ,0);
			reset(1);
			reset(0);
			data(1 ,0);
			data(1 ,1);
			data (0 ,0);
			
			#300 $finish();
	
		end
endmodule