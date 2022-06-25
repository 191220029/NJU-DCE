module myALU4_2(ctrl, A, B, Y, CF, OF);
	input [2:0]ctrl;
	input [3:0]A;
	input [3:0]B;
	output reg [3:0]Y;
	output reg CF;
	output reg OF;
	integer a;
	integer b;
	reg [3:0]B_com;
	
	always @(*) begin
			CF = 0; OF = 0; Y = 0;
		case(ctrl)
			0:begin	//加法
				//Y = 4'b1111;
				{CF, Y} = A + B;
				OF = (A[3] == B[3]) && (Y[3] != A[3]);
			end
			1:begin	//减法
				//Y = 4'b1110;
				B_com = ~B + 1;
				{CF, Y} = A + B_com;
				OF = (A[3] != B[3]) && (Y[3] != A[3]);
			end
			2:begin	//取反
				Y = ~A;
				//Y = 4'b1100;
			end
			3:begin	//与
				Y = A & B;
			end
			4:begin	//或
				Y = A | B;
			end
			5:begin	//异或
				Y = A ^ B;
			end
			6:begin	//比较大小
				a = -A[3]*8+A[2]*4+A[1]*2+A[0];
				b = -B[3]*8+B[2]*4+B[1]*2+B[0];
				Y = a > b;
			end
			7:begin	//判断相等
				Y = (A == B);
			end
		endcase
	end
endmodule 