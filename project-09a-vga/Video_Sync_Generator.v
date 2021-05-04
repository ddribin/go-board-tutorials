module Video_Sync_Generator #(
  // 640 x 480 at 60 Hz (non-interlaced)
  parameter H_VISIBLE       = 640,
  parameter H_RIGHT_BORDER  = 8,
  parameter H_FRONT_PORCH   = 8,
  parameter H_SYNC_TIME     = 96,
  parameter H_BACK_PORCH    = 40,
  parameter H_LEFT_BORDER   = 8,

  parameter V_VISIBLE       = 480,
  parameter V_BOTTOM_BORDER = 8,
  parameter V_FRONT_PORCH   = 2,
  parameter V_SYNC_TIME     = 2,
  parameter V_BACK_PORCH    = 25,
  parameter V_TOP_BORDER    = 8
) (
  // Pixel Clock = 25.175 MHz
  input i_clk,

  output o_hsync,
  output o_hblank,
  output o_vsync,
  output o_vblank,
  output o_display_on,

  output [8:0] o_hpos,
  output [8:0] o_vpos
);

  localparam H_BLANK_START = H_VISIBLE + H_RIGHT_BORDER;
  localparam H_SYNC_START = H_BLANK_START + H_FRONT_PORCH;
  localparam H_SYNC_END = H_SYNC_START + H_SYNC_TIME;
  localparam H_TOTAL = H_SYNC_END + H_BACK_PORCH +  H_LEFT_BORDER;

  reg       r_hsync;
  reg       r_vsync;
  reg [8:0] r_hpos = 0;
  reg [8:0] r_vpos = 0;

  always @(posedge i_clk) begin
    r_hsync = ((r_hpos >= H_SYNC_START-1) && (r_hpos < H_SYNC_END-1));
    if (r_hpos < H_TOTAL-1) begin
      r_hpos <= r_hpos + 1;
    end else begin
      r_hpos <= 0;
    end
  end

  wire h_visible = r_hpos < H_VISIBLE;
  assign o_hsync = r_hsync;
  assign o_hblank = ~h_visible;
  assign o_vsync = r_vsync;
  assign o_hpos = r_hpos;
  assign o_vpos = r_vpos;

  assign o_display_on = (h_visible);
  
endmodule
