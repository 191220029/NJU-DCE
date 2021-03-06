
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module ex05_1(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

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

wire [3:0]num1;
wire [3:0]num0;

//=======================================================
//  Structural coding
//=======================================================
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign LEDR[8:1] = 0;
clock_1 my_1HZclk(CLOCK_50, LEDR[0]);
counter_mod100 counter(LEDR[0], SW[0], SW[1], num1, num0, LEDR[9]);
//counter_mod100 counter(CLOCK_50, SW[0], SW[1], num1, num0, LEDR[9]);
hex15 hex1(num1, HEX1);
hex15 hex0(num0, HEX0);

endmodule
