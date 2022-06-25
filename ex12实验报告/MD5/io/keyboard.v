module keyboard(clk, ps2_clk, ps2_data, ascii, valid);
    input clk, ps2_clk, ps2_data;
    output [7:0] ascii;
    output valid;
    wire [7:0] data;
    wire ready, overflow;
    wire [7:0] cur_data;


//in_info: 某键是否被按下
//move_next: 当前周期是否读入了新的数据

    reg [256:0] cur_in_info = 256'b0, next_in_info = 256'b0;
    reg cur_end_mark = 0, next_end_mark = 0,  cur_move_next = 0, next_data_next = 0;
    reg [7:0] next_show_data = 8'b0, cur_show_data = 8'b0;
    reg cur_shift = 0, next_shift = 0;
	 reg cap = 1;
//两段式状态机：用两个always块来描述状态转移和输出的状态机
//有两个always块;第一个always块使用时序逻辑，描述现态跳转到次态;
//第二个always块使用组合逻辑，判断状态转移条件，描述状态转移以及当前状态的输出

/* 现态逻辑 */
    ps2_keyboard ps2_kbd(.clk(clk), .clrn(1'b1), .ps2_clk(ps2_clk), .ps2_data(ps2_data),
	 .data(data), .ready(ready), .nextdata_n(~next_data_next), .overflow(overflow));

    always @(posedge clk) begin
        cur_in_info <= next_in_info;
        cur_end_mark <= next_end_mark;
        cur_show_data <= next_show_data;
        cur_shift <= next_shift;
		  cur_move_next <= next_data_next;
    end

/* 次态逻辑 */
    always @* begin
        next_end_mark = cur_end_mark;
        next_in_info = cur_in_info;
        next_show_data = cur_show_data;
        next_shift = cur_shift;
		  next_data_next = ready;

        //读取数据
        if(ready) begin
            if(data == 8'hf0) next_end_mark = 1'b1;
            else begin
                next_show_data = data;
                if(cur_end_mark) begin 
                    next_in_info[data] = 1'b0;
                    next_show_data = 8'hff;
                    next_end_mark = 1'b0;

                    if(data == 8'h12 || data == 8'h59) begin
                        next_shift = 1'b0;
                    end
						  //if(data == 8'h58) begin
                       // cap = ~cap;
                   // end
                end
                else if(!cur_in_info[data]) begin
                    next_in_info[data] = 1'b1;
                    if(data == 8'h12 || data == 8'h59) begin
                        next_shift = 1'b1;
                    end
						  /*if(data == 8'h58) begin
                        cap = ~cap;
                    end*/
						  
                end
                else begin
                end
                next_end_mark = 1'b0;
            end
        end
        else begin
            next_show_data = cur_show_data;
        end
    end

	 
    assign cur_data = next_show_data;
    data_2_asc d2a(.cap(cap), .shift(next_shift), .data(cur_data), .ascii(ascii));
    assign valid = ascii != 8'd0;
endmodule 