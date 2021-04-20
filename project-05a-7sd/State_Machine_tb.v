`include "State_Machine.vh"

module State_Machine_tb (
  input i_Clk,
  input [3:0] i_Switches,
  output [`STATE_WIDTH:0] o_State,
  output [6:0] o_Segments
);

  State_Machine #(
    .g_ANIMATION_DELAY(9),
    .g_RESET_DELAY(11)
  ) counter (.*);
    
endmodule
