module kbdecoder(datain, dataout, shift_state, caps_state, ctrl_state);
input [7:0]datain;
input shift_state;	//shift键是否被按下
input caps_state;	//caps键是否被按下
input ctrl_state;	//ctrl键是否被按下
output reg [7:0]dataout;

reg [7:0] asc [255:0];
reg [7:0] ascii_shift [255:0];
reg [7:0] ascii_caps [255:0];
reg [7:0] temp;

initial
begin
	$readmemh(".\\init\\ascii_init.txt", asc, 0, 255); 
	$readmemh(".\\init\\ascii_init_shift.txt", ascii_shift, 0, 255);
	$readmemh(".\\init\\ascii_init_caps.txt", ascii_caps, 0, 255);
	
end
	
always @(*)
begin
	if(shift_state && !caps_state) begin
		dataout <= ascii_shift[datain];
	end
	else if(caps_state && !shift_state) begin
		dataout <= ascii_caps[datain];
	end
	else dataout <= asc[datain];
end
endmodule 