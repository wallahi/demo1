module mux2to1 #(parameter DATA_WIDTH = 32)
					 (input [DATA_WIDTH-1:0] a, input [DATA_WIDTH-1:0] b, input sel, output wire [DATA_WIDTH-1:0] out);
	assign out[DATA_WIDTH-1:0] = sel ? b[DATA_WIDTH-1:0] : a[DATA_WIDTH-1:0];
endmodule
