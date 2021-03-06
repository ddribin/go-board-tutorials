module Debounce_Project_tb
  (input  i_Clk,
   input  i_Switch_1,
   output o_LED_1);

    // Override the limit for testing
    Debounce_Project_Top #(.c_DEBOUNCE_LIMIT(10))
    Debounce_Inst
    (.i_Clk,
    .i_Switch_1,
    .o_LED_1,
    .i_Switch_3(1),
    .o_LED_3(),
    .io_PMOD_1());
    
endmodule