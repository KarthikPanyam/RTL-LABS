module mux4to1_behavtb();


reg [3:0] in;
reg [1:0] sel;
wire z;
integer i,j;

mux4to1_behav m1(.in(in), .y(z), .sel(sel));



task initialize;
begin
{in,sel} = 0;

end
endtask


task inputs( input [3:0] k);
	begin
		in = k;
	end
endtask





initial begin

initialize;

for ( i = 0; i<16; i = i+1) begin
		inputs(i);
		for( j = 0; j<4 ; j = j+1) begin
		#1 sel = j;
		end
	end
	
	
	$finish();

end
endmodule