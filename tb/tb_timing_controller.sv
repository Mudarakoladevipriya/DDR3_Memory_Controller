`timescale 1ns / 1ps

module tb_timing_controller;

    // Clock and Reset signals
    logic clk;
    logic rst_n;

    // Control and Status signals
    logic start_trcd;
    logic start_trp;
    logic trcd_done;
    logic trp_done;

    // Instantiate the Timing Controller (UUT)
    timing_controller #(
        .TRCD_CYCLES(6),
        .TRP_CYCLES(6)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start_trcd(start_trcd),
        .start_trp(start_trp),
        .trcd_done(trcd_done),
        .trp_done(trp_done)
    );

    // 100 MHz Clock Generation (10 ns Period)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        start_trcd = 0;
        start_trp = 0;

        // Apply reset for 20 ns
        #20;
        rst_n = 1;
        #10;

        // Test 1: Trigger tRCD Timer
        @(posedge clk);
        start_trcd <= 1'b1;
        @(posedge clk);
        start_trcd <= 1'b0;

        // Wait for tRCD to finish
        wait (trcd_done);
        #20;

        // Test 2: Trigger tRP Timer
        @(posedge clk);
        start_trp <= 1'b1;
        @(posedge clk);
        start_trp <= 1'b0;

        // Wait for tRP to finish
        wait (trp_done);
        #30;

        $finish;
    end

endmodule
