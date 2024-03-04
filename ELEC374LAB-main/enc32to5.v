module enc32to5(input [31:0] regs, output reg [4:0] sel);

	//basically a lut
	always @ (regs)
	begin
		if(regs[31] == 1) sel = 5'b11111;
		else if (regs[30] == 1) sel = 5'b11110;
		else if (regs[29] == 1) sel = 5'b11101;
		else if (regs[28] == 1) sel = 5'b11100;
		else if (regs[27] == 1) sel = 5'b11011;
		else if (regs[26] == 1) sel = 5'b11010;
		else if (regs[25] == 1) sel = 5'b11001;
		else if (regs[24] == 1) sel = 5'b11000;
		else if (regs[23] == 1) sel = 5'b10111;
		else if (regs[22] == 1) sel = 5'b10110;
		else if (regs[21] == 1) sel = 5'b10101;
		else if (regs[20] == 1) sel = 5'b10100;
		else if (regs[19] == 1) sel = 5'b10011;
		else if (regs[18] == 1) sel = 5'b10010;
		else if (regs[17] == 1) sel = 5'b10001;
		else if (regs[16] == 1) sel = 5'b10000;
		else if (regs[15] == 1) sel = 5'b01111;
		else if (regs[14] == 1) sel = 5'b01110;
		else if (regs[13] == 1) sel = 5'b01101;
		else if (regs[12] == 1) sel = 5'b01100;
		else if (regs[11] == 1) sel = 5'b01011;
		else if (regs[10] == 1) sel = 5'b01010;
		else if (regs[9] == 1) sel = 5'b01001;
		else if (regs[8] == 1) sel = 5'b01000;
		else if (regs[7] == 1) sel = 5'b00111;
		else if (regs[6] == 1) sel = 5'b00110;
		else if (regs[5] == 1) sel = 5'b00101;
		else if (regs[4] == 1) sel = 5'b00100;
		else if (regs[3] == 1) sel = 5'b00011;
		else if (regs[2] == 1) sel = 5'b00010;
		else if (regs[1] == 1) sel = 5'b00001;
		else if (regs[0] == 1) sel = 5'b00000;
		else sel = 5'b11111;
	end
	
endmodule
