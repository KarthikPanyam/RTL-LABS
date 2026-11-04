module piso_top (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,     // External start line
    input  wire [7:0] din,       // Parallel byte input
    output wire       dout,      // Serial bit stream
    output wire       done       // Transfer complete strobe
);

    // Internal Control / Status Wires
    wire load_en;
    wire shift;
    wire inc_count;
    wire clr_count;
    wire count_done;
    wire start_pulse;

    // Optional: Synchronizer + Edge Detector for start
    reg sync_1, sync_2, sync_2_d;
    always @(posedge clk) begin
        sync_1   <= start;
        sync_2   <= sync_1;
        sync_2_d <= sync_2;
    end
    assign start_pulse = sync_2 && !sync_2_d;

    // Control Path Instantiation
    piso_c u_ctrl (
        .clk        (clk),
        .rst        (rst),
        .count_done (count_done),
        .start      (start_pulse),
        .load_en    (load_en),
        .done       (done),
        .shift      (shift),
        .inc_count  (inc_count),
        .clr_count  (clr_count)
    );

    // Datapath Instantiation
    piso_d u_datapath (
        .clk        (clk),
        .rst        (rst),
        .din        (din),
        .load_en    (load_en),
        .shift      (shift),
        .inc_count  (inc_count),
        .clr_count  (clr_count),
        .count_done (count_done),
        .dout       (dout)
    );

endmodule