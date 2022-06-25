module blocing_assign(data, clk, en, out_lock1, out_lock2);
	input data;
	input clk;
	input en;
	output reg out_lock1;
	output reg out_lock2;

	always @(posedge clk)
		if(en)
			begin
				out_lock1 = data;
				out_lock2 = out_lock1;
			end
		else
			begin
				out_lock1 = out_lock1;
				out_lock2 = out_lock2;
			end
endmodule 