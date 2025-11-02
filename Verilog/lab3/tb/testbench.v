self checking test bench for fifo
calculate depth of fifo writing freq is 20mhz, reading 15mghz
idle condition is 2 for writing, reading is 4
burst size is 90


`timescale 1ns/1ps

module tb_fifo_selfcheck;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 256;  // assumed
    parameter BURST_SIZE = 90;

    // Clock periods
    localparam real WRITE_CLK_PERIOD = 50.0;      // 20 MHz -> 50 ns
    localparam real READ_CLK_PERIOD  = 66.67;     // 15 MHz -> 66.67 ns

    // Signals
    reg                   wr_clk, rd_clk, rst;
    reg                   wr_en, rd_en;
    reg  [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire                  full, empty;

 
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        wr_clk = 0;
        forever #(WRITE_CLK_PERIOD/2) wr_clk = ~wr_clk;
    end

    initial begin
        rd_clk = 0;
        forever #(READ_CLK_PERIOD/2) rd_clk = ~rd_clk;
    end

    // Reset
    initial begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        repeat (5) @(posedge wr_clk);
        rst = 0;
    end

    // Variables for self-checking
    integer write_count = 0;
    integer read_count  = 0;
    integer error_count = 0;
    reg [DATA_WIDTH-1:0] exp_mem [0:10000];  // expected data storage

    // ------------------------------
    // WRITE PROCESS
    // ------------------------------
    initial begin : WRITE_PROC
        @(negedge rst);
        forever begin
            // write burst
            repeat (BURST_SIZE) begin
                @(posedge wr_clk);
                if (!full) begin
                    wr_en <= 1;
                    din <= $random;
                    exp_mem[write_count] = din;
                    write_count++;
                end else begin
                    wr_en <= 0;
                end
            end

            // idle for 2 cycles
            wr_en <= 0;
            repeat (2) @(posedge wr_clk);
        end
    end

    // ------------------------------
    // READ PROCESS
    // ------------------------------
    initial begin : READ_PROC
        @(negedge rst);
        forever begin
            // read burst
            repeat (BURST_SIZE) begin
                @(posedge rd_clk);
                if (!empty) begin
                    rd_en <= 1;
                end else begin
                    rd_en <= 0;
                end
            end

            // idle for 4 cycles
            rd_en <= 0;
            repeat (4) @(posedge rd_clk);
        end
    end

    // ------------------------------
    // SELF-CHECK MONITOR
    // ------------------------------
    always @(posedge rd_clk) begin
        if (rd_en && !empty) begin
            if (dout !== exp_mem[read_count]) begin
                $display("ERROR at %0t: Expected %0h, got %0h", $time, exp_mem[read_count], dout);
                error_count++;
            end
            read_count++;
        end
    end

    // ------------------------------
    // DEPTH CALCULATION
    // ------------------------------
    always @(*) begin
        integer depth;
        depth = write_count - read_count;
        // you can monitor:
        // $display("Time=%0t Depth=%0d", $time, depth);
    end

    // ------------------------------
    // END CONDITION
    // ------------------------------
    initial begin
        #500000;  // run for some time
        $display("\nSimulation complete");
        $display("Total Writes = %0d, Reads = %0d, Errors = %0d", write_count, read_count, error_count);
        if (error_count == 0)
            $display("SELF-CHECK PASSED ");
        else
            $display("SELF-CHECK FAILED ");
        $finish;
    end

endmodule
