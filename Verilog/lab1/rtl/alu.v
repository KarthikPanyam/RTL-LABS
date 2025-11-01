module alu_design ( input oe,
					input [3:0] command_in,
					input [7:0] a,b,
					output [15:0] dout);
					
					
			parameter ADD = 4'b0000,
					  SUB = 4'b0001,
					  INC = 4'b0010,
					  DEC = 4'd3,
					  MUL = 4'd4,
					  DIV =4'd5,
					  SHL = 4'd6,
					  SHR = 4'd7,
					  AND = 4'd8,
					  OR = 4'd9,
					  INVe = 4'd10,
					  NAND = 4'd11,
					  NOR = 4'd12,
					  XOR =  4'd13,
					  XNOR = 4'd14,
					  BUFf = 4'd15;
					
			reg [15:0]out;
			
			
	always@(command_in,a,b) begin
			
		case(command_in)
			
			ADD: out = a+b;
			SUB: out = a-b;
			INC: out = a+1;
			DEC: out = a-1;
			MUL: out = a*b;
			DIV: out = a/b;
			SHL: out = a<<1;
			SHR: out = a>>1;
			AND: out =a&&b;
			OR: out = a||b;
			INVe: out = !a;
			NAND : out= ~(a&b);
			NOR: out= ~(a|b);
			XOR : out= a^b;
			XNOR : out=~(a^b);
			BUFf : out= a;
			
			default out = 0;
			
		endcase
			

			
	end
	
	assign dout = oe?out:16'hzzzz;
	
	
	
endmodule