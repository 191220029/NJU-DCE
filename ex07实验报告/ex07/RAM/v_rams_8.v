module v_rams_8 (clk, we, inaddr,outaddr, din, dout0,dout1,dout2);
input clk; 
input we; 
input [2:0] inaddr; input [2:0] outaddr; 
input [7:0] din; 
output [7:0] dout0,dout1,dout2; 

reg [7:0] ram [7:0];
reg [7:0] dout0,dout1;

initial
begin
ram[7] = 8'hf0; ram[6] = 8'h23; ram[5] = 8'h20; ram[4] = 8'h50;
ram[3] = 8'h03; ram[2] = 8'h21; ram[1] = 8'h82; ram[0] = 8'h0D;
end

always @(posedge clk)
begin
	if (we)
		ram[inaddr] <= din;
	else
		dout0 <= ram[outaddr];
end
always @(negedge clk)
begin
	if (!we)
	dout1 <= ram[outaddr];
end
assign dout2 = ram[outaddr];
endmodule 