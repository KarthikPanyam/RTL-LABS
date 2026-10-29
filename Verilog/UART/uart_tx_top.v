module uart_tx_top (
						input clk, rst,
						input [7:0] din,
						input start_tx,
						output dout,
						output tx_complete);
						
	wire le,shifter, incr, clr, d_8;
	wire [1:0] select;
	
	
	uart_tx_dp u1( .clk(clk), .rst(rst),
					 .load_en(le),
					.shift_en(shifter),
					 .inc_count(incr),
					 .clear_count(clr),
					 .sel(select),					
					 .din(din),	
					 .dout(dout),
					 .done_8(d_8) );
					 
					 
					 
					 
	uart_tx_cp u2 ( .clk(clk), .rst(rst),					
					.start_tx(start_tx), 	
					.done_8(d_8),
					.load_en(le), .shift(shifter), .inc(incr), .clear_count(clr),
					.sel(select),
					.tx_complete(tx_complete) );
					
					
endmodule