module round1(indata, in_round, link_var, result);
	input [511:0] datain;
	input [3:0] rounds;
	input [127:0] link_var;
	output [31:0] result;

	wire [31:0] A, B, C, D;
	wire [31:0] F;
	wire [31:0] K, M;
	wire [4:0] S;
	wire [3:0] g;

	assign A = link_var[31:0];
	assign B = link_var[63:32];
	assign C = link_var[95:64];
	assign D = link_var[127:96];

	

	K_ROM getK1(.cnt({2'd0, rounds}), .K(K));
	S_ROM getS1(.cnt({2'd0, rounds}), .S(S));

	assign g = rounds;
	assign M = datain[{g, 5'd0} +: 32]; 
	// +: 变量[起始地址 +: 数据位宽] <–等价于–> 变量[(起始地址+数据位宽-1)：起始地址]
	//变量[结束地址 -: 数据位宽] <–等价于–> 变量[结束地址：(结束地址-数据位宽+1)]
	assign F = ((B & C) | (~B & D)) + A + K + M;

	LRotate lr1(.in(F), .s(S), .out(result));
    
endmodule 