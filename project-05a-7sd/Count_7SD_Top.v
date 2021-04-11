module Count_7SD_Top (
  input i_Clk,
  output io_PMOD_1,
  output io_PMOD_2,
  output io_PMOD_3,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G
);

  wire w_Segment2_A;
  wire w_Segment2_B;
  wire w_Segment2_C;
  wire w_Segment2_D;
  wire w_Segment2_E;
  wire w_Segment2_F;
  wire w_Segment2_G;

  reg [3:0] r_Nibble = 4'h0;
  reg [31:0] r_Delay = 32'd0;

  always @(posedge i_Clk) begin
    if (r_Delay == 25000000) begin
      r_Delay <= 0;
      r_Nibble <= r_Nibble + 1;
    end else begin
      r_Delay <= r_Delay + 1;
    end
  end

  Nibble_To_7SD Nibble_To_7SD_Inst (
    .i_Clk,
    .i_Nibble(r_Nibble),
    .o_Segment_A(w_Segment2_A),
    .o_Segment_B(w_Segment2_B),
    .o_Segment_C(w_Segment2_C),
    .o_Segment_D(w_Segment2_D),
    .o_Segment_E(w_Segment2_E),
    .o_Segment_F(w_Segment2_F),
    .o_Segment_G(w_Segment2_G)
  );

  assign o_Segment2_A = ~w_Segment2_A;
  assign o_Segment2_B = ~w_Segment2_B;
  assign o_Segment2_C = ~w_Segment2_C;
  assign o_Segment2_D = ~w_Segment2_D;
  assign o_Segment2_E = ~w_Segment2_E;
  assign o_Segment2_F = ~w_Segment2_F;
  assign o_Segment2_G = ~w_Segment2_G;

  assign io_PMOD_1 = w_Segment2_A;
  assign io_PMOD_2 = w_Segment2_B;
  assign io_PMOD_3 = w_Segment2_C;
    
endmodule