`include "macro.v"

module picture(clk, in_clk, en, ascii_in, state, vga_clk, vga_hs, vga_vs, vga_blank_in, vga_r, vga_g, vga_b);
	 output vga_clk;
    output		          		vga_blank_in;
	 output		     [7:0]		vga_b;
	 output		     [7:0]		vga_g;
	 output		          		vga_hs;
	 output		     [7:0]		vga_r;
	 output		          		vga_vs;
    input clk, en, in_clk;
    input [7:0] ascii_in;
    input [2:0] state;

    reg [23:0] vga_data;

    reg [21:0] buff[15:0];
    reg [3:0] p_rear;
    reg [3:0] mv_p_rear;
    reg [3:0] p_front;
    wire [1:0] op;
	 wire [9:0] scan_h;
    wire [9:0] scan_v;
    wire [6:0] pos_h;
    wire [4:0] pos_v;
    wire [7:0] char;

    wire [6:0] curse_h;
    wire [4:0] curse_v;

    reg [6:0] cur_h;
    reg [4:0] cur_v;
    wire [4:0] vga_v;
    wire [6:0] vga_h;
    wire [3:0] mod9, mod16;
    wire [7:0] ascii;
    wire [11:0] font;

    reg wr_en;
    reg [6:0] wr_h;
    reg [4:0] wr_v;
    reg [7:0] wr_char;

    reg [6:0] read_h;
    reg [4:0] read_v;
    wire [7:0] read_res;

    reg [6:0] next_read_h, next_curse_h;
    reg [4:0] next_read_v, next_curse_v;
    reg [6:0] next_wr_h;
    reg [4:0] next_wr_v;
    reg next_wr_en;
    reg [7:0] next_wr_char;
    reg [3:0] next_p_front;
    reg [3:0] next_p_rear;

    reg ls_en;
    reg next_ls_en;
	 reg mv_en;
	 reg next_mv_en;

    assign curse_h = next_curse_h;
    assign curse_v = next_curse_v;

    reg input_head;

	 
	 
wire hsync;
wire vsync;
wire valid;
wire [23:0]vga;
assign vga_r = vga[23:16];
assign vga_g = vga[15:8];
assign vga_b = vga[7:0];
assign vga_hs = hsync;
assign vga_vs = vsync;
assign vga_blank_in = valid;
initial
begin
    input_head = 1'b0;
    mv_p_rear = 4'd0;
    p_front = 4'd0;
    next_p_front = 4'd0;
    wr_en = 1'b0;
    next_wr_en = 1'b0;
    ls_en = 1'b0;
    next_ls_en = 1'b0;
    mv_en = 1'b0;
    next_mv_en = 1'b0;
    cur_h = 7'd0;
    next_curse_h = 7'd0;
    cur_v = 5'd0;
    next_curse_v = 5'd0;
end
     assign {op, pos_h, pos_v, char} = buff[p_front];
	// assign map_v = scan_v[8:4];
   // assign mod16 = scan_v[3:0];
	 //assign map_h = scan_h / 9;
    //assign mod9 = scan_h % 9;
	 //vga_ctrl vvv(clk0,1'b0,data,h_addr,v_addr,hsync,vsync,valid,vga[23:16],vga[15:8],vga[7:0]);
	 clkgen #(25000000) gen_vga_clk(.clkin(clk), .rst(1'b0), .clken(1'b1), .clkout(VGA_CLK));
	 vga_ctrl vc(.pclk(VGA_CLK), .reset(1'b0), .vga_data(vga_data), .h_addr(scan_h), .v_addr(scan_v), .hsync(hsync), .vsync(vsync), 
	 .valid(valid), .vga_r(vga[23:16]), .vga_g(vga[15:8]), .vga_b(vga[7:0]));
	 
    div_mod dm(.v(scan_v), .h(scan_h), .map_v(vga_v), .map_h(vga_h), .mod9(mod9), .mod16(mod16));
    ram ram1(.clock(~clk), .data(next_wr_char), .rdaddress({vga_v, vga_h}), .wraddress({next_wr_v, next_wr_h}), .wren(next_wr_en), .q(ascii));
    ram ram2(.clock(~clk), .data(next_wr_char), .rdaddress({next_read_v, next_read_h}), .wraddress({next_wr_v, next_wr_h}), .wren(next_wr_en), .q(read_res));
    rom_font rf(.address({ascii, mod16}), .clock(clk), .q(font));

//显示
    wire curse_clk;
    clkgen #(5) c1(.clkin(~clk), .rst(1'b0), .clken(1'b1), .clkout(curse_clk));
    always @*
    begin
	 //curse 
        if(curse_h == vga_h && curse_v == vga_v && mod9 == 4'b0) begin
            vga_data = curse_clk ? `PINK : 24'h000000;
        end
        else begin
            vga_data = font[mod9] ? 24'hffffff : 24'h000000;
        end
    end
//


    wire [7:0] line_start;
    assign line_start = state == `READ ? `INPUT_FLAG : `OUTPUT_FLAG;

    always @(posedge in_clk)
    begin
        if(!input_head) begin
            buff[mv_p_rear] <= {2'b01, 7'd0, 5'd0, `INPUT_FLAG};
            buff[mv_p_rear+4'd1] <= {2'b00, 7'd1, 5'd0, `BLANK};
            mv_p_rear <= mv_p_rear + 4'd2;
            input_head <= 1'b1;
        end
        else begin
            if(en) begin
                case(ascii_in)
                `ENTER: begin
                    if(curse_v == `HEIGHT - 5'd1) begin
                        buff[mv_p_rear] <= {2'b11, 7'd0, 5'd0, `BLANK};
                        buff[mv_p_rear+4'd1] <= {2'b01, 7'd0, `HEIGHT - 5'd1, line_start};
                        buff[mv_p_rear+4'd2] <= {2'b00, 7'd1, `HEIGHT - 5'd1, `BLANK};
                        mv_p_rear <= mv_p_rear + 4'd3;
                    end
                    else begin
                        buff[mv_p_rear] <= {2'b01, 7'd0, curse_v + 5'd1, line_start};
                        buff[mv_p_rear+4'd1] <= {2'b00, 7'd1, curse_v + 5'd1, `BLANK};
                        mv_p_rear <= mv_p_rear + 4'd2;
                    end
                end
                `BACKSPACE: begin
                    if(curse_h <= 7'd1) begin
                        if(curse_v != 5'd0) begin
                            buff[mv_p_rear] <= {2'b01, 7'd0, curse_v, `BLANK};
                            buff[mv_p_rear+4'd1] <= {2'b00, 7'd70, curse_v - 5'd1, `BLANK};
                            buff[mv_p_rear+4'd2] <= {2'b10, 7'd0, 5'd0, `BLANK};
                            mv_p_rear <= mv_p_rear + 4'd3;
                        end
                    end
                    else begin
                        buff[mv_p_rear] <= {2'b01, curse_h - 7'd1, curse_v, `BLANK};
                        buff[mv_p_rear+4'd1] <= {2'b00, curse_h - 7'd1, curse_v, `BLANK};
                        mv_p_rear <= mv_p_rear + 4'd2;
                    end
                end
                default: begin
                    if(curse_v == `HEIGHT - 5'd1) begin
                        if(curse_h > `WIDTH) begin
                            buff[mv_p_rear] <= {2'b11, 7'd0, 5'd0, `BLANK};
                            buff[mv_p_rear+4'd1] <= {2'b01, 7'd0, `HEIGHT - 5'd1, `CONCAT_FLAG};
                            buff[mv_p_rear+4'd2] <= {2'b01, 7'd1, `HEIGHT - 5'd1, ascii_in};
                            buff[mv_p_rear+4'd3] <= {2'b00, 7'd2, `HEIGHT - 5'd1, 8'd0};
                            mv_p_rear <= mv_p_rear + 4'd4;
                        end
                        else begin
                            buff[mv_p_rear] <= {2'b01, curse_h, curse_v, ascii_in};
                            buff[mv_p_rear+4'd1] <= {2'b00, curse_h + 7'd1, curse_v, `BLANK};
                            mv_p_rear <= mv_p_rear + 4'd2;
                        end
                    end
                    else begin
                        if(curse_h > `WIDTH) begin
                            buff[mv_p_rear] <= {2'b00, 7'd0, curse_v + 5'd1, `CONCAT_FLAG};
                            buff[mv_p_rear+4'd1] <= {2'b01, 7'd1, curse_v + 5'd1, ascii_in};
                            buff[mv_p_rear+4'd2] <= {2'b00, 7'd2, curse_v + 5'd1, `BLANK};
                            mv_p_rear <= mv_p_rear + 4'd3;
                        end
                        else begin
                            buff[mv_p_rear] <= {2'b01, curse_h, curse_v, ascii_in}; 
                            buff[mv_p_rear+4'd1] <= {2'b00, curse_h + 7'd1, curse_v, `BLANK};
                            mv_p_rear <= mv_p_rear + 4'd2;
                        end
                    end
                end
                endcase
            end
        end
    end



    always @(posedge clk)
    begin
        read_h <= next_read_h;
        read_v <= next_read_v;
        wr_h <= next_wr_h;
        wr_v <= next_wr_v;
        wr_en <= next_wr_en;
        cur_h <= next_curse_h;
        cur_v <= next_curse_v;
        wr_char <= read_res;
        p_front <= next_p_front;
        p_rear <= mv_p_rear;
        ls_en <= next_ls_en;
		mv_en <= next_mv_en;
    end


    always @(*)
    begin
		next_wr_h = wr_h;
		next_wr_v = wr_v;
		next_wr_en = 1'b0;
		next_wr_char = wr_char;
		next_read_h = read_h;
		next_read_v = read_v;
		next_curse_h = cur_h;
		next_curse_v = cur_v;
		next_p_front = p_front;
        next_p_rear = p_rear;
		next_ls_en = 1'b0;
		next_mv_en = 1'b0;
        if(p_rear != p_front) begin
            case(op)
            2'b00: begin
                next_curse_h = pos_h;
                next_curse_v = pos_v;
                next_p_front = p_front + 4'b1;
            end
            2'b01: begin
                next_wr_h = pos_h;
                next_wr_v = pos_v;
                next_wr_en = 1'b1;
                next_wr_char = char;
                next_p_front = p_front + 4'b1;
            end
            2'b10: begin
                if(cur_h == 7'b0) begin
                    next_ls_en = 1'b0;
                    next_p_front = p_front + 4'b1;
                end
                else begin
                    if(!ls_en) begin
                        next_ls_en = 1'b1;
						next_read_h = cur_h - 7'd1;
						next_read_v = cur_v;
                    end
                    else begin
                        if(wr_char != 8'b0) begin
                            next_ls_en = 1'b0;
                            next_p_front = p_front + 3'b1;
                        end
						else begin
							next_ls_en = 1'b1;
							next_curse_h = cur_h - 7'd1;
							next_read_h = read_h == 7'd0 ? 7'd0 : read_h - 7'd1;
						end
                    end
                end
            end
            2'b11: begin
				if(!mv_en) begin
					next_read_h = 0;
					next_read_v = 1;
					next_wr_h = 7'h7f;
					next_wr_v = 0;
					next_wr_en = 1'b0;
					next_mv_en = 1'b1;
				end
				else begin
					if(wr_v == `HEIGHT - 5'd1) begin
						if(wr_h == `WIDTH) begin
							next_mv_en = 1'b0;
							next_wr_en = 1'b0;
                            next_p_front = p_front + 4'b1;
						end
						else begin
							next_mv_en = 1'b1;
							next_wr_en = 1'b1;
							next_wr_char = 8'd0;
							next_wr_h = wr_h + 7'd1;
						end
					end
					else begin
                        next_mv_en = 1'b1;
                        next_wr_en = 1'b1;
                        next_wr_char = wr_char;
						if(wr_h == `WIDTH) begin
							next_wr_h = 7'd0;
							next_wr_v = wr_v + 5'd1;
						end
                        else begin
                            next_wr_h = wr_h + 7'd1;
                            next_wr_v = wr_v;
                        end
                        if(read_h == `WIDTH) begin
                            next_read_h = 7'd0;
                            next_read_v = next_read_v == 5'd29 ? read_v : next_read_v + 5'd1;
                        end
                        else begin
                            next_read_h = read_h + 7'd1;
                            next_read_v = read_v;
                        end
					end
				end
            end
            endcase
        end
        else begin
            next_ls_en = 1'b0;
            next_mv_en = 1'b0;
            next_wr_en = 1'b0;
        end
    end

	 
	 
endmodule 