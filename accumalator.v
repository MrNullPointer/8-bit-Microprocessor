//Accumulator code for the controller
module accumulator(
output wire [7:0] address1,
output wire [7:0] address2,
output wire [7:0] accout,

input wire [7:0] regIn,
input wire [3:0] imm,
input wire [7:0] aluOut,
input clb,
input clk,
input wire loadAcc,
input wire selAcc
);

reg [7:0] acc;
reg [7:0] mux2;

assign address2 = acc;
assign address1 = mux2;

always @(posedge clk or posedge loadAcc or clb or regIn or imm or aluOut or selAcc )
begin
if(clb == 1'b0) begin
mux2 <= 8'b0;
end
else begin
case (selAcc)
2'b10  : mux2 = regIn;
2'b11  : mux2 = {4'b0 ,imm};
2'b00  : acc = mux2;
2'b01  : acc = aluOut;
endcase
     end
end
endmodule