module bitmap2_palette (
  input  wire [3:0] i_index,
  output reg  [8:0] o_color
);

  always @(*) begin
    case(i_index)
      4'd00: o_color = 9'h000;
      4'd01: o_color = 9'h027;
      4'd02: o_color = 9'h00B;
      4'd03: o_color = 9'h078;
      4'd04: o_color = 9'h0CF;
      4'd05: o_color = 9'h124;
      4'd06: o_color = 9'h1C0;
      4'd07: o_color = 9'h1CC;
      4'd08: o_color = 9'h1E0;
      4'd09: o_color = 9'h1E4;
      4'd10: o_color = 9'h1E7;
      4'd11: o_color = 9'h1F4;
      4'd12: o_color = 9'h1F8;
      4'd13: o_color = 9'h1FF;
      default: o_color = 9'h000;
    endcase
  end
endmodule
