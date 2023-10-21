`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2023 11:08:47 AM
// Design Name: 
// Module Name: ThreeByOneMux
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


module ThreeByOneMux(
    input [31:0] d0,
    input [31:0] d1,
    input [31:0] d2,
    input [1:0] s,
    output [31:0] y
    );
    
    assign y = s[1] ? d2 : (s[0] ? d1 : d0);
    
endmodule
