// `default_nettype none

module Nyan_Palette (
  input [3:0] i_index,
  output [8:0] o_color
);
  
  assign o_color = nyan_color;
  wire [3:0] nyan_index = i_index;

  reg [8:0] nyan_color;
  always@(*) begin
    case(nyan_index)
      4'd0: nyan_color = 9'h000;
      4'd1: nyan_color = 9'h00B;
      4'd2: nyan_color = 9'h027;
      4'd3: nyan_color = 9'h078;
      4'd4: nyan_color = 9'h0CF;
      4'd5: nyan_color = 9'h124;
      4'd6: nyan_color = 9'h1C0;
      4'd7: nyan_color = 9'h1CC;
      4'd8: nyan_color = 9'h1E0;
      4'd9: nyan_color = 9'h1E4;
      4'd10: nyan_color = 9'h1E7;
      4'd11: nyan_color = 9'h1F4;
      4'd12: nyan_color = 9'h1F8;
      4'd13: nyan_color = 9'h1FF;
      4'd14: nyan_color = 9'h000;
      4'd15: nyan_color = 9'h000;
    endcase
  end
endmodule