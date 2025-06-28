// "Explore Electronics Plus" Youtube Channel

`timescale 1ns/1ns

module FIFO_Sync
  // Parameter definitions for FIFO depth and data width
  #(parameter FIFO_DEPTH = 8,
    parameter DATA_WIDTH = 32)
  // Port declarations
  (
    input clk,                // System clock
    input rst_n,              // Active-low reset
    input cs,                 // Chip select / module enable
    input wr_en,              // Write enable
    input rd_en,              // Read enable
    input [DATA_WIDTH-1:0] data_in,     // Data to be written into FIFO
    output reg [DATA_WIDTH-1:0] data_out, // Data read from FIFO
    output empty,             // FIFO empty flag
    output full               // FIFO full flag
  );

  // Calculate required number of bits for addressing based on depth
  localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH);

  // Memory array declaration for FIFO storage
  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];  // FIFO memory: DEPTH x DATA_WIDTH

  // Read and write pointers with one extra MSB bit for full-empty detection
  reg [FIFO_DEPTH_LOG:0] write_pointer;  // Write address pointer
  reg [FIFO_DEPTH_LOG:0] read_pointer;   // Read address pointer

  // Write logic: writes data on positive clock edge if enabled and not full
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      write_pointer <= 0;  // Reset write pointer on active-low reset
    end else if (cs && wr_en && !full) begin
      fifo[write_pointer[FIFO_DEPTH_LOG-1:0]] <= data_in;  // Write data to FIFO
      write_pointer <= write_pointer + 1'b1;               // Increment pointer
    end
  end

  // Read logic: reads data on positive clock edge if enabled and not empty
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      read_pointer <= 0;  // Reset read pointer on active-low reset
    end else if (cs && rd_en && !empty) begin
      data_out <= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];  // Read data from FIFO
      read_pointer <= read_pointer + 1'b1;                 // Increment pointer
    end
  end

  // Empty condition: when read and write pointers are equal
  assign empty = (read_pointer == write_pointer);

  // Full condition:
  // When write pointer is exactly one cycle ahead of read pointer in circular buffer
  assign full  = (read_pointer == {~write_pointer[FIFO_DEPTH_LOG], write_pointer[FIFO_DEPTH_LOG-1:0]});

endmodule
