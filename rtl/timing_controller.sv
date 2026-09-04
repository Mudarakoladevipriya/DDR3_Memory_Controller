`timescale 1ns / 1ps

module timing_controller #(
    parameter integer TRCD_CYCLES = 4,
    parameter integer TRP_CYCLES  = 4,
    parameter integer TCL_CYCLES  = 3,
    parameter integer TRAS_CYCLES = 8,
    parameter integer TRFC_CYCLES = 6
)(
    input  logic clk,
    input  logic reset,

    input  logic start_trcd,
    input  logic start_trp,
    input  logic start_tcl,
    input  logic start_tras,
    input  logic start_trfc,

    output logic trcd_done,
    output logic trp_done,
    output logic tcl_done,
    output logic tras_done,
    output logic trfc_done
);

    typedef enum logic [2:0] {
        TIMER_IDLE,
        TIMER_TRCD,
        TIMER_TRP,
        TIMER_TCL,
        TIMER_TRAS,
        TIMER_TRFC
    } timer_state_t;

    timer_state_t state;

    integer counter;

    always_ff @(posedge clk) begin

        if (reset) begin
            state     <= TIMER_IDLE;
            counter   <= 0;

            trcd_done <= 1'b0;
            trp_done  <= 1'b0;
            tcl_done  <= 1'b0;
            tras_done <= 1'b0;
            trfc_done <= 1'b0;
        end

        else begin

            /*
             * Done signals are one-clock pulses.
             */
            trcd_done <= 1'b0;
            trp_done  <= 1'b0;
            tcl_done  <= 1'b0;
            tras_done <= 1'b0;
            trfc_done <= 1'b0;

            case (state)

                TIMER_IDLE: begin

                    counter <= 0;

                    if (start_trcd) begin
                        state   <= TIMER_TRCD;
                        counter <= 0;
                    end

                    else if (start_trp) begin
                        state   <= TIMER_TRP;
                        counter <= 0;
                    end

                    else if (start_tcl) begin
                        state   <= TIMER_TCL;
                        counter <= 0;
                    end

                    else if (start_tras) begin
                        state   <= TIMER_TRAS;
                        counter <= 0;
                    end

                    else if (start_trfc) begin
                        state   <= TIMER_TRFC;
                        counter <= 0;
                    end
                end


                TIMER_TRCD: begin

                    if (counter >= TRCD_CYCLES - 1) begin
                        trcd_done <= 1'b1;
                        counter   <= 0;
                        state     <= TIMER_IDLE;
                    end

                    else begin
                        counter <= counter + 1;
                    end
                end


                TIMER_TRP: begin

                    if (counter >= TRP_CYCLES - 1) begin
                        trp_done <= 1'b1;
                        counter  <= 0;
                        state    <= TIMER_IDLE;
                    end

                    else begin
                        counter <= counter + 1;
                    end
                end


                TIMER_TCL: begin

                    if (counter >= TCL_CYCLES - 1) begin
                        tcl_done <= 1'b1;
                        counter  <= 0;
                        state    <= TIMER_IDLE;
                    end

                    else begin
                        counter <= counter + 1;
                    end
                end


                TIMER_TRAS: begin

                    if (counter >= TRAS_CYCLES - 1) begin
                        tras_done <= 1'b1;
                        counter   <= 0;
                        state     <= TIMER_IDLE;
                    end

                    else begin
                        counter <= counter + 1;
                    end
                end
                TIMER_TRFC: begin

                    if (counter >= TRFC_CYCLES - 1) begin
                        trfc_done <= 1'b1;
                        counter   <= 0;
                        state     <= TIMER_IDLE;
                    end

                    else begin
                        counter <= counter + 1;
                    end
                end

                default: begin
                    state   <= TIMER_IDLE;
                    counter <= 0;
                end

            endcase
        end
    end

endmodule
