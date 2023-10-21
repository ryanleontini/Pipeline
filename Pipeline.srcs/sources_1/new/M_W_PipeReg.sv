`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 11:04:06 AM
// Design Name: 
// Module Name: M_W_PipeReg
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


module M_W_PipeReg(
    input CLK,
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [11:7] RdM,
    input [31:0] PCPlus4M,
    output [31:0] ALUResultW,
    output [31:0] ReadDataW,
    output [11:7] RdW,
    output [31:0] PCPlus4W
    );
endmodule
