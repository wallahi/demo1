// Ripple Carry Adder
module adder64 #(parameter DATA_WIDTH = 64)(A, B, Result);

input [DATA_WIDTH-1:0] A, B;
output [DATA_WIDTH-1:0] Result;

reg [DATA_WIDTH-1:0] Result;
reg [DATA_WIDTH:0] LocalCarry;

integer i;

always@(A or B)
	begin
		LocalCarry = 128'd0;
		for(i = 0; i < DATA_WIDTH; i = i + 1)
		begin
				Result[i] = A[i]^B[i]^LocalCarry[i];
				LocalCarry[i+1] = (A[i]&B[i])|(LocalCarry[i]&(A[i]|B[i]));
		end
end
endmodule
