`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 02:48:41 PM
// Design Name: 
// Module Name: CustomMemWrapper
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


module CustomMemWrapper(
    
    input MEM_CLK,
    input logic RST,
    input [31:0] MEM_ADDR1,         // Instruction Memory Port
    input [31:0] MEM_ADDR2,         // Data Memory Port
    input [31:0] MEM_DIN2,
    input MEM_WRITE2,
    input MEM_READ1,
    input MEM_READ2,
    
    input [1:0] MEM_SIZE,           // Do this in PARAM?

    output logic [31:0] MEM_DOUT1,
    output logic [31:0] MEM_DOUT2,
    output logic MEM_VALID1, 
    output logic MEM_VALID2 );
    
    
    logic hit;
    logic delivered;
    logic [127:0] block;
    
    L1 CacheIM(         // L1: instruction memory
                        .rst(RST),
            
                        .raddress(MEM_ADDR1),       // From CPU
                        .rdata(MEM_DOUT1),          // To CPU
                        .hit(hit),                  // To PARAM
                        .memValid1(MEM_VALID1),     // To CPU
            
                        .delivered(delivered),      // From PARAM
                        .blockin(block) );          // From PARAM
                
    ParamMemory Param(  .clk(MEM_CLK),              // MAIN MEMORY: IM & Data
                        .rst(RST),
                        .raddress1(MEM_ADDR1),      // IM Address
                        .hit(hit),
                        .stall(stall),                  // From L1         // InstrD
                        .delivered(delivered),      // To L1
                        .blockout(block),
                        .rdata2(MEM_DOUT2));         // To L1 
    
endmodule
