`timescale 1ns / 1ps

module Comparator(
    input [9:0] i_counter,
    output o_fan_0, o_fan_1, o_fan_2, o_fan_3
    );

    /* 
        o_fan_0 :  0%
        o_fan_1 : 22%
        o_fan_2 : 44%
        o_fan_3 : 66%
    */

    assign o_fan_0 = (i_counter < 0)   ? 1'b1 : 1'b0;
    assign o_fan_1 = (i_counter < 222) ? 1'b1 : 1'b0;
    assign o_fan_2 = (i_counter < 444) ? 1'b1 : 1'b0;
    assign o_fan_3 = (i_counter < 666) ? 1'b1 : 1'b0;
endmodule
