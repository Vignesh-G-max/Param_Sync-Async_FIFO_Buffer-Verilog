`timescale 1ns / 1ps
// ---------------------------------------------
// Module: FIFOMemory
// Description: Dual-port synchronous memory for asynchronous FIFO
// ---------------------------------------------

module FIFOMemory #(
    parameter dataWidth = 8,
    parameter addrWidth = 4
)(
    output [dataWidth-1:0] dataOut,          // Data read from memory
    input [dataWidth-1:0] dataIn,            // Data to write into memory
    input [addrWidth-1:0] writeAddrIn,       // Write address
    input [addrWidth-1:0] readAddrIn,        // Read address
    input writeEnableIn,                     // Write enable
    input fifoFullIn,                        // Full flag (used to block write)
    input writeClkIn                         // Write clock
);

    localparam depth = 1 << addrWidth;
    reg [dataWidth-1:0] memoryArray [0:depth-1];

    // Read is combinational
    assign dataOut = memoryArray[readAddrIn];

    // Write occurs only when FIFO is not full
    always @(posedge writeClkIn) begin
        if (writeEnableIn && !fifoFullIn)
            memoryArray[writeAddrIn] <= dataIn;
    end

endmodule
