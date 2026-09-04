`timescale 1ns / 1ps

module address_mapper (
    input  logic [31:0] address,

    output logic [15:0] row_addr,
    output logic [2:0]  bank_addr,
    output logic [12:0] col_addr
);



    always_comb begin
        row_addr  = address[31:16];
        bank_addr = address[15:13];
        col_addr  = address[12:0];
    end

endmodule
