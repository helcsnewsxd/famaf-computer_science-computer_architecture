// Main decoder test bench module
module maindec_tb
	();

	// Parameters
	parameter CNT_TESTS = 7; // cnt of tests
	
	// Test bench variables
	logic clk, reset_tb;
	logic [8 : 0] flags_expected;
	
	int test_number, cnt_errors;
	logic [37 : 0] test [0 : CNT_TESTS-1];
		// {{Op}, {flags_expected}}
	
	// Module connections
	logic [10 : 0] Op;
	logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	logic [1 : 0] ALUOp;

	maindec dut
		(
			.Op(Op),
			.Reg2Loc(Reg2Loc),
			.ALUSrc(ALUSrc),
			.MemtoReg(MemtoReg),
			.RegWrite(RegWrite),
			.MemRead(MemRead),
			.MemWrite(MemWrite),
			.Branch(Branch),
			.ALUOp(ALUOp)
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
			'{
				{{11'b111_1100_0010}, {9'b011110000}},
				{{11'b111_1100_0000}, {9'b110001000}},
				{{11'b101_1010_0000}, {9'b100000101}},
				{{11'b100_0101_1000}, {9'b000100010}},
				{{11'b110_0101_1000}, {9'b000100010}},
				{{11'b100_0101_0000}, {9'b000100010}},
				{{11'b101_0101_0000}, {9'b000100010}}
			};
		
		// First reset test bench creation
		reset_tb = 1; #27ns reset_tb = 0;
	end
	
	always @(negedge clk) begin
		// Check test executed on positive edge of clk
		if(~reset_tb) begin
			if({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== flags_expected) begin
				$display("Error in test number %d with input = { Op = %b } and output = { flags = %b } --> The expected output was { flags_expected= %b }", test_number, Op, {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp}, flags_expected);
				cnt_errors++;
			end
			test_number++;
			
			if(test_number === CNT_TESTS) begin
				$display("%d tests completed with %d errors", CNT_TESTS, cnt_errors);
				#5ns $stop;
			end
		end
		
		// Prepare next test to positive edge of clk
		#2ns {Op, flags_expected} = test[test_number]; #2ns;
	end
	
endmodule