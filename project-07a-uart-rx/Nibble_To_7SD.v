`include "Seven_Segment_Display.vh"

module Nibble_To_7SD (
  input         i_Clk,
  input  [3:0]  i_Nibble,
  output [6:0]  o_Segments
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
 _         _    _         _    _    _    _    _
| |    |   _|   _|  |_|  |_   |_     |  |_|  |_|
|_|    |  |_    _|    |   _|  |_|    |  |_|   _|

 A .. b .. C .. d .. E .. F     Segments
 _         _         _    _         A
|_|  |_   |     _|  |_   |_        FGB
| |  |_|  |_   |_|  |_   |         EDC
 */

  // Shorter versions
  localparam SEG_A = `SEGMENT_A;
  localparam SEG_B = `SEGMENT_B;
  localparam SEG_C = `SEGMENT_C;
  localparam SEG_D = `SEGMENT_D;
  localparam SEG_E = `SEGMENT_E;
  localparam SEG_F = `SEGMENT_F;
  localparam SEG_G = `SEGMENT_G;

  reg [6:0] r_Hex_Encoding = 7'h00;

  always @(posedge i_Clk) begin
    case (i_Nibble)
      4'h0 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F;
      4'h1 : r_Hex_Encoding <= SEG_B | SEG_C;
      4'h2 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_G | SEG_E | SEG_D;
      4'h3 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_G | SEG_C | SEG_D;
      4'h4 : r_Hex_Encoding <= SEG_F | SEG_B | SEG_G | SEG_C;
      4'h5 : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_C | SEG_D;
      4'h6 : r_Hex_Encoding <= SEG_A | SEG_F | SEG_E | SEG_D | SEG_C | SEG_G;
      4'h7 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C;
      4'h8 : r_Hex_Encoding <= SEG_A | SEG_B | SEG_C | SEG_D | SEG_E | SEG_F | SEG_G;
      4'h9 : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_B | SEG_C | SEG_D;
      4'hA : r_Hex_Encoding <= SEG_A | SEG_F | SEG_B | SEG_G | SEG_E | SEG_C;
      4'hB : r_Hex_Encoding <= SEG_F | SEG_E | SEG_D | SEG_C | SEG_G;
      4'hC : r_Hex_Encoding <= SEG_A | SEG_F | SEG_E | SEG_D;
      4'hD : r_Hex_Encoding <= SEG_B | SEG_G | SEG_E | SEG_D | SEG_C;
      4'hE : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_E | SEG_D;
      4'hF : r_Hex_Encoding <= SEG_A | SEG_F | SEG_G | SEG_E;
    endcase
  end // always

  assign o_Segments = r_Hex_Encoding;
    
   
endmodule