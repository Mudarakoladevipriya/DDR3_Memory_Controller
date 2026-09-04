`timescale 1ns / 1ps

module tb_command_fsm;

    // Inputs to FSM
    logic clk;
    logic rst_n;
    logic read_req;
    logic write_req;
    logic trcd_done;
    logic trp_done;

    // Outputs from FSM
    logic start_trcd;
    logic start_trp;
    logic [2:0] ddr_cmd;
    logic busy;

    // Instantiate Command FSM (UUT)
    command_fsm uut (
        .clk(clk),
        .rst_n(rst_n),
        .read_req(read_req),
        .write_req(write_req),
        .trcd_done(trcd_done),
        .trp_done(trp_done),
        .start_trcd(start_trcd),
        .start_trp(start_trp),
        .ddr_cmd(ddr_cmd),
        .busy(busy)
    );

    // 100 MHz Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        read_req = 0;
        write_req = 0;
        trcd_done = 0;
        trp_done = 0;

        // Release Reset
        #20;
        rst_n = 1;
        #10;

        // --- TEST 1: READ TRANSACTION ---
        @(posedge clk);
        read_req <= 1'b1;
        @(posedge clk);
        read_req <= 1'b0;

        // Simulate tRCD Delay (Wait 6 cycles after start_trcd)
        wait (start_trcd);
        repeat (6) @(posedge clk);
        trcd_done <= 1'b1;
        @(posedge clk);
        trcd_done <= 1'b0;

        // Simulate tRP Delay (Wait 6 cycles after start_trp)
        wait (start_trp);
        repeat (6) @(posedge clk);
        trp_done <= 1'b1;
        @(posedge clk);
        trp_done <= 1'b0;

        // Wait until back to IDLE
        wait (!busy);
        #20;

        // --- TEST 2: WRITE TRANSACTION ---
        @(posedge clk);
        write_req <= 1'b1;
        @(posedge clk);
        write_req <= 1'b0;

        // Simulate tRCD Delay
        wait (start_trcd);
        repeat (6) @(posedge clk);
        trcd_done <= 1'b1;
        @(posedge clk);
        trcd_done <= 1'b0;

        // Simulate tRP Delay
        wait (start_trp);
        repeat (6) @(posedge clk);
        trp_done <= 1'b1;
        @(posedge clk);
        trp_done <= 1'b0;

        wait (!busy);
        #30;

        $finish;
    end

endmodule
