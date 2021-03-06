module ShiftReg(ctrl, data_in, clk, Q);
	input [2:0]ctrl;
	input [7:0]data_in;
	input clk;
	output reg [7:0]Q;
	
initial begin
	Q = 0;
end

	always @(posedge clk) begin
		case(ctrl)
			0: begin//清零
				Q <= 0;
			end
			1: begin //置数
				Q <= data_in;
			end
			2: begin//逻辑右移
				Q <= {1'b0, Q[7:1]};
			end
			3: begin//逻辑左移
				Q <= {Q[6:0], 1'b0};
			end
			4: begin//算数右移
				Q <= {Q[7], Q[7:1]};
			end
			5: begin //左端串行输入1位值，并行输出8位值
				Q <= {data_in[0], Q[7:1]};
			end
			6: begin //循环右移
				Q <= {Q[0], Q[7:1]};
			end
			7: begin //循环左移
				Q <= {Q[6:0], Q[7]};
			end
			default:Q <= Q;
		endcase
	end

endmodule 