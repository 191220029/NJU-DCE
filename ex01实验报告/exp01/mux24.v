module mux24(X, Y, F);
	input [7:0] X;
	input [1:0] Y;
	output reg [1:0]F;
	
	always @(*)
		case (Y)
			0: F=X[1:0];
			1: F=X[3:2];
			2: F=X[5:4];
			3: F=X[7:6];
			default: F = 2'b00;
		endcase
endmodule 