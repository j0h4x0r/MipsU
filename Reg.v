module Reg(Clk, Data, Data_out);
	input Clk;
	input[31:0] Data;
	output[31:0] Data_out;
	reg[31:0] Data_out;
	always
	begin
		Data_out = Data;
	end
endmodule 