module fifo_top ( input clk, rst, push, pop, 
					input [7:0] din,
					
					output full_flag, empty_flag,
					output [7:0] dout
					);
					
	wire l, f, e, i,j ;
					
	fifo_cp f1 ( .push_req(push), .pop_req(pop), 
				.full(f), 
				.empty(e),
				.full_sig(full_flag), .empty_sig(empty_flag),
				.ld_en(l), 
				.inc_rptr(i), 
				.inc_wptr(j));
				
				
	fifo_dp f2( .clk(clk), .rst(rst),
				 .din(din),
				 .ld_en(l),
				 .inc_rptr(i), .inc_wptr(j),
				 .full(f), .empty(e),
				 .dout(dout) );
endmodule				 
				 
			
