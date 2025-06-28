// Testbench for fifoSync 

`timescale 1ns/1ns

module FIFO_Sync_tb;

  // Parameters
  parameter DEPTH = 8;
  parameter WIDTH = 32;

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
      $display("%0t: WRITE -> %0d", $time, dataIn);
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
      $display("%0t: READ  -> %0d", $time, dataOut);
      rdEn = 0;
    end
  endtask

  // Stimulus
  initial begin
    // Initial reset
    rstN = 1; 
    #10;
    rstN = 0;
    wrEn = 0;
    rdEn = 0;
    #10;
    @(posedge clk);
    rstN = 1;
    // ---------------------------------------------------------
    // Test Case 1: Simple Write then Read
    // Purpose: Verify basic FIFO operation and data ordering
    // ---------------------------------------------------------
    for (i = 0; i < DEPTH; i = i + 1) begin
      writeData(i);
      readData();
    end
    #20 $finish;
  end
endmodule
