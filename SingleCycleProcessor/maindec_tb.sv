// Main decoder test bench module
module maindec_tb
	();

	parameter CNT_TESTS = 7;
	
	logic clk, reset_tb;
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

	// init clock
	always begin
		clk = 1; #10ns;
		clk = 0; #10ns;
	end

	logic [37 : 0] test [0 : (CNT_TESTS-1)]; // {{Op}, {flags_expected}}
	logic [8 : 0] flags_expected;
	int test_number, cnt_errors;
	 
	initial begin
		// init tests
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
		
		reset_tb = 1; #27ns reset_tb = 0;
	end
	 
	// apply tests on rising edge of clk
	always @(posedge clk) begin
		#1 {Op, flags_expected} = test[test_number];
	end
	
	// check tests on falling edge of clk
	always @(negedge clk) begin
		if(~reset_tb) begin;
			if({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} !== flags_expected) begin
				$display("Error in test number %d with input = { Op = %b } and output = { flags = %b } --> The expected output was { flags_expected= %b }", test_number, Op, {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp}, flags_expected);
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