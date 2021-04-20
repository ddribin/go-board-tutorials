`include "State_Machine.vh"
`include "Seven_Segment_Display.vh"

module State_Machine #(
  g_ANIMATION_DELAY = 25000000/6,
  g_RESET_DELAY = 25000000*3
) (
  input i_Clk,
  input [3:0] i_Switches,
  output [1:0] o_State,
  output [6:0] o_Segments
);

  reg [3:0] r_Switches;
  reg [1:0] r_State = `STATE_INIT;
  reg [2:0] r_Segment = 3'd0;
  reg [31:0] r_Delay = 32'd0;

  always @(posedge i_Clk) begin
    r_Switches <= i_Switches;
    case (r_State)
      `STATE_INIT : begin
        if ((i_Switches[0] == 1'b0) && (r_Switches[0] == 1'b1)) begin
          // Falling edge of switch 1
          r_State <= `STATE_AUTO;
        end else if ((i_Switches[1] == 1'b0) && (r_Switches[1] == 1'b1)) begin
          // Falling edge of switch 2
          r_State <= `STATE_SWITCH;
        end else if ((i_Switches[2] == 1'b0) && (r_Switches[2] == 1'b1)) begin
          // Falling edge of switch 3
          r_State <= `STATE_BIT;
        end else begin
          // No switches pressed
          if (r_Delay == g_ANIMATION_DELAY) begin
            r_Delay <= 0;
            if (r_Segment == 5) r_Segment <= 0;
            else r_Segment <= r_Segment + 1;
          end else begin
            r_Delay <= r_Delay + 1;
          end
        end
      end

      `STATE_AUTO,
      `STATE_SWITCH,
      `STATE_BIT : begin
        // if ((i_Switches[3] == 1'b1) && (r_Switches[3] == 1'b0)) begin
        //   // Rising edge of Switch 4
        //   r_Delay <= 0;
        // end else if ((i_Switches[3] == 1'b1) && (r_Switches[3] == 1'b0)) begin
        //   // Falling edge of Switch 4
        //   r_Delay <= 0;
        // end else if ((i_Switches[3] == 1'b1) && (r_Switches[3] == 1'b1)) begin
        if (i_Switches[3] == 1'b1) begin
          // Switch 4 held down
          if (r_Delay == g_RESET_DELAY) begin
            r_State <= `STATE_INIT;
            r_Delay <= 0;
            r_Segment <= 0;
          end else begin
            r_Delay <= r_Delay + 1;
          end
        end else begin
          r_Delay <= 0;
        end

      end

      default: begin
        r_State <= `STATE_INIT;
      end
    endcase
  end

  assign o_State = r_State;
  assign o_Segments = 7'd1 << r_Segment;
endmodule
