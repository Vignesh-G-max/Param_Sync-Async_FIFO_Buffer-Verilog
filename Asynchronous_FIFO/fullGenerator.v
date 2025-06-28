`timescale 1ns / 1ps
// -------------------------------------
// Module: fullGenerator
// Description: Write pointer handler with FIFO full flag
// -------------------------------------

module fullGenerator #(
    parameter addrWidth = 4
)(
    output reg fifoFullOut,                     // Indicates FIFO is full
    output [addrWidth-1:0] writeAddrOut,        // Write address to memory
    output reg [addrWidth:0] writePtrOut,       // Write pointer (Gray code)
    input [addrWidth:0] syncedReadPtrIn,        // Read pointer synchronized to write domain
    input writeEnableIn, writeClkIn, writeRstIn // Write enable, clock and active-low reset
);

    reg [addrWidth:0] writeBin;                         // Binary version of write pointer
    wire [addrWidth:0] writeBinNext, writeGrayNext;
    wire isFull;

    // Update write pointer on each write clock edge
    always @(posedge writeClkIn or negedge writeRstIn) begin
        if (!writeRstIn)
            {writeBin, writePtrOut} <= 0;
        else
            {writeBin, writePtrOut} <= {writeBinNext, writeGrayNext};
    end

    assign writeAddrOut = writeBin[addrWidth-1:0];                          // Address to access memory
    assign writeBinNext = writeBin + (writeEnableIn & ~fifoFullOut);       // Increment if not full
    assign writeGrayNext = (writeBinNext >> 1) ^ writeBinNext;             // Binary to Gray code

    assign isFull = (writeGrayNext == {~syncedReadPtrIn[addrWidth:addrWidth-1], syncedReadPtrIn[addrWidth-2:0]});

    
    always @(posedge writeClkIn or negedge writeRstIn) begin
        if (!writeRstIn)
            fifoFullOut <= 1'b0;
        else
            fifoFullOut <= isFull;
    end

endmodule
