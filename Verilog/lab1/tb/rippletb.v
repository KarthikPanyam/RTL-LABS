module rippletb();

reg [3:0]a,b;
reg cin;
wire [3:0] sum;
wire cout;


ripple r1( .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));


initial begin


 a = 4'b0001;
 b = 4'b0001;
 cin = 1'b0;
 #10
 
 
 a = 4'b1000;
 b = 4'b0100;
 cin = 1'b0;
 #10;
 
 
 a = 4'b1111;
 b = 4'b1111;
 cin = 1'b0;
 #10
 
 
 #20 $finish();
 

end


endmodule
