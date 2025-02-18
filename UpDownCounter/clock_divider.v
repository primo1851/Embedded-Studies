module clock_divider (
    input wire clk_in,   // 50 MHz input clock
    output reg clk_out   // Slower output clock
);
    reg [25:0] counter = 0; // 26-bit counter (2^26 ≈ 67M, enough for 1Hz)

    always @(posedge clk_in) begin
        counter <= counter + 1;
        clk_out <= counter[25]; // Toggle slower clock (about 1 Hz)
    end
endmodule
