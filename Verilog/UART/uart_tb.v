`timescale 1ns / 1ps

module uart_tb ();

reg clk, rst;
reg [7:0] din;
reg start_tx;
wire dout, tx_complete;


uart_tx_top dut1( .clk(clk), .rst(rst), .din(din), .start_tx(start_tx), .dout(dout), .tx_complete(tx_complete));


always #5 clk = ~clk;


task send_tx_start ();

	@(negedge clk );
	start_tx = 1;
	
	@(negedge clk);
	start_tx = 0;
	
endtask



task set_din ( input [7:0] test_byte);
@(negedge clk)
	din = test_byte;
	
endtask


initial 
begin
$dumpfile("uart_tb.vcd");
$dumpvars(0, uart_tb);
clk      = 1'b0;
rst      = 1'b1; 
din      = 8'h00;
start_tx = 1'b0;
repeat (2) @(posedge clk);

#20; 
rst = 0;

repeat (2) @(posedge clk);
set_din(8'b10110011);

send_tx_start ();

@(posedge tx_complete);
        repeat (2) @(posedge clk);
$finish();

end

endmodule

