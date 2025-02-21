module SequenceDetector ( input clk,
                  input rstn,
                  input in,
                  output out );

  parameter IDLE 	= 0,
  			S1 		= 1,
  			S10 	= 2,
  			S101 	= 3,
  			S1011 	= 4;

  reg [2:0] cur_state, next_state;

  assign out = cur_state == S1011 ? 1 : 0;

  always @ (posedge clk) begin
    if (!rstn)
      	cur_state <= IDLE;
     else
     	cur_state <= next_state;
  end

  always @ (cur_state or in) begin
    case (cur_state)
      IDLE : begin
        if (in) next_state = S1;
        else next_state = IDLE;
      end

      S1: begin
        if (in) next_state = IDLE;
        else 	next_state = S10;
      end

      S10 : begin
        if (in) next_state = S101;
        else 	next_state = IDLE;
      end

      S101 : begin
        if (in) next_state = S1011;
        else 	next_state = IDLE;
      end

      S1011: begin
        next_state = IDLE;
      end
    endcase
  end
endmodule

module tb;
  reg clk, in, rstn;
  wire out;
  reg [1:0] l_dly;
  reg tb_in;
  integer loop = 1;
  integer i;  // Declare loop variable outside

  // Generate clock signal with a period of 20 time units
  always #10 clk = ~clk;

  // Instantiate the module under test
  SequenceDetector u0 (.clk(clk), .rstn(rstn), .in(in), .out(out));

  initial begin
    clk = 0;
    rstn = 0;
    in = 0;

    // Reset the DUT
    repeat (5) @(posedge clk);
    rstn <= 1;

    // Generate a directed pattern
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;   // Pattern completed
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;   // Pattern completed again 

    // Randomized test sequence
    for (i = 0; i <= loop; i = i + 1) begin
      l_dly = $random % 4;  // Limit delay range to avoid very long waits
      repeat (l_dly) @(posedge clk);
      tb_in = $random % 2;  // Ensure it's 0 or 1
      in <= tb_in;
    end

    // Wait before finishing simulation
    #100 $finish;
  end
endmodule
