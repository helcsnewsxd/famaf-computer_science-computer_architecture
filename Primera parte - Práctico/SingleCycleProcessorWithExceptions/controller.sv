// CONTROLLER

module controller (
    input logic [10:0] instr,
    input logic reset,
    ExtIRQ,
    ExcAck,
    output logic [1:0] AluSrc,
    output logic [3:0] AluControl,
    EStatus,
    output logic reg2loc,
    regWrite,
    Branch,
    memtoReg,
    memRead,
    memWrite,
    ExtIAck,
    ERet,
    Exc
);

  logic [1:0] AluOp_s;
  logic NotAnInstr;

  maindec decPpal (
      .Op(instr),
      .Reg2Loc(reg2loc),
      .ALUSrc(AluSrc),
      .MemtoReg(memtoReg),
      .RegWrite(regWrite),
      .MemRead(memRead),
      .MemWrite(memWrite),
      .Branch(Branch),
      .ALUOp(AluOp_s),
      .reset(reset),
      .ExtIRQ(ExtIRQ),
      .NotAnInstr(NotAnInstr),
      .EStatus(EStatus),
      .ERet(ERet)
  );


  aludec decAlu (
      .funct(instr),
      .aluop(AluOp_s),
      .alucontrol(AluControl)
  );

  assign Exc = ExtIRQ | NotAnInstr;
  assign ExtIAck = ExcAck && ExtIRQ;

endmodule
