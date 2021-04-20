module Auto_Counter #(
  parameter g_Delay = 25000000
) (
  input i_Clk,
  input i_Reset,
  output [3:0] o_Nibble
);

  reg [3:0] r_Nibble = 4'h0;
  reg [31:0] r_Delay = 32'd0;
    
  always @(posedge i_Clk) begin
    if (i_Reset) begin
      r_Delay <= 0;
      r_Nibble <= 0;
    end else if (r_Delay == g_Delay) begin
      r_Delay <= 0;
      r_Nibble <= r_Nibble + 1;
    end else begin
      r_Delay <= r_Delay + 1;
    end
  end

  assign o_Nibble = r_Nibble;

endmodule
