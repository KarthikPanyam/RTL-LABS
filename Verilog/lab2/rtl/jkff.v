module jkff (input j,k,clk,rst,
			output reg q,
			output qn);
		

	parameter SET = 2'b10,
				RESET = 2'b01,
				HOLD = 2'b00,
				TOGGLE = 2'b11;
		
	always@(posedge clk)
	begin
		if(rst) q<= 0;
		
		else begin
		case({j,k})
			HOLD: q <= q;
			RESET : q<=0;
			SET : q<= 1;
			TOGGLE : q<= ~q;
			
			default: q=0;
		endcase
		end
	end

	assign qn = ~q;
	
endmodule