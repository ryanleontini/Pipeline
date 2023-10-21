`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ryan Leontini
// 
// Create Date: 10/21/2023 10:30:23 AM
// Design Name: 
// Module Name: EX_M_PipeReg
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


module EX_M_PipeReg(
    input CLK,
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [11:7] RdE,
    input [31:0] PCPlus4E,
    output [31:0] ALUResultM,
    output [31:0] WriteDataM,
    output [11:7] RdM,
    output [31:0] PCPlus4M
    );
    
    reg [31:0] ram1 [2:0];
    reg [11:7] ram2;
    
    initial begin
        int i;
        for (i = 0; i < 3; i = i + 1) begin
            ram1[i]=0;
        end
        ram2 = 0;
    end
    
    assign ALUResultM = ram1[0];
    assign WriteDataM = ram1[1];
    assign PCPlus4M = ram1[2];
    assign RdM = ram2;
    
    always @ (posedge CLK) begin
        ram1[0] <= ALUResultE;
        ram1[1] <= WriteDataE;
        ram1[2] <= PCPlus4E;
        ram2 <= RdE;
    end
endmodule
