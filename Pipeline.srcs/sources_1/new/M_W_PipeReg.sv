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

// Fourth pipeline register
module M_W_PipeReg(
    input CLK,
    
    // CU Values
    input RegWriteM,
    input [1:0] ResultSrcM,
    output RegWriteW,
    output [1:0] ResultSrcW,
    
    // Pipeline Values
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [11:7] RdM,
    input [31:0] PCPlus4M,
    output [31:0] ALUResultW,
    output [31:0] ReadDataW,
    output [11:7] RdW,
    output [31:0] PCPlus4W
    );
    
    reg [2:0] ramCU;
    reg [31:0] ram1 [2:0];
    reg [11:7] ram2;
    
    initial begin
        int i;
        for (i = 0; i < 3; i = i + 1) begin
            ram1[i]=0;
        end
        ramCU = 0;
        ram2 = 0;
    end
    
    assign RegWriteW = ramCU[0];
    assign ResultSrcW = ramCU[2:1];
    
    assign ALUResultW = ram1[0];
    assign ReadDataW = ram1[1];
    assign PCPlus4W = ram1[2];
    assign RdW = ram2;
    
    always @ (posedge CLK) begin
    
        ramCU[0] <= RegWriteM;
        ramCU[2:1] <= ResultSrcM;        
        
        ram1[0] <= ALUResultM;
        ram1[1] <= ReadDataM;
        ram1[2] <= PCPlus4M;
        ram2 <= RdM;
    end
endmodule
