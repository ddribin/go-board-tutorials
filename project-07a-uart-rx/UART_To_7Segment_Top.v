module UART_To_7Segment_Top (
  input i_Clk,
  input i_UART_RX,
  output io_PMOD_1,
  output io_PMOD_2,
  output io_PMOD_3
);

  wire [7:0] w_byte;
  wire w_valid;
  wire [2:0] w_state;

  // Baud rates @ 25MHz
  localparam BAUD_115200  = 217;
  localparam BAUD_9600    = 2604;

  UART_Receive #(
    .CYCLES_PER_BIT(BAUD_9600)
  ) rx (
    .i_clk(i_Clk),
    .i_serial_rx(i_UART_RX),
    .o_rx_byte(w_byte),
    .o_rx_valid(w_valid)
  );

  assign io_PMOD_1 = i_UART_RX;
  assign io_PMOD_2 = w_byte[7];
  assign io_PMOD_3 = w_valid;
  
endmodule