// Registers test bench module
module regfile_tb
	();

	parameter CNT_TESTS = 64;
	
	logic clk, reset_tb;
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

	// init clock
	always begin
		clk = 1; #10ns;
		clk = 0; #10ns;
	end

	logic [207 : 0] test [0 : (CNT_TESTS-1)]; // {{we3}, {ra1}, {ra2}, {wa3}, {wd3}, {rd1_expected}, {rd2_expected}}
	logic [63 : 0] rd1_expected, rd2_expected, wd3_auxiliar;
	int test_number, cnt_errors;
	 
	initial begin
		// init tests
		test_number = 0;
		cnt_errors = 0;
		
		// test-check initialization
		for(int i = 0; i < 32; i++) begin
			wd3_auxiliar = {2{32'($urandom())}};
			test[i] = {{1'b0}, {5'(i)}, {5'(i)}, {5'(i)}, {wd3_auxiliar}, {2{(i === 0 || i === 31 ? 64'd0 : 64'(i))}}};
		end
		
		// test-check writing
		for(int i = 0; i < 32; i++) begin
			wd3_auxiliar = {2{32'($urandom())}};
			test[i + 32] = {{1'b1}, {5'(i)}, {5'(i)}, {5'(i)}, {wd3_auxiliar}, {2{(i !== 31 ? wd3_auxiliar : 64'b0)}}};
		end
		
		reset_tb = 1; #27ns reset_tb = 0;
	end
	 
	// apply tests on rising edge of clk
	always @(posedge clk)
		#1 {we3, ra1, ra2, wa3, wd3, rd1_expected, rd2_expected} = test[test_number];
	
	// check tests on falling edge of clk
	always @(negedge clk) begin
		if(~reset_tb) begin;				
			// check reading
			if(rd1 !== rd1_expected || rd2 !== rd2_expected) begin
				$display("Error in test number %d with input = { we3 = %b, ra1 = %d, ra2 = %d, wa3 = %d, wd3 = %d } and output = { rd1 = %d, rd2 = %d } --> The expected output was { rd1_expected = %d, rd2_expected = %d }", test_number, we3, ra1, ra2, wa3, wd3, rd1, rd2, rd1_expected, rd2_expected);
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