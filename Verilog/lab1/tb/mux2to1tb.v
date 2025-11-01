module mux2to1tb ();


reg [1:0] in;
reg sel;
wire y;


mux2to1 m1 ( .in(in), .sel(sel), .y(y));

initial begin

sel = 1'b0;
in = 2'b01;
#10


sel = 1'b0;
in = 2'b10;
#10


sel = 1'b1;
in = 2'b10;
#10

sel = 1'b1;
in = 2'b01;
#10

#50 $finish();

end




endmodule
