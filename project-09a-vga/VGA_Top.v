module VGA_Top (
   input  i_Clk,       // Main Clock
   input  i_UART_RX,   // UART RX Data
   output o_UART_TX,   // UART TX Data
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

  wire [2:0] r = {3{w_visible && (((w_hpos&7)==0) || ((w_vpos&7)==0))}};
  wire [2:0] g = {3{w_visible && w_vpos[4]}};
  wire [2:0] b = {3{w_visible && w_hpos[4]}};

  assign o_VGA_HSync = ~w_hsync;
  assign o_VGA_VSync = ~w_vsync;

  assign {o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0} = r;
  assign {o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0} = g;
  assign {o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0} = b;
endmodule
