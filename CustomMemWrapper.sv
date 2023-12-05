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
    input [31:0] RADDRESS,         
    
    output logic [31:0] RDATA,
    output logic HIT );
    
    logic delivered;                                // Internal wiring
    logic [127:0] block;
    logic hit;
    
    assign HIT = hit;
    
    L1 CacheIM(         .rst(RST),                  // L1
                        
                        .raddress(RADDRESS),        // From CPU
                        .rdata(RDATA),              // To CPU
                        
                        .hit(hit),                  // To PARAM
            
                        .delivered(delivered),      // From PARAM
                        .blockin(block) );          // From PARAM
                
    ParamMemory PARAM(  .clk(CLK),                  // MAIN MEMORY
                        .rst(RST),
                        .raddress(RADDRESS),        // From CPU
                        .hit(hit),                  // From L1
                        .delivered(delivered),      // To L1
                        .blockout(block) );         // To L1
        
     
    
    
    
endmodule
