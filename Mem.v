module Mem(Clk,CS,BE,RW,Addr,DataIn,Reset,DataOut,DataReady,MemSign);
	input Clk;
	input CS,MemSign;
	input [3:0] BE;
	input RW;
	input [31:0] Addr;
	input [31:0] DataIn;
	input Reset;
	output [31:0] DataOut;
	output DataReady;
	reg [31:0] memory[31:0];
	reg [31:0] DataOut;
	assign DataReady=1;
	wire s;
	assign s=(BE[3:0]==4'b0111)?memory[Addr[6:2]][15]:
			((BE[3:0]==4'b0011)?memory[Addr[6:2]][7]:1'b0);
	always @(negedge Clk or posedge Reset)
	begin
		if(Reset)
		begin
			//data1:5 data2:2
			memory[0]<=32'b00000000000000000000000000000101;
			memory[1]<=32'b00000000000000000000000000000010;
			//lui $t0,16'hBFC0
			memory[2]<=32'b00100000000010001011111111000000;
			//lw $s0,0($t0)
			memory[3]<=32'b10010001000100000000000000000000;
			//lw $s1,4($t0)
			memory[4]<=32'b10010001000100010000000000000100;
			//subu $t1,$s0,$s1
			memory[5]<=32'b00000010000100010100100000000011;
			//bgtz $t1,2
			memory[6]<=32'b11001001001000000000000000000010;
			//addu $s0,$s1,$zero
			memory[7]<=32'b00000010001000001000000000000001;
			// sw $s0,0($zero)
			memory[8]<=32'b10011100000100000000000000000000;
			//j 26'b1111110000000000000000
			memory[9]<=32'b10100011111100000000000000001000;
		end
		else if(!Clk)
		begin
			if(RW)
			begin
				memory[Addr[6:2]][31:24]<=(BE[3]==1'b1)?DataIn[31:24]:8'b0;
				memory[Addr[6:2]][23:16]<=(BE[2]==1'b1)?DataIn[23:16]:8'b0;
				memory[Addr[6:2]][15:8]<=(BE[1]==1'b1)?DataIn[15:8]:8'b0;
				memory[Addr[6:2]][7:0]<=(BE[0]==1'b1)?DataIn[7:0]:8'b0;
			end
			else
			begin
				DataOut[31:24]<=(BE[3]==1'b1)?memory[Addr[6:2]][31:24]:(MemSign?{s,s,s,s,s,s,s,s}:8'b0);
				DataOut[23:16]<=(BE[2]==1'b1)?memory[Addr[6:2]][23:16]:(MemSign?{s,s,s,s,s,s,s,s}:8'b0);
				DataOut[15:8]<=(BE[1]==1'b1)?memory[Addr[6:2]][15:8]:(MemSign?{s,s,s,s,s,s,s,s}:8'b0);
				DataOut[7:0]<=(BE[0]==1'b1)?memory[Addr[6:2]][7:0]:(MemSign?{s,s,s,s,s,s,s,s}:8'b0);
			end
		end
	end
endmodule 