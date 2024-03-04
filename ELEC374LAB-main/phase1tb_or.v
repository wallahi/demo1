`timescale 1ns/10ps
module phase1tb_or();
	
	// misc reg ctrl sig
	reg PCout, MDRout, Zhighout, Zlowout, HIout, LOout;
	
	// register outputs
	reg R0out, R1out, R2out, R3out, R4out,
		 R5out, R6out, R7out, R8out, R9out,
		 R10out, R11out, R12out, R13out, R14out, R15out;
	
	// other register control signals
	reg PCin, MARin, MDRin, IRin, Zin, Yin, HIin, LOin; 
	reg IncPC, Read;
	
	// alu control
	reg AND, OR, SHR, SHRA, SHL, ROR, ADD, SUB, MUL, DIV, ROL, NEG, NOT; 
	
	// register inputs
	reg R0in, R1in, R2in, R3in, R4in,
		 R5in, R6in, R7in, R8in, R9in,
		 R10in, R11in, R12in, R13in, R14in, R15in;
	reg Clock, Clear;
	reg [31:0] Mdatain; 

	parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011, 
		Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111, 
		T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
	reg [3:0] Present_state = Default;
 
DataPath DUT(Clock, Clear, HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhighout, Zlowout, Yin, MARin, MDRin, MDRout, Read, Mdatain[31:0], 
	R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	ADD, SUB, SHR, SHRA, SHL, ROR, ROL, AND, OR, MUL, DIV, NEG, NOT);
// add test logic here

initial 
	begin
	Clock = 0;
	Clear = 0;
end 
always #10 Clock = ~ Clock;

always @(posedge Clock) // finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default : Present_state = Reg_load1a;
		Reg_load1a : Present_state = Reg_load1b;
		Reg_load1b : Present_state = Reg_load2a;
		Reg_load2a : Present_state = Reg_load2b;
		Reg_load2b : Present_state = Reg_load3a;
		Reg_load3a : Present_state = Reg_load3b;
		Reg_load3b : Present_state = T0;
		T0 : Present_state = T1;
		T1 : Present_state = T2;
		T2 : Present_state = T3;
		T3 : Present_state = T4;
		T4 : Present_state = T5;
 endcase
 end
 
always @(Present_state) // do the required job in each state
begin
	case (Present_state) // assert the required signals in each clock cycle
	Default: begin
	PCout <= 0; Zhighout <= 0; Zlowout <= 0; HIout <= 0; LOout <= 0; MDRout <= 0; // initialize the signals
	
	R0out <= 0; R1out <= 0; R2out <= 0; R3out <= 0; R4out <= 0;
	R5out <= 0; R6out <= 0; R7out <= 0; R8out <= 0; R9out <= 0;
	R10out <= 0; R11out <= 0; R12out <= 0; R13out <= 0; R14out <= 0; R15out <= 0;
	
	IncPC <= 0; Read <= 0;
	AND <= 0; OR <= 0; SHR <= 0; SHRA <= 0; SHL <= 0;
	ROR <= 0; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0;
	ROL <= 0; NEG <= 0; NOT <= 0;
	
	MARin <= 0; Zin <= 0; Yin <= 0; HIin <= 0; LOin <=0; 
	PCin <=0; MDRin <= 0; IRin <= 0; 
	
	R0in <= 0; R1in <= 0; R2in <= 0; R3in <= 0; R4in <= 0;
	R5in <= 0; R6in <= 0; R7in <= 0; R8in <= 0; R9in <= 0;
	R10in <= 0; R11in <= 0; R12in <= 0; R13in <= 0; R14in <= 0; R15in <= 0;
	Mdatain <= 32'h00000000;
end
	Reg_load1a: begin 
	Mdatain <= 32'h00000012;
	#5 Read = 0; MDRin = 0; // the first zero is there for completeness
	#10 Read <= 1; MDRin <= 1; 
 
end
	Reg_load1b: begin
	#5 Read <= 0; MDRin <= 0;
	#10 MDRout <= 1; R2in <= 1; // initialize R2 with the value h12 
	
end
	Reg_load2a: begin 
	Mdatain <= 32'h00000014;
	#5 MDRout <= 0; R2in <= 0;
	#10 Read <= 1; MDRin <= 1;   
end
	Reg_load2b: begin
	#5 Read <= 0; MDRin <= 0;
	#10 MDRout <= 1; R3in <= 1; 
	// initialize R3 with the value h14 
end
	Reg_load3a: begin 
	Mdatain <= 32'h00000018;
	#5 MDRout <= 0; R3in <= 0;
	#10 Read <= 1; MDRin <= 1; 
end
	Reg_load3b: begin
	#5 Read <= 0; MDRin <= 0;
	#10 MDRout <= 1; R8in <= 1; 
	// initialize R1 with the value h18 
end
T0: begin // Start of instruction fetch
    #5 MDRout <= 0; R1in <= 0;
    #10 PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
end
T1: begin // Load instruction to MDR
    #5 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
    #10 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
    Mdatain <= 32'h58C60000; // opcode for “or R1, R2, R3” with the rest of the bits set to 0
end
T2: begin // Write instruction to IR
    #5 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
    #10 MDRout <= 1; IRin <= 1;
end
T3: begin // Output R2 to the bus
    #5 MDRout <= 0; IRin <= 0;
    #10 R2out <= 1; Yin <= 1;
end
T4: begin // Perform the OR operation with R3
    #5 R2out <= 0; Yin <= 0;
    #10 R3out <= 1; OR <= 1; Zin <= 1;
end
T5: begin // Write result to R1
    #5 R3out <= 0; OR <= 0; Zin <= 0;
    #10 Zlowout <= 1; R1in <= 1;
end
endcase
end
endmodule 
