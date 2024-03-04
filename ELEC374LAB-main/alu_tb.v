`timescale 1ns / 1ps

module alu_tb;

// Inputs
reg [31:0] A, B;
reg [4:0] op;

// Outputs
wire [31:0] result_hi, result_lo;

// Instantiate the ALU module
alu uut (
    .A(A), 
    .B(B), 
    .op(op), 
    .result_hi(result_hi), 
    .result_lo(result_lo)
);

initial begin
    // Initialize Inputs
    A = 0; B = 0; op = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add test cases here
    // ADD operation
    A = 32'd15; B = 32'd10; op = 5'b00011; // op code for ADD
    #10; // Wait for the operation to complete
    $display("ADD Test: A=%d, B=%d, Result=%d", A, B, result_lo);

   
    // Test for SUB operation
    A = 32'd20; B = 32'd10; op = 5'b00100; // op code for SUB
    #10;
    $display("SUB Test: A=%d, B=%d, Result=%d", A, B, result_lo);

    //  add test cases for SHR, SHRA, SHL, ROR, ROL, AND, OR, MUL, DIV, NEG, NOT

    // End the simulation
    #100;
    $finish;
end

endmodule
