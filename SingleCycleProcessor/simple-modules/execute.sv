// Execute module
module execute (
    input logic AluSrc,
    input logic [3 : 0] AluControl,
    input logic [63 : 0] PC_E,
    signImm_E,
    readData1_E,
    readData2_E,
    output logic [63 : 0] PCBranch_E,
    aluResult_E,
    writeData_E,
    output logic zero_E
);

  logic [63 : 0] y0_internal, y1_internal;

  sl2 #(64) Shif_left_2 (
      .a(signImm_E),
      .y(y0_internal)
  );

  adder #(64) Add (
      .a(PC_E),
      .b(y0_internal),
      .y(PCBranch_E)
  );

  mux2 #(64) MUX (
      .d0(readData2_E),
      .d1(signImm_E),
      .s (AluSrc),
      .y (y1_internal)
  );

  alu ALU (
      .a(readData1_E),
      .b(y1_internal),
      .ALUControl(AluControl),
      .result(aluResult_E),
      .zero(zero_E)
  );

  assign writeData_E = readData2_E;

endmodule
