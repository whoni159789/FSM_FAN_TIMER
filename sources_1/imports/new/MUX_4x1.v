`timescale 1ns / 1ps

module MUX_4x1(
    input i_fan_0, i_fan_1, i_fan_2, i_fan_3,
    input i_FANOnOff,
    input [3:0] i_1000_value,
    output o_fan
    );

    parameter   S_FAN_OFF = 1'b0,
                S_FAN_ON  = 1'b1;

    reg r_fan;
    assign o_fan = r_fan;

    always @(*) begin
        r_fan = i_fan_0;
        case (i_FANOnOff)
            S_FAN_OFF : begin
                r_fan = i_fan_0;
            end
            S_FAN_ON : begin
                case(i_1000_value)
                    1 : r_fan = i_fan_1;
                    2 : r_fan = i_fan_2;
                    3 : r_fan = i_fan_3;
                endcase
            end
        endcase
    end
endmodule
