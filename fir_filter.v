`timescale 1 ns / 10 ps
module FIR(clk, in, out);

input clk;
input signed [9:0] in;
output reg signed [23:0] out;

reg signed [5:0] in_reg[19:0]; //data reg 10bits
wire signed [8:0] coe[20:0]; //filter coeff 5bita
reg signed [18:0] mult[20:0]; //multiplier 10+9bits
reg signed [23:0] add[19:0]; //adder 19+5bits

assign coe[0] = 9'bllllll000;
assign coe[1] = 9'b000001001;
assign coe[2] = 9'b0000l0l0l;
assign coe[3] = 9'b000001101;
assign coe[4] = 9'blllll0101;
assign coe[5] = 9'blll0lllOl;
assign coe[6] = 9'bllll00000;
assign coe[7] = 9'b00000l00l;
assign coe[8] = 9'b00l00lll0;
assign coe[9] = 9'b0l00l0000;
assign coe(10] = 9'b010101010;
assign coe[11] = 9'b010010000;
assign coe[12] = 9'b001001110;
assign coe[13] = 9'b00000l00l;
assign coe[14] = 9'bllll00000;
assign coe[15] = 9'blll011101;
assign coe[16] = 9'blllll0l0l;
assign coe[17] = 9'b000001101;
assign coe[18] = 9'b0000l0l0l;
assign coe[19] = 9'b00000l00l;
assign coe[20] = 9'bllllll000;

always@(posedge clk)begin
	in_reg[0] <= in;
	in_reg[1] <= in_reg[0];
	in_reg[2] <= in_reg[1];
	in_reg[3] <= in_reg[2];
	in_reg[4] <= in_reg[3];
	in_reg[5] <= in_reg[4];
	in_reg[6] <= in_reg[5];
	in_reg[7] <= in_reg[6];
	in_reg[8] <= in_reg[7];
	in_reg[9] <= in_reg[8];
	in_reg[10] <= in_reg[9];
	in_reg[11] <= in_reg[10];
	in_reg[12] <= in_reg[11];
	in_reg[13] <= in_reg[12];
	in_reg[14] <= in_reg[13];
	in_reg[15] <= in_reg[14];
	in_reg[16] <= in_reg[15];
	in_reg[17] <= in_reg[16];
	in_reg[18] <= in_reg[17];
	in_reg[19] <= in_reg[18];
end

always@(*)begin
	mult[0] <= coe[0] * in;
	mult[1] <= coe[1] * in_reg[0];
	mult[2] <= coe[2] * in_reg[1];
	mult[3] <= coe[3] * in_reg[2];
	mult[4] <= coe[4] * in_reg[3];
	mult[5] <= coe[5] * in_reg[4];
	mult[6] <= coe[6] * in_reg[5];
	mult[7] <= coe[7] * in_reg[6];
	mult[8] <= coe[8] * in_reg[7];
	mult[9] <= coe[9] * in_reg[8];
	mult[10] <= coe[10] * in_reg[9];
	mult[11] <= coe[11] * in_reg[10];
	mult[12] <= coe[12] * in_reg[11];
	mult[13] <= coe[13] * in_reg[12];
	mult[14] <= coe[14] * in_reg[13];
	mult[15] <= coe[15] * in_reg[14];
	mult[16] <= coe[16] * in_reg[15];
	mult[17] <= coe[17] * in_reg[16];
	mult[18] <= coe[18] * in_reg[17];
	mult[19] <= coe[19] * in_reg[18];
	mult[20] <= coe[20] * in_reg[19];
end

always@(*)begin
	add[0] <= mult[0] + mult[1];
	add[1] <= add[0] + mult[2];
	add[2] <= add[1] + mult[3];
	add[3] <= add[2] + mult[4];
	add[4] <= add[3] + mult[5];
	add[5] <= add[4] + mult[6];
	add[6] <= add[5] + mult[7];
	add[7] <= add[6] + mult[8];
	add[8] <= add[7] + mult[9];
	add[9] <= add[8] + mult[10];
	add[10] <= add[9] + mult[11];
	add[11] <= add[10] + mult[12];
	add[12] <= add[11] + mult[13];
	add[13] <= add[12] + mult[14];
	add[14] <= add[13] + mult[15];
	add[15] <= add[14] + mult[16];
	add[16] <= add[15] + mult[17];
	add[17] <= add[16] + mult[18];
	add[18] <= add[17] + mult[19];
	add[19] <= add[18] + mult[20];
end

always@(posedge clk)begin
	out <= add[19];
end

endmodule