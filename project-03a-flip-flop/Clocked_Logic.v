module Clocked_Logic(
    input i_Clk,
    input i_Switch_1,
    output o_LED_1);

    Switch Switch_Inst
    (.i_Clk(i_Clk), .i_Switch(i_Switch_1), .o_LED(o_LED_1));

endmodule
