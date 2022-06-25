module s_ALU4(ctrl, A, B, C, out_c, overflow, isZero);
	input ctrl;
	input [3:0]A;
	input [3:0]B;
	output reg [3:0]C;
	output reg out_c;
	output reg overflow;
	output reg isZero;
	reg [3:0]B_com;
	
	always @(*) begin
		isZero = 0;
		if(ctrl == 0) //加法
		begin
			{out_c, C} = A + B;
			overflow = (A[3] == B[3]) && (C[3] != A[3]);
			isZero = ~(|C);
		end
		else begin // 减法
			B_com = ~B + 1;
			{out_c, C} = A + B_com;
			overflow = (A[3] != B[3]) && (C[3] != A[3]);
			isZero = ~(|C);
		end
	end
endmodule 