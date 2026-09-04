`timescale 1ns / 1ps

module ddr3_controller_top (
    input  logic        clk,
    input  logic        reset,

    input  logic        request_valid,
    input  logic        request_write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic        request_ready,
    output logic [31:0] read_data,
    output logic        read_data_valid,

    output logic        activate_cmd,
    output logic        read_cmd,
    output logic        write_cmd,
    output logic        precharge_cmd,
    output logic        refresh_cmd
);

    logic [15:0] row_addr;
    logic [2:0]  bank_addr;
    logic [12:0] col_addr;

    logic [15:0] row_addr_cmd;
    logic [2:0]  bank_addr_cmd;
    logic [12:0] col_addr_cmd;
    logic [31:0] write_data_cmd;

    logic [31:0] memory_read_data;
    logic        memory_read_valid;

    logic        start_trcd;
    logic        start_trp;
    logic        start_tcl;
    logic        start_tras;
    logic        start_trfc;

    logic        trcd_done;
    logic        trp_done;
    logic        tcl_done;
    logic        tras_done;
    logic        trfc_done;

    logic        refresh_request;
    logic        controller_busy;

    address_mapper u_address_mapper (
        .address    (address),
        .row_addr   (row_addr),
        .bank_addr  (bank_addr),
        .col_addr   (col_addr)
    );

    timing_controller #(
        .TRCD_CYCLES (4),
        .TRP_CYCLES  (4),
        .TCL_CYCLES  (3),
        .TRAS_CYCLES (8),
        .TRFC_CYCLES (6)
    ) u_timing_controller (
        .clk         (clk),
        .reset       (reset),

        .start_trcd  (start_trcd),
        .start_trp   (start_trp),
        .start_tcl   (start_tcl),
        .start_tras  (start_tras),
        .start_trfc  (start_trfc),

        .trcd_done   (trcd_done),
        .trp_done    (trp_done),
        .tcl_done    (tcl_done),
        .tras_done   (tras_done),
        .trfc_done   (trfc_done)
    );

    refresh_controller #(
        .REFRESH_INTERVAL (100)
    ) u_refresh_controller (
        .clk              (clk),
        .reset            (reset),

        .refresh_done     (trfc_done),
        .controller_busy  (controller_busy),

        .refresh_request  (refresh_request)
    );

    command_fsm u_command_fsm (
        .clk               (clk),
        .reset             (reset),

        .request_valid     (request_valid),
        .request_write     (request_write),

        .row_addr          (row_addr),
        .bank_addr         (bank_addr),
        .col_addr          (col_addr),

        .write_data        (write_data),
        .read_data_mem     (memory_read_data),
        .read_valid_mem    (memory_read_valid),

        .refresh_request   (refresh_request),

        .trcd_done         (trcd_done),
        .trp_done          (trp_done),
        .tcl_done          (tcl_done),
        .tras_done         (tras_done),
        .trfc_done         (trfc_done),

        .start_trcd        (start_trcd),
        .start_trp         (start_trp),
        .start_tcl         (start_tcl),
        .start_tras        (start_tras),
        .start_trfc        (start_trfc),

        .activate_cmd      (activate_cmd),
        .read_cmd          (read_cmd),
        .write_cmd         (write_cmd),
        .precharge_cmd     (precharge_cmd),
        .refresh_cmd       (refresh_cmd),

        .row_addr_out      (row_addr_cmd),
        .bank_addr_out     (bank_addr_cmd),
        .col_addr_out      (col_addr_cmd),
        .write_data_out    (write_data_cmd),

        .read_data         (read_data),
        .read_data_valid   (read_data_valid),

        .request_ready     (request_ready),
        .controller_busy   (controller_busy)
    );

    ddr3_memory_model #(
        .ROW_BITS   (16),
        .BANK_BITS  (3),
        .COL_BITS   (13),
        .DATA_WIDTH (32),
        .MEM_DEPTH  (1024)
    ) u_ddr3_memory_model (
        .clk            (clk),
        .reset          (reset),

        .activate_cmd   (activate_cmd),
        .read_cmd       (read_cmd),
        .write_cmd      (write_cmd),
        .precharge_cmd  (precharge_cmd),
        .refresh_cmd    (refresh_cmd),

        .row_addr       (row_addr_cmd),
        .bank_addr      (bank_addr_cmd),
        .col_addr       (col_addr_cmd),

        .write_data     (write_data_cmd),

        .read_data      (memory_read_data),
        .read_valid     (memory_read_valid)
    );
    
endmodule

endmodule
