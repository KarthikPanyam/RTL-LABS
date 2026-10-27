module avg_ctrl (
    input clk, rst,
    input start,            // External input command
    input count_done,       // Sensor flag input from Datapath
    output reg ld_en,       // Knob to Datapath
    output reg strt_count,  // Knob to Datapath
    output reg clr_sum,     // Knob to Datapath
    output reg clr_count,   // Knob to Datapath
    output reg finished     // External output flag
);

    // State Encoding
    localparam IDLE     = 2'b00;
    localparam CALC_ADD = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] current_state, next_state;

    // 1. Sequential State Register
    always @(posedge clk) begin
        if (rst)
            current_state <= IDLE;
        else    
            current_state <= next_state;
    end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        next_state = current_state;
       
        case (current_state)
            IDLE: begin
                if (start) next_state = CALC_ADD;
            end
            CALC_ADD: begin
                if (count_done) next_state = DONE;
            end
            DONE: begin
                if (!start) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // 3. Output Control Logic (Combinational with Safe Defaults)
    always @(*) begin
        // Safe Defaults
        ld_en      = 0;
        clr_sum    = 0;
        clr_count  = 0;
        strt_count = 0;
        finished   = 0;

        case (current_state)
            IDLE: begin
                clr_count = 1;
                clr_sum   = 1;
            end

            CALC_ADD: begin
                ld_en      = 1;
                strt_count = 1;
            end

            DONE: begin
                finished   = 1;
            end

            default: begin
                clr_count = 1;
                clr_sum   = 1;
            end
        endcase
    end

endmodule