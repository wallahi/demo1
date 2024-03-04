module multiplier (input [31:0] A, input [31:0] B, output[31:0] HI, output[31:0] LO);
	// 32 partial products, this is hell, very expensive, lots of connections
	// A is multiplicand
	// B is multiplier
	// if negative multiplier mux the extension wire with supply0 or supply1
	// if two negatives then we don't care
	supply0 gnd;
	supply1 pwr;
	integer i, j;
	
	// partial products are just shifted numbers
	reg [63:0] partials [31:0]; 
	
	always@*
	begin
	// handle edge cases of partial products
		partials[0] = A;
		partials[31][63:32] = A;
		partials[31][31:0] = gnd;
		
	// if the multiplier is zero set all to zero, else do the funky stuff.
		for(i = 0; i < 32; i = i + 1)
		begin
			partials[i] = 64'd0;
			if (B[i])
				begin
					partials[i][31:0] = A[31:0];
					partials[i] = partials[i] << i;
					
					// assign ones if negative to position after shifted
					for (j = i+32; j < 64; j = j + 1)
					begin
						partials[i][j] = (A[31]) ? pwr : gnd;
					end	
				end
			else
				begin
					partials[i] = gnd;
				end
		end
	end
	
	wire [63:0]inter[61:0];
	
	// first row all must be 64 bit width to accomodate sign extension
	// in 29 out 21 (19+2)
	csm csm00(partials[0], partials[1], partials[2], inter[0], inter[1]); //32 33 34 ... 35
	csm csm01(partials[3], partials[4], partials[5], inter[2], inter[3]); //35 36 37 ... 38
	csm csm02(partials[6], partials[7], partials[8], inter[4], inter[5]); //38 39 40
	csm csm03(partials[9], partials[10], partials[11], inter[6], inter[7]); //41
	csm csm04(partials[12], partials[13], partials[14], inter[8], inter[9]); //44
	csm csm05(partials[15], partials[16], partials[17], inter[10], inter[11]); //57
	csm csm06(partials[18], partials[19], partials[20], inter[12], inter[13]); //50
	csm csm07(partials[21], partials[22], partials[23], inter[14], inter[15]); //53
	csm csm08(partials[24], partials[25], partials[26], inter[16], inter[17]); //56
	csm csm09(partials[27], partials[28], partials[29], inter[18], inter[19]); //59
	
	// second row
	// in 21 out 16
	csm csm10(partials[30], partials[31], inter[0], inter[20], inter[21]); //61 adjust
	
	// 3 inputs to two outputs
	csm csm11(inter[1], inter[2], inter[3], inter[22], inter[23]);
	csm csm12(inter[4], inter[5], inter[6], inter[24], inter[25]);
	csm csm13(inter[7], inter[8], inter[9], inter[26], inter[27]);
	csm csm14(inter[10], inter[11], inter[12], inter[28], inter[29]);
	csm csm15(inter[13], inter[14], inter[15], inter[30], inter[31]);
	csm csm16(inter[16], inter[17], inter[18], inter[32], inter[33]);
	csm csm17(inter[19], inter[20], inter[21], inter[34], inter[35]);
	
	// third row
	// in 16 out 11
	csm csm18(inter[22], inter[23], inter[24], inter[36], inter[37]);
	csm csm19(inter[25], inter[26], inter[27], inter[38], inter[39]);
	csm csm20(inter[28], inter[29], inter[30], inter[40], inter[41]);
	csm csm21(inter[31], inter[32], inter[33], inter[42], inter[43]);
	
	// inter 35 is remainder so wire up next
	
	
	// fourth row
	// in 11 out 8 (6 + 2)
	csm csm22(inter[34], inter[35], inter[36], inter[44], inter[45]);
	csm csm23(inter[37], inter[38], inter[39], inter[46], inter[47]);
	csm csm24(inter[40], inter[41], inter[42], inter[48], inter[49]);
	
	
	
	// fifth row
	// in 8 out 6 
	csm csm25(inter[43], inter[44], inter[45], inter[50], inter[51]);
	csm csm26(inter[46], inter[47], inter[48], inter[52], inter[53]);
	
	
	// sixth row
	// in 6 out 4
	csm csm27(inter[49], inter[50], inter[51], inter[54], inter[55]);
	
	
	// seventh row
	// in 4 out 3
	csm csm28(inter[52], inter[53], inter[54], inter[56], inter[57]);
	
	wire [63:0] result;
	csa csa00(inter[55], inter[56], inter[57], result);
	
	
	assign HI[31:0] = result[63:32];
	assign LO[31:0] = result[31:0];

endmodule 
