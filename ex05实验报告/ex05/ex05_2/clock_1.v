module clock_1(clk_50M, clk_o);
	input clk_50M;	//25000000(10) = 1011111010111100001000000(2) 25位
	output reg clk_o;
	integer cnt;
	
	always @(posedge clk_50M) begin
		if(cnt == 25000000) begin 
				cnt <= 0;
				clk_o <= ~clk_o;
			end
			else cnt <= cnt + 1;
	end
	
endmodule 