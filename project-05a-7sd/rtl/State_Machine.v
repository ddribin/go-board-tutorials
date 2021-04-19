`include "State_Machine.vh"
`include "Seven_Segment_Display.vh"

module State_Machine #(
  g_DELAY = 25000000
) (
  input i_Clk,
  input [3:0] i_Switches,
  output [1:0] o_State,
  output [6:0] o_Segments
);

  reg [3:0] r_Switches;
  reg [1:0] r_State = `STATE_INIT;
  reg [6:0] r_Segments = `SEGMENT_A;
  reg [2:0] r_Segment = 3'd0;
  reg [31:0] r_Delay = 32'd0;

  always @(posedge i_Clk) begin
    r_Switches <= i_Switches;
    case (r_State)
      `STATE_INIT : begin
        if ((i_Switches[0] == 1'b0) && (r_Switches[0] == 1'b1)) begin
          r_State <= `STATE_AUTO;
        end else if ((i_Switches[1] == 1'b0) && (r_Switches[1] == 1'b1)) begin
          r_State <= `STATE_SWITCH;
        end else if ((i_Switches[2] == 1'b0) && (r_Switches[2] == 1'b1)) begin
          r_State <= `STATE_BIT;
        end else begin
          if (r_Delay == g_DELAY) begin
            r_Delay <= 0;
            // r_Segments <= {1'b0, r_Segments[4:0], r_Segments[5]};
            // r_Segments <= r_Segments << 1;
            if (r_Segment == 5) r_Segment <= 0;
            else r_Segment <= r_Segment + 1;
            // r_Segment <= (r_Segment + 1) % 6;
            // r_Segments <= 7'd1 << r_Segment;
            // r_Segments <= r_Segments + 1;
          end else begin
            r_Delay <= r_Delay + 1;
          end
        end
      end

      `STATE_AUTO,
      `STATE_SWITCH,
      `STATE_BIT : begin
      end

      default: begin
        r_State <= `STATE_INIT;
      end
    endcase
  end

  // always @(*) begin
  //   case (r_Segment)
  //     3'd0: o_Segments = `SEGMENT_A;
  //     3'd1: o_Segments = `SEGMENT_B;
  //     3'd2: o_Segments = `SEGMENT_C;
  //     3'd3: o_Segments = `SEGMENT_D;
  //     3'd4: o_Segments = `SEGMENT_E;
  //     3'd5: o_Segments = `SEGMENT_F;
  //     default: o_Segments = 7'd0;
  //   endcase
  // end

  assign o_State = r_State;
  assign o_Segments = 7'd1 << r_Segment;
endmodule
