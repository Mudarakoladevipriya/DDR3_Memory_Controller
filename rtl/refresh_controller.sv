`timescale 1ns / 1ps

module refresh_controller #(
    parameter integer REFRESH_INTERVAL = 100
)(
    input  logic clk,
    input  logic reset,
    input  logic controller_busy,
    input  logic refresh_done,

    output logic refresh_request
);

    logic [31:0] refresh_counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            refresh_counter <= 32'd0;
            refresh_request <= 1'b0;
        end
        else begin

            // Clear refresh request after refresh operation is completed
            if (refresh_done) begin
                refresh_request <= 1'b0;
                refresh_counter <= 32'd0;
            end

            // Count only when there is no pending refresh request
            else if (!refresh_request) begin

                if (refresh_counter >= REFRESH_INTERVAL - 1) begin
                    refresh_request <= 1'b1;
                end
                else begin
                    refresh_counter <= refresh_counter + 1'b1;
                end

            end

        end
    end

endmodule
