module Debounce_Project_Top
  (input  i_Clk,
   input  i_Switch_1,
   input  i_Switch_3,
   output o_LED_1,
   output o_LED_3);
                             
  parameter c_DEBOUNCE_LIMIT = 250000;  // 10 ms at 25 MHz

  wire w_Switch_1;
  wire w_Switch_3;
   
  // Instantiate Debounce Module
  Debounce_Switch #(.c_DEBOUNCE_LIMIT(c_DEBOUNCE_LIMIT))
  Debounce1_Inst
  (.i_Clk,
   .i_Switch(i_Switch_1),
   .o_Switch(w_Switch_1));
   
   Switch Switch1_Inst
   (.i_Clk,
    .i_Switch(w_Switch_1),
    .o_LED(o_LED_1));
 
  Debounce_Switch #(.c_DEBOUNCE_LIMIT(c_DEBOUNCE_LIMIT))
  Debounce3_Inst
  (.i_Clk, 
   .i_Switch(i_Switch_3),
   .o_Switch(w_Switch_3));
   
   Switch Switch3_Inst
   (.i_Clk,
    .i_Switch(w_Switch_3),
    .o_LED(o_LED_1));

endmodule
