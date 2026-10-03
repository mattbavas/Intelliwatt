`default_nettype none
// Portable activity demo: enable controls a counter through clock enable.
// This is a foundation, not a power estimator or a closed-loop controller.
module intelliwatt_top #(
    parameter integer COUNTER_WIDTH = 26
) (
    input  wire clk,
    input  wire rst,       // synchronous, active high
    input  wire enable,    // synchronous to clk
    output wire heartbeat
);
    logic [COUNTER_WIDTH-1:0] activity_count;
    always_ff @(posedge clk) begin
        if (rst) activity_count <= '0;
        else if (enable) activity_count <= activity_count + 1'b1;
    end
    assign heartbeat = activity_count[COUNTER_WIDTH-1];
endmodule
`default_nettype wire
