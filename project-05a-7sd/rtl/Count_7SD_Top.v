module Count_7SD_Top (
  input i_Clk,
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,

  output io_PMOD_1,
  output io_PMOD_2,
  output io_PMOD_3,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G
);

  wire w_Segment2_A;
  wire w_Segment2_B;
  wire w_Segment2_C;
  wire w_Segment2_D;
  wire w_Segment2_E;
  wire w_Segment2_F;
  wire w_Segment2_G;

  wire [3:0] w_Nibble;

// `define AUTO_COUNTER 1
// `define SWITCH_COUNTER 1
`define BIT_COUNTER 1

`ifdef AUTO_COUNTER
  Auto_Counter Counter (
    .i_Clk,
    .o_Nibble(w_Nibble)
  );
`endif

`ifdef SWITCH_COUNTER
  wire w_Switch_1;
  Debounce_Switch Debouncer (
    .i_Clk,
    .i_Switch(i_Switch_1),
    .o_Switch(w_Switch_1)
  );

  Switch_Counter Counter (
    .i_Clk,
    .i_Switch(w_Switch_1),
    .o_Nibble(w_Nibble)
  );
`endif

`ifdef BIT_COUNTER
  wire w_Switch_1;
  wire w_Switch_2;
  wire w_Switch_3;
  wire w_Switch_4;
  Debounce_Switch Debounce_1 (
    .i_Clk,
    .i_Switch(i_Switch_1),
    .o_Switch(w_Switch_1)
  );

  Debounce_Switch Debounce_2 (
    .i_Clk,
    .i_Switch(i_Switch_2),
    .o_Switch(w_Switch_2)
  );

  Debounce_Switch Debounce_3 (
    .i_Clk,
    .i_Switch(i_Switch_3),
    .o_Switch(w_Switch_3)
  );

  Debounce_Switch Debounce_4 (
    .i_Clk,
    .i_Switch(i_Switch_4),
    .o_Switch(w_Switch_4)
  );

  Bit_Counter Counter (
    .i_Clk,
    .i_Switch_1(w_Switch_1),
    .i_Switch_2(w_Switch_2),
    .i_Switch_3(w_Switch_3),
    .i_Switch_4(w_Switch_4),
    .o_Nibble(w_Nibble)
  );
`endif

  Nibble_To_7SD Nibble_To_7SD_Inst (
    .i_Clk,
    .i_Nibble(w_Nibble),
    .o_Segment_A(w_Segment2_A),
    .o_Segment_B(w_Segment2_B),
    .o_Segment_C(w_Segment2_C),
    .o_Segment_D(w_Segment2_D),
    .o_Segment_E(w_Segment2_E),
    .o_Segment_F(w_Segment2_F),
    .o_Segment_G(w_Segment2_G)
  );

  assign o_Segment2_A = ~w_Segment2_A;
  assign o_Segment2_B = ~w_Segment2_B;
  assign o_Segment2_C = ~w_Segment2_C;
  assign o_Segment2_D = ~w_Segment2_D;
  assign o_Segment2_E = ~w_Segment2_E;
  assign o_Segment2_F = ~w_Segment2_F;
  assign o_Segment2_G = ~w_Segment2_G;

  assign io_PMOD_1 = w_Segment2_A;
  assign io_PMOD_2 = w_Segment2_B;
  assign io_PMOD_3 = w_Segment2_C;

  assign o_LED_1 = w_Nibble[3];
  assign o_LED_2 = w_Nibble[2];
  assign o_LED_3 = w_Nibble[1];
  assign o_LED_4 = w_Nibble[0];
    
endmodule