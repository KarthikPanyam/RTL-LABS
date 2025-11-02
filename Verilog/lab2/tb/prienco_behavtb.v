module prienco_behavtb ();

reg [7:0] in;
wire [2:0] out;
integer i;
prienco_behav p1(.in(in), .out(out));

task initialize ();
	begin
		
		in = 8'b0000_0000;
		
	end
endtask


	initial  
		begin

			initialize;
		
		
			for(i=0; i <= 255; i= i+1) 
			begin
		
				in = i;
				#2;
			
			end
			
			$finish();
	
		end
		
		
endmodule
	