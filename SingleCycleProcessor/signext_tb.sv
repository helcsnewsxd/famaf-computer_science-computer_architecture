// Immediate signed extension test bench module
module signext_tb
	();
	
	// Parameters
	parameter CNT_TESTS = 13; // cnt of tests
	
	// Test bench variables
	logic clk, reset_tb;
	logic [63 : 0] y_expected;
	
	int test_number, cnt_errors;
	logic [95 : 0] test [0 : CNT_TESTS-1];
		// {{a}, {y_expected}}
	
	// Module connections
	logic [31 : 0] a;
	logic [63 : 0] y;

	signext dut
		(
			.a(a),
			.y(y)
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
		
		test = 
			// {{instruction}, {expected_result}}
			'{
				// LDUR
				{{11'b111_1100_0010, 1'b0, 8'd251, 12'b0}, {{56{1'b0}}, 8'd251}}, // positive
				{{11'b111_1100_0010, 1'b1, 8'd251, 12'b0}, {{56{1'b1}}, 8'd251}}, // negative
				// STUR
				{{11'b111_1100_0000, 1'b0, 8'd251, 12'b0}, {{56{1'b0}}, 8'd251}}, // positive
				{{11'b111_1100_0000, 1'b1, 8'd251, 12'b0}, {{56{1'b1}}, 8'd251}}, // negative
				// CBZ
				{{8'b101_1010_0, 1'b0, 18'd262140, 5'b0}, {{44{1'b0}}, 18'd262140}, 2'b0}, // positive
				{{8'b101_1010_0, 1'b1, 18'd262140, 5'b0}, {{44{1'b1}}, 18'd262140}, 2'b0}, // negative
				// Other implemented opcodes
				{{11'b100_0101_1000, {21{1'b1}}}, {64'b0}}, // ADD
				{{11'b110_0101_1000, {21{1'b1}}}, {64'b0}}, // SUB
				{{11'b100_0101_0000, {21{1'b1}}}, {64'b0}}, // AND
				{{11'b101_0101_0000, {21{1'b1}}}, {64'b0}}, // OR
				// Not implemented opcodes
				{{11'b100_1101_1000, {21{1'b1}}}, {64'b0}}, // MUL
				{{9'b111_1001_01, {23{1'b1}}}, {64'b0}}, // MOVK
				{{11'b110_0101_0000, {21{1'b1}}}, {64'b0}} // EOR
			};
		
		// First reset test bench creation
		reset_tb = 1; #27ns reset_tb = 0;
	end
	
	always @(negedge clk) begin
		// Check test executed on positive edge of clk
		if(~reset_tb) begin
			if(y !== y_expected) begin
				$display("Error in test number %d with input = { a = %d } and output = { y = %d } --> The expected output was { y_expected = %d }", test_number, a, y, y_expected);
				cnt_errors++;
			end
			test_number++;
			
			if(test_number === CNT_TESTS) begin
				$display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
				#5ns $stop;
			end
		end
		
		// Prepare next test to positive edge of clk
		#2ns {a, y_expected} = test[test_number]; #2ns;
	end
	
endmodule