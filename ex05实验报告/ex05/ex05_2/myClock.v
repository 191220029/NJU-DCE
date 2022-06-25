module myClock(clk, mod, select_set, set1, set0, clr_l_cnt, en_cnt, clr_l_alarm, hr1, hr0, min1, min0, sec1, sec0, alarm);
input clk;								//外部时钟输入
input [1:0]mod;						//模式选择信号			
input [2:0]select_set;				//设置时间 选择信号 ***考虑到按钮KEY按下为0，选择110, 101, 011分别作为s, m, h的设置信号
input [2:0]set1;						//设置时间的对应数字输入，十位+个位
input [3:0]set0;
input clr_l_cnt;						//秒表清零
input en_cnt;							//秒表计数开始
input clr_l_alarm;					//关闭闹钟
output reg [3:0]hr1;					//小时数输出 十位+个位
output reg [3:0]hr0;					
output reg [3:0]min1;				//分钟数输出
output reg [3:0]min0;	
output reg [3:0]sec1;				//秒数输出
output reg [3:0]sec0;
output reg alarm;						//闹钟

integer h, m, s;						//内部存储：小时、分钟、秒
integer h_alm, m_alm, s_alm;		//内部存储：闹钟对应的时间
integer h_swch, m_swch, s_swch;	//内部存储：秒表对应的时间

initial begin
	h = 0; m = 0; s = 0;
	h_alm = 24; m_alm = 0; s_alm = 0;
	h_swch = 0; m_swch = 0; s_swch = 0;
end 
/*
always @(posedge clk or negedge clr_l_cnt or negedge clr_l_alarm) begin
		case(mod)
			0: begin //正常计时
				if(clk) begin
					if(h == 23 && m == 59 && s == 59) begin
						h <= 0; m <= 0; s <= 0;
					end
					else if(m == 59 && s == 59) begin
						h <= h + 1; m <= 0; s <= 0;
					end
					else if(s == 59) begin
						m <= m + 1; s <= 0;
					end
					else s <= s + 1;
					
					hr1 <= h / 10; hr0 <= h % 10;
					min1 <= m / 10; min0 <= m % 10;
					sec1 <= s / 10; sec0 <= s % 10;
				
					//检查当前时间与闹钟设置时间是否一致，一致则alarm为1
					if(h == h_alm && m == m_alm && s == s_alm)
						alarm = 1;
					else alarm = alarm;
				end
				else ;
				//闹钟的关闭
				if(!clr_l_alarm)	alarm = 0;
				else alarm = alarm;
			end
			
			1: begin //设置时间
				if(clk) begin
					case(select_set) //根据select_set信号选择要设置的是h, m 或者 s
						3'b110:	//s
							s <= set1 * 10 + set0;
						3'b101: 	//m
							m <= set1 * 10 + set0;
						3'b011:	//h
							h <= set1 * 10 + set0;
						default:;
					endcase
					hr1 <= h / 10; hr0 <= h % 10;
					min1 <= m / 10; min0 <= m % 10;
					sec1 <= s / 10; sec0 <= s % 10;
				end
			end
			
			2: begin	//设置闹铃	
				if(clk) begin
					case(select_set) //根据select_set信号选择要设置的是h_alm, m_alm 或者 s_alm
						3'b110:	//s
							s_alm <= set1 * 10 + set0;
						3'b101: 	//m
							m_alm <= set1 * 10 + set0;
						3'b011:	//h
							h_alm <= set1 * 10 + set0;
						default:;
					endcase
				
					//显示闹铃时间
					hr1 <= h_alm / 10; hr0 <= h_alm % 10;
					min1 <= m_alm / 10; min0 <= m_alm % 10;
					sec1 <= s_alm / 10; sec0 <= s_alm % 10;
				end
			end
			
			3: begin //秒表
				if(!clr_l_cnt) begin //异步清零
					h_swch <= 0; m_swch <= 0; s_swch <= 0;
				end
				else if(en_cnt) begin//计时
					if(clk) begin
						if(h_swch == 23 && m_swch == 59 && s_swch == 59) begin
							h_swch <= 0; m_swch <= 0; s_swch <= 0;
						end
						else if(m_swch == 59 && s_swch == 59) begin
							h_swch <= h_swch + 1; m <= 0; s <= 0;
						end
						else if(s == 59) begin
							m_swch <= m_swch + 1; s_swch <= 0;
						end
						else s_swch <= s_swch + 1;
					end
				end
				else begin//暂停
					h_swch <= h_swch; m_swch <= m_swch; s_swch <= s_swch;
				end
				hr1 <= h_swch / 10; hr0 <= h_swch % 10;
				min1 <= m_swch / 10; min0 <= m_swch % 10;
				sec1 <= s_swch / 10; sec0 <= s_swch % 10;
			end
			
			default: begin
				hr1 <= hr1; hr0 <= hr0;
				min1 <= min1; min0 <= min0;
				sec1 <= sec1; sec0 <= sec0;
			end
		endcase
			
	end

endmodule 
*/


	always @(posedge clk) begin
		//时钟计时模块
		if(h == 23 && m == 59 && s == 59) begin
			h <= 0; m <= 0; s <= 0;
		end
		else if(m == 59 && s == 59) begin
			h <= h + 1; m <= 0; s <= 0;
		end
		else if(s == 59) begin
			m <= m + 1; s <= 0;
		end
		else s <= s + 1;
		case(mod)
			0: begin //正常计时
				/*
				if(h == 23 && m == 59 && s == 59) begin
					h <= 0; m <= 0; s <= 0;
				end
				else if(m == 59 && s == 59) begin
					h <= h + 1; m <= 0; s <= 0;
				end
				else if(s == 59) begin
					m <= m + 1; s <= 0;
				end
				else s <= s + 1;
				*/
				hr1 <= h / 10; hr0 <= h % 10;
				min1 <= m / 10; min0 <= m % 10;
				sec1 <= s / 10; sec0 <= s % 10;
				
				//检查当前时间与闹钟设置时间是否一致，一致则alarm为1
				if(h == h_alm && m == m_alm && s == s_alm)
					alarm = 1;
				else alarm = alarm;
				//闹钟的关闭
				if(!clr_l_alarm)	alarm = 0;
				else alarm = alarm;
			end
			
			1: begin //设置时间 
				case(select_set) //根据select_set信号选择要设置的是h, m 或者 s
					3'b110:	begin//s
						if(set1 * 10 + set0 <= 59)
							s <= set1 * 10 + set0;
						else s <= 59;	//确保时间是合法的
					end
					3'b101: 	begin//m
						if(set1 * 10 + set0 <= 59)
							m <= set1 * 10 + set0;
						else m <= 59;
					end
					3'b011:	begin//h
						if(set1 * 10 + set0 <= 23)
							h <= set1 * 10 + set0;
						else h <= 23;
					end
					default:;
				endcase
				
				hr1 <= h / 10; hr0 <= h % 10;
				min1 <= m / 10; min0 <= m % 10;
				sec1 <= s / 10; sec0 <= s % 10;
			end
			
			2: begin	//设置闹铃			
				case(select_set) //根据select_set信号选择要设置的是h_alm, m_alm 或者 s_alm
					3'b110:	begin//s
						if(set1 * 10 + set0 <= 59)
							s_alm <= set1 * 10 + set0;
						else s_alm <= 59;
					end
					3'b101: 	begin//m
						if(set1 * 10 + set0 <= 59)
							m_alm <= set1 * 10 + set0;
						else m_alm <= 59;
					end
					3'b011:	begin//h
						if(set1 * 10 + set0 <= 24)
							h_alm <= set1 * 10 + set0;
						else h_alm <= 24;
					end
					default:;
				endcase
				
				//显示闹铃时间
				hr1 <= h_alm / 10; hr0 <= h_alm % 10;
				min1 <= m_alm / 10; min0 <= m_alm % 10;
				sec1 <= s_alm / 10; sec0 <= s_alm % 10;
			end
			
			3: begin //秒表
				if(!clr_l_cnt) begin //清零
					h_swch <= 0; m_swch <= 0; s_swch <= 0;
				end
				else if(en_cnt) begin//计时
					if(h_swch == 23 && m_swch == 59 && s_swch == 59) begin
						h_swch <= 0; m_swch <= 0; s_swch <= 0;
					end
					else if(m_swch == 59 && s_swch == 59) begin
						h_swch <= h_swch + 1; m <= 0; s <= 0;
					end
					else if(s == 59) begin
						m_swch <= m_swch + 1; s_swch <= 0;
					end
					else s_swch <= s_swch + 1;
				end
				else begin//暂停
					h_swch <= h_swch; m_swch <= m_swch; s_swch <= s_swch;
				end
				hr1 <= h_swch / 10; hr0 <= h_swch % 10;
				min1 <= m_swch / 10; min0 <= m_swch % 10;
				sec1 <= s_swch / 10; sec0 <= s_swch % 10;
			end
			
			default: begin
				hr1 <= hr1; hr0 <= hr0;
				min1 <= min1; min0 <= min0;
				sec1 <= sec1; sec0 <= sec0;
			end
		endcase
			
	end

endmodule 

