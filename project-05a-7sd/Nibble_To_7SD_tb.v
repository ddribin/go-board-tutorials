module Nibble_To_7SD_tb (
  input         i_Clk,
  input  [3:0]  i_Nibble,
  output        o_Segment_A,
  output        o_Segment_B,
  output        o_Segment_C,
  output        o_Segment_D,
  output        o_Segment_E,
  output        o_Segment_F,
  output        o_Segment_G
);

  Nibble_To_7SD Inst (
    .i_Clk,
    .i_Nibble,
    .o_Segments({o_Segment_G, o_Segment_F, o_Segment_E, o_Segment_D,
      o_Segment_C, o_Segment_B, o_Segment_A})

  );
  
endmodule