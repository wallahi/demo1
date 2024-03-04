module mdr #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
	input clear, clock, mdrin, read,
	input [DATA_WIDTH_IN-1:0]BusMuxOut,
	input [DATA_WIDTH_IN-1:0]Mdatain,
	output wire [DATA_WIDTH_OUT-1:0]MDROut
);
	reg [DATA_WIDTH_IN-1:0]q;
	wire [31:0] mdmux_result;
	initial q = INIT;

	mux2to1  mdmux( BusMuxOut, Mdatain, read, mdmux_result);

	always @ (posedge clock)
		begin 
			if (clear) begin
				q <= {DATA_WIDTH_IN{1'b0}};
			end
			else if (mdrin) begin
					q <= mdmux_result;
			end
		end
	assign MDROut = q[DATA_WIDTH_OUT-1:0];
endmodule
