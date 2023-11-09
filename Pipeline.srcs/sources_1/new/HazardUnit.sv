`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2023 04:06:59 PM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    input [4:0] RdM, RdW,
    input RegWriteM,
    input RegWriteW,
    
    // Stalling
    output StallF, StallD, FlushE,
    input ResultSrcE_MSB, 
    input [4:0] Rs1D, Rs2D, RdE,
    
    // Branch
    output FlushD,
    input PCSrcE
    );
       
    always_comb begin
        if ((Rs1E == RdM) && RegWriteM && Rs1E != 0)
            ForwardAE = 2'b10;
        else if ((Rs1E == RdW) && RegWriteW && Rs1E != 0)
            ForwardAE = 2'b01;
        else 
            ForwardAE = 2'b00;
    end
    
    always_comb begin
        if ((Rs2E == RdM) && RegWriteM && Rs2E != 0)
            ForwardBE = 2'b10;
        else if ((Rs2E == RdW) && RegWriteW && Rs2E != 0)
            ForwardBE = 2'b01;
        else 
            ForwardBE = 2'b00;
    end    
    
    // Stalling Logic.
    logic lwStall;
    
    assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrcE_MSB;
    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushE = lwStall || PCSrcE;
    assign FlushD = PCSrcE;
    
endmodule
