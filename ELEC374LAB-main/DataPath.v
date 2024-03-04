module DataPath(
	input wire clock, clear,
	input wire HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhighout, Zlowout, Yin, MARin, MDRin, MDRout, Read,
	input wire [31:0] Mdatain,
	input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	input wire ADD, SUB, SHR, SHRA, SHL, ROR, ROL, AND_, OR_, MUL, DIV, NEG, NOT_
);

	wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, MDR_, HI, LO, IR, BusMuxOut, Y, Zhi, Zlo, PC; //Output wires
	wire [63:0] Z;
	wire [4:0] alu_encode, bus_encode; 
	
	wire [31:0] MAR_hold; 	// Wires to hold MAR and MDR outputs until memory is set up 
	wire[31:0] empty;	// Wire to hold empty value
	assign empty = 32'b0;

	
//Registers
	
	register Reg0(clear, clock, R0in, BusMuxOut, R0);
	register Reg1(clear, clock, R1in, BusMuxOut, R1);
	register Reg2(clear, clock, R2in, BusMuxOut, R2);
	register Reg3(clear, clock, R3in, BusMuxOut, R3);
	register Reg4(clear, clock, R4in, BusMuxOut, R4);
	register Reg5(clear, clock, R5in, BusMuxOut, R5);
	register Reg6(clear, clock, R6in, BusMuxOut, R6);
	register Reg7(clear, clock, R7in, BusMuxOut, R7);
	register Reg8(clear, clock, R8in, BusMuxOut, R8);
	register Reg9(clear, clock, R9in, BusMuxOut, R9);
	register Reg10(clear, clock, R10in, BusMuxOut, R10);
	register Reg11(clear, clock, R11in, BusMuxOut, R11);
	register Reg12(clear, clock, R12in, BusMuxOut, R12);
	register Reg13(clear, clock, R13in, BusMuxOut, R13);	
	register Reg14(clear, clock, R14in, BusMuxOut, R14);
	register Reg15(clear, clock, R15in, BusMuxOut, R15);

	register RegPC(clear, clock, PCin, BusMuxOut, PC);
	register RegIR(clear, clock, IRin, BusMuxOut, IR);
	register RegMAR(clear, clock, MARin, BusMuxOut, MAR_hold);

	register RegHI(clear, clock, HIin, BusMuxOut, HI);
	register RegLO(clear, clock, LOin, BusMuxOut, LO);
	
	mdr MDR(clear, clock, MDRin, Read, BusMuxOut, Mdatain, MDR_);

//ALU
	
	register RY(clear, clock, Yin, BusMuxOut, Y);

	enc32to5 alu_encoder({empty[31:19], NOT_, NEG, DIV, MUL, empty[14:12], OR_, AND_, ROL, ROR, SHL, SHRA, SHR, SUB, ADD, empty[2:0]}, alu_encode);
	alu alu_z(Y, BusMuxOut, alu_encode, Zhi, Zlo);
	
	register #( 64, 64, 64'b0 ) RZ (clear, clock, Zin, {Zhi, Zlo}, Z);
	
//Bus
	
	enc32to5 bus_encoder({empty[31:22], MDRout, PCout, Zlowout, Zhighout, LOout, HIout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out}, bus_encode);
	Bus bus(R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, HI, LO, Z[63:32], Z[31:0], PC, MDR_, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, bus_encode, BusMuxOut);

endmodule
