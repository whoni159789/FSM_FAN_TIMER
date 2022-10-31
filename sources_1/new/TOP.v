`timescale 1ns / 1ps

module TOP(
    input i_clk,
    input i_reset,
    input i_button_R,
    input i_button_L,
    input i_button_D,
    input i_button_U,
    input i_button_C,
    output [3:0] o_FND_Digit,
    output [7:0] o_FND_Font,
    output [2:0] o_fanlight,
    output o_timerlight,
    output o_fan
    );


    // FND Digit Part
    wire w_1KHz_clk;
    ClockDivider_1KHz ClockDivider_1KHz(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk(w_1KHz_clk)
    );

    wire [1:0] w_digitPosition;
    Counter_FND Counter_FND(
        .i_clk(w_1KHz_clk),
        .i_reset(i_reset),
        .o_counter(w_digitPosition)
    );

    Decoder_2x4 Decoder_2x4(
        .i_digitPosition(w_digitPosition),
        .o_Digit(o_FND_Digit)
    );

    wire w_button_R;
    ButtonController Button_R(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button_R),
        .o_button(w_button_R)
    );

    wire w_button_L;
    ButtonController Button_L(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button_L),
        .o_button(w_button_L)
    );

    wire w_button_D;
    ButtonController Button_D(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button_D),
        .o_button(w_button_D)
    );

    wire w_button_U;
    ButtonController Button_U(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button_U),
        .o_button(w_button_U)
    );

    wire w_button_C;
    ButtonController Button_C(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button(i_button_C),
        .o_button(w_button_C)
    );

    wire [1:0] w_fanState;
    FSM_FAN FSM_FAN(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button_R(w_button_R),
        .i_button_L(w_button_L),
        .i_button_D(w_button_D),
        .o_fanState(w_fanState)
    );

    wire [2:0] w_timerState;
    FSM_TIMER FSM_TIMER(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_button_U(w_button_U),
        .i_button_C(w_button_C),
        .i_button_D(w_button_D),
        .i_downCount(w_downCount),
        .o_timerState(w_timerState)
    );

    wire w_1Hz_clk;
    ClockDivider_1Hz ClockDivider_1Hz(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk(w_1Hz_clk)
    );

    wire [31:0] w_downCount;
    Counter_1s Counter_1s(
        .i_clk(w_1Hz_clk),
        .i_reset(i_reset),
        .i_button_C(w_button_C),
        .o_downCount(w_downCount)
    );

    wire [3:0] w_1000_value, w_100_value, w_10_value, w_1_value;
    wire w_FANOnOff, w_TIMEROnOff;
    ValueController ValueController(
        .i_fanState(w_fanState),
        .i_timerState(w_timerState),
        .i_downCount(w_downCount),
        .o_1000_value(w_1000_value), 
        .o_100_value(w_100_value), 
        .o_10_value(w_10_value), 
        .o_1_value(w_1_value),
        .o_FANOnOff(w_FANOnOff),
        .o_TIMEROnOff(w_TIMEROnOff)
    );

    wire [3:0] w_value;
    MUX_FNDValueSel MUX_FNDValueSel(
        .i_1000_value(w_1000_value), 
        .i_100_value(w_100_value), 
        .i_10_value(w_10_value), 
        .i_1_value(w_1_value),
        .i_digitPosition(w_digitPosition),
        .o_value(w_value)
    );

    BCDToFND_Decoder BCDToFND_Decoder(
        .i_value(w_value),
        .o_font(o_FND_Font)
    );

    // Led Part
    LightController LightController(
        .i_FANOnOff(w_FANOnOff),
        .i_TIMEROnOff(w_TIMEROnOff),
        .i_1000_value(w_1000_value),
        .o_fanlight(o_fanlight),
        .o_timerlight(o_timerlight)
    );

    // Motor Part
    wire w_1MHz_clk;
    ClockDivider_1MHz ClockDivider_1MHz(
        .i_clk(i_clk),
        .i_reset(i_reset),
        .o_clk(w_1MHz_clk)
    );

    wire [9:0] w_counter;
    Counter_Fan Counter_Fan(
        .i_clk(w_1MHz_clk),
        .i_reset(i_reset),
        .o_counter(w_counter)
    );

    wire w_fan_0, w_fan_1, w_fan_2, w_fan_3;
    Comparator Comparator(
        .i_counter(w_counter),
        .o_fan_0(w_fan_0), 
        .o_fan_1(w_fan_1), 
        .o_fan_2(w_fan_2), 
        .o_fan_3(w_fan_3)
    );

    MUX_4x1 MUX_4x1(
        .i_fan_0(w_fan_0), 
        .i_fan_1(w_fan_1), 
        .i_fan_2(w_fan_2), 
        .i_fan_3(w_fan_3),
        .i_FANOnOff(w_FANOnOff),
        .i_1000_value(w_1000_value),
        .o_fan(o_fan)
    );

endmodule
