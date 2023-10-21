`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 09:24:07 AM
// Design Name: 
// Module Name: TwoByOneMux
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


module TwoByOneMux(
    input [31:0] d0,
    input [31:0] d1,
    input s,
    output [31:0] y
    );
    
    assign y = s ? d1 : d0;
    
endmodule
