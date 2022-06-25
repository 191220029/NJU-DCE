module counter_mod100(clk, en, clr_n, num1, num0, rco);
	input clk, en, clr_n;
	output reg [3:0]num1;
	output reg [3:0]num0;
	output reg rco;
	integer cnt;

initial begin
	cnt = 0;
end
	
	always @(posedge clk or negedge clr_n) begin
		if(!clr_n) begin //异步清零
		cnt <= 0; rco <= 0;
		end
		else begin
			if(en) //计数 
				if(cnt == 99) begin
					cnt <= 0; rco <= 1;
				end
				else begin 
					cnt <= cnt + 1;
					rco <= 0;
				end
			else cnt <= cnt;//暂停
		end
		//输出
		num1 <= cnt / 10;
		num0 <= cnt % 10;
	end
endmodule 