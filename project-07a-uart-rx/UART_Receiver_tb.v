module UART_Receiver_tb (
  input         i_clk,
  input         i_serial_rx,
  output        o_rx_valid,
  output [7:0]  o_rx_byte
);

  UART_Receiver #(
    .CYCLES_PER_BIT(10)
  ) rx (.o_read_stb(), .o_serial_rx(), .*);

endmodule