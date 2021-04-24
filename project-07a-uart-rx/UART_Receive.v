module UART_Receive #(
  parameter CYCLES_PER_BIT = 217
) (
  input         i_clk,
  input         i_serial_rx,
  output        o_read_stb,
  output        o_serial_rx,
  output        o_rx_valid,
  output [7:0]  o_rx_byte
);

  localparam STATE_IDLE       = 3'd0;
  localparam STATE_START_BIT  = 3'd1;
  localparam STATE_DATA_BITS  = 3'd2;
  localparam STATE_STOP_BIT   = 3'd3;
  localparam STATE_SEND_VALID = 3'd4;

  localparam COUNT_WIDTH = $clog2(CYCLES_PER_BIT);

  localparam CYCLES_PER_HALF_BIT = (CYCLES_PER_BIT)/2;

  reg         r_serial_rx = 1;
  reg         r_rx_valid = 0;
  reg [7:0]   r_rx_byte = 0;
  reg [2:0]   r_state = STATE_IDLE;
  reg [COUNT_WIDTH-1:0] r_count = 0;
  reg [2:0]   r_bit_count = 0;
  reg         r_read_stb;

  always @(posedge i_clk) begin
    r_serial_rx <= i_serial_rx;

    case (r_state)
      STATE_IDLE : begin
        // Wait for falling edge
        if ((r_serial_rx == 1) && (i_serial_rx == 0)) begin
          r_state <= STATE_START_BIT;
          r_rx_byte <= 0;
          r_read_stb <= 1;
          r_count <= 0;
        end
      end

      STATE_START_BIT : begin
        // Wait until mid start bit
        if (r_count == CYCLES_PER_HALF_BIT-1) begin
          if (i_serial_rx == 0) begin
            r_state <= STATE_DATA_BITS;
            r_bit_count <= 0;
            r_rx_byte <= 8'd0;
            r_count <= 0;
            r_read_stb <= 1;
          end else begin
            r_state <= STATE_IDLE;
          end
        end else begin
          r_count <= r_count + 1;
          r_read_stb <= 0;
        end
      end

      STATE_DATA_BITS : begin
        if (r_count == CYCLES_PER_BIT-1) begin
          // Shift in the new bit
          r_rx_byte <= {i_serial_rx, r_rx_byte[7:1]};
          r_read_stb <= 1;
          if (r_bit_count == 7) begin
            r_state <= STATE_STOP_BIT;
            r_count <= 0;
          end else begin
            r_bit_count <= r_bit_count + 1;
            r_count <= 0;
          end
        end else begin
          r_read_stb <= 0;
          r_count <= r_count + 1;
        end
      end

      STATE_STOP_BIT : begin
        r_read_stb <= 0;
        if (r_count == CYCLES_PER_BIT-1) begin
          if (i_serial_rx == 1) begin
            r_state <= STATE_SEND_VALID;
            r_rx_valid <= 1;
            r_count <= 0;
            r_read_stb <= 1;
          end else begin
            r_state <= STATE_IDLE;
          end
        end else begin
          r_count <= r_count + 1;
          r_read_stb <= 0;
        end
      end

      STATE_SEND_VALID : begin
        // Strobe r_rx_valid for only a single clock cycle
        r_state <= STATE_IDLE;
        r_rx_valid <= 0;
        r_read_stb <= 0;
      end

      default: r_state <= STATE_IDLE;
    endcase
  end

  assign o_rx_valid = r_rx_valid;
  assign o_rx_byte = r_rx_byte;
  assign o_read_stb = r_read_stb;
  assign o_serial_rx = r_serial_rx;
  
endmodule