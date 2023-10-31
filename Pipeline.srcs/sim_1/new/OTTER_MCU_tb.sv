`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 09:38:43 AM
// Design Name: 
// Module Name: OTTER_MCU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OTTER_MCU_tb();

    logic RST, INTR, CLK, IOBUS_WR;
    logic [31:0] IOBUS_IN, IOBUS_OUT, IOBUS_ADDR;
    
    OTTER_MCU UUT(.CLK(CLK), .INTR(INTR), .RESET(RST), .IOBUS_IN(IOBUS_IN), .IOBUS_OUT(IOBUS_OUT), 
        .IOBUS_ADDR(IOBUS_ADDR), .IOBUS_WR(IOBUS_WR));
        
    initial begin 
        CLK = 0;
        #10;
    end
    
    always begin
        #5 CLK <= ~CLK;
    end
    
    initial begin
        RST = 0;
        INTR = 0;
        IOBUS_IN = 32'd1;
        #10;
        
        RST = 1;
        INTR = 0;
        IOBUS_IN = 32'd1;
        #10;

        RST = 0;
        INTR = 0;
        IOBUS_IN = 32'd1;
        #10000;
    end
    
endmodule