module picture(
    input	clk,
    input	reset,
    output	VGA_BLANK_N,
	 output	[7:0]VGA_R,
	 output	[7:0]VGA_B,
	 output	[7:0]VGA_G,
	 output	VGA_HS,
	 output	VGA_SYNC_N,
	 output	VGA_VS
);

wire [9:0]h_addr;
wire [9:0]v_addr;
wire hsync;
wire vsync;
wire valid;
wire [23:0]vga_data;
assign VGA_SYNC_N = 1'b0;
assign VGA_R = vga_data[23:16];
assign VGA_G = vga_data[15:8];
assign VGA_B = vga_data[7:0];
assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_BLANK_N = valid;
reg [23:0]data = 24'hffffff;
reg [18:0]addr;

vga_ctrl ctrl1(clk,reset,data,h_addr,v_addr,hsync,vsync,valid,vga_data[23:16],vga_data[15:8],vga_data[7:0]);

wire[11:0]curdata;

rimg r1(
	.address(addr),
	.clock(clk),
	.q(curdata)
);


always @(clk)
begin
    addr = v_addr + (h_addr - 1) * 18'd512 - 18'd1;
    data[3:0] <= 0;//低4位置零
    data[7:4] <= curdata[3:0];
    data[11:8] <= 0;//低4位置零
    data[15:12] <= curdata[7:4];
    data[19:16] <= 0;//低4位置零
    data[23:20] <= curdata[11:8];
end
endmodule 
