// `default_nettype none

module ram #(
  parameter ADDR_WIDTH = 10,
  parameter DATA_WIDTH = 4
) (
  input i_clk,
  input [DATA_WIDTH-1:0] i_data,
  input [ADDR_WIDTH-1:0] i_addr,
  input i_write_en,
  output reg [DATA_WIDTH-1:0] o_data
);

  reg [DATA_WIDTH-1:0] r_mem[(1<<ADDR_WIDTH) - 1:0];

  always @(posedge i_clk) begin
    if (i_write_en) begin
      r_mem[i_addr] <= i_data;
    end
    o_data <= r_mem[i_addr];
  end

  initial begin
    $readmemh("foo.txt", r_mem);
  end
endmodule
