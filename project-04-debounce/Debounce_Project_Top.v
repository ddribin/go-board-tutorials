module Debounce_Project_Top
  (input  i_Clk,
   input  i_Switch_1,
   output o_LED_1);
                             
  parameter c_DEBOUNCE_LIMIT = 250000;  // 10 ms at 25 MHz

  reg  r_LED_1    = 1'b0;
  reg  r_Switch_1 = 1'b0;
  wire w_Switch_1;
   
  // Instantiate Debounce Module
  Debounce_Switch #(.c_DEBOUNCE_LIMIT(c_DEBOUNCE_LIMIT))
  Debounce_Inst
  (.i_Clk(i_Clk), 
   .i_Switch(i_Switch_1),
   .o_Switch(w_Switch_1));
   
  // Purpose: Toggle LED output when w_Switch_1 is released.
  always @(posedge i_Clk)
  begin
    r_Switch_1 <= w_Switch_1;         // Creates a Register
 
    // This conditional expression looks for a falling edge on w_Switch_1.
    // Here, the current value (i_Switch_1) is low, but the previous value
    // (r_Switch_1) is high.  This means that we found a falling edge.
    if (w_Switch_1 == 1'b0 && r_Switch_1 == 1'b1)
    begin
      r_LED_1 <= ~r_LED_1;         // Toggle LED output
    end
  end
 
  assign o_LED_1 = r_LED_1;
 
endmodule
