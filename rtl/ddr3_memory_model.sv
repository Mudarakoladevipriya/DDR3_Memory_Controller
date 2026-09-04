`timescale 1ns / 1ps

module ddr3_memory_model #(
    parameter integer ROW_BITS    = 16,
    parameter integer BANK_BITS   = 3,
    parameter integer COL_BITS    = 13,
    parameter integer DATA_WIDTH  = 32,
    parameter integer MEM_DEPTH   = 1024
)(
    input  logic                   clk,
    input  logic                   reset,

    input  logic                   activate_cmd,
    input  logic                   read_cmd,
    input  logic                   write_cmd,
    input  logic                   precharge_cmd,
    input  logic                   refresh_cmd,

    input  logic [ROW_BITS-1:0]    row_addr,
    input  logic [BANK_BITS-1:0]   bank_addr,
    input  logic [COL_BITS-1:0]    col_addr,

    input  logic [DATA_WIDTH-1:0]  write_data,
    output logic [DATA_WIDTH-1:0]  read_data,
    output logic                   read_valid
);

    logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

    logic [ROW_BITS-1:0]  active_row;
    logic [BANK_BITS-1:0] active_bank;
    logic                 bank_active;

    integer memory_index;
    integer i;

    always_ff @(posedge clk) begin

        if (reset) begin
            active_row  <= '0;
            active_bank <= '0;
            bank_active <= 1'b0;
            read_data   <= '0;
            read_valid  <= 1'b0;

            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                memory[i] <= '0;
            end
        end

        else begin

            read_valid <= 1'b0;

            if (activate_cmd) begin
                active_row  <= row_addr;
                active_bank <= bank_addr;
                bank_active <= 1'b1;
            end

            else if (write_cmd) begin

                if (bank_active &&
                    (bank_addr == active_bank) &&
                    (row_addr == active_row)) begin

                    memory_index = col_addr % MEM_DEPTH;
                    memory[memory_index] <= write_data;

                end
            end

            else if (read_cmd) begin

                if (bank_active &&
                    (bank_addr == active_bank) &&
                    (row_addr == active_row)) begin

                    memory_index = col_addr % MEM_DEPTH;
                    read_data  <= memory[memory_index];
                    read_valid <= 1'b1;

                end
                else begin
                    read_data  <= '0;
                    read_valid <= 1'b0;
                end
            end
            else if (precharge_cmd) begin
                bank_active <= 1'b0;
            end

            else if (refresh_cmd) begin
                bank_active <= 1'b0;
            end
        end
    end
endmodule
