module md5_abcd_sequence_adjust( //adjust the sequence of output a, b, c, d
    input [127:0] MD5_output,
    output [1023:0] MD5_result,
    output [7:0] MD5_result_len
);
    assign MD5_result_len = 8'd16;
    wire [31:0] a, b, c, d;
    assign a = MD5_output[127:96];
    assign b = MD5_output[95:64];
    assign c = MD5_output[63:32];
    assign d = MD5_output[31:0];
    assign MD5_result = {896'd0, d, c, b, a};
endmodule 