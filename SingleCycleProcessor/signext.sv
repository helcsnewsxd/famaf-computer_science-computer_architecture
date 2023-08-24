// Immediate signed extension module
module signext
(
	input logic [31 : 0] a,
	output logic [63 : 0] y
);

	always_comb begin
		casez (a[31 : 21])
			11'b111_1100_00?0 : y = {{55{a[20 : 20]}}, a[20 : 12]}; // STUR, LDUR
			11'b101_1010_0??? : y = {{43{a[23 : 23]}}, a[23 : 5], 2'b0}; // CBZ
			default: y = 64'b0;
		endcase
	end

endmodule
	