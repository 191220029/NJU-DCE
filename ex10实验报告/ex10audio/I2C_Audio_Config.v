module I2C_Audio_Config (clk_i2c, reset_n, I2C_SCLK, I2C_SDAT, volume_up, volume_down,x );
parameter total_cmd = 9; //sending 9 commands
input clk_i2c; //10k I2C clock
input reset_n;
output I2C_SCLK;
inout I2C_SDAT;
input volume_up, volume_down;

reg [23:0] mi2c_data;
reg mi2c_go;
wire mi2c_end;
reg [1:0] mi2c_state; //state 0: stop, state 1: send next;
//state 2: wait for finish, state 3:move index
wire [2:0] mi2c_ack;
wire [7:0] audio_addr;
reg [3:0] cmd_count;
reg [6:0] audio_reg [15:0]; //register to write
reg [8:0] audio_cmd [15:0]; //register content

reg [6:0] audio_reg1 [15:0]; //register to write
reg [8:0] audio_cmd1 [15:0]; //register content
reg [6:0] audio_reg2 [15:0]; //register to write
reg [8:0] audio_cmd2 [15:0]; //register content
reg [6:0] audio_reg3 [15:0]; //register to write
reg [8:0] audio_cmd3 [15:0]; //register content
reg [6:0] audio_reg4 [15:0]; //register to write
reg [8:0] audio_cmd4 [15:0]; //register content
reg [6:0] audio_reg5 [15:0]; //register to write
reg [8:0] audio_cmd5 [15:0]; //register content
reg [6:0] audio_reg6 [15:0]; //register to write
reg [8:0] audio_cmd6 [15:0]; //register content

output [2:0]x;
reg [3:0]reg_x;

assign x = reg_x;

initial //predefine all the commands
begin
	audio_reg6[0]= 7'h0f; audio_cmd6[0]=9'h0; //reset
	audio_reg6[1]= 7'h06; audio_cmd6[1]=9'h0; //Disable Power Down
	audio_reg6[2]= 7'h08; audio_cmd6[2]=9'h2; //Sampling Control
	audio_reg6[3]= 7'h02; audio_cmd6[3]=9'h79; //Left Volume
	audio_reg6[4]= 7'h03; audio_cmd6[4]=9'h79; //Right Volume
	audio_reg6[5]= 7'h07; audio_cmd6[5]=9'h1; //I2S format
	audio_reg6[6]= 7'h09; audio_cmd6[6]=9'h1; //Active
	audio_reg6[7]= 7'h04; audio_cmd6[7]=9'h16; //Analog path
	audio_reg6[8]= 7'h05; audio_cmd6[8]=9'h06; //Digital path
	
	audio_reg1[0]= 7'h0f; audio_cmd1[0]=9'h0; //reset
	audio_reg1[1]= 7'h06; audio_cmd1[1]=9'h0; //Disable Power Down
	audio_reg1[2]= 7'h08; audio_cmd1[2]=9'h2; //Sampling Control
	audio_reg1[3]= 7'h02; audio_cmd1[3]=9'h40; //Left Volume
	audio_reg1[4]= 7'h03; audio_cmd1[4]=9'h40; //Right Volume
	audio_reg1[5]= 7'h07; audio_cmd1[5]=9'h1; //I2S format
	audio_reg1[6]= 7'h09; audio_cmd1[6]=9'h1; //Active
	audio_reg1[7]= 7'h04; audio_cmd1[7]=9'h16; //Analog path
	audio_reg1[8]= 7'h05; audio_cmd1[8]=9'h06; //Digital path
	
	audio_reg2[0]= 7'h0f; audio_cmd2[0]=9'h0; //reset
	audio_reg2[1]= 7'h06; audio_cmd2[1]=9'h0; //Disable Power Down
	audio_reg2[2]= 7'h08; audio_cmd2[2]=9'h2; //Sampling Control
	audio_reg2[3]= 7'h02; audio_cmd2[3]=9'h50; //Left Volume
	audio_reg2[4]= 7'h03; audio_cmd2[4]=9'h50; //Right Volume
	audio_reg2[5]= 7'h07; audio_cmd2[5]=9'h1; //I2S format
	audio_reg2[6]= 7'h09; audio_cmd2[6]=9'h1; //Active
	audio_reg2[7]= 7'h04; audio_cmd2[7]=9'h16; //Analog path
	audio_reg2[8]= 7'h05; audio_cmd2[8]=9'h06; //Digital path
	
	audio_reg3[0]= 7'h0f; audio_cmd3[0]=9'h0; //reset
	audio_reg3[1]= 7'h06; audio_cmd3[1]=9'h0; //Disable Power Down
	audio_reg3[2]= 7'h08; audio_cmd3[2]=9'h2; //Sampling Control
	audio_reg3[3]= 7'h02; audio_cmd3[3]=9'h60; //Left Volume
	audio_reg3[4]= 7'h03; audio_cmd3[4]=9'h60; //Right Volume
	audio_reg3[5]= 7'h07; audio_cmd3[5]=9'h1; //I2S format
	audio_reg3[6]= 7'h09; audio_cmd3[6]=9'h1; //Active
	audio_reg3[7]= 7'h04; audio_cmd3[7]=9'h16; //Analog path
	audio_reg3[8]= 7'h05; audio_cmd3[8]=9'h06; //Digital path
	
	audio_reg4[0]= 7'h0f; audio_cmd4[0]=9'h0; //reset
	audio_reg4[1]= 7'h06; audio_cmd4[1]=9'h0; //Disable Power Down
	audio_reg4[2]= 7'h08; audio_cmd4[2]=9'h2; //Sampling Control
	audio_reg4[3]= 7'h02; audio_cmd4[3]=9'h70; //Left Volume
	audio_reg4[4]= 7'h03; audio_cmd4[4]=9'h70; //Right Volume
	audio_reg4[5]= 7'h07; audio_cmd4[5]=9'h1; //I2S format
	audio_reg4[6]= 7'h09; audio_cmd4[6]=9'h1; //Active
	audio_reg4[7]= 7'h04; audio_cmd4[7]=9'h16; //Analog path
	audio_reg4[8]= 7'h05; audio_cmd4[8]=9'h06; //Digital path
	
	audio_reg5[0]= 7'h0f; audio_cmd5[0]=9'h0; //reset
	audio_reg5[1]= 7'h06; audio_cmd5[1]=9'h0; //Disable Power Down
	audio_reg5[2]= 7'h08; audio_cmd5[2]=9'h2; //Sampling Control
	audio_reg5[3]= 7'h02; audio_cmd5[3]=9'h76; //Left Volume
	audio_reg5[4]= 7'h03; audio_cmd5[4]=9'h76; //Right Volume
	audio_reg5[5]= 7'h07; audio_cmd5[5]=9'h1; //I2S format
	audio_reg5[6]= 7'h09; audio_cmd5[6]=9'h1; //Active
	audio_reg5[7]= 7'h04; audio_cmd5[7]=9'h16; //Analog path
	audio_reg5[8]= 7'h05; audio_cmd5[8]=9'h06; //Digital path
	
	reg_x = 3'h2;
end


assign audio_addr={7'b0011010,1'b0}; //WM8731 addr, always write

I2C_Controller u0(.CLOCK(clk_i2c), //Controller Work Clock
.I2C_SCLK(I2C_SCLK), //I2C CLOCK
.I2C_SDAT(I2C_SDAT), //I2C DATA
.I2C_DATA(mi2c_data),//DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
.GO(mi2c_go), //GO transfer
.END(mi2c_end), //END transfer
.ACK(mi2c_ack), //ACK
.RESET_N(reset_n) );

always @ (posedge clk_i2c or negedge reset_n) begin
     if(!reset_n)
	  begin
	     cmd_count  <= 4'b0;
		  mi2c_state <= 4'b0;
	     mi2c_go    <= 1'b0;
	  end
	  
	  else
	  begin
	  
	     case(mi2c_state)
		  2'd0: begin  //stop
		            if(cmd_count ==4'b0)
						   mi2c_state <= 2'd1;
		        end
		  2'd1: begin
					case(reg_x)
						4'h1:mi2c_data <= {audio_addr, audio_reg1[cmd_count], audio_cmd1[cmd_count]};
						4'h2:mi2c_data <= {audio_addr, audio_reg2[cmd_count], audio_cmd2[cmd_count]};
						4'h3:mi2c_data <= {audio_addr, audio_reg3[cmd_count], audio_cmd3[cmd_count]};
						4'h4:mi2c_data <= {audio_addr, audio_reg4[cmd_count], audio_cmd4[cmd_count]};
						4'h5:mi2c_data <= {audio_addr, audio_reg5[cmd_count], audio_cmd5[cmd_count]};
						4'h6:mi2c_data <= {audio_addr, audio_reg6[cmd_count], audio_cmd6[cmd_count]};
					endcase
						mi2c_go   <= 1'b1;
						mi2c_state<= 2'd2;
		        end
		  2'd2: begin
		             if(mi2c_end)
						 begin
						        mi2c_state <= 2'd3;
								  mi2c_go    <= 1'b0;
						 end
		        end
		  2'd3: begin
		            cmd_count <= cmd_count + 4'd1;
						if(cmd_count + 4'd1 < total_cmd)
						   mi2c_state <= 2'd1;  //start next
					   else
						   mi2c_state <= 2'd0;  //last cmd
		        end
		  endcase
	  end
	  
end

always @ (negedge volume_up or negedge volume_down) begin
		if(!volume_up) begin //set volume++
			if(reg_x < 4'h6) reg_x <= reg_x + 4'h1;
			else ;
		end
		else if(!volume_down) begin //set volume--
			if(reg_x > 4'h1) reg_x <= reg_x - 4'h1;
			else ;
		end
		else ;
end

endmodule