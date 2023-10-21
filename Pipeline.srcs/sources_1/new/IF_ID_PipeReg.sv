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


module IF_ID_PipeReg(
    input CLK,
    input [31:0] InstrFromIM,
    input [31:0] PCFromF,
    input [31:0] PCPlus4FromF,
    output [31:0] InstrToD,
    output [31:0] PCToD,
    output [31:0] PCPlus4ToD
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
        ram[0] <= InstrFromIM;
        ram[1] <= PCFromF;
        ram[2] <= PCPlus4FromF;
    end
    
endmodule
