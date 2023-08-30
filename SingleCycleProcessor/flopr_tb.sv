// Async Flip-Flop D test bench
module flopr_tb
	();
	
	// Parameters
	parameter CNT_TESTS = 10; // cnt of tests
	parameter N = 64; // cnt bits of register
	
	// Test bench variables
	logic clk, reset_tb;
	logic [N-1 : 0] d_auxiliar, q_expected;
	
	int test_number, cnt_errors;
	logic [2*N : 0] test [0 : CNT_TESTS];
		// {{reset}, {d}, {q_expected}}
	
	// Module connections
	logic reset;
	logic [N-1 : 0] d, q;

	flopr #(N) dut
		(
			.clk(clk),
			.reset(reset),
			.d(d),
			.q(q)
		);

	// Clock generation with 10ns period
	always begin
		clk = 1; #5ns;
		clk = 0; #5ns;
	end
	
	initial begin
		// Init tests
		test_number = 0;
		cnt_errors = 0;
		
		for(int i = 0; i <= CNT_TESTS; i++) begin
			d_auxiliar = {2{32'($urandom())}};
			test[i] = {
				1'(i < CNT_TESTS/2),
				d_auxiliar,
				(i < CNT_TESTS/2 ? 64'b0 : d_auxiliar)
			};
		end
		
		// First reset test bench creation
		reset_tb = 1; #27ns reset_tb = 0;
	end
	
	always @(negedge clk) begin
		// Check test executed on positive edge of clk
		if(~reset_tb) begin;
			if(q !== q_expected) begin
				$display("Error in test number %d with input = { reset = %d, d = %d } and output = { q = %d } --> The expected output was { q_expected = %d }", test_number, reset, d, q, q_expected);
				cnt_errors++;
			end
			test_number++;
			
			if(test_number > CNT_TESTS) begin
				$display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
				#5ns $stop;
			end
		end
		
		// Prepare next test to positive edge of clk
		#2ns {reset, d, q_expected} = test[test_number]; #2ns;
	end
	
endmodule