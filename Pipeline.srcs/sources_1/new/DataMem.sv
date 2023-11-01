`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2023 03:33:10 PM
// Design Name: 
// Module Name: DataMem
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


module DATAMEM(
    input logic clk, we,
    input logic [31:0] a,
    input logic [31:0] wd,
    output logic [31:0] rd
    );
    
    logic [31:0] RAM[63:0];
    
    assign rd = RAM[a[31:2]]; // word aligned
    
    always_ff @(posedge clk)
        if(we) RAM[a[31:2]] <= wd;
    
endmodule
