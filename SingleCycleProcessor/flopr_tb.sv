// Asinc Flip-Flop D test bench
module flopr_tb
	();
	
	parameter N = 64; // cnt bits of register
	parameter R = 5; // first reset interval
	parameter CNT_TESTS = 11; // test 10 cases because the first thing into the flip flop is trash
	
	logic clk, reset, reset_tb;
	logic [(N-1) : 0] d, q;

	flopr #(N) dut
		(
			.clk(clk),
			.reset(reset),
			.d(d),
			.q(q)
		);

	// init clock
	always begin
		clk = 1; #10;
		clk = 0; #10;
	end

	logic [N : 0] test [0 : (CNT_TESTS-1)];
	logic [(N-1) : 0] q_expected [0 : (CNT_TESTS-1)];
	int test_number, cnt_errors;
	 
	initial begin
		// init tests
		test_number = 0;
		cnt_errors = 0;
		for(int i = 0; i < CNT_TESTS; i++) begin
			test[i][N] = (i < R ? 1 : 0);
			test[i][(N-1) : 0] = (i ? test[i - 1][(N-1) : 0] - 1 : (1 << N) - 1);
		end
		q_expected[0] = 0; // is trash
		for(int i = 1; i <= CNT_TESTS; i++)
			q_expected[i] = (test[i-1][N] ? 0 : test[i-1][(N-1) : 0]);
		
		reset_tb = 1; #27 reset_tb = 0;
	end
	 
	// apply tests on rising edge of clk
	always @(posedge clk) begin
		#1 {reset, d} = test[test_number];
	end
	
	// check tests on falling edge of clk
	always @(negedge clk) begin
		if(~reset_tb) begin;
			if(q !== q_expected[test_number]) begin
				$display("Error with input = { reset = %b, d = %b } and output = { q = %b } --> The expected output was { q_expected = %b}", reset, d, q, q_expected[test_number]);
				cnt_errors++;
			end
			test_number++;
			if(test_number === CNT_TESTS) begin
				$display("%d tests completed with %d errors", test_number, cnt_errors);
				$stop;
			end
		end
	end
	
endmodule