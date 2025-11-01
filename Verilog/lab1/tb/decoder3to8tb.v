module decoder3to8tb ();

reg [2:0] in;
reg en;
wire [7:0] out;


decoder3to8 d1(.in(in), .en(en), .out(out));

initial en = 1'b1;

initial 
begin
in = 3'b000;

#10

in = 3'b001;

#10;

in = 3'b010;

#10;

in = 3'b011;

#10;

in = 3'b100;

#10;

in = 3'b101;

#10;

in = 3'b110;

#10;

in = 3'b111;

#10;

end

initial #150 $finish();

endmodule

/*`timescale 1ns/1ps

module tb_decoder3to8;

    // Testbench signals
    reg  [2:0] in;
    reg        en;
    wire [7:0] out;

    // Instantiate the DUT (Device Under Test)
    decoder3to8 dut (
        .in(in),
        .en(en),
        .out(out)
    );

    // Stimulus
    initial begin
        $display("Time\t en in out");
        $monitor("%0t\t %b  %b  %b", $time, en, in, out);

        // Initialize
        en = 0; in = 3'b000;
        #10;

        // Enable OFF test
        repeat(8) begin
            in = in + 1;
            #10;
        end

        // Enable ON test
        en = 1; in = 3'b000;
        #10;
        repeat(8) begin
            in = in + 1;
            #10;
        end

        $finish;
    end

endmodule
*/