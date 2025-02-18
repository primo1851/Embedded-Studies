module top (
    input wire clk_in, 
    input wire up_down,
    output wire [6:0] seg
);

    wire slow_clk;
    wire [3:0] count;

    // Instantiate clock divider
    clock_divider clk_div (
        .clk_in(clk_in),
        .clk_out(slow_clk)
    );

    // Instantiate counter
    simple_counter my_counter (
        .clk(slow_clk),   // Use slowed-down clock
        .up_down(up_down),
        .count(count)
    );

    // Instantiate 7-segment display decoder
    seven_seg_decoder my_decoder (
        .binary_input(count),
        .seg(seg)  
    );

endmodule


module top_testbench;
    reg clk_in;
    reg up_down;
    wire [6:0] seg;

    // Instantiate the top module
    top uut (
        .clk_in(clk_in),
        .up_down(up_down),
        .seg(seg)
    );

    // Clock generation (50 MHz equivalent with 20 ns period)
    initial begin
        clk_in = 0;
        forever #10 clk_in = ~clk_in;  
    end

    // Test sequence
    initial begin
        up_down = 1;  // Start counting up
        #100 up_down = 0;  // Count down after some time
        #200 up_down = 1;  // Count up again
        #300 $finish;  // Stop simulation
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | clk_in=%b | clk=%b | up_down=%b | count=%b | seg=%b", 
                 $time, clk_in, uut.clk, up_down, uut.my_counter.count, seg);
    end
endmodule
