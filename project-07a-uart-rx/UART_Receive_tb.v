module UART_Receive_tb (
  input         i_clk,
  input         i_serial_rx,
  output        o_rx_valid,
  output [7:0]  o_rx_byte
);

  UART_Receive #(
    .CYCLES_PER_BIT(10)
  ) rx (.*);

endmodule