`include "State_Machine.vh"
`include "Seven_Segment_Display.vh"

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

  wire [3:0] w_Nibble;
  wire [6:0] w_Segments2;
  wire [`STATE_WIDTH-1:0] w_State;
  wire [6:0] w_Segments_SM;

  wire [3:0] w_Switches;
  wire w_Reset = ~w_State[2];
  Debounce_All Debounce_All_Inst (
    .i_Clk,
    .i_Switch_1, .i_Switch_2, .i_Switch_3, .i_Switch_4,
    .o_Switches(w_Switches)
  );

  State_Machine machine (
    .i_Clk,
    .i_Switches(w_Switches),
    .o_State(w_State),
    .o_Segments(w_Segments_SM)
  );

  wire [3:0] w_Auto_Nibble;
  Auto_Counter Auto_Counter_Inst (
    .i_Clk,
    .i_Reset(w_Reset),
    .o_Nibble(w_Auto_Nibble)
  );

  wire [3:0] w_Switch_Nibble;
  Switch_Counter Switch_Count_Inst (
    .i_Clk,
    .i_Reset(w_Reset),
    .i_Switch(w_Switches[0]),
    .o_Nibble(w_Switch_Nibble)
  );

  wire [3:0] w_Bit_Nibble;
  Bit_Counter Bit_Counter_Inst (
    .i_Clk,
    .i_Reset(w_Reset),
    .i_Switch_1(w_Switches[0]),
    .i_Switch_2(w_Switches[1]),
    .i_Switch_3(w_Switches[2]),
    .i_Switch_4(w_Switches[3]),
    .o_Nibble(w_Bit_Nibble)
  );

  reg [3:0] r_Nibble;
  always @(posedge i_Clk) begin
    case (w_State)
      `STATE_AUTO: r_Nibble <= w_Auto_Nibble;
      `STATE_SWITCH: r_Nibble <= w_Switch_Nibble;
      `STATE_BIT: r_Nibble <= w_Bit_Nibble;
      `STATE_RESET_WAIT: r_Nibble <= 4'b1111;
      default: r_Nibble <= 4'd0;
    endcase
  end

  Nibble_To_7SD Nibble_To_7SD_Inst (
    .i_Clk,
    .i_Nibble(r_Nibble),
    .o_Segment_A(w_Segments2[0]),
    .o_Segment_B(w_Segments2[1]),
    .o_Segment_C(w_Segments2[2]),
    .o_Segment_D(w_Segments2[3]),
    .o_Segment_E(w_Segments2[4]),
    .o_Segment_F(w_Segments2[5]),
    .o_Segment_G(w_Segments2[6])
  );

  reg [6:0] r_Segments2;
  always @(posedge i_Clk) begin
    case (w_State)
      `STATE_INIT: r_Segments2 <= w_Segments_SM;
      `STATE_RESET_WAIT: r_Segments2 <= `SEGMENT_E | `SEGMENT_G;
      default: r_Segments2 <= w_Segments2;
    endcase
  end

  assign o_Segment2_A = ~r_Segments2[0];
  assign o_Segment2_B = ~r_Segments2[1];
  assign o_Segment2_C = ~r_Segments2[2];
  assign o_Segment2_D = ~r_Segments2[3];
  assign o_Segment2_E = ~r_Segments2[4];
  assign o_Segment2_F = ~r_Segments2[5];
  assign o_Segment2_G = ~r_Segments2[6];

  assign o_LED_1 = r_Nibble[3];
  assign o_LED_2 = r_Nibble[2];
  assign o_LED_3 = r_Nibble[1];
  assign o_LED_4 = r_Nibble[0];
    
  // For debugging: Send some signals out the PMOD connector
  assign io_PMOD_1 = w_Segments_SM[0];
  assign io_PMOD_2 = w_Segments_SM[1];
  assign io_PMOD_3 = w_Segments_SM[3];

endmodule
