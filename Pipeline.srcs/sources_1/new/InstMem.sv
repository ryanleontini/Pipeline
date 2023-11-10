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
    output [31:0] rd
    );
    
    logic [31:0] RAM[63:0];
    
    initial 
        $readmemh("stalltest.mem", RAM);
    
    assign rd = RAM[a[31:2]]; // word aligned
    
endmodule
