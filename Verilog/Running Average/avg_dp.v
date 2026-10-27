module avg_dp (
    input clk, rst,
    input [7:0] din,
    input ld_en, strt_count,
    input clr_sum, clr_count,
    output count_done,
    output [7:0] avg_out
);

    reg [10:0] accum;
    reg [2:0] count;

    always @ (posedge clk) begin
        if(rst) begin
            accum <= 0;
            count <= 0;
        end
        else begin
            // Isolated Accumulator Register
            if (clr_sum)
                accum <= 0;
            else if (ld_en)
                accum <= accum + din;

            // Isolated Counter Register
            if (clr_count)
                count <= 0;
            else if (strt_count)
                count <= count + 1;
        end
    end

    // Pure, untangled combinational readouts
    assign count_done = (count == 3'd4);
    assign avg_out = accum[9:2]; // Shift right by 2 to divide by 4

endmodule
