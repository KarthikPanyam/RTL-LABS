module fifo_cp (
				input push_req, pop_req,
				input full, empty,

				output full_sig, empty_sig,
				output ld_en, inc_rptr, inc_wptr);
				
				
	assign ld_en = push_req && !full;

	assign inc_wptr = 	push_req && !full;
	assign inc_rptr = pop_req && !empty;
	
	assign full_sig = full;
	assign empty_sig = empty;
	
endmodule