module RanGen(clk, rs_n, load, data_in, Q);
	input clk;
	input rs_n;
	input load;
	input [7:0]data_in;
	output reg [7:0]Q;
	
	always @(posedge clk) begin
		if(!rs_n) //清零信号
			Q <= 0;
		else if(load) //载入
			Q <= data_in;
		else begin	//线性移位
			//X8=X4⊕X3⊕X2⊕X0
			//加入全0状态
			Q <= {(Q[4]^Q[3]^Q[2]^Q[0]) ^ (~(|Q[7:0])), Q[7:1]};
			//if((Q[7:1] == 0 ) ^ (Q[4]^Q[3]^Q[2]^Q[0])) 
			//	Q <= 0;
			//else Q <= {(Q[4]^Q[3]^Q[2]^Q[0]), Q[7:1]};
		end
	end
endmodule 

/*
module RanGen(  
    input               rst_n,    //rst_n is necessary to prevet locking up 
    input               clk,      //clock signal  
    input               load,     //load seed to rand_num,active high
    input      [7:0]    seed,       
    output reg [7:0]    rand_num  //random number output  
);  
    
 //X8=X4⊕X3⊕X2⊕X0
always@(posedge clk or negedge rst_n)  
begin  
    if(!rst_n)  
        rand_num    <=8'b0;  
    else if(load)  
        rand_num <=seed;    //load the initial value when load is active  
    else  
        begin  
            rand_num[0] <= rand_num[7];  
            rand_num[1] <= rand_num[0];  
            rand_num[2] <= rand_num[1];  
            rand_num[3] <= rand_num[2];  
            rand_num[4] <= rand_num[3]^rand_num[7];  
            rand_num[5] <= rand_num[4]^rand_num[7];  
            rand_num[6] <= rand_num[5]^rand_num[7];  
            rand_num[7] <= rand_num[6];  
        end  
                
end  
endmodule  
*/