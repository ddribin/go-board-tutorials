module Clocked_Logic_tb(
    input clock,

    input i_Switch_1,
    output o_LED_1
    );

    Clocked_Logic DUT (
        .i_Clk(clock),
        .i_Switch_1(i_Switch_1),
        .o_LED_1(o_LED_1)
    );

endmodule
