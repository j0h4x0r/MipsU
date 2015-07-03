`define MUL_MUL 2'b00
`define MUL_SEL_HIGH 'b1
`define MUL_SEL_LOW 'b0
module Mul(MUL_Flag, Reset, MUL_DA, MUL_DB, Clk, MUL_DC, MUL_SelHL, MUL_Start, MUL_SelMD, MUL_Write);
	input Clk;
	input Reset;
	input MUL_Start;
	input MUL_SelHL;
	input [1:0] MUL_SelMD;
	input MUL_Write;
	output MUL_Flag;
	input [31:0] MUL_DB;
	input [31:0] MUL_DA;
	output [31:0] MUL_DC;
	reg [31:0] hi;
	reg [31:0] lo;
	reg working;
	reg [63:0] result;
	reg finish;
//	reg finish2;
	function[63:0] result_mul;
		input[31:0] a,b;
		begin
			result_mul = a * b;
		end
	endfunction
	function[63:0] result_div;
		input[31:0] a,b;
		begin
			result_div[31:0]=a/b;
			result_div[62:32]=a%b;
		end
	endfunction
	
	assign MUL_Flag = finish;
	assign MUL_DC = finish ? (MUL_SelHL == `MUL_SEL_HIGH ? hi : lo) : 32'b0;
	always @(posedge Clk)
	begin
		if(Reset)
		begin
			working <= 1'b0;
			finish <= 1'b0;
		end
		else if(MUL_Start)
		begin
			finish <= 1'b0;
			working <= 1'b1;
			if(MUL_SelMD==2'b00)
				result <= result_mul(MUL_DA,MUL_DB);
			else if(MUL_SelMD==2'b01)
				result <= result_div(MUL_DA,MUL_DB);
			finish <= 1'b1;
			working <= 1'b0;
		end
	end
	always @(posedge Clk)
	begin
		if(Reset)
		begin
			hi <= 32'b0;
			lo <= 32'b0;
		end
		else if(MUL_Write)
		begin
			if(MUL_SelHL == `MUL_SEL_HIGH)
				hi <= MUL_DB;
			else
				lo <= MUL_DB;
		end
		else if(finish)
		begin
			hi <= result[63:32];
			lo <= result[31:0];
		end
	end
endmodule
