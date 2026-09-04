`timescale 1ns / 1ps

module command_fsm (
    input  logic        clk,
    input  logic        reset,

    input  logic        request_valid,
    input  logic        request_write,

    input  logic [15:0] row_addr,
    input  logic [2:0]  bank_addr,
    input  logic [12:0] col_addr,

    input  logic [31:0] write_data,
    input  logic [31:0] read_data_mem,
    input  logic        read_valid_mem,

    input  logic        refresh_request,

    input  logic        trcd_done,
    input  logic        trp_done,
    input  logic        tcl_done,
    input  logic        tras_done,
    input  logic        trfc_done,

    output logic        start_trcd,
    output logic        start_trp,
    output logic        start_tcl,
    output logic        start_tras,
    output logic        start_trfc,

    output logic        activate_cmd,
    output logic        read_cmd,
    output logic        write_cmd,
    output logic        precharge_cmd,
    output logic        refresh_cmd,

    output logic [15:0] row_addr_out,
    output logic [2:0]  bank_addr_out,
    output logic [12:0] col_addr_out,
    output logic [31:0] write_data_out,

    output logic [31:0] read_data,
    output logic        read_data_valid,

    output logic        request_ready,
    output logic        controller_busy
);

    typedef enum logic [3:0] {
        IDLE,
        ACTIVATE,
        WAIT_TRCD,
        READ_CMD,
        WAIT_TCL,
        WRITE_CMD,
        WAIT_TRAS,
        PRECHARGE,
        WAIT_TRP,
        REFRESH,
        WAIT_TRFC
    } state_t;

    state_t state;

    logic pending_write;

    always_ff @(posedge clk) begin

        if (reset) begin
            state            <= IDLE;
            pending_write    <= 1'b0;

            row_addr_out     <= '0;
            bank_addr_out    <= '0;
            col_addr_out     <= '0;
            write_data_out   <= '0;

            read_data        <= '0;
            read_data_valid  <= 1'b0;
        end

        else begin

            read_data_valid <= 1'b0;

            case (state)

                IDLE: begin

                    if (refresh_request) begin
                        state <= REFRESH;
                    end

                    else if (request_valid) begin

                        row_addr_out   <= row_addr;
                        bank_addr_out  <= bank_addr;
                        col_addr_out   <= col_addr;
                        write_data_out <= write_data;

                        pending_write <= request_write;

                        state <= ACTIVATE;
                    end
                end


                ACTIVATE: begin
                    state <= WAIT_TRCD;
                end


                WAIT_TRCD: begin

                    if (trcd_done) begin

                        if (pending_write)
                            state <= WRITE_CMD;
                        else
                            state <= READ_CMD;

                    end
                end


                READ_CMD: begin
                    state <= WAIT_TCL;
                end


                WAIT_TCL: begin

                    if (read_valid_mem) begin
                        read_data       <= read_data_mem;
                        read_data_valid <= 1'b1;
                        state           <= WAIT_TRAS;
                    end

                    else if (tcl_done) begin
                        state <= WAIT_TRAS;
                    end
                end


                WRITE_CMD: begin
                    state <= WAIT_TRAS;
                end


                WAIT_TRAS: begin

                    if (tras_done) begin
                        state <= PRECHARGE;
                    end
                end


                PRECHARGE: begin
                    state <= WAIT_TRP;
                end


                WAIT_TRP: begin

                    if (trp_done) begin
                        state <= IDLE;
                    end
                end


                REFRESH: begin
                    state <= WAIT_TRFC;
                end


                WAIT_TRFC: begin

                    if (trfc_done) begin
                        state <= IDLE;
                    end
                end


                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end


    always_comb begin

        start_trcd = 1'b0;
        start_trp  = 1'b0;
        start_tcl  = 1'b0;
        start_tras = 1'b0;
        start_trfc = 1'b0;

        activate_cmd  = 1'b0;
        read_cmd      = 1'b0;
        write_cmd     = 1'b0;
        precharge_cmd = 1'b0;
        refresh_cmd   = 1'b0;

        request_ready   = 1'b0;
        controller_busy = 1'b1;

        case (state)

            IDLE: begin
                request_ready   = !refresh_request;
                controller_busy = 1'b0;
            end

            ACTIVATE: begin
                activate_cmd = 1'b1;
            end

            WAIT_TRCD: begin
                start_trcd = 1'b1;
            end

            READ_CMD: begin
                read_cmd = 1'b1;
            end

            WAIT_TCL: begin
                start_tcl = 1'b1;
            end

            WRITE_CMD: begin
                write_cmd = 1'b1;
            end

            WAIT_TRAS: begin
                start_tras = 1'b1;
            end

            PRECHARGE: begin
                precharge_cmd = 1'b1;
            end

            WAIT_TRP: begin
                start_trp = 1'b1;
            end

            REFRESH: begin
                refresh_cmd = 1'b1;
            end

            WAIT_TRFC: begin
                start_trfc = 1'b1;
            end

            default: begin
                request_ready   = 1'b0;
                controller_busy = 1'b1;
            end

        endcase
    end
endmodule

endmodule
