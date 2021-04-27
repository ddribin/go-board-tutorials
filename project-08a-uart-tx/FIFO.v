module FIFO (
  input i_clk,

  input i_wr_en,
  input [7:0] i_wr_data,
  input i_rd_en,

  output [7:0] o_rd_data,
  output o_fifo_not_empty
);

  reg [7:0] r_buffer;
  reg r_fifo_not_empty;

  assign o_fifo_not_empty = i_wr_en | r_fifo_not_empty;
  assign o_rd_data = i_wr_en ? i_wr_data : r_buffer;

  always @(posedge i_clk) begin
    if (i_wr_en & i_rd_en) begin
      r_fifo_not_empty <= 1'b0;
    end else if (i_wr_en) begin
      r_fifo_not_empty <= 1'b1;
      r_buffer <= i_wr_data;
    end else if (i_rd_en) begin
      r_fifo_not_empty <= 1'b0;
      r_buffer <= 0;
    end
  end

endmodule