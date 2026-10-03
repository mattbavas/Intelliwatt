`timescale 1ns/1ps
`default_nettype none
module intelliwatt_top_tb;
    localparam integer WIDTH = 4;
    logic clk = 0;
    logic rst = 1;
    logic enable = 0;
    wire heartbeat;
    integer model = 0;
    integer checks = 0;
    intelliwatt_top #(.COUNTER_WIDTH(WIDTH)) dut (.*);
    always #5 clk = ~clk;
    task automatic step(input bit reset_value, input bit enable_value);
        @(negedge clk);
        rst = reset_value;
        enable = enable_value;
        @(posedge clk);
        if (reset_value) model = 0;
        else if (enable_value) model = (model + 1) % (1 << WIDTH);
        #1;
        if (heartbeat !== ((model >> (WIDTH-1)) & 1))
            $fatal(1, "Mismatch at check %0d, model=%0d", checks, model);
        checks = checks + 1;
    endtask
    initial begin
        step(1, 0);
        repeat (40) step(0, 1); // rollover and multiple heartbeat transitions
        repeat (10) step(0, 0); // hold while disabled, including high output
        step(1, 1);             // reset wins over enable
        repeat (64) step(0, $urandom_range(0, 1));
        step(1, 0);
        $display("PASS: %0d checks", checks);
        $finish;
    end
    initial begin
        #10000;
        $fatal(1, "Simulation timeout");
    end
endmodule
`default_nettype wire
