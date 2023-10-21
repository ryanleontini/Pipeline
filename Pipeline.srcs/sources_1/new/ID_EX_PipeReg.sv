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


module ID_EX_PipeReg(
    input CLK,
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] PCD,
    input [11:7] RdD,
    input [31:0] ImmExtD,
    input [31:0] PCPlus4D,
    output [31:0] RD1E,
    output [31:0] RD2E,
    output [31:0] PCE,
    output [11:7] RdE,
    output [31:0] ImmExtE,
    output [31:0] PCPlus4E
    );
    
    reg [31:0] ram1 [4:0];
    reg [11:7] ram2;
    
    initial begin
        int i;
        for (i = 0; i < 5; i = i + 1) begin
            ram1[i]=0;
        end
        ram2 = 0;
    end
    
    assign RD1E = ram1[0];
    assign RD2E = ram1[1];
    assign PCE = ram1[2];
    assign RdE = ram2;
    assign ImmExtE = ram1[3];
    assign PCPlus4E = ram1[4];
    
    always @ (posedge CLK) begin
        ram1[0] <= RD1D;
        ram1[1] <= RD2D;
        ram1[2] <= PCD;
        ram1[3] <= ImmExtD;
        ram1[4] <= PCPlus4D;
        ram2 <= RdD;
    end
    
endmodule
