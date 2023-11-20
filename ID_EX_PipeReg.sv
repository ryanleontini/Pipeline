`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ryan Leontini
// 
// Create Date: 10/21/2023 09:31:57 AM
// Design Name: 
// Module Name: ID_EX_PipeReg
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

// Second Pipeline Register
module ID_EX_PipeReg(
    input CLK,
    
    // CU Values
    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchD,
    input [3:0] ALUControlD,
    input InvertZeroD,
    input ALUSrcD,
    output RegWriteE,
    output [1:0] ResultSrcE,
    output MemWriteE,
    output JumpE,
    output BranchE,
    output [3:0] ALUControlE,
    input InvertZeroE,
    output ALUSrcE,
    
    // Pipeline Values
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] PCD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [11:7] RdD,
    input [31:0] ImmExtD,
    input [31:0] PCPlus4D,
    output [31:0] RD1E,
    output [31:0] RD2E,
    output [31:0] PCE,
    output [4:0] Rs1E,
    output [4:0] Rs2E,
    output [11:7] RdE,
    output [31:0] ImmExtE,
    output [31:0] PCPlus4E,
    input FlushE
    );
    
    reg [11:0] ramCU;
    reg [31:0] ram1 [4:0];
    reg [11:7] ram2;
    reg [4:0] ramHazard [1:0];
    
    initial begin
        int i;
        for (i = 0; i < 5; i = i + 1) begin
            ram1[i]=0;
        end
        ramCU = 0;
        ram2 = 0;
    end
    
  
    assign RegWriteE = ramCU[0];
    assign ResultSrcE = ramCU[2:1];
    assign MemWriteE = ramCU[3];
    assign JumpE = ramCU[4];
    assign BranchE = ramCU[5];
    assign ALUControlE = ramCU[9:6];
    assign InvertZeroE = ramCU[10];
    assign ALUSrcE = ramCU[11];
    
    assign RD1E = ram1[0];
    assign RD2E = ram1[1];
    assign PCE = ram1[2];
    assign Rs1E = ramHazard[0];
    assign Rs2E = ramHazard[1];
    assign RdE = ram2;
    assign ImmExtE = ram1[3];
    assign PCPlus4E = ram1[4];
    
    always @ (posedge CLK) begin
        if (FlushE) begin
            // Clear the control signals and hazard information
            ramCU <= 12'd0; // Assuming there are 10 control bits in ramCU
            ramHazard[0] <= 5'd0;
            ramHazard[1] <= 5'd0;
            ram2 <= 5'd0; // Assuming that the [11:7] width here is 5 bits like a register identifier
    
            // Optionally, clear the data path elements too
            ram1[0] <= 32'd0;
            ram1[1] <= 32'd0;
            ram1[2] <= 32'd0;
            ram1[3] <= 32'd0;
            ram1[4] <= 32'd0;
        end else begin
            ramCU[0] <= RegWriteD;
            ramCU[2:1] <= ResultSrcD;
            ramCU[3] <= MemWriteD;
            ramCU[4] <= JumpD;
            ramCU[5] <= BranchD;
            ramCU[9:6] <= ALUControlD;
            ramCU[10] <= InvertZeroD;
            ramCU[11] <= ALUSrcD;
        
            ram1[0] <= RD1D;
            ram1[1] <= RD2D;
            ram1[2] <= PCD;
            ramHazard[0] <= Rs1D;
            ramHazard[1] <= Rs2D;
            ram1[3] <= ImmExtD;
            ram1[4] <= PCPlus4D;
            ram2 <= RdD;
            end;
    end
    
endmodule
