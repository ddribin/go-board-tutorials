`default_nettype none

module VGA_Top (
  input   i_Clk,
  input   i_UART_RX,
  output  o_UART_TX,

   // Segment1 is upper digit, Segment2 is lower digit
   output o_Segment1_A,
   output o_Segment1_B,
   output o_Segment1_C,
   output o_Segment1_D,
   output o_Segment1_E,
   output o_Segment1_F,
   output o_Segment1_G,
   //
   output o_Segment2_A,
   output o_Segment2_B,
   output o_Segment2_C,
   output o_Segment2_D,
   output o_Segment2_E,
   output o_Segment2_F,
   output o_Segment2_G,
     
   // VGA
   output o_VGA_HSync,
   output o_VGA_VSync,
   output o_VGA_Red_0,
   output o_VGA_Red_1,
   output o_VGA_Red_2,
   output o_VGA_Grn_0,
   output o_VGA_Grn_1,
   output o_VGA_Grn_2,
   output o_VGA_Blu_0,
   output o_VGA_Blu_1,
   output o_VGA_Blu_2
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
  wire w_rd_en = ~w_tx_active | w_tx_done;

  FIFO fifo (
    .i_clk(i_Clk),
    .i_wr_en(w_rx_valid),
    .i_wr_data(w_rx_byte),
    .i_rd_en(w_rd_en),
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
  
  wire w_hsync;
  wire w_vsync;
  wire [9:0] w_hpos;
  wire [9:0] w_vpos;
  wire w_visible;
  Video_Sync_Generator sync_gen (
    .i_clk(i_Clk),
    .o_hsync(w_hsync),
    .o_hblank(),
    .o_vsync(w_vsync),
    .o_vblank(),
    .o_hpos(w_hpos),
    .o_vpos(w_vpos),
    .o_visible(w_visible)
  );

  wire [2:0] w_red;
  wire [2:0] w_grn;
  wire [2:0] w_blu;
  Test_Pattern_Generator test_pattern (
    .i_clk(i_Clk),
    .i_pattern(r_rx_byte[3:0]),
    .i_hpos(w_hpos),
    .i_vpos(w_vpos),
    .i_visible(w_visible),
    .o_red_video(w_red),
    .o_grn_video(w_grn),
    .o_blu_video(w_blu)
  );

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

  assign o_VGA_HSync = ~w_hsync;
  assign o_VGA_VSync = ~w_vsync;

  assign {o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0} = w_red;
  assign {o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0} = w_grn;
  assign {o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0} = w_blu;
endmodule
