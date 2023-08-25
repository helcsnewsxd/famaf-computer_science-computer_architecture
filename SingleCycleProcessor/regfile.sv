// Registers module
module regfile
(
	input logic clk, we3,
	input logic [4 : 0] ra1, ra2, wa3,
	input logic [63 : 0] wd3,
	output logic [63 : 0] rd1, rd2
);
	
	// registers array
	logic [63 : 0] X [0 : 31];

	initial begin
		// init registers
		X[31] = 0;
		for(int i = 0; i < 31; i++)
			X[i] = i;
	end
	
	// read (async)
	assign rd1 = (we3 && wa3 !== 31 ? wd3 : X[ra1]);
	assign rd2 = (we3 && wa3 !== 31 ? wd3 : X[ra2]);
	
	// write (sync)
	always @(posedge clk)
		if(we3 && wa3 !== 31)
			X[wa3] <= wd3;

endmodule