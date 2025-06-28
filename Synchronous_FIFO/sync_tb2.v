
`timescale 1ns/1ns

module sync_tb;

  // Parameters
  parameter DEPTH = 8;
  parameter WIDTH = 8;

  // Signals
  reg clk = 0;
  reg rstN;
  reg wrEn;
  reg rdEn;
  reg [WIDTH-1:0] dataIn;
  wire [WIDTH-1:0] dataOut;
  wire empty;
  wire full;

  integer i;

  // Instantiate the FIFO
  fifoSync #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
  ) dut (
    .clk(clk),
    .rstN(rstN),
    .wrEn(wrEn),
    .rdEn(rdEn),
    .dataIn(dataIn),
    .dataOut(dataOut),
    .empty(empty),
    .full(full)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Write task
  task writeData(input [WIDTH-1:0] d);
    begin
      @(posedge clk);
      wrEn = 1;
      dataIn = d;
      @(posedge clk);
      wrEn = 0;
    end
  endtask

  // Read task
  task readData;
    begin
      @(posedge clk);
      rdEn = 1;
      @(posedge clk);
      rdEn = 0;
    end
  endtask

  // Stimulus
  initial begin
    // Initial reset
    rstN = 0;
    wrEn = 0;
    rdEn = 0;
    #2;
    @(posedge clk);
    rstN = 1;

    // -----------------------------------------------
    // TEST CASE 2: Overwrite FIFO (write beyond full)
    // -----------------------------------------------
    for (i = 0; i <= DEPTH + 3; i = i + 1) begin
      writeData(i);  // One more than capacity
    end


    #20 $finish;
  end

  // Waveform dump
  initial begin
    $dumpfile("fifoSync_tb.vcd");
    $dumpvars;
  end

endmodule
