module alu(input wire [31:0] A, B, input wire [4:0] op, output reg[31:0] result_hi, result_lo);
	integer i;
    	integer tempB;
		
	wire [31:0] negate_result, add_result, subtract_result, multiply_result_hi, multiply_result_lo,  divide_result_hi, divide_result_lo, negate_b_result;
	
	adder add_instance(A, B, add_result);
	adder negate_b_instance(~B, 1, negate_b_result);
	adder subtract_instance(A, negate_b_result, subtract_result);
	multiplier multiply_instance(A, B, multiply_result_hi, multiply_result_lo);
	divide divide_instance(A, B, divide_result_lo, divide_result_hi);
	adder negate_instance(~A, 1, negate_result);

	always @(*) begin
		result_hi = 32'b0;
		tempB = B[5:0];
		case(op)
			3 	:	result_lo = add_result;			// Add
			4 	:	result_lo = subtract_result;    	// Subtract
			5	:	begin		                        // Shift Right
						if (B > 31) begin
							result_lo = {32'b0};
						end
						else begin
			            			result_lo = {1'b0, A[31:1]};
			            			for(i=1; i < tempB; i=i+1) begin
			                			result_lo = {1'b0, result_lo[31:1]};
			           	 		end
						end
			        	end
			6	:	begin		                        // Shift Right Arithmetic

						if (B > 31) begin
							result_lo = A[31] ? 32'hFFFFFFFFFFFF : 32'h0;
						end
						else begin
							result_lo = {A[31], A[31:1]};
			            			for(i=1; i < tempB; i=i+1) begin
			                			result_lo = {A[31], result_lo[31:1]};
			            			end
						end
			        	end
			7	:	begin		                        // Shift Left

						if (B > 31) begin
							result_lo = {32'b0};
						end
						else begin
			            			result_lo = {A[30:0], 1'b0};
			            			for(i=1; i < tempB; i=i+1) begin
			                			result_lo = {result_lo[30:0], 1'b0};
			            			end
						end
			        	end
			8	:	begin		                        // Rotate Right
			            		result_lo = {A[0], A[31:1]};
			            		for(i=1; i < tempB; i=i+1) begin
			                		result_lo = {result_lo[0], result_lo[31:1]};
			            		end
			        	end
			9	:	begin		                        // Rotate Left
			            		result_lo = {A[30:0], A[31]};
			            		for(i=1; i < tempB; i=i+1) begin
			                		result_lo = {{result_lo[30:0], result_lo[31]}};
			            		end
			        	end
			10	:	result_lo = A & B;			// AND	
			11	:	result_lo = A | B;			// OR
			15	:	begin					// Multiply
						result_lo = multiply_result_lo;		
						result_hi = multiply_result_hi;
					end
			16	:	begin					// Divide
						result_lo = divide_result_lo;		
						result_hi = divide_result_hi;
					end
			17	:	result_lo = negate_b_result;	// Negate
			18	:	result_lo = ~B;		// NOT

			default: result_lo = A & B;
		endcase
	end
endmodule
