// Registers module
module regfile_tb
	();
	
	// Parameters
	parameter CNT_TESTS = 64; // cnt of tests
	
	// Test bench variables
	logic clk, reset_tb;
	logic [63 : 0] rd1_expected, rd2_expected, wd3_auxiliar;
	
	int test_number, cnt_errors;
	logic [207 : 0] test [0 : CNT_TESTS-1];
		// {{we3}, {ra1}, {ra2}, {wa3}, {wd3}, {rd1_expected}, {rd2_expected}}
	
	// Module connections
	logic we3;
	logic [4 : 0] ra1, ra2, wa3;
	logic [63 : 0] wd3, rd1, rd2;

	regfile dut
		(
			.clk(clk),
			.we3(we3),
			.ra1(ra1),
			.ra2(ra2),
			.wa3(wa3),
			.wd3(wd3),
			.rd1(rd1),
			.rd2(rd2)
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
		
		// test-check initialization
		for(int i = 0; i < 32; i++) begin
			wd3_auxiliar = {2{32'($urandom())}};
			test[i] = {{1'b0}, {3{5'(i)}}, {wd3_auxiliar}, {2{(i === 0 || i === 31 ? 64'd0 : 64'(i))}}};
		end
		
		// test-check writing
		for(int i = 0; i < 32; i++) begin
			wd3_auxiliar = {2{32'($urandom())}};
			test[i + 32] = {{1'b1}, {3{5'(i)}}, {wd3_auxiliar}, {2{(i !== 31 ? wd3_auxiliar : 64'b0)}}};
		end
		
		// First reset test bench creation
		reset_tb = 1; #27ns reset_tb = 0;
	end
	
	always @(negedge clk) begin
		// Check test executed on positive edge of clk
		if(~reset_tb) begin
			// Test writing (reading the written register)
			if(test_number >= 32)
				we3 = 1'b0;
		
			if({rd1, rd2} !== {rd1_expected, rd2_expected}) begin
				if(test_number < 32)
					$display("Error in initialization test number %d with input = { we3 = %b, ra1 = %d, ra2 = %d, wa3 = %d, wd3 = %d } and output = { rd1 = %d, rd2 = %d } --> The expected output was { rd1_expected = %d, rd2_expected = %d }", test_number, we3, ra1, ra2, wa3, wd3, rd1, rd2, rd1_expected, rd2_expected);
				else
					$display("Error in writing test number %d with input = { we3 = %b, ra1 = %d, ra2 = %d, wa3 = %d, wd3 = %d } and output = { rd1 = %d, rd2 = %d } --> The expected output was { rd1_expected = %d, rd2_expected = %d }", test_number, 1'b1, ra1, ra2, wa3, wd3, rd1, rd2, rd1_expected, rd2_expected);
				cnt_errors++;
			end
			test_number++;
			
			if(test_number === CNT_TESTS) begin
				$display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
				#5ns $stop;
			end
		end
		
		// Prepare next test to positive edge of clk
		#2ns {we3, ra1, ra2, wa3, wd3, rd1_expected, rd2_expected} = test[test_number]; #2ns;
	end
	
endmodule