module encoder( input [7:0] encin,
				output [2:0] out
				);
				
				
		assign out [2] = encin[7] | encin[6] | encin[5] | encin[4] ;
		assign out [1] = encin[7] | encin[6] | encin[3] | encin[2] ;
		assign out [0] = encin[1] | encin[3] | encin[5] | encin[7] ;
		
		endmodule
		