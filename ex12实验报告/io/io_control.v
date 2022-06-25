`include "macro.v"

module io_contorl(clk, in_clk, kb_clk, input_valid, kb_input, result, result_len, ready, vga_data, buff, buff_len, finish, vga_clk, vga_hs, vga_vs, vga_blank_in, vga_r, vga_g, vga_b);
    output vga_clk;
    output		          		vga_blank_in;
	 output		     [7:0]		vga_b;
	 output		     [7:0]		vga_g;
	 output		          		vga_hs;
	 output		     [7:0]		vga_r;
	 output		          		vga_vs;
	 
	 input clk, in_clk, kb_clk;

    input input_valid;
    input [7:0] kb_input;
    
    input [1023:0] result;
    input [7:0] result_len;
    input ready;

    

    output reg [511:0] buff;
    output reg [63:0] buff_len;
    output [23:0] vga_data;
    output reg finish;

    reg [1023:0] kb_buff; // 1024 / 8 = 128
    reg [7:0] kb_pre_input;
    integer cnt;
    reg [9:0] kb_buff_front, kb_buff_rear;

    reg [7:0] ascii_in;
    reg en;
	 wire cur_ascii;
initial
begin
    cnt = 0;
    kb_buff_rear = 10'd0;
    kb_buff_front = 10'd0;
    buff = 1024'd0;
    buff_len = 64'd0;
    ascii_in = 8'd0;
    en = 1'b0;
end
    always @(posedge kb_clk)
    begin
        if(input_valid) begin
            if(kb_input == kb_pre_input && cnt < 12) begin
                cnt <= cnt + 1;
            end
            else begin
                if(kb_input != kb_pre_input) begin
                    cnt <= 0;
                    kb_pre_input <= kb_input;
                    kb_buff[kb_buff_rear+:8] <= kb_input;
                    kb_buff_rear <= kb_buff_rear + 10'd8;
                end
                else begin
                    if(cnt == 0) begin
                        kb_pre_input <= kb_input;
                        kb_buff[kb_buff_rear+:8] <= kb_input;
                        kb_buff_rear <= kb_buff_rear + 10'd8;
                    end
                    cnt <= cnt + 1;
                end
            end
        end
        else begin
            cnt <= 0;
            kb_pre_input <= 8'd0;
        end
    end


    reg [1:0] state;
    reg [1023:0] res_temp;
    reg [7:0] length_cnt, res_temp;

    
initial
begin
    state = `READ;
    length_cnt = 8'd0;
    res_temp = 8'd0;
    finish = 1'b0;
end

    wire [7:0] cur_kb_ascii;
    assign cur_kb_ascii = kb_buff[kb_buff_front+:8];
	 assign cur_ascii = result[{length_cnt[6:0], 3'd0} +: 4];
	 
	 
    always @(negedge in_clk)
    begin
        case(state)
        `READ: begin
            if(kb_buff_front != kb_buff_rear) begin
                ascii_in <= cur_kb_ascii;
                kb_buff_front <= kb_buff_front + 10'd8;
                if(cur_kb_ascii == `ENTER) begin
                    finish <= 1'b1;
                    state <= `WAIT;
                    en <= 1'b1;
                end
                else if(cur_kb_ascii == `BACKSPACE) begin
                    if(buff_len[8:0] != 9'd0) begin
                        buff[buff_len[8:0] - 9'd8 +: 8] <= `BLANK;
                        buff_len <= buff_len - 64'd8;
                        en <= 1'b1;
                    end
                    else begin
                        en <= 1'b0;
                    end
                end
                else begin
                    if(buff_len[8:0] == 9'd0) begin
                        buff <= 512'd0;
                    end
                    buff[buff_len[8:0]+:8] <= cur_kb_ascii;
                    buff_len <= buff_len + 64'd8;
                    en <= 1'b1;
                end
            end
            else begin
                en <= 1'b0;
            end
        end
        `WAIT: begin
            if(ready) begin
                state <= `RESPONSE;
                length_cnt <= result_len;
            end
            else begin
                length_cnt <= result_len;
                state <= `WAIT;
            end
            res_temp <= 8'd0;
            finish <= 1'b0;
            en <= 1'b0;
        end
        `RESPONSE: begin
            if(res_temp != length_cnt) begin
                en <= 1'b1;
                begin
                    ascii_in <= cur_ascii;
                    res_temp <= res_temp + 8'd1;
                end

                state <= `RESPONSE;
            end
            else begin
                en <= 1'b1;
                ascii_in <= `ENTER;
                state <= `READ;
                res_temp <= 8'd0;
                buff <= 1024'd0;
                buff_len <= 64'd0;
            end
        end
        endcase
    end

    picture ppp(.clk(clk), .in_clk(in_clk), .en(en), .ascii_in(ascii_in),
   .state(state), .vga_clk(VGA_CLK), .vga_hs(VGA_HS), .vga_vs(VGA_VS), .vga_blank_in(VGA_BLANK_N), .vga_r(VGA_R), .vga_g(VGA_G), .vga_b(VGA_B));


endmodule 