`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ryan Leontini
// 
// Create Date: 10/20/2023 02:24:46 PM
// Design Name: 
// Module Name: IF_ID_PipeReg
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

// First pipeline register
module IF_ID_PipeReg(
    input CLK,
    input [31:0] InstrFromIM,
    input [31:0] PCFromF,
    input [31:0] PCPlus4FromF,
    output [31:0] InstrToD,
    output [31:0] PCToD,
    output [31:0] PCPlus4ToD,
    input StallDFlipped,
    input FlushD
    );
    
    reg [31:0] ram [0:2];
    
    // Initialize 3 spaces of ram for the 3 values being held.
    initial begin
        int i;
        for (i = 0; i < 3; i = i + 1) begin
            ram[i]=0;
        end
    end
    
    // Assign outputs from the internal storage
    assign InstrToD = ram[0];
    assign PCToD = ram[1];
    assign PCPlus4ToD = ram[2];

    always @ (posedge CLK) begin
        if (FlushD) begin
            // If FlushD is asserted, reset the values
            ram[0] <= 32'b0;
            ram[1] <= 32'b0;
            ram[2] <= 32'b0; 
        end
        else if (StallDFlipped) begin
            // Only write to the pipeline register if not stalled or flushed
            ram[0] <= InstrFromIM;
            ram[1] <= PCFromF;
            ram[2] <= PCPlus4FromF;
        end
        // If StallDFlipped is false and FlushD is false, do nothing (hold the current value)
    end
    
endmodule
