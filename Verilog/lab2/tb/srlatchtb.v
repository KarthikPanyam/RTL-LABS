module srlatchtb ();

	reg s,r,cntrl;
	wire q,qn;
	
	srlatch sr1 (.s(s), .r(r), .q(q), .qn(qn));
	
	
	initial
	begin
		s=0;
		r=1;
		#10 ;
		s=0;
		r=0;
		#10;
		s=1;
		r=0;
		#10;
		s=1;
		r=1;
		#10;
		
		s=1;
		r=0;
		$finish();
		


	end
	
endmodule