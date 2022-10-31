`timescale 1ns / 1ps

module FSM_FAN(
    input i_clk,
    input i_reset,
    input i_button_R,
    input i_button_L,
    input i_button_D,
    output [1:0] o_fanState
    );

    parameter   S_FAN_0 = 2'b00,
                S_FAN_1 = 2'b01,
                S_FAN_2 = 2'b10,
                S_FAN_3 = 2'b11;

    reg [1:0] curState = S_FAN_0; 
    reg [1:0] nextState;

    reg [1:0] r_fanState;
    assign o_fanState = r_fanState;

    always @(posedge i_clk or posedge i_reset) begin
        if(i_reset) curState <= S_FAN_0;
        else        curState <= nextState;
    end

    always @(i_button_D or i_button_R or i_button_L or curState) begin
        case (curState)
            S_FAN_0 : begin
                if(i_button_R)      nextState <= S_FAN_1;
                else                nextState <= S_FAN_0;
            end
            S_FAN_1 : begin
                if(i_button_D)      nextState <= S_FAN_0;
                else if(i_button_R) nextState <= S_FAN_2;
                else if(i_button_L) nextState <= S_FAN_0;
                else                nextState <= S_FAN_1;
            end
            S_FAN_2 : begin
                if(i_button_D)      nextState <= S_FAN_0;
                else if(i_button_R) nextState <= S_FAN_3;
                else if(i_button_L) nextState <= S_FAN_1;
                else                nextState <= S_FAN_2;
            end
            S_FAN_3 : begin
                if(i_button_D)      nextState <= S_FAN_0;
                else if(i_button_L) nextState <= S_FAN_2;
                else                nextState <= S_FAN_3;
            end
        endcase
    end

    always @(curState) begin
        case(curState)
            S_FAN_0 : r_fanState <= S_FAN_0;
            S_FAN_1 : r_fanState <= S_FAN_1;
            S_FAN_2 : r_fanState <= S_FAN_2;
            S_FAN_3 : r_fanState <= S_FAN_3;
        endcase 
    end

endmodule
