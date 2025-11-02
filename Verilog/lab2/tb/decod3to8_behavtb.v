module decod3to8_behavtb ();

reg [2:0] in;
reg en;
wire [7:0] out;
integer i;

decod3to8_behav d1( .in(in) , .en(en) , .out(out));


	initial 
		begin
			en =1;
			for( i =0; i<8; i = i+1) begin
			
			in = i;
			#10;
			end
			
			$finish();
			
			
			
			
		end
		
		
endmodule

		
		
		
		
		
		