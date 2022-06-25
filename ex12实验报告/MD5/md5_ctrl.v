module md5_ctrl(in_clk, indata, start, len, MD5code, finish);
input start, in_clk;
input[63:0] len;
input[511:0] indata;
output[127:0] MD5code;
output reg finish = 1'b0;

reg [63:0]lastlen = 64'd0;
reg[511:0]copedata0 = 512'b0, copedata1 = 512'b0, copedata2 = 512'b0;
reg start_cope = 1'b1, start_block = 1'b1;
reg last = 1'b0, first = 1'b0, over = 1'b0;
reg blocknop = 1'b0, times = 1'b0;
reg additional = 1'b0, last_finish = 1'b0;
reg [1:0]reset = 2'b0;

integer i = 0;

main u1(in_clk, start_cope, start_block, copedata0, copefinish, MD5code, over);

always @(posedge in_clk)	begin

	if(reset == 2'b1)	begin 
		start_cope = 1'b1;	
		start_block = 1'b1;	first = 1'b0; over = 1'b0; 
		additional = 1'b0; last_finish =1'b0;	lastlen = 64'd0; finish = 1'b0; reset = 2'b0;
	end
	if(reset > 2'b1)	reset = reset - 1;
	if(blocknop)	begin 
		start_block = 1'b0; blocknop = ~blocknop;
		if(!first)	begin 
			first = ~first; start_cope = 1'b0;	
		end			
	end
	if(additional)	begin 
		over =1'b0;	start_block =1'b0;	additional = 1'b0;	
		if(last_finish)begin
			finish = 1'b1; 	last_finish = 1'b0;	 reset = 2'b11;
		end
	end
	if (copefinish)  begin
		finish = 1'b0;
		//start_block = 1'b1;
		if(times) begin  
			times = ~times;	
			copedata0 = copedata1;
			start_block = 1'b1;
			blocknop = 1'b1;	end
		else if (last == 1'b1) begin
			last = 1'b0; over = 1'b1; start_block = 1'b1; additional = 1'b1; last_finish = 1'b1;
			
			$display("indata: %x", indata);
			$display("input: %x", copedata0);
			
		end
	end

	if (start) begin
		last = 1'b1;
		copedata0 = indata;
		if(len[8:0] < 9'd448) begin
		/*填充函数
       *处理后应满足bits≡448(mod512),字节就是bytes≡56（mode64)
       *填充方式为先加一个1,其它位补零
       *最后加上64位的原来长度
		 */
			copedata0[len[8:0] + 7] = 1'b1;
			copedata0[511:448] = len[63:0];
			start_block = 1'b1;
			blocknop = 1'b1;
		end
		else begin
			times = 1'b1;
			if(len[8:0] < 9'd504) begin
				copedata0[len[8:0] + 7] = 1'b1;
			end
			else begin
				copedata1[7] = 1'b1;
			end
			copedata1[511:448] = len[63:0];
			start_block = 1'b1;
			blocknop = 1'b1;
		end
	end
	else if(len[8:0] == 9'd0 && len!= lastlen) begin
		lastlen =len;
		copedata0 = indata;
		start_block = 1'b1;
		blocknop = 1'b1;
		end
	end
endmodule
