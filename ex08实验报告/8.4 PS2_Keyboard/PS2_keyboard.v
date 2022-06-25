
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module PS2_keyboard(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// Seg7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2
);

//module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,ready,nextdata_n,overflow); 
//module key_to_ascii(clk,data,out);
//module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,ready,nextdata_n,overflow,out)
//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [7:0]keycode;
//wire [7:0]data1;
wire [7:0]ascii;
reg [7:0]cnt = 8'h00;
reg e_out;
wire ready;
reg next_data_n = 0;

keyboard keyboard1(CLOCK_50,SW[0],PS2_CLK,PS2_DAT,keycode,ready,next_data_n,LEDR[0]);

//module kbdecoder(datain, dataout, shift_state, caps_state, ctrl_state);
kbdecoder decode1(temp, ascii, shift_state, caps_state, ctrl_state);

hex15 h0(temp[3:0],HEX0, e_out);
hex15 h1(temp[7:4],HEX1, e_out);

hex15 h2(ascii[3:0],HEX2, e_out);
hex15 h3(ascii[7:4],HEX3, e_out);


hex15 h4(cnt[3:0],HEX4, 1'b1);
hex15 h5(cnt[7:4],HEX5, 1'b1);

assign LEDR[5] = e_out;



//=======================================================
//  Structural coding
//=======================================================

reg caps_state = 0;
reg ctrl_state = 0;
reg shift_state = 0;
reg release_flag = 0;
reg [7:0]temp;

assign LEDR[9] = caps_state;
assign LEDR[8] = shift_state;
assign LEDR[7] = ctrl_state;

always@(posedge CLOCK_50) begin
	if(ready == 1 && next_data_n == 1)begin
		temp <= keycode;
		next_data_n <= 0;
		if(keycode == 8'hf0) begin//realse
			release_flag <= 1;
			cnt <= cnt + 1;
		end
		else if(keycode == 8'h12 || keycode == 8'h59) begin//shift
			if(release_flag) begin
				shift_state <= 0;
				e_out <= 0;
				release_flag <= 0;
			end
			else begin
				shift_state <= 1;
				e_out <= 1;
			end
		end
		else if(keycode == 8'h14) begin //ctrl
			if(release_flag) begin
				ctrl_state <= 0;
				e_out <= 0;
				release_flag <= 0;
			end
			else begin
				ctrl_state <= 1;
				e_out <= 1;
			end
		end
		else begin
			if(release_flag) begin
				e_out <= 0;
				release_flag <= 0;
				if(keycode == 8'h58) caps_state <= ~caps_state;
				else;
			end
			else e_out <= 1;
		end
	end
	else begin
		next_data_n <= 1;
	end
end


endmodule
