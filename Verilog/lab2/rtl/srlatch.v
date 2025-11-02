module srlatch(input s,r,cntl,
				output  q,
				output qn);
				
		
	wire w1, w2; 


		nand n1(w1, s, s);
		nand n2(w2, r, r);
		nand n3 (q, w1, qn);
		nand n4 (qn,w2,q);
		
		
		
		
endmodule