module J(IR,PC,out);
	input [25:0] IR;
	input [31:28] PC;
	output [31:0] out;
	assign out = {PC[31:28],IR[25:0],2'b00};
endmodule 