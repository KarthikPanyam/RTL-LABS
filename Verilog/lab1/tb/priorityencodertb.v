module priorityencodertb();

reg [7:0] in;
wire [2:0] out;

priencoder encoder1 (.in(in), .out(out));


initial begin

in = 8'b00101000;
#10
in = 8'b10101000;
#10
in = 8'b01101000;
#10
in = 8'b00001000;
#10
in = 8'b00101010;
#10
in = 8'b11101000;
#10
in = 8'b00000011;
#10
in = 8'b00000010;
#10
in = 8'b00000000;
#10
in = 8'b00110011;
#10
in = 8'b11110011;
#10

#20 $finish();

end
endmodule