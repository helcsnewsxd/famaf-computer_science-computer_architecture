// Execute test bench module
module execute_tb ();

  // Parameters
  parameter CNT_TESTS = 10;  // cnt of tests

  // Test bench variables
  logic clk, reset_tb;
  logic [63 : 0] PCBranch_E_expected, aluResult_E_expected, writeData_E_expected;
  logic zero_E_expected;

  int test_number, cnt_errors;
  logic [453 : 0] test[0 : CNT_TESTS-1];
  // {{AluSrc}, {AluControl}, {PC_E}, {signImm_E}, {readData1_E}, {readData2_E}, {PCBranch_E_expected}, {aluResult_E_expected}, {writeData_E_expected}, {zero_E_expected}}

  // Module connections
  logic AluSrc, zero_E;
  logic [3 : 0] AluControl;
  logic [63 : 0] PC_E, signImm_E, readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E;

  execute dut (
      .AluSrc(AluSrc),
      .AluControl(AluControl),
      .PC_E(PC_E),
      .signImm_E(signImm_E),
      .readData1_E(readData1_E),
      .readData2_E(readData2_E),
      .PCBranch_E(PCBranch_E),
      .aluResult_E(aluResult_E),
      .writeData_E(writeData_E),
      .zero_E(zero_E)
  );

  // Clock generation with 10ns period
  always begin
    clk = 1;
    #5ns;
    clk = 0;
    #5ns;
  end

  initial begin
    // Init tests
    test_number = 0;
    cnt_errors = 0;



    // First reset test bench creation
    reset_tb = 1;
    #27ns reset_tb = 0;
  end

  always @(negedge clk) begin
    // Check test executed on positive edge of clk
    if (~reset_tb) begin
      if({PCBranch_E, aluResult_E, writeData_E, zero_E} !== {PCBranch_E_expected, aluResult_E_expected, writeData_E_expected, zero_E_expected}) begin
        $display("Error in test number %d with \
            input = { AluSrc = %d, AluControl = %d, PC_E = %d, signImm_E = %d, readData1_E = %d, readData2_E = %d } and \
            output = { PCBranch_E = %d, aluResult_E = %d, writeData_E = %d, zero_E = %d } --> \
            The expected output was { PCBranch_E_expected = %d, aluResult_E_expected = %d, writeData_E_expected = %d, zero_E_expected = %d }\
            ", test_number, AluSrc, AluControl, PC_E, signImm_E,
                 readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E, zero_E,
                 PCBranch_E_expected, aluResult_E_expected, writeData_E_expected, zero_E_expected);
        cnt_errors++;
      end
      test_number++;

      if (test_number === CNT_TESTS) begin
        $display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
        #5ns $stop;
      end
    end

    // Prepare next test to positive edge of clk
    #2ns;
    {AluSrc, AluControl, PC_E, signImm_E, readData1_E, readData2_E, PCBranch_E_expected, aluResult_E_expected, writeData_E_expected, zero_E_expected} = test[test_number];
    #2ns;
  end

endmodule
