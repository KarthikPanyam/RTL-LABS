module running_averager_top (
    input clk,
    input rst,
    input start,
    input [7:0] din,
    output [7:0] avg_out,
    output finished
);

    // Inner structural wires linking paths
    wire w_ld_en;
    wire w_strt_count;
    wire w_clr_sum;
    wire w_clr_count;
    wire w_count_done;

    // Instantiate Control Path Module (The Manager)
    avg_ctrl controller_unit (
        .clk(clk),
        .rst(rst),
        .start(start),
        .count_done(w_count_done),
        .ld_en(w_ld_en),
        .strt_count(w_strt_count),
        .clr_sum(w_clr_sum),
        .clr_count(w_clr_count),
        .finished(finished)
    );

    // Instantiate Datapath Module (The Factory Floor)
    avg_dp datapath_unit (
        .clk(clk),
        .rst(rst),
        .din(din),
        .ld_en(w_ld_en),
        .strt_count(w_strt_count),
        .clr_sum(w_clr_sum),
        .clr_count(w_clr_count),
        .count_done(w_count_done),
        .avg_out(avg_out)
    );

endmodule