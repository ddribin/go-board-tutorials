module Nibble_To_7SD (
  input       i_Clk,
  input [3:0] i_Nibble,
  output      o_Segment_A,
  output      o_Segment_B,
  output      o_Segment_C,
  output      o_Segment_D,
  output      o_Segment_E,
  output      o_Segment_F,
  output      o_Segment_G
);

/*
 +-A-+
 |   |
 F   B
 |   |
 +-G-+  Seven Segment Display (7SD)
 |   |
 E   C
 |   |
 +-D-+


 0 .. 1 .. 2 .. 3 .. 4 .. 5 .. 6 .. 7 .. 8 .. 9
 _         _    _         _         _    _    _
| |    |   _|   _|  |_|  |_   |_     |  |_|  |_|
|_|    |  |_    _|    |   _|  |_|    |  |_|    |

 A .. b .. C .. d .. E .. F     Segments
 _         _         _    _         A
|_|  |_   |     _|  |_   |_        FGB
| |  |_|  |_   |_|  |_   |         EDC
 */

  localparam SEG_A = 7'b1000000;
  localparam SEG_B = 7'b0100000;
  localparam SEG_C = 7'b0010000;
  localparam SEG_D = 7'b0001000;
  localparam SEG_E = 7'b0000100;
  localparam SEG_F = 7'b0000010;
  localparam SEG_G = 7'b0000001;

  reg [6:0] r_Hex_Encoding = 7'h00;

  always @(posedge i_Clk) begin
    case (i_Nibble)
      4'h0 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F;
      4'h1 : r_Hex_Encoding <= SEG_B | SEG_C;
      4'h2 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_G | SEG_E | SEG_D;
      4'h3 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_G | SEG_C | SEG_D;
      4'h4 : r_Hex_Encoding <= SEG_F | SEG_B | SEG_G | SEG_C;
      4'h5 : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_C | SEG_D;
      4'h6 : r_Hex_Encoding <= SEG_F | SEG_E | SEG_D | SEG_C | SEG_G;
      4'h7 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C;
      4'h8 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F | SEG_G;
      4'h9 : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_B | SEG_C;
      4'hA : r_Hex_Encoding <= SEG_A | SEG_F | SEG_B | SEG_G | SEG_E | SEG_C;
      4'hB : r_Hex_Encoding <= SEG_F | SEG_E | SEG_D | SEG_C | SEG_G;
      4'hC : r_Hex_Encoding <= SEG_A | SEG_F | SEG_E | SEG_D;
      4'hD : r_Hex_Encoding <= SEG_B | SEG_G | SEG_E | SEG_D | SEG_C;
      4'hE : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_E | SEG_D;
      4'hF : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_E;
    endcase
  end // always

  // r_Hex_Encoding[7] is unused
  assign o_Segment_A = r_Hex_Encoding[6];
  assign o_Segment_B = r_Hex_Encoding[5];
  assign o_Segment_C = r_Hex_Encoding[4];
  assign o_Segment_D = r_Hex_Encoding[3];
  assign o_Segment_E = r_Hex_Encoding[2];
  assign o_Segment_F = r_Hex_Encoding[1];
  assign o_Segment_G = r_Hex_Encoding[0];
    
   
endmodule