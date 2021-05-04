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
  output o_visible,

  output [8:0] o_hpos,
  output [8:0] o_vpos
);

  localparam H_BLANK_START = H_VISIBLE + H_RIGHT_BORDER;
  localparam H_SYNC_START = H_BLANK_START + H_FRONT_PORCH;
  localparam H_SYNC_END = H_SYNC_START + H_SYNC_TIME;
  localparam H_TOTAL = H_SYNC_END + H_BACK_PORCH +  H_LEFT_BORDER;

  localparam V_BLANK_START = V_VISIBLE + V_BOTTOM_BORDER;
  localparam V_SYNC_START = V_BLANK_START + V_FRONT_PORCH;;
  localparam V_SYNC_END = V_SYNC_START + V_SYNC_TIME;
  localparam V_TOTAL = V_SYNC_END + V_BACK_PORCH + V_TOP_BORDER;

  reg       r_hsync;
  reg       r_vsync;
  reg [8:0] r_hpos = 0;
  reg [8:0] r_vpos = 0;

  wire w_end_of_line = r_hpos == H_TOTAL-1;

  always @(posedge i_clk) begin
    r_hsync <= ((r_hpos >= H_SYNC_START-1) && (r_hpos < H_SYNC_END-1));

    if (r_hpos < H_TOTAL-1) begin
      r_hpos <= r_hpos + 1;
    end else begin
      r_hpos <= 0;
    end
  end

  always @(posedge i_clk) begin
    if (w_end_of_line) begin
      r_vsync = ((r_vpos >= V_SYNC_START-1) && (r_vpos < V_SYNC_END-1));

      if (r_vpos < V_TOTAL-1) begin
        r_vpos <= r_vpos + 1;
      end else begin
        r_vpos <= 0;
      end
    end
  end

  wire w_h_visible = r_hpos < H_VISIBLE;
  assign o_hsync = r_hsync;
  assign o_hblank = ~w_h_visible;
  assign o_hpos = r_hpos;

  wire w_v_visible = r_vpos < V_VISIBLE;
  assign o_vsync = r_vsync;
  assign o_vblank = ~w_v_visible;
  assign o_vpos = r_vpos;

  assign o_visible = (w_h_visible & w_v_visible);
  
endmodule
