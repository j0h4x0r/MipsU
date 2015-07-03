module Regfile (Read1, Read2, WriteReg, WriteData, RegWrite, Data1, Data2, Clk, LLbitin, LLbitout);
	input [4:0] Read1, Read2, WriteReg;
	input [31:0] WriteData;
	input RegWrite, Clk, LLbitin;
	output [31:0] Data1, Data2;
	output reg LLbitout;
	reg [31:0] RF [31:0];
	assign Data1 = RF[Read1];
	assign Data2 = RF[Read2];
	always @(posedge Clk)
	begin
		if (RegWrite) RF[WriteReg] <= WriteData;
		if (LLbitin) LLbitout <= 1;
	end
endmodule 