`timescale 1ns / 1ps
// -------------------------------------
// Module: emptyGenerator
// Description: Read pointer handler with FIFO empty flag
// -------------------------------------

module emptyGenerator #(
    parameter addrWidth = 4
)(
    output reg fifoEmptyOut,                  // Indicates FIFO is empty
    output [addrWidth-1:0] readAddrOut,       // Read address to memory
    output reg [addrWidth:0] readPtrOut,      // Read pointer (Gray code)
    input [addrWidth:0] syncedWritePtrIn,     // Write pointer synchronized to read domain
    input readEnableIn, readClkIn, readRstIn  // Read enable, clock and active-low reset
);

    reg [addrWidth:0] readBin;                        // Binary version of read pointer
    wire [addrWidth:0] readBinNext, readGrayNext;
    wire isEmpty;

    // Update read pointer on each read clock edge
    always @(posedge readClkIn or negedge readRstIn) begin
        if (!readRstIn)
            {readBin, readPtrOut} <= 0;
        else
            {readBin, readPtrOut} <= {readBinNext, readGrayNext};
    end

    assign readAddrOut = readBin[addrWidth-1:0];                     // Address to access memory
    assign readBinNext = readBin + (readEnableIn & ~fifoEmptyOut);  // Increment if not empty
    assign readGrayNext = (readBinNext >> 1) ^ readBinNext;         // Binary to Gray code

    assign isEmpty = (readGrayNext == syncedWritePtrIn);            // Compare to write pointer

    always @(posedge readClkIn or negedge readRstIn) begin
        if (!readRstIn)
            fifoEmptyOut <= 1'b1;
        else
            fifoEmptyOut <= isEmpty;
    end

endmodule

