module nonblocing_assign(data, clk, en, out_unlock1, out_unlock2);
	input data;
	input clk;
	input en;
	output reg out_unlock1;
	output reg out_unlock2;
	
	always @(posedge clk)
		if(en)
			begin
				out_unlock1 <= data;
				out_unlock2 <= out_unlock1;
			end
		else
			begin
				out_unlock1 <= out_unlock1;
				out_unlock2 <= out_unlock2;
			end
endmodule 