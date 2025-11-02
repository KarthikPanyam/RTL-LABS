module tfftb();

reg clk, rst, t;
wire q, qn;


tff t1(.clk(clk), .rst(rst) , .t(t), .q(q), .qn(qn));


	initial begin
	clk = 0;
	forever #5 clk = ~clk;
	
	end


	task initialize();

		begin

			t = 0;
			rst = 1;
		end
	endtask



	task reset ( input i);
	
		begin
			@(negedge clk)  rst = i;	
		end
	endtask
	
	
	
	task tin ( input x);
	
		begin
		
			@( negedge clk) t = x;
		end
	
	endtask
	
	
	
	initial begin
	
	
		initialize();
		reset(0);
		tin(0);
		
		reset(1);
		tin(0);
		reset(0);
		tin(0);
		
		tin(1);
		tin(1);
		tin(1);
		
		reset(1);
		tin(1);
		tin(0);
		tin(0);
		
		
		#100 $finish();
	
	
	end
	
	
endmodule

	