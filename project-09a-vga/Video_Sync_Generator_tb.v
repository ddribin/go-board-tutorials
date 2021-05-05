module Video_Sync_Generator_tb (
  input i_clk,

  output o_hsync,
  output o_hblank,
  output o_vsync,
  output o_vblank,
  output o_visible,

  output [9:0] o_hpos,
  output [9:0] o_vpos
);

  Video_Sync_Generator #(
    // 10 x 3
    .H_VISIBLE(10),
    .H_RIGHT_BORDER(1),
    .H_FRONT_PORCH(2),
    .H_SYNC_TIME(4),
    .H_BACK_PORCH(2),
    .H_LEFT_BORDER(1),

    .V_VISIBLE(3),
    .V_BOTTOM_BORDER(1),
    .V_FRONT_PORCH(2),
    .V_SYNC_TIME(1),
    .V_BACK_PORCH(2),
    .V_TOP_BORDER(1)
  )
  sync_gen (.*);

endmodule
