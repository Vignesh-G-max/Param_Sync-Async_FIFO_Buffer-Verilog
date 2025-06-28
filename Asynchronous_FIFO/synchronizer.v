`timescale 1ns / 1ps
// ------------------------------------------
// Module: FIFOTop
// Description: Top-level module for Asynchronous FIFO
// ------------------------------------------

module FIFOTop #(
    parameter dataWidth = 8,
    parameter addrWidth = 4
)(
    output [dataWidth-1:0] dataOut,     // Data output from FIFO
    output fifoFullOut,                 // FIFO full flag
    output fifoEmptyOut,                // FIFO empty flag
    input [dataWidth-1:0] dataIn,       // Data input to FIFO
    input writeEnableIn,                // Write enable signal
    input readEnableIn,                 // Read enable signal
    input writeClkIn,                   // Write clock
    input readClkIn,                    // Read clock
    input writeRstIn,                   // Active-low write domain reset
    input readRstIn                     // Active-low read domain reset
);

    // Internal signals
    wire [addrWidth:0] writePtr, readPtr;
    wire [addrWidth:0] syncedReadPtr, syncedWritePtr;
    wire [addrWidth-1:0] writeAddr, readAddr;

    // ---------------------------
    // Synchronizers (CDC)
    // ---------------------------

    synchronizer #(addrWidth+1) syncReadToWrite (
        .q2(syncedReadPtr),
        .din(readPtr),
        .clk(writeClkIn),
        .rst_n(writeRstIn)
    );

    synchronizer #(addrWidth+1) syncWriteToRead (
        .q2(syncedWritePtr),
        .din(writePtr),
        .clk(readClkIn),
        .rst_n(readRstIn)
    );

    // ---------------------------
    // FIFO Memory
    // ---------------------------

    FIFOMemory #(dataWidth, addrWidth) fifoMem (
        .dataOut(dataOut),
        .dataIn(dataIn),
        .writeAddrIn(writeAddr),
        .readAddrIn(readAddr),
        .writeEnableIn(writeEnableIn),
        .fifoFullIn(fifoFullOut),
        .writeClkIn(writeClkIn)
    );

    // ---------------------------
    // Empty Flag & Read Pointer
    // ---------------------------

    emptyGenerator #(addrWidth) readCtrl (
        .fifoEmptyOut(fifoEmptyOut),
        .readAddrOut(readAddr),
        .readPtrOut(readPtr),
        .syncedWritePtrIn(syncedWritePtr),
        .readEnableIn(readEnableIn),
        .readClkIn(readClkIn),
        .readRstIn(readRstIn)
    );

    // ---------------------------
    // Full Flag & Write Pointer
    // ---------------------------

    fullGenerator #(addrWidth) writeCtrl (
        .fifoFullOut(fifoFullOut),
        .writeAddrOut(writeAddr),
        .writePtrOut(writePtr),
        .syncedReadPtrIn(syncedReadPtr),
        .writeEnableIn(writeEnableIn),
        .writeClkIn(writeClkIn),
        .writeRstIn(writeRstIn)
    );

endmodule
