module
Controler(IR,PClk,Func,Reset,ALU_Zero,MemData_Ready,Mul_Ready,ExtInt,IE,ALU_Overflow
,CP0_rs,Branch_al,LLbitout,PCWrite,MemRW,BE,IRWrite,RegWrite,ALUOp,CP0Write,IorD,RegDst,
RFSource,ALUSrcA,ALUSrcB,SHTNumSrc,ALUOutSrc,CP0Src,PCSource,SHTOp,MULSelMD,MULStart,
MULselHL,MULWrite,ExCode,Exception,state,MemSign,LLbitin);
	input[31:26] IR;
	wire[5:0]opcode;
	assign opcode= IR;
	input[25:21]CP0_rs;
	input[20:16]Branch_al;
	input[5:0]Func;
	input Reset,PClk,ALU_Overflow,ALU_Zero,MemData_Ready,Mul_Ready,ExtInt,IE,LLbitout;
	output PCWrite;
	output MemRW,MemSign;
	output [3:0] BE;
	output IRWrite;
	output RegWrite;
	output[3:0] ALUOp;
	output CP0Write;
	output IorD;
	output[1:0]RegDst;
	output[2:0]RFSource;
	output[1:0] ALUSrcA;
	output[2:0] ALUSrcB;
	output SHTNumSrc;
	output[1:0] ALUOutSrc;
	output CP0Src;
	output[2:0] PCSource;
	output[1:0] SHTOp;
	output MULStart,MULselHL,MULWrite,Exception,LLbitin;
	output[1:0] MULSelMD;
	output[4:0] ExCode;
	output[31:0] state;
		
	`define ALUOp_B 			4'b0000
	`define ALUOp_ADDU			4'b0001
	`define ALUOp_ADD 			4'b0010
	`define ALUOp_SUBU 			4'b0011
	`define ALUOp_SUB 			4'b0100
	`define ALUOp_AND 			4'b0101
	`define ALUOp_OR 			4'b0110
	`define ALUOp_NOR 			4'b0111
	`define ALUOp_XOR 			4'b1000
	`define ALUOp_SLTU 			4'b1001
	`define ALUOp_SLT 			4'b1010
	`define ALUOp_SLET 			4'b1011
	`define ALUOp_LU 			4'b1100
	`define ALUOp_STA0			4'b1101
	`define ALUOp_STA1			4'b1110
	`define IorD_PC 			0
	`define IorD_ALU 			1
	`define RegDst_rt 			2'b00
	`define RegDst_rd 			2'b01
	`define RegDst_ra 			2'b11
	`define RFSourse_ALU	 	2'b00
	`define RFSourse_MDR	 	2'b01
	`define RFSourse_CP0	 	2'b10
	`define RFSourse_PC 		2'b11
	`define ALUSrcA_PC 			0
	`define ALUSrcA_A 			1
	`define ALUSrcB_B 			2'b00
	`define ALUSrcB_4 			2'b01
	`define ALUSrcB_Imm 		2'b10
	`define ALUSrcB_4Imm 		2'b11
	`define SHTNumSrc_B 		0
	`define SHTNumSrc_IR 		1
	`define ALUOutSrc_ALU 		2'b00
	`define ALUOutSrc_SHIFTER 	2'b01 
	`define ALUOutSrc_MUL 		2'b10
	`define CP0Src_EPC 			0
	`define CP0Src_cs 			1
	
	`define PCSource_PC4 		3'b001
	`define PCSource_J 			3'b011
	`define PCSource_BRANCH 	3'b010
	`define PCSource_EXCEPTION 	3'b100
	`define PCSource_INT 		3'b101
	`define PCSource_EPC 		3'b110
	`define BE_WORD 			4'b1111
	`define BE_HALF 			4'b0111
	`define BE_BYTE 			4'b0011
	`define BE_DEFAULT 			4'b0000
	`define MemRW_Read 			0
	`define MemRW_Write 		1
	`define Mul_SelMD_DIV 		2'b01
	`define Mul_SelMD_MUL 		2'b00
	`define Mul_SelMD_MUL_ADD	2'b10
	`define Mul_SelMD_MUL_SUB	2'b11
	`define SHTOp_NOP 			2'b00
	`define SHTOp_LOGLEFT 		2'b01
	`define SHTOp_LOGRIGHT 		2'b10
	`define SHTOp_ARiGHT 		2'b11
	
	`define STATE_IR 		22'b000000_00000000_00000001
	`define STATE_OPDECODE 	22'b000000_00000000_00000010
	`define STATE_MEMCALC 	22'b000000_00000000_00000100
	`define STATE_MEMREAD 	22'b000000_00000000_00001000
	`define STATE_MEMWRITE	22'b000000_00000000_00010000
	`define STATE_WRITEBACK 22'b000000_00000000_00100000
	`define STATE_R 		22'b000000_00000000_01000000
	`define STATE_I 		22'b000000_00000000_10000000
	`define STATE_CP0		22'b000000_00000001_00000000
	`define STATE_REND		22'b000000_00000010_00000000
	`define STATE_IEND		22'b000000_00000100_00000000
	`define STATE_BEND		22'b000000_00001000_00000000
	`define STATE_JEND		22'b000000_00010000_00000000
	`define STATE_CP0END	22'b000000_00100000_00000000
	`define STATE_EI		22'b000000_01000000_00000000
	`define STATE_ESC		22'b000000_10000000_00000000
	`define STATE_EBP		22'b000001_00000000_00000000
	`define STATE_EBK		22'b000010_00000000_00000000
	`define STATE_EA 		22'b000100_00000000_00000000
	`define STATE_TRAP		22'b001000_00000000_00000000
	`define STATE_TRAPEND	22'b010000_00000000_00000000
	`define STATE_REND2		22'b100000_00000000_00000000
	reg[21:0] state;
	
	wire tmpZero;
	assign tmpZero=((state[6] && (is_Func23||is_Func24) && ALU_Zero)||
					(state[19]&&ALU_Zero)||
					(state[6] && (is_Func25||is_Func26) && ALU_Zero)
					)?1:((state[1])?0:tmpZero);
	assign LLbitin = is_R5;
	
	wire is_sl,is_r,is_i,is_cp0,is_branch,is_j,is_ex;
	assign is_sl = (IR[31]& !IR[30] & !IR[29]) || (!IR[31]& IR[30] & IR[29]);
	assign is_r = !IR[31]& !IR[30] & !IR[29]&!IR[28] &!IR[27] &!IR[26];
	assign is_i = !IR[31]& !IR[30] & IR[29];
	assign is_cp0 = !IR[31]& IR[30] & !IR[29];
	assign is_branch = IR[31]& IR[30] & !IR[29];
	assign is_j1 = IR[31]& !IR[30] & IR[29];  
	assign is_esc = IR[31]& IR[30] & IR[29] & IR[28] & IR[27] & IR[26] & Func[1] & !Func[0];
	assign is_ebp = IR[31]& IR[30] & IR[29] & IR[28] & IR[27] & IR[26] & !Func[1] & Func[0];
	assign is_nop = !(IR[31:26]||Func);
	assign is_trap = (!IR[31] & !IR[30] & !IR[29] & !IR[28] & !IR[27] & IR[26]) ||
					 (!IR[31] & !IR[30] & !IR[29] & !IR[28] & IR[27] & !IR[26]);
	
	wire is_mf;
	assign is_mf = (!Func[5] && Func[4] && !Func[3] && Func[2] &&((Func[1] && !Func[0]) || (!Func[1] && Func[0])));
	
	always @ (posedge PClk or posedge Reset)
	if(Reset)
	begin
	state <= `STATE_IR;
	end
	else
	begin
		case(state)
		`STATE_IR:
			begin
			if(MemData_Ready)
				state<= `STATE_OPDECODE;
			end
		`STATE_OPDECODE:
			begin
				if(is_sl)
					state <=`STATE_MEMCALC;
				else if(is_r)
					state<=`STATE_R;
				else if(is_branch)
					state<=`STATE_BEND;
				else if(is_j1)
					state<=`STATE_JEND;
				else if(is_i)
					state<=`STATE_I;
				else if(is_cp0)
					state<=`STATE_CP0;
				else if(is_esc)
					state<=`STATE_ESC;
				else if(is_ebp)
					state<=`STATE_EBP;
				else if(is_nop)
					state<=`STATE_IR;
				else if(is_trap)
					state<=`STATE_TRAP;
				else
					state<=`STATE_EI;
			end
		`STATE_MEMCALC:
			begin
				if((IR[28]&&IR[27:26])||((!IR[28])&&IR[27]&&!IR[31])||(IR[28]&&(!IR[27])&&IR[26]&&!IR[31]))
					state<=`STATE_MEMWRITE;
				else
					state<=`STATE_MEMREAD;
			end
		`STATE_MEMREAD:
			begin
				if(MemData_Ready)
					state<=`STATE_WRITEBACK;
				else
					state<=`STATE_MEMREAD;
			end
		`STATE_MEMWRITE:
			begin
				if(MemData_Ready)
					state<=`STATE_IR;
				else
					state<=`STATE_MEMWRITE;
			end
		`STATE_WRITEBACK:
			state<=`STATE_IR;
		`STATE_R:
			begin
				if(is_mf && !Mul_Ready)
					state<=`STATE_R;
				else
					state<=`STATE_REND;
			end
		`STATE_I:
			state<=`STATE_IEND;
		`STATE_CP0:
			begin
				if(CP0_rs[25] && !CP0_rs[24:21])
					state<=`STATE_IR;
				else if((!CP0_rs[22:21] && !CP0_rs[25:24] && CP0_rs[23]) || is_mtc1)
					state<=`STATE_CP0END;
				else if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_IR;
			end
		`STATE_REND:
			begin
				if(ALU_Overflow && IR)
					state<=`STATE_EA;
				else if(ExtInt && IE)
					state <=`STATE_EBK;
				else if(is_Func18&&!Mul_Ready)
					state <=`STATE_REND;
				else if(is_Func18||is_Func23||is_Func24||is_Func25||is_Func26)
					state <=`STATE_REND2;
				else
					state<=`STATE_IR;
			end
		`STATE_IEND:
			begin
				if(ALU_Overflow && IR)
					state<=`STATE_EA;
				else if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_IR;
			end
		`STATE_BEND:
			begin
				if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_IR;
			end
		`STATE_JEND:
			begin
				if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_IR;
			end
		`STATE_CP0END:
			begin
				if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_IR;
			end
		`STATE_TRAP:
			begin
				if(ExtInt && IE)
					state <=`STATE_EBK;
				else
					state<=`STATE_TRAPEND;
			end
		default:state<=`STATE_IR;
		endcase
	end
	
	
	assign is_beq=//110000
opcode[5]&&opcode[4]&&!opcode[3]&&!opcode[2]&&!opcode[1]&&!opcode[0];
	assign is_bgez=//110001
opcode[5]&&opcode[4]&&!opcode[3]&&!opcode[2]&&!opcode[1]&&opcode[0];
	assign is_bgtz=//110010
opcode[5]&&opcode[4]&&!opcode[3]&&!opcode[2]&&opcode[1]&&!opcode[0];
	assign is_bltz=//110011
opcode[5]&&opcode[4]&&!opcode[3]&&!opcode[2]&&opcode[1]&&opcode[0];
	assign is_blez=//110100
opcode[5]&&opcode[4]&&!opcode[3]&&opcode[2]&&!opcode[1]&&!opcode[0];
	assign is_bne=//110101
opcode[5]&&opcode[4]&&!opcode[3]&&opcode[2]&&!opcode[1]&&opcode[0];
	assign is_bclf=//110110
opcode[5]&&opcode[4]&&!opcode[3]&&opcode[2]&&opcode[1]&&!opcode[0];
	assign is_bclt=//110111
opcode[5]&&opcode[4]&&!opcode[3]&&opcode[2]&&opcode[1]&&opcode[0];

	assign is_Branch_al1=//[20:16]00000
!(Branch_al[16]||Branch_al[17]||Branch_al[18]||Branch_al[19]||Branch_al[20]);
	assign is_Branch_al2=//[20:16]00001
(!(Branch_al[17]||Branch_al[18]||Branch_al[19]||Branch_al[20]))&&Branch_al[16];	

	assign is_CP0_rs1=//[25:21]00000
!(CP0_rs[25]||CP0_rs[24]||CP0_rs[23]||CP0_rs[22]||CP0_rs[21]);
	assign is_CP0_rs2=//[25:21]00100
(!(CP0_rs[25]||CP0_rs[24]))&&CP0_rs[23]&&(!(CP0_rs[22]||CP0_rs[21]));
	assign is_CP0_rs3=//[25:21]10000
CP0_rs[25]&&(!(CP0_rs[24]||CP0_rs[23]||CP0_rs[22]||CP0_rs[21]));
	assign is_mfc1=//[25:21]01000
!CP0_rs[25]&&CP0_rs[24]&&!CP0_rs[23]&&!CP0_rs[22]&&!CP0_rs[21];
	assign is_mtc1=//[25:21]00010
!CP0_rs[25]&&!CP0_rs[24]&&!CP0_rs[23]&&CP0_rs[22]&&!CP0_rs[21];
	
	//addu add subu sub and nor or
	//000***
	assign is_Func1=!(Func[5]||Func[4]||Func[3]);
	//xor sltu 00100*
	assign is_Func2=(!(Func[5]||Func[4]))&&Func[3]&&(!(Func[2]||Func[1]));
	//slt 001010
	assign is_Func3=(!(Func[5]||Func[4]))&&Func[3]&&(!Func[2])&&Func[1]&&(!Func[0]);
	//div 001011
	assign is_Func4=(!(Func[5]||Func[4]))&&Func[3]&&(!Func[2])&&Func[1]&&Func[0];
	//divu 001100
	assign is_Func5=(!(Func[5]||Func[4]))&&Func[3]&&Func[2]&&(!(Func[1]||Func[0]));
	//mult 010011
	assign is_Func6=(!Func[5])&&Func[4]&&(!(Func[3]||Func[2]))&&Func[1]&&Func[0];
	//multu 010100
	assign is_Func7=(!Func[5])&&Func[4]&&(!Func[3])&&Func[2]&&(!(Func[1]||Func[0]));
	//mfhi 010101
	assign is_Func8=(!Func[5])&&Func[4]&&(!Func[3])&&Func[2]&&(!Func[1])&&Func[0];
	//mflo 010110
	assign is_Func9=(!Func[5])&&Func[4]&&(!Func[3])&&Func[2]&&Func[1]&&(!Func[0]);
	//mthi 010111
	assign is_Func10=(!Func[5])&&Func[4]&&(!Func[3])&&Func[2]&&Func[1]&&Func[0];
	//mtlo 011000
	assign is_Func11=(!Func[5])&&Func[4]&&Func[3]&&(!(Func[2]||Func[1]||Func[0]));
	//sll 001101
	assign is_Func12=(!(Func[5]||Func[4]))&&Func[3]&&Func[2]&&!Func[1]&&Func[0];
	//sllv 001110
	assign is_Func13=(!(Func[5]||Func[4]))&&Func[3]&&Func[2]&&Func[1]&&!Func[0];
	//sra 001111
	assign is_Func14=(!(Func[5]||Func[4]))&&Func[3]&&Func[2]&&Func[1]&&Func[0];
	//srav 010000
	assign is_Func15=(!Func[5])&&Func[4]&&(!(Func[3]||Func[2]||Func[1]||Func[0]));
	//srl 010001
	assign is_Func16=(!Func[5])&&Func[4]&&(!(Func[3]||Func[2]||Func[1]))&&Func[0];
	//srlv 010010
	assign is_Func17=(!Func[5])&&Func[4]&&(!(Func[3]||Func[2]))&&Func[1]&&(!Func[0]);
	//mul 011001
	assign is_Func18=(!Func[5])&&Func[4]&&Func[3]&&(!Func[2])&&(!Func[1])&&Func[0];
	//madd 011010
	assign is_Func19=(!Func[5])&&Func[4]&&Func[3]&&(!Func[2])&&Func[1]&&(!Func[0]);
	//maddu 011011
	assign is_Func20=(!Func[5])&&Func[4]&&Func[3]&&(!Func[2])&&Func[1]&&Func[0];
	//msub 011100
	assign is_Func21=(!Func[5])&&Func[4]&&Func[3]&&Func[2]&&(!Func[1])&&(!Func[0]);
	//msubu 011101
	assign is_Func22=(!Func[5])&&Func[4]&&Func[3]&&Func[2]&&(!Func[1])&&Func[0];
	//movn 011110
	assign is_Func23=(!Func[5])&&Func[4]&&Func[3]&&Func[2]&&Func[1]&&(!Func[0]);
	//movz 011111
	assign is_Func24=(!Func[5])&&Func[4]&&Func[3]&&Func[2]&&Func[1]&&Func[0];
	//movf 100010
	assign is_Func25=Func[5]&&(!Func[4])&&(!Func[3])&&(!Func[2])&&(Func[1])&&(!Func[0]);
	//movt 100011
	assign is_Func26=Func[5]&&(!Func[4])&&(!Func[3])&&(!Func[2])&&(Func[1])&&Func[0];
	//clz 100000
	assign is_Func27=Func[5]&&!Func[4]&&!Func[3]&&!Func[2]&&!Func[1]&&!Func[0];
	//clo 100001
	assign is_Func28=Func[5]&&!Func[4]&&!Func[3]&&!Func[2]&&!Func[1]&&Func[0];

	assign is_opcode1=//lui 001000
(!(opcode[5]||opcode[4]))&&opcode[3]&&(!(opcode[2]||opcode[1]||opcode[0]));
	assign is_opcode2=//addiu 001001
(!(opcode[5]||opcode[4]))&&opcode[3]&&(!(opcode[2]||opcode[1]))&&opcode[0];
	assign is_opcode3=//addi 001010
(!(opcode[5]||opcode[4]))&&opcode[3]&&(!opcode[2])&&opcode[1]&&(!opcode[0]);
	assign is_opcode4=//andi 001011
(!(opcode[5]||opcode[4]))&&opcode[3]&&(!opcode[2])&&opcode[1]&&opcode[0];
	assign is_opcode5=//ori 001100
(!(opcode[5]||opcode[4]))&&opcode[3]&&opcode[2]&&(!(opcode[1]||opcode[0]));
	assign is_opcode6=//xori 001101
(!(opcode[5]||opcode[4]))&&opcode[3]&&opcode[2]&&(!opcode[1])&&opcode[0];
	assign is_opcode7=//sltiu 001110
(!(opcode[5]||opcode[4]))&&opcode[3]&&opcode[2]&&opcode[1]&&(!opcode[0]);
	assign is_opcode8=//slti 001111
(!(opcode[5]||opcode[4]))&&opcode[3]&&opcode[2]&&opcode[1]&&opcode[0];

	assign is_R1=//lh lhu 10001*
opcode[5]&&!opcode[4]&&!opcode[3]&&!opcode[2]&&opcode[1];
	assign is_R2=//lw 100100
opcode[5]&&!opcode[4]&&!opcode[3]&&opcode[2]&&!opcode[1]&&!opcode[0];
	assign is_R3=//lwl 011000
(!opcode[5])&&opcode[4]&&opcode[3]&&(!opcode[2])&&(!opcode[1])&&(!opcode[0]);
	assign is_R4=//lwr 011001
(!opcode[5])&&opcode[4]&&opcode[3]&&(!opcode[2])&&(!opcode[1])&&opcode[0];
	assign is_R5=//ll 011100
(!opcode[5])&&opcode[4]&&opcode[3]&&opcode[2]&&(!opcode[1])&&(!opcode[0]);
	assign is_W1=//sh 100110
opcode[5]&&!opcode[4]&&!opcode[3]&&opcode[2]&&opcode[1]&&!opcode[0];
	assign is_W2=//sw 100111
opcode[5]&&!opcode[4]&&!opcode[3]&&opcode[2]&&opcode[1]&&opcode[0];
	assign is_W3=//swl 011010
(!opcode[5])&&opcode[4]&&opcode[3]&&(!opcode[2])&&opcode[1]&&(!opcode[0]);
	assign is_W4=//swr 011011
(!opcode[5])&&opcode[4]&&opcode[3]&&(!opcode[2])&&opcode[1]&&opcode[0];
	assign is_W5=//sc 011101
(!opcode[5])&&opcode[4]&&opcode[3]&&opcode[2]&&(!opcode[1])&&opcode[0];

	assign is_j=//101000
opcode[5]&&!opcode[4]&&opcode[3]&&(!(opcode[2]||opcode[1]||opcode[0]));
	assign is_jal=//101001
opcode[5]&&!opcode[4]&&opcode[3]&&!opcode[2]&&!opcode[1]&&opcode[0];
	assign is_jalr=//101011
opcode[5]&&!opcode[4]&&opcode[3]&&!opcode[2]&&opcode[1]&&opcode[0];
	assign is_jr=//101010
opcode[5]&&!opcode[4]&&opcode[3]&&!opcode[2]&&opcode[1]&&!opcode[0];

	assign is_teq=//Func000000
(!Func[5])&&(!Func[4])&&(!Func[3])&&(!Func[2])&&!(Func[1])&&(!Func[0])&&IR[26];
	assign is_tne=//Func000001
(!Func[5])&&(!Func[4])&&(!Func[3])&&(!Func[2])&&!(Func[1])&&Func[0]&&IR[26];
	assign is_tge=//Func000010
(!Func[5])&&(!Func[4])&&(!Func[3])&&(!Func[2])&&Func[1]&&(!Func[0])&&IR[26];
	assign is_tgeu=//Func000011
(!Func[5])&&(!Func[4])&&(!Func[3])&&(!Func[2])&&Func[1]&&Func[0]&&IR[26];
	assign is_tlt=//Func000100
(!Func[5])&&(!Func[4])&&(!Func[3])&&Func[2]&&!(Func[1])&&(!Func[0])&&IR[26];
	assign is_tltu=//Func000101
(!Func[5])&&(!Func[4])&&(!Func[3])&&Func[2]&&!(Func[1])&&Func[0]&&IR[26];
	assign is_teqi=//Branch_al 00000
(!Branch_al[20])&&(!Branch_al[19])&&(!Branch_al[18])&&(!Branch_al[17])&&(!Branch_al[16])&&!IR[26];
	assign is_tgei=//Branch_al 00001
(!Branch_al[20])&&(!Branch_al[19])&&(!Branch_al[18])&&(!Branch_al[17])&&Branch_al[16]&&!IR[26];
	assign is_tgeiu=//Branch_al 00010
(!Branch_al[20])&&(!Branch_al[19])&&(!Branch_al[18])&&Branch_al[17]&&(!Branch_al[16])&&!IR[26];
	assign is_tlti=//Branch_al 00100
(!Branch_al[20])&&(!Branch_al[19])&&Branch_al[18]&&(!Branch_al[17])&&(!Branch_al[16])&&!IR[26];
	assign is_tltiu=//Branch_al 00101
(!Branch_al[20])&&(!Branch_al[19])&&Branch_al[18]&&(!Branch_al[17])&&Branch_al[16]&&!IR[26];
	assign is_tnei=//Branch_al 00011
(!Branch_al[20])&&(!Branch_al[19])&&(!Branch_al[18])&&Branch_al[17]&&Branch_al[16]&&!IR[26];

	assign PCWrite=state[0]||
	(state[8]&&is_CP0_rs3)||
	(state[11]&&is_beq&&ALU_Zero)||
	(state[11]&&is_bgez&&ALU_Zero&&is_Branch_al1)||
	(state[11]&&is_bgez&&ALU_Zero&&is_Branch_al2)||
	(state[11]&&is_bgtz&&ALU_Zero)||
	(state[11]&&is_bltz&&!ALU_Zero&&is_Branch_al1)||
	(state[11]&&is_bltz&&!ALU_Zero&&is_Branch_al2)||
	(state[11]&&is_blez&&!ALU_Zero)||
	(state[11]&&is_bne&&!ALU_Zero)||
	(state[11]&&is_bclf&&ALU_Zero)||
	(state[11]&&is_bclt&&ALU_Zero)||
	state[12]||state[14]||state[15]||state[16]||state[17]||state[18]||
	(state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
	(state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));


	assign MemRW = state[4]&&!(!LLbitout && is_W5);

	assign MemSign = state[3]&&opcode[0];
	
	assign BE[0]=state[0]||(state[3]&&(!is_R3))||(state[4]&&(!is_W3));
	assign BE[1]=state[0]||(state[3]&&is_R1)||(state[3]&&is_R2)||(state[4]&&is_W1)||(state[4]&&is_W2)||(state[3]&&is_R4)||(state[4]&&is_W4)||(state[3]&&is_R5)||(state[4]&&is_W5&&LLbitout);
	assign BE[2]=state[0]||(state[3]&&is_R2)||(state[4]&&is_W2)||(state[3]&&is_R3)||(state[4]&&is_W3)||(state[3]&&is_R5)||(state[4]&&is_W5&&LLbitout);
	assign BE[3]=state[0]||(state[3]&&is_R2)||(state[4]&&is_W2)||(state[3]&&is_R3)||(state[4]&&is_W3)||(state[3]&&is_R5)||(state[4]&&is_W5&&LLbitout);
	
	assign IRWrite = state[0];
	assign RegWrite =state[5] || (state[8]&&(is_CP0_rs1||is_mfc1))||(state[9]&&!is_Func23&&!is_Func24&&!is_Func25&&!is_Func26&&!is_Func4&&!is_Func5&&!is_Func6&&!is_Func7)||
					 (state[21] && is_Func23 && (!tmpZero))||
				     (state[21] && is_Func24 && tmpZero)||
					 (state[21]&&is_Func25&&tmpZero)||
					 (state[21]&&is_Func26&&!(tmpZero))||
					 (state[21]&&is_Func18)||
					 (state[9] && is_Func27) ||
					 (state[9] && is_Func28) ||
					 state[10]||
				     (state[11]&&is_bgez&&is_Branch_al2)||
					 (state[11]&&is_bltz&&is_Branch_al2)||
					 (state[12] && is_jal)||
					 (state[12] && is_jalr)||
					 (state[4] && is_W5);
	assign ALUOp[3]=(state[6] && is_Func1 && Func[3]) ||
					(state[6] && is_Func2 && Func[3]) ||
					(state[6] && is_Func3 && Func[3]) ||
					(state[6] && is_Func27) ||
					(state[6] && is_Func28) ||
					(state[7]&&is_opcode1)||
					(state[7]&&is_opcode6)||
					(state[7]&&is_opcode7)||
					(state[7]&&is_opcode8)||
					(state[11]&&is_bgez&&is_Branch_al1)||
					(state[11]&&is_bgez&&is_Branch_al2)||
					(state[11]&&is_bgtz)||
					(state[11]&&is_bltz&&is_Branch_al1)||
					(state[11]&&is_bltz&&is_Branch_al2)||
					(state[11]&&is_blez)||
					(state[19]&&(is_tge||is_tgeu||is_tlt||is_tltu||is_tgei||is_tgeiu||is_tlti||is_tltiu));
	assign ALUOp[2]=(state[6] && is_Func1 && Func[2])||
					(state[6] && is_Func2 && Func[2])||
					(state[6] && is_Func3 && Func[2])||
					(state[6] && is_Func27) ||
					(state[6] && is_Func28) ||
					(state[7]&&is_opcode1)||
					(state[7]&&is_opcode4)||
					(state[7]&&is_opcode5);
	assign ALUOp[1]=state[1]||state[2]||
					(state[6] && is_Func1 && Func[1])||
					(state[6] && is_Func2 && Func[1])||
					(state[6] && is_Func3 && Func[1])||
					(state[6] && (is_Func25||is_Func26))||
					(state[6] && is_Func28) ||
					(state[7]&&is_opcode3)||
					(state[7]&&is_opcode5)||
					(state[7]&&is_opcode8)||
					state[11]||state[14]||state[15]||state[16]||state[17]||state[18]||
					(state[19])||
					(state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					(state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
					
	assign ALUOp[0]=state[0]||
					(state[6] && is_Func1 && Func[0])||
					(state[6] && is_Func2 && Func[0])||
					(state[6] && is_Func3 && Func[0])||
					(state[6] && (is_Func25||is_Func26))||
					(state[6] && is_Func27) ||
					(state[7]&&is_opcode2)||
					(state[7]&&is_opcode4)||
					(state[7]&&is_opcode7)||
					(state[9] && (is_Func23||is_Func24))||
					(state[9]&&(is_Func25||is_Func26))||
					(state[11]&&is_beq)||
					(state[11]&&is_bgtz)||
					(state[11]&&is_blez)||
					(state[11]&&is_bne)||
					(state[11]&&(is_bclf||is_bclt))||
					(state[12]&&is_jalr)||
					(state[12]&&is_jr)||
					state[14]||state[15]||state[16]||state[17]||state[18]||
					(state[19]&&(is_teq||is_tne||is_teqi||is_tnei))||
					(state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					(state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	
	assign CP0Write = state[13]||state[14]||state[15]||state[16]||state[17]||state[18]||
					  (state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					  (state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	
	assign IorD = state[3]||(state[4]&&!(!LLbitout && is_W5));
	
	assign RegDst[1]= (state[11] && is_bgez&&is_Branch_al2) ||
					  (state[11]&&is_bltz&&is_Branch_al2) ||
					  (state[12] && is_jal);
	assign RegDst[0]=	state[9] ||
						(state[11] && is_bgez&&is_Branch_al2) ||
						(state[11]&&is_bltz&&is_Branch_al2) ||
						(state[12] && is_jal)||
						(state[12] && is_jalr)||
						state[21];
	assign RFSource[2] = state[4] && is_W5;
	assign RFSource[1] = (state[8] && (is_CP0_rs1||is_mfc1)) ||
						(state[11] && is_bgez&&is_Branch_al2) ||
						(state[11]&&is_bltz&&is_Branch_al2) ||
						(state[12] && is_jal)||
						(state[12] && is_jalr);
	assign RFSource[0] = state[5] ||
						(state[11] && is_bgez&&is_Branch_al2) ||
						(state[11]&&is_bltz&&is_Branch_al2) ||
						(state[12] && is_jal)||
						(state[12] && is_jalr);		
	assign ALUSrcA[1] = state[11]&&(is_bclf||is_bclt)||
						(state[6] && (is_Func25||is_Func26));
	assign ALUSrcA[0] = state[2]||
					(state[6] && is_Func1) ||
					(state[6] && is_Func2) ||
					(state[6] && is_Func3) ||
					(state[6] && is_Func26)||
					(state[6] && is_Func27) ||
					(state[6] && is_Func28) ||
					state[7]||
					(state[9] && (is_Func23||is_Func24))||
					(state[9]&&(is_Func25||is_Func26))||
					(state[11]&&!is_bclf)||
					(state[12] && is_jalr)||
					(state[12] && is_jr)||
					(state[19]);
	assign ALUSrcB[2] = state[11]&&(is_bgez||is_bgtz||is_blez||is_bltz)||
						(state[9] && (is_Func23||is_Func24))||
						(state[9]&&(is_Func25||is_Func26));		
	assign ALUSrcB[1] = state[1]||state[2]||state[7]||
						(state[19]&&(is_teqi||is_tgei||is_tgeiu||is_tlti||is_tltiu||is_tnei));
	assign ALUSrcB[0] = state[0]||state[1]||state[14]||state[15]||state[16]|state[17]||state[18]||
						(state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
						(state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	
	assign SHTNumSrc = (state[6] && is_Func12) ||
						(state[6] && is_Func14) ||
						(state[6] && is_Func6);
	
	assign ALUOutSrc[1] = (state[6] && is_Func8) ||
							(state[6] && is_Func9)||
							(state[9] && is_Func18)||
							(state[21] && is_Func18);
	assign ALUOutSrc[0] = (state[6] && is_Func12) ||
							(state[6] && is_Func13) ||
							(state[6] && is_Func14) ||
							(state[6] && is_Func15) ||
							(state[6] && is_Func16) ||
							(state[6] && is_Func17);
	
	assign CP0Src = (state[8] && is_CP0_rs1)||
					(state[8] && is_CP0_rs2)||
					(state[8] && is_mfc1)||
					(state[8] && is_mtc1)||
					state[13];
					
	assign ExCode[4] = 0;
	assign ExCode[3] = state[14]||state[15]||state[16]|state[17]||
					   (state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					   (state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	assign ExCode[2] = 0;
	assign ExCode[1] = state[14]||
					   (state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					   (state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	assign ExCode[0] = state[16];
	
	assign PCSource[2]=(state[8]&&is_CP0_rs3)||
					   state[14]||state[15]||state[16]|state[17]||state[18]||
					   (state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					   (state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
	assign PCSource[1]=(state[8]&&is_CP0_rs3) ||
						(state[12] && is_j)||
					   (state[12] && is_jal)||	
					   state[11]||state[14]||state[15]||state[16]|state[18];
	assign PCSource[0]= state[0]||
						state[12]||
						state[17];
	assign SHTOp[1]=(state[6] && is_Func14) ||
					(state[6] && is_Func15) ||
					(state[6] && is_Func16) ||
					(state[6] && is_Func17);
	assign SHTOp[0]=(state[6] && is_Func12) ||
					(state[6] && is_Func13) ||
					(state[6] && is_Func14) ||
					(state[6] && is_Func15);
	assign MULSelMD[1] = state[6] && (is_Func19 || is_Func20 || is_Func21 || is_Func22);
	assign MULSelMD[0] = (state[6] && is_Func4) ||
					     (state[6] && is_Func5) ||
					     (state[6] && is_Func21) ||
						 (state[6] && is_Func22);
    assign MULStart = (state[6] && (is_Func4||is_Func5||is_Func6||is_Func7||is_Func18||is_Func19||is_Func20||is_Func21||is_Func22));
	assign MULselHL = (state[6] && is_Func8) ||
					  (state[6] && is_Func10);
	assign MULWrite = (state[6] && is_Func10) ||
					  (state[6] && is_Func11);
	assign Exception = state[14]||state[15]||state[16]||state[17]||state[18]||
					   (state[20]&&(is_teq||is_tge||is_tgeu||is_teqi||is_tgei||is_tgeiu)&&tmpZero)||
					   (state[20]&&(is_tne||is_tnei||is_tlt||is_tltu||is_tlti||is_tltiu)&&(!tmpZero));
endmodule