`timescale 1ns / 1ps

module tb_address_mapper;
    logic [26:0] sys_addr;
    logic [12:0] row_addr;
    logic [2:0]  bank_addr;
    logic [10:0] col_addr;

    // Instantiate Unit Under Test (UUT)
    address_mapper uut (
        .sys_addr(sys_addr),
        .row_addr(row_addr),
        .bank_addr(bank_addr),
        .col_addr(col_addr)
    );

    initial begin
        // Test Address 1
        sys_addr = 27'h7FFFFFF; #10;
        
        // Test Address 2
        sys_addr = 27'h1234567; #10;
        
        $finish;
    end
endmodule
