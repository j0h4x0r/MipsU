module expand1_32(in ,out);
	input in;
	output [31:0] out;
	assign out = 32'b0 + in;
endmodule 