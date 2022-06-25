module pri_encoder83(en, x, y, h);
	input en;
	input [7:0]x;
	output reg [2:0]y;
	output reg h;
	integer i;
	/*
	always @(x) begin
		if(en) begin
			y = 0; h = 0;
			for(i = 0; i <= 7; i = i + 1)
				if(x[i] == 1) begin
				y = i;	h = 1;
				end
		end
		else begin
			y = 0; h = 0;
		end
	end
	*/
	always @(x) begin
		if(en) begin
			y = 0; h = 0;
			casex(x)
				8'b00000001:begin y = 0; h = 1; end
				8'b0000001x:begin y = 1; h = 1; end
				8'b000001xx:begin y = 2; h = 1; end
				8'b00001xxx:begin y = 3; h = 1; end
				8'b0001xxxx:begin y = 4; h = 1; end
				8'b001xxxxx:begin y = 5; h = 1; end
				8'b01xxxxxx:begin y = 6; h = 1; end
				8'b1xxxxxxx:begin y = 7; h = 1; end
				default:;
			endcase
		end
		else begin
			y = 0; h = 0;
		end
	end
endmodule 