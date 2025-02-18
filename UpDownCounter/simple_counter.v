module simple_counter (
    input clk,
    input up_down,
    output reg [3:0] count 
);

  always @(posedge clk) begin
    $display("Clock Edge Detected at %t, count = %d", $time, count);
    
    if (up_down) begin
      if (count == 4'b1001)
        count <= 4'b0000;  // Non-blocking assignment
      else
        count <= count + 1;  // Non-blocking assignment
    end 
    else begin
      if (count == 4'b0000)
        count <= 4'b1001;  // Non-blocking assignment
      else
        count <= count - 1;  // Non-blocking assignment
    end
  end

endmodule


module tb_simple_counter;

  reg clk;
  reg up_down;
  wire [3:0] count;

  // Instantiate the simple_counter module
  simple_counter uut (
    .clk(clk),
    .up_down(up_down),
    .count(count)
  );

  // Generate clock signal
  always begin
    #5 clk = ~clk;  // Toggle clock every 5 time units
  end

  // Test procedure
  initial begin
    // Initialize signals
    clk = 0;
    up_down = 1;  // Start counting up

    // Display the initial value
    $display("Starting count up test...");
    #10;  // Wait for a few clock cycles
    $display("count = %d", count);

    // Simulate counting up
    #50;  // Wait for 50 time units to observe counting up
    $display("count after counting up: %d", count);

    // Change direction to count down
    up_down = 0;  // Start counting down
    $display("Starting count down test...");
    #10;  // Wait for a few clock cycles
    $display("count = %d", count);

    // Simulate counting down
    #50;  // Wait for 50 time units to observe counting down
    $display("count after counting down: %d", count);

  end

endmodule
