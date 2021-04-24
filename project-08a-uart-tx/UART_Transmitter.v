module UART_Transmitter #(
  parameter CYCLES_PER_BIT = 217
) (
  input         i_clk,
  input [7:0]   i_tx_byte,
  input         i_tx_dv,
  output        o_tx_serial,
  output        o_tx_active,
  output        o_tx_done
);

  localparam STATE_INIT       = 2'd0;
  localparam STATE_START_BIT  = 2'd1;
  localparam STATE_DATA_BITS  = 2'd2;
  localparam STATE_STOP_BIT   = 2'd3;

  localparam COUNT_WIDTH = $clog2(CYCLES_PER_BIT);

  reg [7:0]     r_tx_byte;
  reg           r_tx_serial;
  reg           r_tx_active;
  reg           r_tx_done;

  reg [1:0]     r_state;
  reg [COUNT_WIDTH-1:0] r_count = 0;
  reg [2:0]   r_bit_count = 0;

  always @(posedge i_clk) begin
    case (r_state)
      STATE_INIT : begin
        r_tx_done <= 0;
        if (i_tx_dv) begin
          r_state <= STATE_START_BIT;
          r_tx_byte <= i_tx_byte;
          r_tx_serial <= 0;
          r_tx_active <= 1;
          r_count <= 0;
          r_bit_count <= 0;
        end else begin
          r_tx_active <= 0;
          r_tx_serial <= 1;
        end
      end

      STATE_START_BIT : begin
        if (r_count == CYCLES_PER_BIT-1) begin
          r_state <= STATE_DATA_BITS;
          r_tx_serial <= r_tx_byte[0];
          r_tx_byte <= r_tx_byte >> 1;
          r_count <= 0;
        end else begin
          r_count <= r_count + 1;
        end
      end

      STATE_DATA_BITS : begin
        if (r_count == CYCLES_PER_BIT-1) begin
          r_count <= 0;
          if (r_bit_count == 7) begin
            r_state <= STATE_STOP_BIT;
            r_tx_serial <= 1;
          end else begin
            r_tx_serial <= r_tx_byte[0];
            r_tx_byte <= r_tx_byte >> 1;
            r_bit_count <= r_bit_count + 1;
          end
        end else begin
          r_count <= r_count + 1;
        end
      end

      STATE_STOP_BIT : begin
        if (r_count == CYCLES_PER_BIT-2) begin
          r_tx_done <= 1;
          r_state <= STATE_INIT;
        end else begin
          r_count <= r_count + 1;
        end
      end

      default: r_state <= STATE_INIT;
    endcase
  end

  assign o_tx_serial = r_tx_serial;
  assign o_tx_active = r_tx_active;
  assign o_tx_done = r_tx_done;
  
endmodule
