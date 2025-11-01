module bibuff (inout a,b,
				input en);
				
				
				bufif1 b1(b,a,en);
				bufif0 b2(a,b,en);
				
				endmodule
				