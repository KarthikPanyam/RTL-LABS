module dff1tb();

reg rst, clk, din;
wire q, qn;


dff1 dff_1 (.din(din), .rst(rst), .clk(clk), .q(q), .qn(qn));


parameter CYCLE = 10;
initial
begin
clk = 0;
forever 
	begin

		#(CYCLE/2) clk = ~ clk;
	end
end	
	
task initialize();
	begin
		{rst,clk} =0;
	end
endtask


task reset (input i);

	begin 
		@(negedge clk)
			rst = i;

	end
endtask



task data ( input d);

	begin
		@(negedge clk)
			din = d;
	end

endtask


initial 
begin
	initialize();

	reset(1);
	data(1);

	reset (0);
	data(1);

	data(0);

	reset(1);

	reset(0);

	data(0);

	data(1);

	data(1);
	
	#200 $finish();

end


endmodule

