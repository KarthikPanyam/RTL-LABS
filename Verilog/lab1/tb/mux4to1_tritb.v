module mux4to1_tritb ();

reg [3:0] in;
reg [1:0] sel;
wire y;


mux4to1tri mux1( .in(in), .sel(sel), .y(y));


initial begin

sel = 2'b00;
in = 4'b0001;

#10

sel = 2'b00;
in = 4'b1110;
#10

sel = 2'b01;
in = 4'b0001;

#10

sel = 2'b01;
in = 4'b1110;
#10

sel = 2'b10;
in = 4'b0001;

#10

sel = 2'b10;
in = 4'b1110;
#10

sel = 2'b11;
in = 4'b0001;

#10

sel = 2'b11;
in = 4'b1000;
#10

#30 $finish();


end
endmodule