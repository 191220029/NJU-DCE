
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module ex04_2(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,

	//////////// SW //////////
	input 		     [4:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

assign LEDR[9:2] = 0;


//=======================================================
//  Structural coding
//=======================================================

synDff mySynD(SW[0], SW[1], CLOCK_50, LEDR[0]);//同步清零D触发器
aynDff myAynD(SW[0], SW[1], CLOCK_50, LEDR[1]);//异步清零D触发器
endmodule
