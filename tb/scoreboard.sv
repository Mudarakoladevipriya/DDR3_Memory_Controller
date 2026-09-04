`timescale 1ns / 1ps

module scoreboard;

    logic [31:0] expected_data;
    integer      pass_count;
    integer      fail_count;

    initial begin
        expected_data = 32'd0;
        pass_count    = 0;
        fail_count    = 0;
    end

    task automatic check_data(
        input logic [31:0] actual_data,
        input logic [31:0] expected
    );
        begin
            if (actual_data === expected) begin
                pass_count = pass_count + 1;

                $display(
                    "SCOREBOARD PASS: Expected=%h Actual=%h",
                    expected,
                    actual_data
                );
            end
            else begin
                fail_count = fail_count + 1;

                $error(
                    "SCOREBOARD FAIL: Expected=%h Actual=%h",
                    expected,
                    actual_data
                );
            end
        end
    endtask

    task automatic print_result;
        begin
            $display("----------------------------------------");
            $display("SCOREBOARD RESULTS");
            $display("PASS COUNT = %0d", pass_count);
            $display("FAIL COUNT = %0d", fail_count);
            $display("----------------------------------------");
        end
    endtask

endmodule
