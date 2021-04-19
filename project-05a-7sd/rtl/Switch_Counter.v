module Switch_Counter (
  input i_Clk,
  input i_Switch,
  output [3:0] o_Nibble
);

  reg r_Switch = 1'b0;
  reg [3:0] r_Nibble = 4'h0;

  always @(posedge i_Clk) begin
    r_Switch <= i_Switch;
    // Rising edge of i_Switch
    if ((i_Switch == 1'b1) && (r_Switch == 1'b0)) begin
      if (r_Nibble == 9) r_Nibble <= 0;
      else r_Nibble <= r_Nibble + 1;
    end
  end

  assign o_Nibble = r_Nibble;
endmodule
