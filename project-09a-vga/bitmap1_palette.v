`default_nettype none

module bitmap1_palette (
  input  wire [3:0] i_index,
  output reg  [8:0] o_color
);

  always @(*) begin
    case(i_index)
      4'd00: o_color = 9'h000;
      4'd01: o_color = 9'h04D;
      4'd02: o_color = 9'h055;
      4'd03: o_color = 9'h09E;
      4'd04: o_color = 9'h0A7;
      4'd05: o_color = 9'h0AF;
      4'd06: o_color = 9'h0C0;
      4'd07: o_color = 9'h110;
      4'd08: o_color = 9'h140;
      4'd09: o_color = 9'h199;
      4'd10: o_color = 9'h1C0;
      4'd11: o_color = 9'h1E5;
      4'd12: o_color = 9'h1E9;
      4'd13: o_color = 9'h1F5;
      4'd14: o_color = 9'h1FA;
      4'd15: o_color = 9'h1FF;
      default: o_color = 9'h000;
    endcase
  end
endmodule
