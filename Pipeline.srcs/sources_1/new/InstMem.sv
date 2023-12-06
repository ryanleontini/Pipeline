`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2023 03:33:10 PM
// Design Name: 
// Module Name: InstMem
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


module INSTMEM(
    input [31:0] a,
    output [127:0] rd_block
);

    logic [31:0] RAM[4095:0];

    initial 
        $readmemh("hazardtest4.mem", RAM);

    // Calculate the base index for the block of instructions
    wire [13:4] base_index = a[31:4];

    // Assign each 32-bit instruction to the output block
    assign rd_block[31:0]   = RAM[base_index];
    assign rd_block[63:32]  = RAM[base_index + 1];
    assign rd_block[95:64]  = RAM[base_index + 2];
    assign rd_block[127:96] = RAM[base_index + 3];

endmodule

