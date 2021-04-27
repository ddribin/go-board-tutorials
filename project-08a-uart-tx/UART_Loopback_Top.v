module UART_Loopback_Top (
  input   i_Clk,
  input   i_UART_RX,
  output  o_UART_TX,

  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,

  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G,

  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,

  output io_PMOD_1,
  output io_PMOD_2,
  output io_PMOD_3,
  output io_PMOD_4,
  output io_PMOD_7,
  output io_PMOD_8,
  output io_PMOD_9,
  output io_PMOD_10
);

  // Synchronizer
  wire w_UART_RX;
  Synchronizer UART_RX_Sync (
    .i_clk(i_Clk),
    .i_input(i_UART_RX),
    .o_input_sync(w_UART_RX)
  );

  wire [7:0] w_rx_byte;
  wire w_rx_valid;
  wire [2:0] w_state;
  wire w_read_stb;
  wire w_serial_rx;

  // Baud rates @ 25MHz
  localparam BAUD_115200  = 217;
  localparam BAUD_9600    = 2604;
  localparam BUAD_RATE    = BAUD_115200;

  UART_Receiver #(
    .CYCLES_PER_BIT(BUAD_RATE)
  ) rx (
    .i_clk(i_Clk),
    .i_serial_rx(w_UART_RX),
    .o_read_stb(w_read_stb),
    .o_serial_rx(w_serial_rx),
    .o_rx_byte(w_rx_byte),
    .o_rx_valid(w_rx_valid)
  );

  wire w_fifo_not_empty;
  wire [7:0] w_data_out;
  wire w_shift_out = ~w_tx_active | w_tx_done;
  FIFO_2word_FWFT fifo_fwft (
    .clk(i_Clk),
    .reset(0),
    .shift_in(w_rx_valid),
    .data_in(w_rx_byte),

    .shift_out(w_shift_out),
    .fifo_not_empty(),
    .fifo_full(),
    .data_out()
  );

  FIFO fifo (
    .i_clk(i_Clk),
    .i_wr_en(w_rx_valid),
    .i_wr_data(w_rx_byte),
    .i_rd_en(w_shift_out),
    .o_fifo_not_empty(w_fifo_not_empty),
    .o_rd_data(w_data_out)
  );

  wire w_tx_serial;
  wire w_tx_active;
  wire w_tx_done;

  UART_Transmitter #(
    .CYCLES_PER_BIT(BUAD_RATE)
  ) tx (
    .i_clk(i_Clk),
    .i_tx_byte(w_data_out),
    .i_tx_dv(w_fifo_not_empty),
    .o_tx_active(w_tx_active),
    .o_tx_serial(w_tx_serial),
    .o_tx_done(w_tx_done)
  );

  reg [7:0] r_rx_byte;
  always @(posedge i_Clk) begin
    if (w_rx_valid) begin
      r_rx_byte <= w_rx_byte;
    end
  end

  wire [6:0] w_Segments1;
  Nibble_To_7SD Segment1 (
    .i_Clk(i_Clk),
    .i_Nibble(r_rx_byte[7:4]),
    .o_Segments(w_Segments1)
  );

  wire [6:0] w_Segments2;
  Nibble_To_7SD Segment2 (
    .i_Clk(i_Clk),
    .i_Nibble(r_rx_byte[3:0]),
    .o_Segments(w_Segments2)
  );

  assign o_UART_TX = w_tx_serial;

  assign o_Segment1_A = ~w_Segments1[0];
  assign o_Segment1_B = ~w_Segments1[1];
  assign o_Segment1_C = ~w_Segments1[2];
  assign o_Segment1_D = ~w_Segments1[3];
  assign o_Segment1_E = ~w_Segments1[4];
  assign o_Segment1_F = ~w_Segments1[5];
  assign o_Segment1_G = ~w_Segments1[6];

  assign o_Segment2_A = ~w_Segments2[0];
  assign o_Segment2_B = ~w_Segments2[1];
  assign o_Segment2_C = ~w_Segments2[2];
  assign o_Segment2_D = ~w_Segments2[3];
  assign o_Segment2_E = ~w_Segments2[4];
  assign o_Segment2_F = ~w_Segments2[5];
  assign o_Segment2_G = ~w_Segments2[6];

  assign o_LED_1 = r_rx_byte[3];
  assign o_LED_2 = r_rx_byte[2];
  assign o_LED_3 = r_rx_byte[1];
  assign o_LED_4 = r_rx_byte[0];

  wire [7:0] w_debug = {
    i_UART_RX,
    w_UART_RX,
    w_rx_valid,
    w_fifo_not_empty,
    w_shift_out,
    w_tx_serial,
    w_tx_active,
    w_tx_done
//    1'd0
  };
  assign io_PMOD_1 = w_debug[7];
  assign io_PMOD_2 = w_debug[6];
  assign io_PMOD_3 = w_debug[5];
  assign io_PMOD_4 = w_debug[4];

  assign io_PMOD_7 = w_debug[3];
  assign io_PMOD_8 = w_debug[2];
  assign io_PMOD_9 = w_debug[1];
  assign io_PMOD_10 = w_debug[0];
  
endmodule