// megafunction wizard: %LPM_CONSTANT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_constant 

// ============================================================
// File Name: const4.v
// Megafunction Name(s):
// 			lpm_constant
//
// Simulation Library Files(s):
// 			
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 7.2 Build 151 09/26/2007 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2007 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


//lpm_constant CBX_AUTO_BLACKBOX="ALL" ENABLE_RUNTIME_MOD="NO" LPM_CVALUE=4 LPM_WIDTH=32 result
//VERSION_BEGIN 7.2 cbx_lpm_constant 2006:12:21:09:16:46:SJ cbx_mgl 2007:08:03:15:48:12:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463


//synthesis_resources = 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  const4_lpm_constant_fm8
	( 
	result) /* synthesis synthesis_clearbox=1 */;
	output   [31:0]  result;


	assign
		result = 32'b00000000000000000000000000000100;
endmodule //const4_lpm_constant_fm8
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module const4 (
	result)/* synthesis synthesis_clearbox = 1 */;

	output	[31:0]  result;

	wire [31:0] sub_wire0;
	wire [31:0] result = sub_wire0[31:0];

	const4_lpm_constant_fm8	const4_lpm_constant_fm8_component (
				.result (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: Radix NUMERIC "10"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: Value NUMERIC "4"
// Retrieval info: PRIVATE: nBit NUMERIC "32"
// Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "4"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=NO"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "32"
// Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL result[31..0]
// Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL const4.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL const4.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL const4.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL const4.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL const4_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL const4_bb.v TRUE