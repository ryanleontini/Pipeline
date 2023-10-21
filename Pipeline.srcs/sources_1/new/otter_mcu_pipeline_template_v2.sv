`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  J. Callenes
// 
// Create Date: 01/04/2019 04:32:12 PM
// Design Name: 
// Module Name: PIPELINED_OTTER_CPU
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

  typedef enum logic [6:0] {
           LUI      = 7'b0110111,
           AUIPC    = 7'b0010111,
           JAL      = 7'b1101111,
           JALR     = 7'b1100111,
           BRANCH   = 7'b1100011,
           LOAD     = 7'b0000011,
           STORE    = 7'b0100011,
           OP_IMM   = 7'b0010011,
           OP       = 7'b0110011,
           SYSTEM   = 7'b1110011
 } opcode_t;
        
typedef struct packed{
    opcode_t opcode;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;
    logic rs1_used;
    logic rs2_used;
    logic rd_used;
    logic [3:0] alu_fun;
    logic memWrite;
    logic memRead2;
    logic regWrite;
    logic [1:0] rf_wr_sel;
    logic [2:0] mem_type;  //sign, size
    logic [31:0] pc;
} instr_t;

module OTTER_MCU(input CLK,
                input INTR,
                input RESET,
                input [31:0] IOBUS_IN,
                output [31:0] IOBUS_OUT,
                output [31:0] IOBUS_ADDR,
                output logic IOBUS_WR 
);           
    wire [6:0] opcode;
    wire [31:0] pc, pc_value, next_pc, jalr_pc, branch_pc, jump_pc, int_pc,A,B,
        I_immed,S_immed,U_immed,aluBin,aluAin,aluResult,rfIn,csr_reg, mem_data;
    
    wire [31:0] IR;
    wire memRead1,memRead2;
    
    wire pcWrite,regWrite,memWrite, op1_sel,mem_op,IorD,pcWriteCond,memRead;
    wire [1:0] opB_sel, rf_sel, wb_sel, mSize;
    logic [1:0] pc_sel;
    wire [3:0]alu_fun;
    wire opA_sel;
    
    logic br_lt,br_eq,br_ltu;
    
//==== Control Unit Wires ===========================================
    logic PCSrcE;
    logic RegWriteW;
              
//==== Instruction Fetch ===========================================
    
    logic [31:0] RD, PCF, PCPlus4F, PCFPrime;
    
    TwoByOneMux IFMux(PCPlus4F, PCTargetE, PCSrcE, PCFPrime);
    
    // Program Counter
    always_ff @(posedge CLK) begin
            PCF <= PCFPrime; // should these be switched?
    end
    
    assign pcWrite = 1'b1; 	//Hardwired high, assuming now hazards
    assign memRead1 = 1'b1; 	//Fetch new instruction every cycle
    
    // Instruction Memory
    INSTMEM instructionMemory(PCF, RD);
    
    // ADDER
    logic [2:0] hardcoded4;
    assign hardcoded4 = 3'b100;
    
    ADDER ifAdder(PCF, hardcoded4, PCPlus4F);
    
    // Pipeline Reg
    
    logic [31:0] InstrD, PCD, PCPlus4D; // Pipeline reg outputs.
    
    IF_ID_PipeReg IFIDReg(CLK, RD, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);

     
//==== Instruction Decode ===========================================
    logic [31:0] de_ex_opA;
    logic [31:0] de_ex_opB;
    logic [31:0] de_ex_rs2;
    
    logic [31:0] RD1D;
    logic [31:0] RD2D;

    instr_t de_ex_inst, de_inst;
    
    opcode_t OPCODE;
    assign OPCODE_t = opcode_t'(opcode);
    
    assign de_inst.rs1_addr=InstrD[19:15];
    assign de_inst.rs2_addr=InstrD[24:20];
    assign de_inst.rd_addr=InstrD[11:7];
    assign de_inst.opcode=OPCODE;
   
//    assign de_inst.rs1_used=    de_inst.rs1 != 0
//                                && de_inst.opcode != LUI
//                                && de_inst.opcode != AUIPC
//                                && de_inst.opcode != JAL;

    REG_FILE registerFile(de_inst.rs1_addr, de_inst.rs2_addr, RegWriteW, RdW, 
                            ResultW, CLK, RD1D, RD2D);
     
    
    // Extend
    logic [31:7] InstrDExt;
    logic [1:0] ImmSrcD;
    logic [31:0] ImmExtD;
    
    assign InstrDExt = InstrD[31:7];
    
    EXTEND extend(InstrDExt, ImmSrcD, ImmExtD);
    
    // ID_EX_REG
    logic [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    logic [11:7] RdE;
    
    ID_EX_PipeReg IDEXReg(CLK, RD1D, RD2D, PCD, de_inst.rd_addr, ImmExtD, PCPlus4D, 
               RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E);
	
////==== Execute ======================================================
//     logic [31:0] ex_mem_rs2;
//     logic ex_mem_aluRes = 0;
//     instr_t ex_mem_inst;
//     logic [31:0] opA_forwarded;
//     logic [31:0] opB_forwarded;
        logic [31:0] PCTargetE, ALUResultE, SrcBE, WriteDataE;
        logic [2:0] ALUControlE;
        logic ALUSrcE, ZeroE;
        
        assign WriteDataE = RD2E;
        
        // Mux
        TwoByOneMux EXMux(RD2E, ImmExtE, ALUSrcE, SrcBE); 
     
        // Creates a RISC-V ALU
        OTTER_ALU ALU(RD1E, SrcBE, ALUControlE, ALUResultE, ZeroE); // the ALU
        
        // Adder
        ADDER exAdder(PCE, ImmExtE, PCTargetE);
        
        // EX_Mem_Reg
        logic [31:0] ALUResultM, WriteDataM, PCPlus4M;
        logic [11:7] RdM;
        
        EX_M_PipeReg EXMReg(CLK, ALUResultE, WriteDataE, RdE, PCPlus4E, ALUResultM, 
                        WriteDataM, RdM, PCPlus4M);

////==== Memory ======================================================
    
//    assign IOBUS_ADDR = ex_mem_aluRes;
//    assign IOBUS_OUT = ex_mem_rs2;
    logic MemWriteM;
    logic [31:0] ReadDataM;
    
    DATAMEM dataMemory(CLK, MemWriteM, ALUResultM, WriteDataM, ReadDataM);
 
    // M Pipeline Reg
    logic [31:0] ALUResultW, ReadDataW, PCPlus4W;
    
    M_W_PipeReg MWReg(CLK, ALUResultM, ReadDataM, RdM, PCPlus4M, ALUResultW, 
        ReadDataW, RdW, PCPlus4W);
     
////==== Write Back ==================================================
     
    logic [11:7] RdW;
    logic [31:0] ResultW;
    logic [1:0] ResultSrcW;
 
    ThreeByOneMux WMux(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);
            
endmodule
