`timescale 1ns / 1ps

module ValueController(
    input [1:0] i_fanState,
    input [2:0] i_timerState,
    input [31:0] i_downCount,
    output [3:0] o_1000_value, o_100_value, o_10_value, o_1_value,
    output o_FANOnOff, o_TIMEROnOff
    );

    parameter   S_FAN_0 = 2'b00,
                S_FAN_1 = 2'b01,
                S_FAN_2 = 2'b10,
                S_FAN_3 = 2'b11;

    parameter   S_TIMER_INACTIVE    = 3'd0,   // timer off
                S_TIMER_5           = 3'd1,   // timer 5s
                S_TIMER_10          = 3'd2,   // timer 10s
                S_TIMER_15          = 3'd3,   // timer 15s
                S_TIMER_5_ACTIVE    = 3'd4,   // timer 5s active
                S_TIMER_10_ACTIVE   = 3'd5,   // timer 10s active
                S_TIMER_15_ACTIVE   = 3'd6,   // timer 15s active
                S_TIMER_COMPLETE    = 3'd7;   // timer complete

    parameter   S_FAN_OFF = 1'b0,
                S_FAN_ON  = 1'b1;

    parameter   S_TIMER_OFF = 1'b0,
                S_TIMER_ON  = 1'b1;

    reg [3:0] r_1000_value, r_100_value, r_10_value, r_1_value;
    assign o_1000_value = r_1000_value;
    assign o_100_value  = r_100_value;
    assign o_10_value   = r_10_value;
    assign o_1_value    = r_1_value;

    reg r_FANOnOff = S_FAN_OFF;
    assign o_FANOnOff = r_FANOnOff;

    reg r_TIMEROnOff = S_TIMER_OFF;
    assign o_TIMEROnOff = r_TIMEROnOff;

    always @(*) begin
        case(i_fanState)
            S_FAN_0 : begin
                r_1000_value = 0;
                r_FANOnOff = S_FAN_OFF;
            end
            S_FAN_1 : begin
                r_1000_value = 1;
                r_FANOnOff = S_FAN_ON;
            end
            S_FAN_2 : begin
                r_1000_value = 2;
                r_FANOnOff = S_FAN_ON;
            end
            S_FAN_3 : begin
                r_1000_value = 3;
                r_FANOnOff = S_FAN_ON;
            end
        endcase
 
        case(i_timerState)
            S_TIMER_INACTIVE : begin
                r_TIMEROnOff = S_TIMER_OFF;
                r_10_value = 0 / 10 % 10;
                r_1_value = 0 % 10;
            end
            S_TIMER_5 : begin
                r_TIMEROnOff = S_TIMER_OFF;
                r_10_value = 5 / 10 % 10;
                r_1_value = 5 % 10;
            end
            S_TIMER_10 : begin
                r_TIMEROnOff = S_TIMER_OFF;
                r_10_value = 10 / 10 % 10;
                r_1_value = 10 % 10;
            end
            S_TIMER_15 : begin
                r_TIMEROnOff = S_TIMER_OFF;
                r_10_value = 15 / 10 % 10;
                r_1_value = 15 % 10;
            end
            S_TIMER_5_ACTIVE : begin
                r_TIMEROnOff = S_TIMER_ON;
                r_10_value = (5 - i_downCount) / 10 % 10;
                r_1_value = (5 - i_downCount) % 10;
            end
            S_TIMER_10_ACTIVE : begin
                r_TIMEROnOff = S_TIMER_ON;
                r_10_value = (10 - i_downCount) / 10 % 10;
                r_1_value = (10 - i_downCount) % 10;
            end
            S_TIMER_15_ACTIVE : begin
                r_TIMEROnOff = S_TIMER_ON;
                r_10_value = (15 - i_downCount) / 10 % 10;
                r_1_value = (15 - i_downCount) % 10;
            end
            S_TIMER_COMPLETE : begin
                r_10_value = 0;
                r_1_value = 0;
                r_FANOnOff = S_FAN_OFF;
                r_TIMEROnOff = S_TIMER_OFF;
            end
        endcase
    end
endmodule
