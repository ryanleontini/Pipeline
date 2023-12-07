`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nikolai Downs
// 
// Create Date: 02/01/2023 10:49:08 AM
// Design Name: 
// Module Name: OTTER_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ALU preforms operations on inputs a and b,
//              output is dependent on the operation ALU_FUN decides
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OTTER_ALU(
    input [31:0] ALU_a, 
    input [31:0] ALU_b,
    input [3:0] ALU_FUN,
    input InvertZeroALU,
    output logic [31:0] ALU_RESULT,
    output logic ZeroE );
    
    // All operations are completed. ALU FUN only determines which is outputted.
    logic [31:0] r; // Temporary RESULT holder
    logic [31:0] ADD; // Temporary A + B holder
    logic [31:0] SUB; // Temporary A - B holder
    logic [31:0] OR1; // Temporary A or B holder
    logic [31:0] AND1; // Temporary A and B holder
    logic [31:0] XOR1; // Temporary A xor B holder
    logic [31:0] SRL; // Temporary A shifted B holder
    logic [31:0] SLL; // Temporary A shifted B holder
    logic [31:0] SRA; // Temporary A shifted B holder
    logic [31:0] SLT; // Temporary A < B holder
    logic [31:0] SLTU; // Temporary A < B holder
    logic [31:0] LUI_COPY; // Reflects A
    
    //logic [3:0] ALU_FUN4BIT;      // Your 4-bit output
    logic ResultZero;

    //assign ALU_FUN4BIT = {1'b0, ALU_FUN};  // Concatenate 0 to the MSB of input3bit
    
    
    // Assignments for the holders
    assign ADD = ALU_a + ALU_b;
    assign SUB = ALU_a - ALU_b;
    assign OR1 = ALU_a | ALU_b;
    assign AND1 = ALU_a & ALU_b;
    assign XOR1 = ALU_a ^ ALU_b;
    assign SRL = ALU_a >> ALU_b[4:0];
    assign SLL = ALU_a << ALU_b[4:0];
    assign SRA = signed'(ALU_a) >>> ALU_b[4:0];
    assign LUI_COPY = ALU_a;
    
    assign ALU_RESULT = r;
    
    always_comb begin
    
        // Logic for determinging if A < B
        if ( $signed(ALU_a) < $signed(ALU_b)) begin
            SLT = 1; end  
        else begin
            SLT = 0; end
        if (ALU_a < ALU_b) begin
            SLTU = 1; end
        else begin
            SLTU = 0; end
            
            
        case (ALU_FUN) // ALU FUN determines which operation to output
            4'b0000: r = ADD; 
            4'b0001: r = SUB; 
            4'b0010: r = AND1;
            4'b0011: r = OR1;
            4'b0100: r = SLL;
            4'b0101: r = SLT;  
            4'b0110: r = XOR1;
            4'b0111: r = SLTU;
            4'b1000: r = SRL;
            4'b1001: r = SRA;
            default: r = 32'hdeaddead;
            // Default should never be outputed
        endcase
        
        ResultZero = (ALU_RESULT == 0) ? 1'b1 : 1'b0;
        ZeroE = (InvertZeroALU) ? ~ResultZero : ResultZero;
    end
endmodule
