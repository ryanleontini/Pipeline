`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2023 08:05:16 PM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input [6:0] op,
    output reg RegWriteD,
    output reg [1:0] ResultSrcD,
    output reg MemWriteD,
    output reg JumpD,
    output reg BranchD,
    output reg [2:0] ALUop,
    output reg ALUSrcD,
    output reg [1:0] ImmSrcD
    );
    
    always_comb begin
    
        RegWriteD = 0;
        ImmSrcD = 0;
        ALUSrcD = 0;
        MemWriteD = 0;
        ResultSrcD = 0;
        BranchD = 0;
        ALUop = 0;
        JumpD = 0;
    
        case (op)
       
            // LW
            7'b0000011: begin
                RegWriteD = 1'b1;
                ImmSrcD = 2'b00;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b01;
                BranchD = 1'b0;
                ALUop = 3'b00;
                JumpD = 1'b0;
                end
                
            // SW
            7'b0100011: begin
                RegWriteD = 1'b0;
                ImmSrcD = 2'b01;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b1;
                ResultSrcD = 2'b01;
                BranchD = 1'b0;
                ALUop = 2'b00;
                JumpD = 1'b0;
                end
                
            // R-Type
            7'b0110011: begin
                RegWriteD = 1'b1;
                ImmSrcD = 2'b00;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUop = 2'b10;
                JumpD = 1'b0;
                end
                
            // beq
            7'b1100011: begin
                RegWriteD = 1'b0;
                ImmSrcD = 2'b10;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b01;
                BranchD = 1'b1;
                ALUop = 2'b01;
                JumpD = 1'b0;
                end
                
            // I-type
            7'b0010011: begin
                RegWriteD = 1'b1;
                ImmSrcD = 2'b00;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUop = 2'b10;
                JumpD = 1'b0;
                end
                
            // jal
            7'b1101111: begin
                RegWriteD = 1'b1;
                ImmSrcD = 2'b11;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b10;
                BranchD = 1'b0;
                ALUop = 2'b00;
                JumpD = 1'b1;
                end

        endcase            
    end
    
endmodule
