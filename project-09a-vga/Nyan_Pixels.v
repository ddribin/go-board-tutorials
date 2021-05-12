// module Nyan_Pixels #(
//   parameter ADDR_WIDTH = 10,
//   parameter DATA_WIDTH = 4
// ) (
//   input i_clk,
//   input [DATA_WIDTH-1:0] i_data,
//   input [ADDR_WIDTH-1:0] i_addr,
//   input i_write_en,
//   output reg [DATA_WIDTH-1:0] o_data
// );

//   reg [DATA_WIDTH-1:0] r_mem[(1<<ADDR_WIDTH) - 1:0];

//   always @(posedge i_clk) begin
//     if (i_write_en) begin
//       r_mem[i_addr] <= i_data;
//     end
//     o_data = r_mem[i_addr];
//   end

//   initial begin
//     $readmemh("foo.txt", r_mem);
//   end
// endmodule

module Nyan_Pixels (din, addr, write_en, clk, dout);// 512x8
  parameter addr_width = 10;
  parameter data_width = 4;
  input [addr_width-1:0] addr;
  input [data_width-1:0] din;
  input write_en, clk;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout; // Register for output.
  reg [data_width-1:0] mem [(1<<addr_width)-1:0];

  always @(posedge clk)
  begin
    if (write_en) mem[(addr)] <= din;
    dout <= mem[addr]; // Output register controlled by clock.
  end

  initial begin
    $readmemh("foo.txt", mem);
  end
endmodule
