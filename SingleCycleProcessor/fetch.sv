// Fetch module
module fetch
(
	input logic PCSrc_F, clk, reset,
	input logic [63 : 0] PCBranch_F,
	output logic [63 : 0] imem_addr_F
);
	
	logic [63 : 0] d_internal, next_instruction_internal;

	mux2 #(64) MUX
		(
			.d0(next_instruction_internal),
			.d1(PCBranch_F),
			.s(PCSrc_F),
			.y(d_internal)
		);
	
	flopr PC
		(
			.clk(clk),
			.reset(reset),
			.d(d_internal),
			.q(imem_addr_F)
		);
	
	adder #(64) Add
		(
			.a(imem_addr_F),
			.b(64'd4),
			.y(next_instruction_internal)
		);

endmodule