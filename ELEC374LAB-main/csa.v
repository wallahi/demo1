module csa #(parameter DATA_WIDTH = 64)
	(input [DATA_WIDTH-1:0] A,
	input [DATA_WIDTH-1:0] B,
	input [DATA_WIDTH-1:0] C,
	output wire[DATA_WIDTH-1:0] RESULT);
	
	integer i;
	supply0 gnd;
	reg [DATA_WIDTH-1:0] carry;
	reg [DATA_WIDTH-1:0] sum;
	wire throw;
	
	// sum connections shifted right one place
	wire [DATA_WIDTH-1:0] sum_connect;
	assign sum_connect[DATA_WIDTH-2:0] = sum[DATA_WIDTH-1:1];
	assign sum_connect[DATA_WIDTH-1] = gnd;
	
	// second row of full adders, offset by one position, use carry-lookaheads
	adder64 add(carry, sum_connect, {throw, RESULT[DATA_WIDTH-1:1]});
	
	// not sure if i should be using what operators for optimization purposes, so we don't bother
	assign RESULT[0] = sum[0];
	always@(A or B or C) begin
		carry[0] = 0;
		sum[DATA_WIDTH-1] = A[DATA_WIDTH-1]^B[DATA_WIDTH-1]^C[DATA_WIDTH-1];
		for (i = 0; i < DATA_WIDTH-1; i=i+1)
		begin
			sum[i] = A[i]^B[i]^C[i];
			carry[i+1] = (A[i]&B[i]) | (A[i]&C[i]) | (B[i]&C[i]);
		end	
	end
	
endmodule 
