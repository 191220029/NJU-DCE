module clkgen(
    input clkin,
    input rst,
    input clken,
    output reg clkout
);
    parameter clk_freq = 1000;
    parameter countlimit = 50000000 / 2 / clk_freq;

    reg [31:0] clkcount;

initial
begin
    clkout = 1'b0;
    clkcount = 32'd0;
end

    always @(posedge clkin)
        if(rst)
        begin
            clkcount = 0;
            clkout = 1'b0;
        end
        else
        begin
            if(clken)
            begin
                clkcount = clkcount + 1;
                if(clkcount >= countlimit)
                begin
                    clkcount = 32'd0;
                    clkout = ~clkout;
                end
                else
                    clkout = clkout;
            end
            else
            begin
                clkcount = clkcount;
                clkout = clkout;
            end
        end
endmodule