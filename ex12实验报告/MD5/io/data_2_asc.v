module data_2_asc(cap, shift, data, ascii);
    input shift, cap;
    input [7:0] data;
    output reg [7:0] ascii;
    reg [7:0] ascii_no_shift, ascii_shift;
	/* 
reg [7:0] asc[255:0];
reg [7:0] shi[255:0];
initial
begin
	 //$readmemh("F:/quartus/keyboard/ascii.txt", asc, 0, 255); 
	 $readmemh ("ascii.txt", asc, 0, 255);
	 $readmemh ("shift.txt", shi, 0, 255);	 
end
	*/ 
    always @* begin
        ascii = shift ? ascii_shift : ascii_no_shift;
    end
	/* always @*
begin
   if (data != 8'hff && data != 8'h00)begin
	ascii_no_shift = asc[data];
	ascii_shift = shi[data];
	end
	else begin
	ascii_no_shift = 8'h00;
	ascii_shift = 8'h00;
	end
end */


    always @* begin
        case(data)
            //alphabet
            8'h1c:  ascii_no_shift = 8'h61;
            8'h32:  ascii_no_shift = 8'h62;
            8'h21:  ascii_no_shift = 8'h63;
            8'h23:  ascii_no_shift = 8'h64;
            8'h24:  ascii_no_shift = 8'h65;
            8'h2b:  ascii_no_shift = 8'h66;
            8'h34:  ascii_no_shift = 8'h67;
            8'h33:  ascii_no_shift = 8'h68;
            8'h43:  ascii_no_shift = 8'h69;
            8'h3b:  ascii_no_shift = 8'h6a;
            8'h42:  ascii_no_shift = 8'h6b;
            8'h4b:  ascii_no_shift = 8'h6c;
            8'h3a:  ascii_no_shift = 8'h6d;
            8'h31:  ascii_no_shift = 8'h6e;
            8'h44:  ascii_no_shift = 8'h6f;
            8'h4d:  ascii_no_shift = 8'h70;
            8'h15:  ascii_no_shift = 8'h71;
            8'h2d:  ascii_no_shift = 8'h72;
            8'h1b:  ascii_no_shift = 8'h73;
            8'h2c:  ascii_no_shift = 8'h74;
            8'h3c:  ascii_no_shift = 8'h75;
            8'h2a:  ascii_no_shift = 8'h76;
            8'h1d:  ascii_no_shift = 8'h77;
            8'h22:  ascii_no_shift = 8'h78;
            8'h35:  ascii_no_shift = 8'h79;
            8'h1a:  ascii_no_shift = 8'h7a;
            //number from 0 to 9
            8'h45:  ascii_no_shift = 8'h30;
            8'h16:  ascii_no_shift = 8'h31;
            8'h1e:  ascii_no_shift = 8'h32;
            8'h26:  ascii_no_shift = 8'h33;
            8'h25:  ascii_no_shift = 8'h34;
            8'h2e:  ascii_no_shift = 8'h35;
            8'h36:  ascii_no_shift = 8'h36;
            8'h3d:  ascii_no_shift = 8'h37;
            8'h3e:  ascii_no_shift = 8'h38;
            8'h46:  ascii_no_shift = 8'h39;
            8'h29:  ascii_no_shift = 8'h20; // empty space
            8'h66:  ascii_no_shift = 8'h08; //backspace
            8'h5a:  ascii_no_shift = 8'h0d; //enter
            8'h0d:  ascii_no_shift = 8'h09; // tab
            8'h76:  ascii_no_shift = 8'h1b; // esc
            8'h54:  ascii_no_shift = 8'h5b; // [
            8'h5b:  ascii_no_shift = 8'h5d; // ]
            8'h4c:  ascii_no_shift = 8'h3b; // ;
            8'h52:  ascii_no_shift = 8'h27; // '
            8'h41:  ascii_no_shift = 8'h2c; // ,
            8'h49:  ascii_no_shift = 8'h2e; // .
            8'h4a:  ascii_no_shift = 8'h2f; // /
            8'h55:  ascii_no_shift = 8'h3d;// =
            8'h4e:  ascii_no_shift = 8'h2d;// -
            8'h5d:  ascii_no_shift = 8'h5c;// \ 
            8'h0e:  ascii_no_shift = 8'h60; // `
            default: ascii_no_shift = 8'h00;
        endcase
    end

    always @* begin
        case(data)
            8'h1c:  ascii_shift = 8'h41;
            8'h32:  ascii_shift = 8'h42;
            8'h21:  ascii_shift = 8'h43;
            8'h23:  ascii_shift = 8'h44;
            8'h24:  ascii_shift = 8'h45;
            8'h2b:  ascii_shift = 8'h46;
            8'h34:  ascii_shift = 8'h47;
            8'h33:  ascii_shift = 8'h48;
            8'h43:  ascii_shift = 8'h49;
            8'h3b:  ascii_shift = 8'h4a;
            8'h42:  ascii_shift = 8'h4b;
            8'h4b:  ascii_shift = 8'h4c;
            8'h3a:  ascii_shift = 8'h4d;
            8'h31:  ascii_shift = 8'h4e;
            8'h44:  ascii_shift = 8'h4f;
            8'h4d:  ascii_shift = 8'h50;
            8'h15:  ascii_shift = 8'h51;
            8'h2d:  ascii_shift = 8'h52;
            8'h1b:  ascii_shift = 8'h53;
            8'h2c:  ascii_shift = 8'h54;
            8'h3c:  ascii_shift = 8'h55;
            8'h2a:  ascii_shift = 8'h56;
            8'h1d:  ascii_shift = 8'h57;
            8'h22:  ascii_shift = 8'h58;
            8'h35:  ascii_shift = 8'h59;
            8'h1a:  ascii_shift = 8'h5a;
            8'h16:  ascii_shift = 8'h21;//!
            8'h1e:  ascii_shift = 8'h40;//@
            8'h26:  ascii_shift = 8'h23;//#
            8'h25:  ascii_shift = 8'h24;//$
            8'h2e:  ascii_shift = 8'h25;//%
            8'h36:  ascii_shift = 8'h5e;//^
            8'h3d:  ascii_shift = 8'h26;//&
            8'h3e:  ascii_shift = 8'h2a;//*
            8'h46:  ascii_shift = 8'h28;//(
            8'h45:  ascii_shift = 8'h29;//)
            8'h54:  ascii_shift = 8'h7b; // {
            8'h5b:  ascii_shift = 8'h7d; // }
            8'h4c:  ascii_shift = 8'h3a;// :
            8'h52:  ascii_shift = 8'h22;// "
            8'h41:  ascii_shift = 8'h3c;// <
            8'h49:  ascii_shift = 8'h3e;// >
            8'h4a:  ascii_shift = 8'h3f;// ?
            8'h0e:  ascii_shift = 8'h7e;// ~
            8'h5d:  ascii_shift = 8'h7c;// |
            8'h55:  ascii_shift = 8'h2b; // +
            8'h4e:  ascii_shift = 8'h5f; // _
            default: ascii_shift = 8'h00;
    endcase
end
endmodule 