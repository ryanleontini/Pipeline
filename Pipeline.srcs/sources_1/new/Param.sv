`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 09:17:48 AM
// Design Name: 
// Module Name: Param
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


module ParamMemory(
    input clk,
    input [31:0] raddress,
    input hit,
    output reg delivered,
    output reg [127:0] p_blockout
);

    logic [31:0] RAM[4095:0];

    initial 
        $readmemh("hazardtest4.mem", RAM);

    // Calculate the base index for the block of instructions
    wire [9:0] base_index = raddress[31:4];

    // Create block out of current word + 3 following words.
    always_ff @(posedge clk) begin
        if (!hit) begin
            delivered <= 1'b1;
            p_blockout[31:0]   = RAM[base_index];
            p_blockout[63:32]  = RAM[base_index + 1];
            p_blockout[95:64]  = RAM[base_index + 2];
            p_blockout[127:96] = RAM[base_index + 3];
        end else begin
            delivered <= 1'b0;
        end
    end
    
endmodule

