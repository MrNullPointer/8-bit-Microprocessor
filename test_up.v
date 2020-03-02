// This is a testbench file created by **Parikshit Dubey** and **Arva Kagdi** //
// Testbench implements functioning for a 8-bit micro controller //
// Various input parameters are provided accordingly to get the proper simulation outputs //

`timescale 1ns/1ps
module test_up();	//module instantiation

reg clk;
reg clb;

wire Z;   
wire C;   
  
wire [3:0]Opcode;   
wire LoadIR;   
wire IncPC;   
wire SelPC;   
wire LoadPC;   
wire LoadReg;   
wire LoadAcc;   
wire [1:0] SelAcc;  
wire [3:0] SelALU;  
    
wire [7:0] a;  
wire [7:0] b;  
wire [1:0] ALU_sel;  
wire [1:0] load_shift;  
wire [7:0] result;  
wire cout;   
wire zout;   
    
wire [7:0] address; // PC
wire [7:0] regIn;  
wire [3:0] imm;  
    
wire [7:0] reg_out;  
wire [7:0] reg_in;  
wire [3:0] RegAddr;  
      
wire [7:0] address1; //Accumulator 
wire [7:0] address2;  
wire [7:0] accout;  
wire [7:0] aluOut;  

reg [22:0] memory[15:0];
wire [3:0] opcode;
reg  [3:0] address12;
wire [1:0] dc;
wire [1:0] reg1;

assign opcode = memory[address12][7:4];
assign dc     = memory[address12][3:2];
assign reg1   = memory[address12][1:0];


initial
begin
	$readmemh("test_vectors.txt", memory);
	
end
initial
begin
	clk = 0;
	clb = 0;
	#20 clb = 1;
end

always
begin
	#5 clk = ~ clk;
end

top_level top(
	.CLK (clk),
	.CLB (clb),
	.Z (Z),
	.C (C),
	.Opcode (Opcode),
	.LoadIR (LoadIR),
	.IncPC (IncPC),
	.SelPC (SelPC),
	.LoadPC (LoadPC),
	.LoadReg (LoadReg),
	.LoadAcc (LoadAcc),
	.SelAcc (SelAcc),
	.SelALU (SelALU),
	.a (a),
	.b (b),
	.ALU_sel (ALU_sel),
	.load_shift (load_shift),
	.result (result),
	.address (address),
	.regIn (regIn),
	.imm (imm),
	.reg_out (reg_out),
	.reg_in (reg_in),
	.RegAddr (RegAddr),
	.cout(cout),
	.zout(zout),
	.address1 (address1),
	.address2 (address2),
	.accout (accout),
	.aluOut (aluOut)
	);

endmodule



