//This project on 8-bit Microprocessor is completed by **Parikshit Dubey** and **Arva Kagdi**//
//In this project we implement an 8-bit Microprocessor which performs various operations based on the opodes provided//
//The simulation of this Microprocessor implementation is observed properly and included in the detailed report//

module top_level (
	input wire Z,		     //Controller
	input wire C,
	input wire CLK,
	input wire CLB,
	input wire [3:0]Opcode,
	output wire LoadIR,
	output wire IncPC,
	output wire SelPC,
	output wire LoadPC,
	output wire LoadReg,
	output wire LoadAcc,
	output wire [1:0] SelAcc,
	output wire [3:0] SelALU,

	input wire [7:0] a,               // ALU
	input wire [7:0] b,
	input wire [1:0] ALU_sel,
	input wire [1:0] load_shift,
	output wire [7:0] result,
	output wire cout,
	output wire zout,

	output wire [7:0] address,        // PC
	input wire [7:0] regIn,
	input wire [3:0] imm,
		                              
	output wire [7:0] reg_out,	//Register
	input wire [7:0] reg_in,
	input wire [3:0] RegAddr,


	output wire [7:0] address1,    //Accumulator 
	output wire [7:0] address2,
	output wire [7:0] accout,
	input wire [7:0] aluOut
);

ControllerFSM C1 (Z, C, CLK, CLB, Opcode, LoadIR, IncPC, SelPC, LoadPC, LoadReg, LoadAcc, SelAcc, SelALU);
ALU A1 (a,b,ALU_sel, load_shift, result, cout, zout);
program_counter PC (address, regIn, imm, CLB, clk, IncPC, LoadPC, selPC);
reg_file register1 (reg_out, reg_in, RegAddr, clk, CLB, LoadReg);
accumulator acc1 (address1, address2, accout, regIn, imm, aluOut, clb, clk, loadAcc, selAcc);

endmodule

