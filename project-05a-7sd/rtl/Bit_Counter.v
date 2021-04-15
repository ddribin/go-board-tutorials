module Bit_Counter (
  input i_Clk,
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,
  output [3:0] o_Nibble
);

  reg r_Switch_1 = 1'b0;
  reg r_Switch_2 = 1'b0;
  reg r_Switch_3 = 1'b0;
  reg r_Switch_4 = 1'b0;
  reg [3:0] r_Nibble = 4'h0;

  always @(posedge i_Clk) begin
    r_Switch_1 <= i_Switch_1;
    r_Switch_2 <= i_Switch_2;
    r_Switch_3 <= i_Switch_3;
    r_Switch_4 <= i_Switch_4;

    if ((i_Switch_1 == 1'b1) && (r_Switch_1 == 1'b0)) begin
      r_Nibble[0] <= ~r_Nibble[0];
    end

    if ((i_Switch_2 == 1'b1) && (r_Switch_2 == 1'b0)) begin
      r_Nibble[1] <= ~r_Nibble[1];
    end

    if ((i_Switch_3 == 1'b1) && (r_Switch_3 == 1'b0)) begin
      r_Nibble[2] <= ~r_Nibble[2];
    end

    if ((i_Switch_4 == 1'b1) && (r_Switch_4 == 1'b0)) begin
      r_Nibble[3] <= ~r_Nibble[3];
    end
  end

  assign o_Nibble = r_Nibble;

endmodule