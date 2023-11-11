// Main decoder module
module maindec (
    input logic [10 : 0] Op,
    input logic reset,
    ExtIRQ,
    output logic Reg2Loc,
    MemtoReg,
    RegWrite,
    MemRead,
    MemWrite,
    Branch,
    NotAnInstr,
    ERet,
    output logic [1 : 0] ALUSrc,
    ALUOp,
    output logic [3 : 0] EStatus
);

  always_comb begin
    if (reset)
      {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0;
    else begin
      casez (Op)
        11'b111_1100_0010:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0011110000000000; // LDUR
        11'b111_1100_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b1010001000000000; // STUR
        11'b101_1010_0???:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b1000000101000000; // CBZ
        11'b100_0101_1000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000100010000000; // ADD
        11'b110_0101_1000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000100010000000; // SUB
        11'b100_0101_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000100010000000; // AND
        11'b101_0101_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000100010000000; // ORR
        11'b110_1011_0000:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b1000000101000000; // BR
        11'b110_1011_0100:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000000101010000; // ERET
        11'b110_1010_1001:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b1100100001000000; // MRS
        default:
        {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, NotAnInstr, ERet, EStatus} = 16'b0000000000100010; // Invalid Opcode
      endcase
    end

    if (ExtIRQ) EStatus = 4'b0001;
  end

endmodule
