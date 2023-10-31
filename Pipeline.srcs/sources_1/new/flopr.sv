`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 09:53:34 AM
// Design Name: 
// Module Name: flopr
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


module flopReset(
    input logic clk,
    input logic reset,
    input logic [31:0] d,
    output logic [31:0] q
    );
    
    always_ff @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else q <= d;
        
endmodule
