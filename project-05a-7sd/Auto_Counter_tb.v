module Auto_Counter_tb (
  input i_Clk,
  input i_Reset,
  output [3:0] o_Nibble
);

  Auto_Counter #(
    .g_Delay(4)
  ) counter (.*);
    
endmodule
