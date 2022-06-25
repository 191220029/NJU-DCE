//异步清零D触发器
module aynDff(D, clr_n, clk, Q);
	input D;
	input clr_n;
	input clk; 
	output reg Q;
	
	always @ (negedge clr_n or posedge clk) begin
		if(!clr_n) begin
				Q <= 0;
			end
		else Q <= D;
	end
endmodule 