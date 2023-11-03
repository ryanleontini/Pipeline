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
    
    logic RegWriteD;
    logic [1:0] ResultSrcD;
    logic MemWriteD;
    logic JumpD;
    logic BranchD;
    logic [2:0] ALUControlD;
    logic ALUSrcD;
    logic [1:0] ImmSrcD;
    
    logic PCSrcE;
    logic RegWriteE;
    logic [1:0] ResultSrcE;
    logic MemWriteE;
    logic JumpE;
    logic BranchE;
    logic [2:0] ALUControlE;
    logic ALUSrcE;
    
    logic RegWriteM;
    logic [1:0] ResultSrcM;
    logic MemWriteM;
    
    logic RegWriteW;
    logic [1:0] ResultSrcW;
    
              
//==== Instruction Fetch ===========================================
    
    logic [31:0] RD, PCF, PCPlus4F, PCFPrime;
    
    TwoByOneMux IFMux(PCPlus4F, PCTargetE, PCSrcE, PCFPrime);
    
    logic StallFFlipped;
    // Basically, if a stall is not being signalled, run the pipe reg.
    assign StallFFlipped = ~StallF;
    
    // Program Counter
    flopReset flopr(.clk(CLK), .reset(RESET), .d(PCFPrime), .q(PCF), .StallFFlipped(StallFFlipped));
    
    assign pcWrite = 1'b1; 	//Hardwired high, assuming now hazards
    assign memRead1 = 1'b1; 	//Fetch new instruction every cycle
    
    // Instruction Memory
    INSTMEM instructionMemory(PCF, RD);
    
    // ADDER
    logic [31:0] hardcoded4;
    assign hardcoded4 = 32'd4;
    
    ADDER ifAdder(PCF, hardcoded4, PCPlus4F);
    
    // Pipeline Reg
    
    logic [31:0] InstrD, PCD, PCPlus4D; // Pipeline reg outputs.
    
    // Stalling
    logic StallDFlipped;
    // Basically, if a stall is not being signalled, run the pipe reg.
    assign StallDFlipped = ~StallD;
    
    IF_ID_PipeReg IFIDReg(CLK, RD, PCF, PCPlus4F, InstrD, PCD, PCPlus4D, StallDFlipped);

     
//==== Instruction Decode ===========================================
    
    logic [31:0] RD1D;
    logic [31:0] RD2D;

    instr_t de_ex_inst, de_inst;
    
    opcode_t OPCODE;
    assign OPCODE_t = opcode_t'(opcode);
    
    logic [4:0] RdD, RS1A1, RS2A2, RDA3;
    assign RdD = InstrD[11:7];
    assign RS1A1 = InstrD[19:15];
    assign RS2A2 = InstrD[24:20];
    assign RDA3 = InstrD[11:7];
    assign de_inst.opcode=OPCODE;
    
    logic [4:0] Rs1D, Rs2D;
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];

    REG_FILE registerFile(RS1A1, RS2A2, RegWriteW, RdW, 
                            ResultW, CLK, RD1D, RD2D);
     
    
    // Extend
    logic [31:7] InstrDExt;
    //logic [1:0] ImmSrcD;
    logic [31:0] ImmExtD;
    
    assign InstrDExt = InstrD[31:7];
    
    EXTEND extend(InstrDExt, ImmSrcD, ImmExtD);
    
    logic [6:0] op;
    logic [2:0] funct3;
    logic funct7;
    logic [1:0] ALUop;
    
    assign op = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];
        
    // ControlUnit
    ControlUnit MainDecoder(op, RegWriteD, ResultSrcD,MemWriteD, JumpD, BranchD, ALUop,ALUSrcD,ImmSrcD);
        
   // ALU Decoder
    ALUDecoder AluDecoder(funct3, funct7, op5, ALUop, ALUControlD);
    
    // ID_EX_REG
    logic [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    logic [11:7] RdE;
    logic [4:0] Rs1E, Rs2E;
    
    ID_EX_PipeReg IDEXReg(CLK, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD,
                        RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE,
                        RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D, 
                        RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E, FlushE);
	
////==== Execute ======================================================
//     logic [31:0] ex_mem_rs2;
//     logic ex_mem_aluRes = 0;
//     instr_t ex_mem_inst;
//     logic [31:0] opA_forwarded;
//     logic [31:0] opB_forwarded;
        logic [31:0] PCTargetE, ALUResultE, SrcBE, WriteDataE;
        //logic [2:0] ALUControlE;
//        logic ALUSrcE, ZeroE;
        logic ZeroE;
        
        // No longer needed after BEMux.
//        assign WriteDataE = RD2E;
        
        ThreeByOneMux AEMux(RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
        ThreeByOneMux BEMux(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
        
        // Mux
        TwoByOneMux EXMux(RD2E, ImmExtE, ALUSrcE, SrcBE); 
     
        // Creates a RISC-V ALU
        OTTER_ALU ALU(RD1E, SrcBE, ALUControlE, ALUResultE, ZeroE); // the ALU
        
        // Adder
        ADDER exAdder(PCE, ImmExtE, PCTargetE);
        
        
        
        // EX_Mem_Reg
        logic [31:0] ALUResultM, WriteDataM, PCPlus4M;
        logic [11:7] RdM;
        
        EX_M_PipeReg EXMReg(CLK, RegWriteE, ResultSrcE, MemWriteE, 
                        RegWriteM, ResultSrcM, MemWriteM,
                        ALUResultE, WriteDataE, RdE, PCPlus4E, ALUResultM,
                        WriteDataM, RdM, PCPlus4M);

////==== Memory ======================================================
    
//    assign IOBUS_ADDR = ex_mem_aluRes;
//    assign IOBUS_OUT = ex_mem_rs2;
    //logic MemWriteM;
    logic [31:0] ReadDataM;
    
    DATAMEM dataMemory(CLK, MemWriteM, ALUResultM, WriteDataM, ReadDataM);
 
    // M Pipeline Reg
    logic [31:0] ALUResultW, ReadDataW, PCPlus4W;
    
    assign PCSrcE = JumpE | (BranchE & ZeroE);
    
    M_W_PipeReg MWReg(CLK, RegWriteM, ResultSrcM,RegWriteW, ResultSrcW,
                        ALUResultM, ReadDataM, RdM, PCPlus4M, ALUResultW, 
                        ReadDataW, RdW, PCPlus4W);
     
////==== Write Back ==================================================
     
    logic [11:7] RdW;
    logic [31:0] ResultW;
 
    ThreeByOneMux WMux(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);
    
////==== Hazard Unit ==================================================
    
    logic [1:0] ForwardAE, ForwardBE;
    
    HazardUnit hazard_unit(Rs1E, Rs2E, ForwardAE, ForwardBE, 
                            RdM, RegWriteM, RdW, RegWriteW, StallF, StallD,
                            Rs1D, Rs2D, FlushE, RdE, ResultSrcE_MSB);
                            
////==== Stalling ==================================================
    logic StallF, StallD, FlushE, ResultSrcE_MSB;   
    assign ResultSrcE_MSB = ResultSrcE[0];                   
            
endmodule
