`default_nettype none

module ram #(
  parameter ADDR_WIDTH = 10,
  parameter DATA_WIDTH = 4,
  parameter FILE = ""
) (
  input  wire i_clk,
  input  wire [DATA_WIDTH-1:0] i_data,
  input  wire [ADDR_WIDTH-1:0] i_addr,
  input  wire i_write_en,
  output reg  [DATA_WIDTH-1:0] o_data
);

  reg [DATA_WIDTH-1:0] r_mem[(1<<ADDR_WIDTH) - 1:0];

  always @(posedge i_clk) begin
    if (i_write_en) begin
      r_mem[i_addr] <= i_data;
    end
    o_data <= r_mem[i_addr];
  end

  initial begin
    if (FILE != 0) begin
      $display("Initializing from file '%s'.", FILE);
      $readmemh(FILE, r_mem);
    end
  end
endmodule
