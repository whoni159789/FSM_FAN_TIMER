`timescale 1ns / 1ps

module Counter_1s(
    input i_clk,
    input i_reset,
    input i_button_C,
    output [31:0] o_downCount
    );

    reg [31:0] r_downCount = 0;
    assign o_downCount = r_downCount;

    always @(posedge i_clk or posedge i_reset or posedge i_button_C) begin
        if(i_reset) r_downCount <= 0;
        else if (i_button_C)    r_downCount <= 0;
        else        r_downCount <= r_downCount + 1;
    end

endmodule
