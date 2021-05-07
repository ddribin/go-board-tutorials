`default_nettype none

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
  assign pattern_red[1] = {3{1'b0}};
  assign pattern_grn[1] = 0;
  assign pattern_blu[1] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 6: Plaid
  /////////////////////////////////////////////////////////////////////////////
  assign pattern_red[6] = {3{(((i_hpos&7)==0) || ((i_vpos&7)==0))}};
  assign pattern_grn[6] = {3{i_vpos[4]}};
  assign pattern_blu[6] = {3{i_hpos[4]}};

  /////////////////////////////////////////////////////////////////////////////
  // Select between different test patterns
  /////////////////////////////////////////////////////////////////////////////
  always @(posedge i_clk) begin
    case (i_pattern)
      4'd1, 4'd6: begin
        o_red_video <= i_visible? pattern_red[i_pattern] : 3'd0;
        o_grn_video <= i_visible? pattern_grn[i_pattern] : 3'd0;
        o_blu_video <= i_visible? pattern_blu[i_pattern] : 3'd0;
      end
      default: begin
        o_red_video <= pattern_red[0];
        o_grn_video <= pattern_grn[0];
        o_blu_video <= pattern_blu[0];
      end

    endcase
  end
  
endmodule