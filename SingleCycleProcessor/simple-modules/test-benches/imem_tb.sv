// ROM module
module imem_tb ();

  // Parameters
  parameter CNT_TESTS = 50;  // cnt of tests
  parameter N = 32;

  // Test bench variables
  logic clk, reset_tb;
  logic [31 : 0] initROM[0 : 63];
  logic [31 : 0] q_expected;

  int test_number, cnt_errors;
  logic [37 : 0] test [0 : CNT_TESTS-1];
  // {{addr}, {q_expected}}

  // Module connections
  logic [ 5 : 0] addr;
  logic [31 : 0] q;

  imem #(N) dut (
      .addr(addr),
      .q(q)
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

    initROM[0 : 46] = '{
        32'hf8000001,
        32'hf8008002,
        32'hf8000203,
        32'h8b050083,
        32'hf8018003,
        32'hcb050083,
        32'hf8020003,
        32'hcb0a03e4,
        32'hf8028004,
        32'h8b040064,
        32'hf8030004,
        32'hcb030025,
        32'hf8038005,
        32'h8a1f0145,
        32'hf8040005,
        32'h8a030145,
        32'hf8048005,
        32'h8a140294,
        32'hf8050014,
        32'haa1f0166,
        32'hf8058006,
        32'haa030166,
        32'hf8060006,
        32'hf840000c,
        32'h8b1f0187,
        32'hf8068007,
        32'hf807000c,
        32'h8b0e01bf,
        32'hf807801f,
        32'hb4000040,
        32'hf8080015,
        32'hf8088015,
        32'h8b0103e2,
        32'hcb010042,
        32'h8b0103f8,
        32'hf8090018,
        32'h8b080000,
        32'hb4ffff82,
        32'hf809001e,
        32'h8b1e03de,
        32'hcb1503f5,
        32'h8b1403de,
        32'hf85f83d9,
        32'h8b1e03de,
        32'h8b1003de,
        32'hf81f83d9,
        32'hb400001f
    };

    for (int i = 47; i < 64; i++) initROM[i] = '0;

    for (logic [5 : 0] i = 0; i < CNT_TESTS; i++) test[i] = {i, initROM[i]};

    // First reset test bench creation
    reset_tb = 1;
    #27ns reset_tb = 0;
  end

  always @(negedge clk) begin
    // Check test executed on positive edge of clk
    if (~reset_tb) begin
      if (q !== q_expected) begin
        $display("Error in test number %d with \
			input = { addr = %d } and \
			output = { q = %h } --> \
			The expected output was { q_expected = %h }\
			", test_number, addr, q, q_expected);
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
    {addr, q_expected} = test[test_number];
    #2ns;
  end

endmodule
