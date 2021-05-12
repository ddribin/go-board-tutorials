// `default_nettype none

module Test_Pattern_Generator #(
  parameter VIDEO_WIDTH = 3,
  parameter H_VISIBLE = 640,
  parameter V_VISIBLE = 480
) (
  input         i_clk,
  input [3:0]   i_pattern,
  input [9:0]   i_hpos,
  input [9:0]   i_vpos,
  input         i_visible,
  input         i_frame_strobe,

  output reg [2:0] o_red_video,
  output reg [2:0] o_grn_video,
  output reg [2:0] o_blu_video
);
  // Patterns have 16 indexes (0 to 15) and can be 3 bits wide
  wire [2:0] pattern_red[0:15];
  wire [2:0] pattern_grn[0:15];
  wire [2:0] pattern_blu[0:15];

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 0: Disables the Test Pattern Generator
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[0] = 0;
  assign pattern_grn[0] = 0;
  assign pattern_blu[0] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 1: All red
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[1] = {3{1'b1}};
  assign pattern_grn[1] = 0;
  assign pattern_blu[1] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 2: All green
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[2] = 0;
  assign pattern_grn[2] = {3{1'b1}};
  assign pattern_blu[2] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 3: All blue
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[3] = 0;
  assign pattern_grn[3] = 0;
  assign pattern_blu[3] = {3{1'b1}};

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 4: Vertical color bars
  /////////////////////////////////////////////////////////////////////////////
  localparam BAR_WIDTH = H_VISIBLE/8;
  wire [2:0] w_bar =
    i_hpos < BAR_WIDTH*1 ? 3'd0 :
    i_hpos < BAR_WIDTH*2 ? 3'd1 :
    i_hpos < BAR_WIDTH*3 ? 3'd2 :
    i_hpos < BAR_WIDTH*4 ? 3'd3 :
    i_hpos < BAR_WIDTH*5 ? 3'd4 :
    i_hpos < BAR_WIDTH*6 ? 3'd5 :
    i_hpos < BAR_WIDTH*7 ? 3'd6 :
    i_hpos < BAR_WIDTH*8 ? 3'd7 : 3'd0;

  assign pattern_red[4] = {3{~w_bar[1]}};
  assign pattern_grn[4] = {3{~w_bar[2]}};
  assign pattern_blu[4] = {3{~w_bar[0]}};

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 5: Black with white border
  /////////////////////////////////////////////////////////////////////////////
  localparam BORDER_WIDTH = 8;
  wire [2:0] w_border =
    ((i_hpos < BORDER_WIDTH) || (i_hpos > (H_VISIBLE - BORDER_WIDTH - 1)) ||
     (i_vpos < BORDER_WIDTH) || (i_vpos > (V_VISIBLE - BORDER_WIDTH - 1))) ? 3'd3 : 3'd0;
  assign pattern_red[5] = w_border;
  assign pattern_grn[5] = w_border;
  assign pattern_blu[5] = w_border;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 6: Plaid
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[6] = {3{(((i_hpos&7)==0) || ((i_vpos&7)==0))}};
  assign pattern_grn[6] = {3{i_vpos[4]}};
  assign pattern_blu[6] = {3{i_hpos[4]}};

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 7: Scrolling horizontal color bars
  /////////////////////////////////////////////////////////////////////////////
  localparam V_BAR_HEIGHT = V_VISIBLE/8;
  reg [6:0] r_frame_count;
  always @(posedge i_clk) begin
    if (i_frame_strobe) begin
      r_frame_count <= r_frame_count + 1;
    end
  end

  wire [10:0] w_fade_vpos = {1'b0,i_vpos} + {4'b0,r_frame_count};
  wire [2:0] w_fade_intensity = w_fade_vpos[3:1];
  assign pattern_red[7] = w_fade_vpos[5] ? w_fade_intensity : 0;
  assign pattern_grn[7] = w_fade_vpos[6] ? w_fade_intensity : 0;
  assign pattern_blu[7] = w_fade_vpos[4] ? w_fade_intensity : 0;


  /////////////////////////////////////////////////////////////////////////////
  // Pattern 8: Nyan Cat
  /////////////////////////////////////////////////////////////////////////////
  wire [9:0] w_addr = {2'd0, {i_vpos[9:2]}};
  wire [8:0] nyan_color;
  wire [3:0] nyan_index = pixel_data; // i_vpos[7:4];
  Nyan_Palette nyan_palette (.i_index(nyan_index), .o_color(nyan_color));
  wire [3:0] pixel_data;
  ram ram (
    .i_clk(i_clk),
    .i_addr(w_addr),
    .i_data(4'd0),
    .i_write_en(1'b0),
    .o_data(pixel_data)
  );

  // wire [3:0] RDATA_c = pixel_data;
  // wire [9:0] RADDR_c = i_hpos;
  // wire RCLK_c = i_clk;
  // wire RCLKE_c = 1;
  // wire RE_c = 1;
  // wire [9:0] WADDR_c = 0;
  // wire WCLK_c = i_clk;
  // wire WCLKE_c = 1;
  // wire [3:0] WDATA_c;
  // wire WE_c = 0;
  // SB_RAM1024x4 ram1024x4_inst (
  //   .RDATA(RDATA_c[3:0]),
  //   .RADDR(RADDR_c[9:0]),
  //   .RCLK(RCLK_c),
  //   .RCLKE(RCLKE_c),
  //   .RE(RE_c),
  //   .WADDR(WADDR_c[9:0]),
  //   .WCLK(WCLK_c),
  //   .WCLKE(WCLKE_c),
  //   .WDATA(WDATA_c[3:0]),
  //   .WE(WE_c)
  // );
  // defparam ram1024x4_inst.INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
  // defparam ram1024x4_inst.INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

  assign pattern_red[8] = nyan_color[8:6];
  assign pattern_grn[8] = nyan_color[5:3];
  assign pattern_blu[8] = nyan_color[2:0];
  // assign pattern_red[8] = {3{pixel_data[0]}};
  // assign pattern_grn[8] = {3{pixel_data[1]}};
  // assign pattern_blu[8] = {3{pixel_data[2]}};

  /////////////////////////////////////////////////////////////////////////////
  // Select between different test patterns
  /////////////////////////////////////////////////////////////////////////////
  always @(posedge i_clk) begin
    if (i_pattern <= 4'd8) begin
      o_red_video <= i_visible? pattern_red[i_pattern] : 3'd0;
      o_grn_video <= i_visible? pattern_grn[i_pattern] : 3'd0;
      o_blu_video <= i_visible? pattern_blu[i_pattern] : 3'd0;
    end else begin
      o_red_video <= pattern_red[0];
      o_grn_video <= pattern_grn[0];
      o_blu_video <= pattern_blu[0];
    end
  end
  
endmodule
