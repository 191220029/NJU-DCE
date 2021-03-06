module K_ROM(cnt, K);
    input [5:0] cnt;
    output reg [31:0] K;

    always @(*)
        case(cnt)
            6'd0: K = 32'hd76aa478;
            6'd1: K = 32'he8c7b756;
            6'd2: K = 32'h242070db;
            6'd3: K = 32'hc1bdceee;
            6'd4: K = 32'hf57c0faf;
            6'd5: K = 32'h4787c62a;
            6'd6: K = 32'ha8304613;
            6'd7: K = 32'hfd469501;
            6'd8: K = 32'h698098d8;
            6'd9: K = 32'h8b44f7af;
            6'd10: K = 32'hffff5bb1;
            6'd11: K = 32'h895cd7be;
            6'd12: K = 32'h6b901122;
            6'd13: K = 32'hfd987193;
            6'd14: K = 32'ha679438e;
            6'd15: K = 32'h49b40821;
            6'd16: K = 32'hf61e2562;
            6'd17: K = 32'hc040b340;
            6'd18: K = 32'h265e5a51;
            6'd19: K = 32'he9b6c7aa;
            6'd20: K = 32'hd62f105d;
            6'd21: K = 32'h02441453;
            6'd22: K = 32'hd8a1e681;
            6'd23: K = 32'he7d3fbc8;
            6'd24: K = 32'h21e1cde6;
            6'd25: K = 32'hc33707d6;
            6'd26: K = 32'hf4d50d87;
            6'd27: K = 32'h455a14ed;
            6'd28: K = 32'ha9e3e905;
            6'd29: K = 32'hfcefa3f8;
            6'd30: K = 32'h676f02d9;
            6'd31: K = 32'h8d2a4c8a;
            6'd32: K = 32'hfffa3942;
            6'd33: K = 32'h8771f681;
            6'd34: K = 32'h6d9d6122;
            6'd35: K = 32'hfde5380c;
            6'd36: K = 32'ha4beea44;
            6'd37: K = 32'h4bdecfa9;
            6'd38: K = 32'hf6bb4b60;
            6'd39: K = 32'hbebfbc70;
            6'd40: K = 32'h289b7ec6;
            6'd41: K = 32'heaa127fa;
            6'd42: K = 32'hd4ef3085;
            6'd43: K = 32'h04881d05;
            6'd44: K = 32'hd9d4d039;
            6'd45: K = 32'he6db99e5;
            6'd46: K = 32'h1fa27cf8;
            6'd47: K = 32'hc4ac5665;
            6'd48: K = 32'hf4292244;
            6'd49: K = 32'h432aff97;
            6'd50: K = 32'hab9423a7;
            6'd51: K = 32'hfc93a039;
            6'd52: K = 32'h655b59c3;
            6'd53: K = 32'h8f0ccc92;
            6'd54: K = 32'hffeff47d;
            6'd55: K = 32'h85845dd1;
            6'd56: K = 32'h6fa87e4f;
            6'd57: K = 32'hfe2ce6e0;
            6'd58: K = 32'ha3014314;
            6'd59: K = 32'h4e0811a1;
            6'd60: K = 32'hf7537e82;
            6'd61: K = 32'hbd3af235;
            6'd62: K = 32'h2ad7d2bb;
            6'd63: K = 32'heb86d391;
        endcase
endmodule 