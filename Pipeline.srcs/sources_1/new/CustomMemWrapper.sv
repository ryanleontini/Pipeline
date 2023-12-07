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
    
    input CLK,
    input logic RST,
    input [31:0] PC,         
    
    output logic [31:0] RDATA,
    output logic MISS );
    
    logic delivered;                                // Internal wiring
    logic [127:0] block;
    logic miss;
    
    
    assign MISS = miss;
    
    L1 CacheIM(         .clk(CLK),                  // L1
                        .rst(RST),                  
                        
                        .raddress(PC[31:2]),        // From CPU
                        .rdata(RDATA),              // To CPU
                        
                        .miss(miss),                  // To PARAM
            
                        .delivered(delivered),      // From PARAM
                        .blockin(block) );          // From PARAM
                
    ParamMemory PARAM(  .clk(CLK),                  // MAIN MEMORY
                        .raddress(PC),        // From CPU
                        .miss(miss),                  // From L1
                        .delivered(delivered),      // To L1
                        .blockout(block) );         // To L1
        
     
    
    
    
endmodule
