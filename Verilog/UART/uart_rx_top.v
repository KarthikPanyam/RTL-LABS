

module uart_rx_top (
    input            clk,
    input            rst,
    input            RX_in,
    output           rx_complete,
    output     [7:0] rx_data
);

    // Internal Interconnect Wires (Sensors & Knobs)
    wire done_8;
    wire clr_count;
    wire inc_count;
    wire shift_en;
    wire load_out;

    // Instantiate Control Path (The Brain)
    uart_rx_cp u_cp (
        .clk         (clk),
        .rst         (rst),
        .RX_in       (RX_in),
        .done_8      (done_8),
        .clr_count   (clr_count),
        .inc_count   (inc_count),
        .shift_en    (shift_en),
        .load_out    (load_out),
        .rx_complete (rx_complete)
    );

    // Instantiate Datapath (The Muscle)
    uart_rx_dp u_dp (
        .clk       (clk),
        .rst       (rst),
        .RX_in     (RX_in),
        .clr_count (clr_count),
        .inc_count (inc_count),
        .shift_en  (shift_en),
        .load_out  (load_out),
        .done_8    (done_8),
        .dout      (rx_data)
    );

endmodule