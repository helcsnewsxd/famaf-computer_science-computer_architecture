// Fetch module
module fetch_tb
	();

	// Parameters
	parameter CNT_TESTS = 10; // cnt of tests
	
	// Test bench variables
	logic clk, reset_tb;
	logic [63 : 0] PCBranch_F_auxiliar, PCCounter_auxiliar, imem_addr_F_expected;
	
	int test_number, cnt_errors;
	logic [129 : 0] test [0 : CNT_TESTS-1];
		// {{PCSrc_F}, {reset}, {PCBranch_F}, {imem_addr_F_expected}}
	
	// Module connections
	logic PCSrc_F, reset;
	logic [63 : 0] PCBranch_F, imem_addr_F;

	fetch dut
		(
			.PCSrc_F(PCSrc_F),
			.clk(clk),
			.reset(reset),
			.PCBranch_F(PCBranch_F),
			.imem_addr_F(imem_addr_F)
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
		
		PCBranch_F_auxiliar = {2{32'($urandom())}};
		PCCounter_auxiliar = 64'b0;
		for(int i = 0; i < CNT_TESTS; i++) begin
			if(i < 5)
				test[i] = {{1'b0}, {1'b1}, {PCBranch_F_auxiliar}, {PCCounter_auxiliar}};
			else if(i != CNT_TESTS) begin
				PCCounter_auxiliar += 4;
				test[i] = {{1'b0}, {1'b0}, {PCBranch_F_auxiliar}, {PCCounter_auxiliar}};
			end
			else test[i] = {{1'b1}, {1'b0}, {PCBranch_F_auxiliar}, {PCBranch_F_auxiliar}};
		end
		
		// First reset test bench creation
		reset_tb = 1; #27ns reset_tb = 0;
	end
	
	always @(negedge clk) begin
		// Check test executed on positive edge of clk
		if(~reset_tb) begin
			if(imem_addr_F !== imem_addr_F_expected) begin
				$display("Error in test number %d with input = { PCSrc_F = %b, clk = %b, reset = %b, PCBranch_F = %d } and output = { imem_addr_F = %d } --> The expected output was { imem_addr_F_expected = %d }", test_number, PCSrc_F, clk, reset, PCBranch_F, imem_addr_F, imem_addr_F_expected);
				cnt_errors++;
			end
			test_number++;
			
			if(test_number === CNT_TESTS) begin
				$display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
				#5ns $stop;
			end
		end
		
		// Prepare next test to positive edge of clk
		#2ns {PCSrc_F, reset, PCBranch_F, imem_addr_F_expected} = test[test_number]; #2ns;
	end
	
endmodule