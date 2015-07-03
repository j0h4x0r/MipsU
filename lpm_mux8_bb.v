// megafunction wizard: %LPM_MUX%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: lpm_mux 

// ============================================================
// File Name: lpm_mux8.v
// Megafunction Name(s):
// 			lpm_mux
//
// Simulation Library Files(s):
// 			lpm
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

module lpm_mux8 (
	data0x,
	data1x,
	sel,
	result);

	input	[3:0]  data0x;
	input	[3:0]  data1x;
	input	  sel;
	output	[3:0]  result;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "2"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "4"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "1"
// Retrieval info: USED_PORT: data0x 0 0 4 0 INPUT NODEFVAL data0x[3..0]
// Retrieval info: USED_PORT: data1x 0 0 4 0 INPUT NODEFVAL data1x[3..0]
// Retrieval info: USED_PORT: result 0 0 4 0 OUTPUT NODEFVAL result[3..0]
// Retrieval info: USED_PORT: sel 0 0 0 0 INPUT NODEFVAL sel
// Retrieval info: CONNECT: result 0 0 4 0 @result 0 0 4 0
// Retrieval info: CONNECT: @data 0 0 4 4 data1x 0 0 4 0
// Retrieval info: CONNECT: @data 0 0 4 0 data0x 0 0 4 0
// Retrieval info: CONNECT: @sel 0 0 1 0 sel 0 0 0 0
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL lpm_mux8_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
