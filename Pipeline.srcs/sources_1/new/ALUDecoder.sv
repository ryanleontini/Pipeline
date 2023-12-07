`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 09:55:05 PM
// Design Name: 
// Module Name: ALUDecoder
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


module ALUDecoder(
    input [2:0] funct3,
    input funct7,
    input op5,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl,
    output reg InvertZeroALU
    );
    
    always_comb begin
    
        ALUControl = 4'b0000;
        InvertZeroALU = 0;
            
        case (ALUOp)
            
            2'b00: begin
                ALUControl = 4'b0000;    // add
            end
            
            2'b01: begin
                ALUControl = 4'b0001;    // sub
                case (funct3)
                    3'b001: begin
                        InvertZeroALU = 1; end
                endcase
                
            end
            
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (op5 && funct7) begin
                             ALUControl = 4'b0001;   // sub
                        end
                        else begin
                            ALUControl = 4'b0000;    // add
                        end
                    end
                    3'b001: begin
                        ALUControl = 4'b0100;        // sll
                    end
                    3'b010: begin
                        ALUControl = 4'b0101;        // slt
                    end
                    3'b011: begin
                        ALUControl = 4'b0111;        // sltu
                    end
                    3'b100: begin
                        ALUControl = 4'b0110;        // xor
                    end
                    3'b101: begin
                        if (op5) begin
                             ALUControl = 4'b1001;   // sra
                        end
                        else begin
                            ALUControl = 4'b1000;    // srl
                        end
                    end
                    3'b110: begin
                        ALUControl = 4'b0011;        // or
                    end
                    3'b111: begin
                        ALUControl = 4'b0010;        // and
                    end
                endcase
                
            end
        
        
        endcase            
    end
endmodule