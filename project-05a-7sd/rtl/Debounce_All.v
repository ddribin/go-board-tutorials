module Debounce_All (
  input i_Clk,
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,
  output [3:0] o_Switches
);
  
  Debounce_Switch Debounce_1 (
    .i_Clk,
    .i_Switch(i_Switch_1),
    .o_Switch(o_Switches[0])
  );

  Debounce_Switch Debounce_2 (
    .i_Clk,
    .i_Switch(i_Switch_2),
    .o_Switch(o_Switches[1])
  );

  Debounce_Switch Debounce_3 (
    .i_Clk,
    .i_Switch(i_Switch_3),
    .o_Switch(o_Switches[2])
  );

  Debounce_Switch Debounce_4 (
    .i_Clk,
    .i_Switch(i_Switch_4),
    .o_Switch(o_Switches[3])
  );

endmodule