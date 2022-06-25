module main(clk, start, blockstart, indata, finish, MD5code, over);
input clk, start, blockstart, over;
input[511:0] indata;
output reg finish = 1'b0;
output[127:0] MD5code;

localparam endrounds = 7'd64; //run 4 rounds to encode


reg[127:0] linkvar;
initial begin
    linkvar[31:0] = 32'h67452301;
    linkvar[63:32] = 32'hefcdab89;
    linkvar[95:64] = 32'h98badcfe;
    linkvar[127:96] = 32'h10325476;
end

reg[31:0] a, b, c, d;
reg[31:0] a_next, b_next, c_next, d_next;
reg[31:0] init_a, init_b, init_c, init_d;
reg[31:0] init_a_next, init_b_next, init_c_next, init_d_next;
wire[31:0] result1, result2, result3, result4;
reg[31:0] Atemp, Btemp, Ctemp, Dtemp;
reg[6:0] cnt;
reg[6:0] ncnt;

wire[1:0] round_cnt; //第几轮 0~3
wire[3:0] in_round; //该轮中的第几次

assign round_cnt = cnt[5:4];
assign in_round = cnt[3:0];

round1 r1(.indata(indata), .in_round(in_round), .link_var({ d, c, b, a }), .result(result1));
round2 r2(.indata(indata), .in_round(in_round), .link_var({ d, c, b, a }), .result(result2));
round3 r3(.indata(indata), .in_round(in_round), .link_var({ d, c, b, a }), .result(result3));
round4 r4(.indata(indata), .in_round(in_round), .link_var({ d, c, b, a }), .result(result4));

integer i = 0;

always @(posedge clk)
begin
    Atemp = a_next + init_a;
    Btemp = b_next + init_b;
    Ctemp = c_next + init_c;
    Dtemp = d_next + init_d;
    a <= (start | blockstart) ? (start ? linkvar[31:0] : Atemp) : a_next;
    b <= (start | blockstart) ? (start ? linkvar[63:32] : Btemp) : b_next;
    c <= (start | blockstart) ? (start ? linkvar[95:64] : Ctemp) : c_next;
    d <= (start | blockstart) ? (start ? linkvar[127:96] : Dtemp) : d_next;
    init_a <= (start | blockstart) ? (start ? linkvar[31:0] : Atemp) : init_a_next;
    init_b <= (start | blockstart) ? (start ? linkvar[63:32] : Btemp) : init_b_next;
    init_c <= (start | blockstart) ? (start ? linkvar[95:64] : Ctemp) : init_c_next;
    init_d <= (start | blockstart) ? (start ? linkvar[127:96] : Dtemp) : init_d_next;
    //i = i + 1;
    if (finish)  finish = ~finish;
    else if (cnt >= endrounds && i >= 63)  begin 
		finish = 1'b1; i = 0;
	 end
    else finish = 1'b0;
    cnt <= (blockstart && ~over) ? 7'd0 : ncnt;
	 
    $display("%d: a=%x b=%x c=%x d=%x", i, a, b, c, d);
	 
    i <= blockstart ? 0 : i + 1;
end

always @(*) begin
    init_a_next = init_a;
    init_b_next = init_b;
    init_c_next = init_c;
    init_d_next = init_d;
end

always @(*) begin
	if(cnt < endrounds) begin
		a_next = d;
		d_next = c;
		c_next = b;
		if(cnt <= 7'd15)
			b_next = b + result1;
		else if(cnt <= 7'd31)
			b_next = b + result2;
		else if(cnt <= 7'd47)
			b_next = b + result3;
		else if(cnt <= 7'd63)
			b_next = b + result4;
	end
	else begin
		 a_next = a;
		 b_next = b;
		 c_next = c;
		 d_next = d;
	end
end

always @(*) begin
	if (cnt >= endrounds) begin
		ncnt = cnt;
	end
	else
		ncnt = cnt + 6'd1;
end

assign MD5code = { a, b, c, d };

endmodule
