// `default_nettype none

`define INFER
// `define INSTANTIATE

`ifdef INSTANTIATE
// module ram (
//   input clk,
//   input [3:0] din,
//   input [9:0] addr,
//   input write_en,
//   output [3:0] dout
// );
//   SB_RAM1024x4 ram1024x4_inst (
//     .RDATA(dout),
//     .RADDR(addr),
//     .RCLK(clk),
//     .RCLKE(1'b1),
//     .RE(1'b1),
//     .WADDR(addr),
//     .WCLK(clk),
//     .WCLKE(1'b1),
//     .WDATA(din),
//     .WE(write_en)
//   );
//   // defparam ram1024x4_inst.INIT_0 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   // defparam ram1024x4_inst.INIT_0 = 256'h3333333333333333333333333333333333333333333333333333333333333333;
//   defparam ram1024x4_inst.INIT_0 = 256'h8765432109ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_1 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_2 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_3 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_4 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_5 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_6 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_7 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_8 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_9 = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_A = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_B = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_C = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_D = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_E = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
//   defparam ram1024x4_inst.INIT_F = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
// endmodule
`elsif INFER
// module ram (din, addr, write_en, clk, dout);// 512x8
//   parameter addr_width = 10;
//   parameter data_width = 4;
//   input [addr_width-1:0] addr;
//   input [data_width-1:0] din;
//   input write_en, clk;
//   output [data_width-1:0] dout;
//   reg [data_width-1:0] dout; // Register for output.
//   reg [data_width-1:0] mem [(1<<addr_width)-1:0];

//   always @(posedge clk)
//   begin
//     if (write_en) mem[(addr)] <= din;
//     dout <= mem[addr]; // Output register controlled by clock.
//   end

//   initial begin
//     $readmemh("foo.txt", mem);
//   end
// endmodule

module ram #(
  parameter ADDR_WIDTH = 10,
  parameter DATA_WIDTH = 4
) (
  input clk,
  input [DATA_WIDTH-1:0] din,
  input [ADDR_WIDTH-1:0] addr,
  input write_en,
  output reg [DATA_WIDTH-1:0] dout
);

  reg [DATA_WIDTH-1:0] r_mem[(1<<ADDR_WIDTH) - 1:0];

  always @(posedge clk) begin
    if (write_en) begin
      r_mem[addr] <= din;
    end
    dout = r_mem[addr];
  end

  initial begin
    $readmemh("foo.txt", r_mem);
  end
endmodule

`endif
