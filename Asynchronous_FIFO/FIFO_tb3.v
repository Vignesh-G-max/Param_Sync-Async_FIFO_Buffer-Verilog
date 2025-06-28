`timescale 1ns / 1ps
// -----------------------------------------------------
// Testbench: FIFOTop_tb
// Description: Testbench for FIFOTop asynchronous FIFO
// -----------------------------------------------------

module FIFOTop_tb();

    parameter dataWidth = 8;
    parameter addrWidth = 3;
    parameter fifoDepth = 1 << addrWidth;

    reg [dataWidth-1:0] dataIn;
    wire [dataWidth-1:0] dataOut;
    wire fifoFullOut, fifoEmptyOut;
    reg writeEnableIn, readEnableIn;
    reg writeClkIn, readClkIn;
    reg writeRstIn, readRstIn;

    // Instantiate the FIFO
    FIFOTop #(dataWidth, addrWidth) uut (
        .dataOut(dataOut),
        .fifoFullOut(fifoFullOut),
        .fifoEmptyOut(fifoEmptyOut),
        .dataIn(dataIn),
        .writeEnableIn(writeEnableIn),
        .readEnableIn(readEnableIn),
        .writeClkIn(writeClkIn),
        .readClkIn(readClkIn),
        .writeRstIn(writeRstIn),
        .readRstIn(readRstIn)
    );

    integer i;
    // Generate write and read clocks
    always #5 writeClkIn = ~writeClkIn;   // Fast write clock
    always #10 readClkIn = ~readClkIn;    // Slower read clock

    initial begin
        // Initialize signals
        writeClkIn = 0;
        readClkIn = 0;
        writeRstIn = 1;
        readRstIn = 1;
        writeEnableIn = 0;
        readEnableIn = 0;
        dataIn = 0;

        // Apply resets
        #20 writeRstIn = 0; readRstIn = 0;
        #20 writeRstIn = 1; readRstIn = 1;
        
       // --------------------------------------------------
       // TEST CASE 3: Attempt to overread the FIFO
       // --------------------------------------------------
       writeEnableIn = 1;
        for (i = 0; i < fifoDepth - 4; i = i + 1) begin
           dataIn = i;
           #10;
       end
       writeEnableIn = 0;

       readEnableIn = 1;
        for (i = 0; i < fifoDepth + 3; i = i + 1) begin
           #20;
       end
        $finish;
    end

endmodule
