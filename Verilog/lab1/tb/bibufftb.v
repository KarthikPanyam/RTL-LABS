module bibufftb();

wire a,b;
reg en;

reg temp1, temp2;
integer i;

bibuff b1(.a(a),.b(b), .en(en));


initial begin

for ( i =0; i<8;i=i+1) begin
	{temp1,temp2,en} = i;
	#10;
	end
	
	#1000 $finish();
	



end

assign a = en?temp1:1'bz;
assign b = ~en?temp2:1'bz;

endmodule


