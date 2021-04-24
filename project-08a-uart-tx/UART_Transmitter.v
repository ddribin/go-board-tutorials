module UART_Transmitter #(
  parameter CYCLES_PER_BIT = 217
) (
  input         i_clk,
  input [7:0]   i_tx_byte,
  input         i_tx_dv,
  output        o_tx_serial,
  output        o_tx_active,
  output        o_tx_done
);
  
endmodule
