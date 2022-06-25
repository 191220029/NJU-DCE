
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module exp10audio(

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

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
//---->keyboard---->
wire [7:0]keycode;
reg e_out;
wire ready;
reg next_data_n = 0;
reg [7:0]temp;
reg release_flag = 0;
//wire [7:0]kout;
//-------<----------

//------->i2------->
wire clk_i2c;
wire reset;
wire [15:0] freq;
reg [15:0] freqr;
wire [15:0] audiodata;

integer Q0 = 0; //no valid input
integer Q1 = 1; //one valid input
integer Q2 = 2; //two valid input
integer Q3 = 3; 
integer state = 0;
integer a1 = 65536;
integer a2 = 48000;

reg [7:0] key0;
reg [7:0] key1;
reg [7:0] key2;
//-------<----------

//=======================================================
//  Structural coding
//=======================================================

//---->keyboard---->
assign LEDR[5] = e_out;
keyboard keyboard1(CLOCK_50,SW[0],PS2_CLK,PS2_DAT,keycode,ready,next_data_n,LEDR[0]);
hex15 h0(temp[3:0],HEX0, 1'b1);
hex15 h1(temp[7:4],HEX1, 1'b1);
hex15 h2(keycode[3:0],HEX2, 1'b1);
hex15 h3(keycode[7:4],HEX3, 1'b1);
hex15 h4(key0[3:0],HEX4, 1'b1);
hex15 h5(key0[7:4],HEX5, 1'b1);

reg neflag = 0;

reg [15:0]rom_freq[255:0];
initial begin
	$readmemh(".\\init\\key2Hz.txt", rom_freq, 0, 255);
end


always@(posedge CLOCK_50) begin
	if(ready == 1 && next_data_n == 1)begin
	//if(ready == 1)beginf
		if(temp != keycode) neflag = 1;
		else;
		temp <= keycode;
		next_data_n <= 0;
		if(keycode == 8'hf0) begin//realse
			release_flag <= 1;
			//temp <= keycode;
			case(state)
				Q0: state <= Q0;
				Q1: state <= Q0;
				Q2: state <= Q1;
				Q3: state <= Q2;
				default: state <= Q0;
			endcase;
		end
		else begin
			if(release_flag) begin
				e_out <= 0;
				release_flag <= 0;
				if(key0 == keycode) begin
					key0 = key1;
					key1 = key2;
					key2 = 0;
				end
				else if(key1 == keycode) begin
					key1 = key2;
					key2 = 0;
				end
				else if(key2 == keycode)begin
					key2 = 0;
				end
				else;
			end
			else begin
				e_out <= 1;
				if(neflag) begin
					case(state)
						Q0: begin state <= Q1; 	key0 = keycode; end
						Q1: begin state <= Q2;	key1 = key0; key0 = keycode; end
						Q2: begin state <= Q3;	key2 = key1; key1 = key0; key0 = keycode; end
						Q3: begin state <= Q3; 	key2 = key1; key1 = key0; key0 = keycode; end
						default: state <= 0;
					endcase
					neflag = 0;
				end
				else ;
			end
		end
	end
	else begin
		next_data_n <= 1;
	end
end

assign LEDR[8:7] = state;

always @(state) begin
	if(!SW[0]) 
		freqr = 16'h0400;
	else begin
		case(state)
			Q0: freqr = 16'h0;
			Q1: freqr = rom_freq[key0] * a1 / a2;
			Q2: freqr = (rom_freq[key1] / 2 + rom_freq[key0] / 2) * a1 / a2;
			Q3: freqr = (rom_freq[key2] / 3 + rom_freq[key1] / 3 + rom_freq[key0] / 3) * a1 / a2;
			default:freqr = 16'h0400;
		endcase
	end
end


/*

always @(posedge clk) begin
	if(!clrn) state <= Q0;
	else if(last_keycode != keycode) begin
		if(keycode == 8'hf0) begin
			case(state)
					Q0: state <= Q0;
					Q1: state <= Q0;
					Q2: state <= Q1;
					Q3: state <= Q2;
			endcase;
			release_flag <= 1;
		end
		else begin
			if(release_flag == 1) begin
				
				release_flag <= 0;
			end
			else case(state)
					Q0: begin state <= Q1; 	key0 <= keycode; end
					Q1: begin state <= Q2;	key1 <= key0; key0 <= keycode; end
					Q2: begin state <= Q3;	key2 <= key1; key1 <= key0; key0 <= keycode; end
					Q3: begin state <= Q3; 	key2 <= key1; key1 <= key0; key0 <= keycode; end
					default: state <= 0;
			endcase
		end
	end
	else begin
		//last_keycode <= keycode;
	end
	last_keycode <= keycode;
end
*/

//-------<----------

//------->i2------->

assign reset = ~KEY[0];
I2S_CLKgen u1(CLOCK_50, reset,AUD_XCK, LEDR[9]);
clkgen #(10000) i2c_clk(CLOCK_50,reset,1'b1,clk_i2c);
I2C_Audio_Config i2cconfig(clk_i2c, KEY[0],FPGA_I2C_SCLK,FPGA_I2C_SDAT, KEY[1], KEY[2], LEDR[3:1]);
I2S_Audio myaudio(AUD_XCK, KEY[0], AUD_BCLK, AUD_DACDAT, AUD_DACLRCK, audiodata);

//key2freq k2f(CLOCK_50, key0, key1, key2, SW[0], freq, state);

Sin_Generator sin_wave(AUD_DACLRCK, KEY[0], freq, audiodata);



assign freq = freqr;

//-------<----------
endmodule
