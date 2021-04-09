module Clocked_Logic(
    input i_Clk,
    input i_Switch_1,
    input i_Switch_3,
    output o_LED_1,
    output o_LED_3);

    Switch Switch1_Inst
    (.i_Clk(i_Clk), .i_Switch(i_Switch_1), .o_LED(o_LED_1));

    Switch Switch2_Inst
    (.i_Clk(i_Clk), .i_Switch(i_Switch_3), .o_LED(o_LED_3));

endmodule
