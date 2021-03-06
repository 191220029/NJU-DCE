
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module ex05_2(

	//////////// CLOCK //////////
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
	output		     [6:0]		HEX5
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [3:0]hour1;
wire [3:0]hour0;
wire [3:0]min1;
wire [3:0]min0;
wire [3:0]sec1;
wire [3:0]sec0;


//=======================================================
//  Structural coding
//=======================================================
clock_1 clock(CLOCK_50, LEDR[9]);
myClock elec_clk(LEDR[9], SW[9:8], KEY[2:0], SW[7:4], SW[3:0], KEY[3], SW[0], KEY[3], hour1, hour0, min1, min0, sec1, sec0, LEDR[0]);
hex15 hex_h1(hour1, HEX5);
hex15 hex_h0(hour0, HEX4);
hex15 hex_m1(min1, HEX3);
hex15 hex_m0(min0, HEX2);
hex15 hex_s1(sec1, HEX1);
hex15 hex_s0(sec0, HEX0);

endmodule
