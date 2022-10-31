`timescale 1ns / 1ps

module FSM_TIMER(
    input i_clk,
    input i_reset,
    input i_button_U,
    input i_button_C,
    input i_button_D,
    input [31:0] i_downCount,
    output [2:0] o_timerState
    );

    parameter   S_TIMER_INACTIVE    = 3'd0,   // timer off
                S_TIMER_5           = 3'd1,   // timer 5s
                S_TIMER_10          = 3'd2,   // timer 10s
                S_TIMER_15          = 3'd3,   // timer 15s
                S_TIMER_5_ACTIVE    = 3'd4,   // timer 5s active
                S_TIMER_10_ACTIVE   = 3'd5,   // timer 10s active
                S_TIMER_15_ACTIVE   = 3'd6,   // timer 15s active
                S_TIMER_COMPLETE    = 3'd7;   // timer complete

    reg [2:0] curState = S_TIMER_INACTIVE;
    reg [2:0] nextState;

    reg [2:0] r_timerState;
    assign o_timerState = r_timerState;

    always @(posedge i_clk or posedge i_reset) begin
        if(i_reset) curState <= S_TIMER_INACTIVE;
        else        curState <= nextState;
    end

    always @(i_button_U or i_button_C or i_downCount or curState) begin
        case (curState)
            S_TIMER_INACTIVE : begin
                if(i_button_U)      nextState <= S_TIMER_5;
                else                nextState <= S_TIMER_INACTIVE;
            end
            S_TIMER_5 : begin
                if(i_button_U)          nextState <= S_TIMER_10;
                else if(i_button_C)     nextState <= S_TIMER_5_ACTIVE;
                else                    nextState <= S_TIMER_5;
            end
            S_TIMER_10 : begin
                if(i_button_U)          nextState <= S_TIMER_15;
                else if(i_button_C)     nextState <= S_TIMER_10_ACTIVE;
                else                    nextState <= S_TIMER_10;
            end
            S_TIMER_15 : begin
                if(i_button_U)          nextState <= S_TIMER_INACTIVE;
                else if(i_button_C)     nextState <= S_TIMER_15_ACTIVE;
                else                    nextState <= S_TIMER_15;
            end
            S_TIMER_5_ACTIVE : begin
                if(i_downCount > 4)     nextState <= S_TIMER_COMPLETE;
                else                    nextState <= S_TIMER_5_ACTIVE;
            end
            S_TIMER_10_ACTIVE : begin
                if(i_downCount > 9)    nextState <= S_TIMER_COMPLETE;
                else                    nextState <= S_TIMER_10_ACTIVE;
            end
            S_TIMER_15_ACTIVE : begin
                if(i_downCount > 14)    nextState <= S_TIMER_COMPLETE;
                else                    nextState <= S_TIMER_15_ACTIVE;
            end
            S_TIMER_COMPLETE : begin
                if(i_button_D)          nextState <= S_TIMER_INACTIVE;
                else                    nextState <= S_TIMER_COMPLETE;
            end
        endcase
    end

    always @(curState) begin
        case(curState)
            S_TIMER_INACTIVE  : r_timerState <= S_TIMER_INACTIVE;
            S_TIMER_5         : r_timerState <= S_TIMER_5;
            S_TIMER_10        : r_timerState <= S_TIMER_10;
            S_TIMER_15        : r_timerState <= S_TIMER_15;
            S_TIMER_5_ACTIVE  : r_timerState <= S_TIMER_5_ACTIVE;
            S_TIMER_10_ACTIVE : r_timerState <= S_TIMER_10_ACTIVE;
            S_TIMER_15_ACTIVE : r_timerState <= S_TIMER_15_ACTIVE;
            S_TIMER_COMPLETE  : r_timerState <= S_TIMER_COMPLETE;
        endcase
    end
endmodule
