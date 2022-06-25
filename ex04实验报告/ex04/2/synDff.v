//同步清零D触发器
module synDff(D, clr_n, clk, Q);
	input D;
	input clr_n;
	input clk; 
	output reg Q;
	
	always @ (posedge clk) begin
		if(!clr_n) begin
				Q <= 0;
		end
		else Q <= D;
	end
endmodule 