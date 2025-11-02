module dualporttb();


	reg clk, rst, we, re;
	reg [3:0] rd_add, wr_add;
	reg [7:0] datain; 
	wire [7:0] dataout;
	
	
    dualport ram1(.clk(clk), .rst(rst), .we(we), .re(re),.rd_add(rd_add), .wr_add(wr_add),.datain(datain),.dataout(dataout));
					
					
					
	initial 
	begin
		clk = 0;
		forever 
			begin 
				#5 clk = ~clk;
			end
	end
	
	
	
	
	task intialize();
	
		begin
			rst = 1;
			we = 0;
			re = 0;
			rd_add = 0;
			wr_add = 0;
			datain = 0;
		end
	
	endtask
	
	
	
	task reset ( );
	
		begin
	
			@(negedge clk);
			rst = 1;
			@(negedge clk);
			rst = 0;
		end
	
	endtask
	
	
	
	
	task write( input [3:0] add, input [7:0] data);
	
		begin
	
			@ (negedge clk) 
			we = 1;
			datain = data;
			wr_add = add;
			
			@(negedge clk) we = 0;
	
		end	
	
	endtask
	
	
	task read( input [3:0] addrd);
	
		begin
	
			@ (negedge clk) 
			re = 1;
			
			rd_add = addrd;
			@(negedge clk) re = 0;
	
		end	
	
	endtask
	
	
	
	initial
	begin
	
		intialize();
		reset();
		#20 write (4'b0100, 8'd12);
			read(4'b0000);
		 read(4'b0100);
		
		
		reset();
		
		#500 $finish();
		
	end

endmodule	
		
	
	