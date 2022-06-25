module round2(indata, in_round, link_var, result);
    input [511:0] indata;
    input [3:0] in_round;
    input [127:0] link_var;
    output [31:0] result;

    wire [31:0] A, B, C, D;

    assign A = link_var[31:0];
    assign B = link_var[63:32];
    assign C = link_var[95:64];
    assign D = link_var[127:96];

    wire [31:0] F;
    wire [31:0] K, M;
    wire [4:0] S;
    wire [3:0] g;

    K_ROM getK1(.cnt({2'd1, in_round}), .K(K));
    S_ROM getS1(.cnt({2'd1, in_round}), .S(S));

    assign g = in_round + (in_round << 2) + 4'd1;
    assign M = indata[{g, 5'd0} +: 32];
    assign F = ((B & D) | (C & ~D)) + A + K + M;

    LRotate lr2(.in(F), .s(S), .out(result));
    
endmodule