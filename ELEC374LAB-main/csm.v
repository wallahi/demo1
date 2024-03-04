module csm #(parameter DATA_WIDTH = 64)
	// carru save module
	(input [DATA_WIDTH-1:0] A,
	input [DATA_WIDTH-1:0] B,
	input [DATA_WIDTH-1:0] C,
	output [DATA_WIDTH-1:0] out1,
	output [DATA_WIDTH-1:0] out2
	);
	
	integer i;
	
	reg [DATA_WIDTH-1:0] carry;
	reg [DATA_WIDTH-1:0] sum;
	
	// not sure if i should be using what operators for optimization purposes, so we don't bother
	always@(A or B or C) begin
		carry[0] = 0;
		sum[DATA_WIDTH-1] = A[DATA_WIDTH-1]^B[DATA_WIDTH-1]^C[DATA_WIDTH-1];
		for (i = 0; i < DATA_WIDTH-1; i=i+1)
		begin
			sum[i] = A[i]^B[i]^C[i];
			carry[i+1] = (A[i]&B[i]) | (A[i]&C[i]) | (B[i]&C[i]);
		end	
	end
	 
	assign out1[DATA_WIDTH-1:0] = sum[DATA_WIDTH-1:0];
	assign out2[DATA_WIDTH-1:0] = carry[DATA_WIDTH-1:0]; 
	
	
endmodule 
