module key2freq(clk, key0, key1, key2, clrn, freq, state);
input clk;
input [7:0]key0;
input [7:0]key1;
input [7:0]key2;
input clrn;
input [1:0] state;
output reg [15:0] freq;

reg [15:0]rom_freq[255:0];
integer a1 = 65536;
integer a2 = 48000;
/*
reg [15:0] Hz0;
reg [15:0] Hz1;
reg [15:0] Hz2;
*/
integer Q0 = 0; //no valid input
integer Q1 = 1; //one valid input
integer Q2 = 2; //two valid input
integer Q3 = 3; 
initial begin
	$readmemh(".\\init\\key2Hz.txt", rom_freq, 0, 255);
end

always @(state) begin
	if(!clrn) 
		freq <= 16'h0400;
	else begin
		if(state == Q0) freq <= 16'h0;
		else if(state == Q1) begin
			freq <= rom_freq[key0] * a1 / a2;
		end
		else if(state == Q2) begin
			freq <= (rom_freq[key1] / 2 + rom_freq[key0] / 2) * a1 / a2;
		end
		else if(state == Q3) begin
			freq <= (rom_freq[key2] / 3 + rom_freq[key1] / 3 + rom_freq[key0] / 3) * a1 / a2;
		end
		else freq <= 12'h0400;
	end
end


/*
always @(*) begin
	if(!clrn) 
		freq <= 16'h0400;
	else begin
		Hz0 <= rom_freq[keycode];
		freq <= Hz0 * a1 / a2;
		//freq <= rom_freq[keycode];
	end
end */

endmodule 