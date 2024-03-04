module Bus (
	// all general purpose registers idk how to do this more efficiently, i tried 2d arrays but thats a system verilog thing apparently
	input [31:0] r0, input [31:0] r1, input [31:0] r2, input [31:0] r3,
	input [31:0] r4, input [31:0] r5, input [31:0] r6,	input [31:0] r7,
	input [31:0] r8, input [31:0] r9, input [31:0] r10, input [31:0] r11,
	input [31:0] r12, input [31:0] r13,	input [31:0] r14,	input [31:0] r15,
	input [31:0] r16, input [31:0] r17,	input [31:0] r18,	input [31:0] r19,
	input [31:0] r20, input [31:0] r21, input [31:0] r22,	input [31:0] r23,
	input [31:0] r24, input [31:0] r25,	input [31:0] r26,	input [31:0] r27,
	input [31:0] r28, input [31:0] r29,	input [31:0] r30,	input [31:0] r31,
	//Encoder
	input [4:0] sel,

	output wire [31:0] BusMuxOut
);

	wire [31:0] a [3:0];
	wire [31:0] b [3:0];
	wire [31:0] ab[1:0];
	wire [31:0] q;

	mux4to1 mux0(r0, r1, r2, r3, sel[1:0], a[0]);
	mux4to1 mux1(r4, r5, r6, r7, sel[1:0], a[1]);
	mux4to1 mux2(r8, r9, r10, r11, sel[1:0], a[2]);
	mux4to1 mux3(r12, r13, r14, r15, sel[1:0], a[3]);

	mux4to1 mux4(r16, r17, r18, r19, sel[1:0], b[0]);
	mux4to1 mux5(r20, r21, r22, r23, sel[1:0], b[1]);
	mux4to1 mux6(r24, r25, r26, r27, sel[1:0], b[2]);
	mux4to1 mux7(r28, r29, r30, r31, sel[1:0], b[3]);

	mux4to1 mux8(a[0], a[1], a[2], a[3], sel[3:2], ab[0]);
	mux4to1 mux9(b[0], b[1], b[2], b[3], sel[3:2], ab[1]);

	mux2to1 mux10(ab[0], ab[1], sel[4], q);
	assign BusMuxOut = q;

endmodule
