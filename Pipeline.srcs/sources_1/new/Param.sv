`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 09:17:48 AM
// Design Name: 
// Module Name: Param
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


module ParamMemory(
    input clk,
    input rst,
    input [31:0] raddress,
    input hit,
    output stall,
    output delivered,
    output [127:0] p_blockout,
    output [31:0] rdata2
    );
    
    // If reset, do this
    
    // Take in raddress
    
    // If hit is false,
        // Stall true
        // Find block ( which words do I send in the block?)
        // Find word within block
        // Send blockout, rdata2, delivered is true, stall false
    
endmodule
