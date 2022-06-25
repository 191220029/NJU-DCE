module RAM1(clk, we, inaddr, outaddr, din, dout);
	input clk;
	input we;
	input [3:0]inaddr, outaddr;
	input [7:0]din;
	output reg [7:0]dout;
	
	reg [7:0] ram [15:0];
	reg [3:0] out;
	
	initial begin
		$readmemh(".\\init\\mem1.txt", ram, 0, 15);
		out = 0;
	end
	
	always @(posedge clk) begin
		if(we)
			ram[inaddr] <= din;
		out <= ram[outaddr];
		dout <= out;		//输出缓存
	end
	
	
endmodule 