module vga_char(
	input clk,
	output VGA_CLK,
	input [7:0]ascii_in, 
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);

wire [9:0]h_addr;
wire [9:0]v_addr;
wire hsync;
wire vsync;
wire valid;
wire [23:0]vga;
assign VGA_SYNC_N = 1'b0;
assign VGA_R = vga[23:16];
assign VGA_G = vga[15:8];
assign VGA_B = vga[7:0];
assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_BLANK_N = valid;
reg [23:0]data = 24'hffffff;

wire [8:0]font;		//data read from lattic
reg [11:0]address;	//address for lattice
reg [11:0]block_addr = 0;	//address for ram(read)
reg [7:0] ascii_data;	//data for ram(write)
reg wen = 1;	//write enable for ram

reg [11:0]index = 0; //current position of current line
reg [11:0]ram_index[29:0]; //store the end position of each line
reg [11:0]preindex;	//ending of last line

wire [7:0]ram_vga_ret; //data read from ram
wire clk_vga;	//clk for vgactrl
wire clk_keyboard;	//clk for receive ascii from keyboard
wire clk_cursur;	//clk for showing the curser
assign VGA_CLK = clk_vga;
wire [7:0]cur_ascii;
reg backspace_state = 1;
reg enter_state = 1;
reg [3:0]cnt = 0;
//reg [7:0]preascii;
clkgen #25000000 c(clk,1'b0,1'b1,clk_vga);
clkgen #40 c2(clk,1'b0,1'b1,clk_keyboard);
clkgen #5 cursur_clk(clk,1'b0,1'b1,clk_cursur);

vga_ctrl v_C(clk_vga,1'b0,data,h_addr,v_addr,hsync,vsync,valid,vga[23:16],vga[15:8],vga[7:0]);
lattice rf(.address(address),.clock(clk_vga),.q(font));
//ram_vga rv(block_addr,index,clk_vga,clk_keyboard,1'b0,ascii_data,1'b0,1'b1,ram_vga_ret);
//ram_vga rv(block_addr,index - 1,clk_vga,clk_keyboard,1'b0,ascii_data,1'b0,1'b1,ram_vga_ret);
ram_vga rv(block_addr,index,clk_vga,clk_keyboard,1'b0,ascii_data,1'b0,wen,ram_vga_ret);



always @(posedge clk_keyboard)begin
	if(index < 12'd70)begin
		preindex <= 0;
	end
	else begin
		preindex <= ram_index[(index/70)-1];
	end
end



always @(posedge clk_vga)begin
    block_addr <= (v_addr >> 4) * 70 + ((h_addr) / 9);
	 address <= (ram_vga_ret << 4) + (v_addr % 16);
	 
	 //show the cursor
	 //cursor is at the end of current line
	 if(v_addr > (index / 70) * 16 && v_addr < (1 + index / 70) * 16
		&& h_addr > (index % 70 + 1) * 9 + 5 && h_addr < (index % 70 + 2) * 9)
		if(clk_cursur) data <= 24'hffffff;
		else data <= 24'h000000;
	
	//show the font
	 else if(font[(h_addr + 2) % 9] == 1'b1)
		data <= 24'hffffff;
	 else
		data <= 24'h000000;
		
	//current line: (index - 1)/70
	//cursur pos: (index - 1) % 70
end	

reg [7:0]ascii;
reg [2:0]cnt_c;
always @(posedge clk_keyboard)begin 
	if(cnt_c == 3'd12) begin
		cnt_c <= 3'd0;
		ascii <= ascii_in;
	end
	else cnt_c <= cnt_c + 3'd1;
end

always @(posedge clk_keyboard) begin
    if(ascii != 0) 
		begin
			if(cnt == 0 ) //short hit
			begin
				if(ascii == 8'h0d)begin//hit enter
					 backspace_state <= 0;
					 //store this line's ending position
					 ram_index[index/70] <= index + 1;
					 //move cursur to next line
                index <= index + 70 - (index % 70);
					 //index <= index + 70 - (index % 70) + 1;
					 enter_state <= 0;
				end
				else if (ascii == 8'h08) begin//hit backspace
						if(backspace_state == 0)begin
							index <= index - 1;
							backspace_state <= 1'b1;
						end
						else begin //backspace_state == 1'b0
							if(index % 70 == 0)begin
								//return to last line's end
								index <= preindex;
							end
							else begin
								//delete one char
								index <= index - 1;
							end
						end
					 end
				else begin//hit key
					 if(backspace_state == 1 || enter_state == 0)
						index <= index; //deleting or changing line avoid writing ram
					 else begin
						if((index + 1) % 70 == 0)begin
							//current line is to be full
							ram_index[(index - 1) / 70] <= index;
						end begin
							if(ascii == 8'h38) begin 
								//move cursur to last line
								index <= index - 70;
								wen = 0;
							end
							else if(ascii == 8'h32) begin
								//move cursur to next line
								//store this line's ending position
								ram_index[index / 70] <= index + 1;
								//backspace_state <= 1;
								index <= index + 70;
								wen = 0;
							end
							else if(ascii == 8'h34) begin
								//left move cursur
								index <= index - 1;
								wen = 0;
							end
							else if(ascii == 8'h36) begin 
								//right move  cursur
								index <= index + 1;
								wen = 0;
							end
							else if(ascii == 8'h14)begin
								//skip caps_lock
								wen = 0;
								index <= index;
							end
							else begin
								//add one char
								wen = 1;
								index <= index + 1;
							end
						end
					 end
					 backspace_state <= 0;
					 enter_state <= 1;
				end
				cnt <= cnt + 1;
			end
			else if(cnt == 4'd15)begin //long press
						if(ascii == 8'h0d)  //enter
							index <= index + 70 - (index % 70) - 1;
						else if (ascii == 8'h08)begin //backspace
							if(index % 70 == 0)begin
								//this line has nothing left, ret to last line
								index <= preindex;
							end
							else begin
								//delete one char
								index <= index - 1;
							end
						end
					else begin
						if((index + 1) % 70 == 0)begin //end of line
							//store this line's ending position
							ram_index[(index-1)/70] <= index; 
						end							
							if(ascii == 8'h38) begin 
								//move cursur to last line
								index <= index - 70;
								wen = 0;
							end
							else if(ascii == 8'h32) begin
								//move cursur to next line
								//store this line's position
								ram_index[index/70] <= index + 1;
								//backspace_state <= 1;
								index <= index + 70;
								wen = 0;
							end
							else if(ascii == 8'h34) begin
								//left move cursur
								index <= index - 1;
								wen = 0;
							end
							else if(ascii == 8'h36) begin 
								//right move  cursur
								index <= index + 1;
								wen = 0;
							end
							else if(ascii == 8'h14)begin
								//skip caps_lock
								wen = 0;
								index <= index;
							end
							else begin
								//add one char
								wen = 1;
								index <= index + 1;
							end
						end
					end
			else begin //waiting if long press
				index <= index;
				cnt <= cnt + 1;
			end
			ascii_data <= ascii;
		end
	
    else begin //reset cnt		  
        index <= index;
		  cnt <= 0;
	 end

	if(index >= 2100) //return to the start of the page if reaching the end
        index <= 0;
end

endmodule 