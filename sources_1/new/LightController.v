`timescale 1ns / 1ps

module LightController(
    input i_FANOnOff, i_TIMEROnOff,
    input [3:0] i_1000_value,
    output [2:0] o_fanlight,
    output o_timerlight
    );
    // 0 : timer on/off, 1 : fan 1 / 2 : fan 2 / 3: fan 3 

    parameter   S_FAN_OFF = 1'b0,
                S_FAN_ON  = 1'b1;

    parameter   S_TIMER_OFF = 1'b0,
                S_TIMER_ON  = 1'b1;

    reg [2:0] r_fanlight;
    assign o_fanlight = r_fanlight;

    reg r_timerlight;
    assign o_timerlight = r_timerlight;

    always @(*) begin
        case (i_FANOnOff)
            S_FAN_OFF : begin
                r_fanlight = 3'b000;
            end

            S_FAN_ON : begin
                r_fanlight = 3'b000;
                case (i_1000_value)
                    1 : r_fanlight = 3'b001;
                    2 : r_fanlight = 3'b011;
                    3 : r_fanlight = 3'b111;
                endcase
            end
        endcase

        case (i_TIMEROnOff)
            S_TIMER_OFF : begin
                r_timerlight = 1'b0;
            end
            S_TIMER_ON : begin
                r_timerlight = 1'b1;
            end
        endcase
    end
endmodule
